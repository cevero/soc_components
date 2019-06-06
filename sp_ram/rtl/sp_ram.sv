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

    integer i;

    assign addr = addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];

    always @(posedge clk) begin
        if (rst_n && we_i) begin
            for (i = 0; i < DATA_WIDTH/8; i++) begin
                if (be_i[i])
                  mem[addr][i] <= wdata[i];
            end
        end
        rdata_o <= mem[addr];
    end

    genvar w;
    generate for(w = 0; w < DATA_WIDTH/8; w++) begin
        assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
    end
    endgenerate

    always_comb 
        if(req_i)
            gnt_o = 1'b1;
        else
            gnt_o = 1'b0;

    always_ff @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            rvalid_o <= 1'b0;
        else
            rvalid_o <= gnt_o;
endmodule
