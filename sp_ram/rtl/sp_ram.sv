module sp_ram
#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 256
)(
    input  logic                    clk,
    input  logic                    rst_n,

    input  logic                    req_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic                    we_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    input  logic [DATA_WIDTH/8-1:0] be_i,


    output logic                    gnt_o,
    output logic                    rvalid_o,
    output logic [DATA_WIDTH-1:0]   rdata_o
);

    //localparam words = NUM_WORDS/(DATA_WIDTH/8);
    localparam words = NUM_WORDS;

    logic [DATA_WIDTH/8-1:0][7:0] mem[words];
    logic [DATA_WIDTH/8-1:0][7:0] wdata;
    logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr;
    logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr1;
    logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr2;

    integer i;

	logic get_new_addr;
	logic pending_req;
	logic [1:0]  cs = 0,ns=0;


    always_comb  begin : next_state_and_out_logic
        case (cs)
			2'b00 : begin //reset	
				if(rst_n == 0)
					ns 				=2'b00;
				else
					ns 				=2'b01;

				gnt_o 				= 1'b0; 
				rvalid_o 			= 1'b0; 
				get_new_addr 		= 1'b0;
				pending_req 		= 1'b0;
			end
				
			2'b01: begin //gnt
				if(req_i) begin
					ns 				= 2'b10;

					get_new_addr 	= 1'b1;
					gnt_o 			= 1'b1;
					rvalid_o 		= 1'b0;
					pending_req 	= 1'b1;
				end else begin
					ns 				= 2'b01;

					gnt_o 			= 1'b0;
					rvalid_o 		= 1'b0;
					pending_req 	= 1'b0;
					get_new_addr 	= 1'b0;
				end
			end

			2'b10: begin //rvalid
				//if(pending_req) begin
					rdata_o <= mem[addr1];
				//end
				if(req_i) begin
					get_new_addr	= 1'b1;
					pending_req 	= 1'b1;
					gnt_o 			= 1'b1;
					rvalid_o 		= 1'b1;

					ns 				= 2'b10;
				end else begin
					gnt_o 			= 1'b0;
					rvalid_o 		= 1'b1;
					get_new_addr 	= 1'b0;
					pending_req 	= 1'b0;
					ns 				= 2'b01;
				end
			end
		endcase
    end

	assign	addr = addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];

    always_ff @(posedge clk or negedge rst_n) begin : update_regs
		if(rst_n == 0)
			cs <= 2'b00;
		else
			cs <= ns;

		if(req_i) begin
			addr1   <= addr;
			addr2   <= addr1;
			if (we_i) begin
				for (i = 0; i < DATA_WIDTH/8; i++) begin
					if (be_i[i])
					  mem[addr][i] <= wdata[i];
				end
			end
		end

	end

    genvar w;
    generate for(w = 0; w < DATA_WIDTH/8; w++) begin
        assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
    end
    endgenerate

endmodule
