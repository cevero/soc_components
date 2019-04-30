module sp_ram
#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 256
)(
    input  logic                    clk,
    input  logic                    rst_n,

    input  logic                    port_req_i,
    input  logic [ADDR_WIDTH-1:0]   port_addr_i,
    input  logic                    port_we_i,
    input  logic [DATA_WIDTH-1:0]   port_wdata_i,
    input  logic                    en_i,
    input  logic [DATA_WIDTH/8-1:0] be_i,

    output logic                    port_gnt_o,
    output logic                    port_rvalid_o,
    output logic [DATA_WIDTH-1:0]   port_rdata_o,

    output logic                    mem_flag,
    output logic                    mem_result
);

    //localparam words = NUM_WORDS/(DATA_WIDTH/8);
    localparam words = NUM_WORDS;

    logic [DATA_WIDTH/8-1:0][7:0] mem[words];
    logic [DATA_WIDTH/8-1:0][7:0] wdata;
    logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr;

    integer i;

    assign addr = port_addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];

    always @(posedge clk) begin
        if (en_i && port_we_i) begin
            for (i = 0; i < DATA_WIDTH/8; i++) begin
            if (be_i[i])
              mem[addr][i] <= wdata[i];
            end
        end

        port_rdata_o <= mem[addr];
    end

    genvar w;
    generate for(w = 0; w < DATA_WIDTH/8; w++) begin
        assign wdata[w] = port_wdata_i[(w+1)*8-1:w*8];
    end
    endgenerate

    always_comb 
        if(port_req_i)
            port_gnt_o = 1'b1;
        else
            port_gnt_o = 1'b0;

    always_ff @(posedge clk, negedge rst_n)
        if (rst_n == 1'b0)
            port_rvalid_o <= 1'b0;
        else
            port_rvalid_o <= port_gnt_o;
endmodule
