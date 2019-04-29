module sp_ram
(
    input  logic        clk,
    input  logic        rst_n,

    input  logic        port_req_i,
    output logic        port_gnt_o,
    output logic        port_rvalid_o,
    input  logic [31:0] port_addr_i,
    input  logic        port_we_i,
    output logic [31:0] port_rdata_o,
    input  logic [31:0] port_wdata_i,

    output logic [31:0] mem_flag,
    output logic [31:0] mem_result
);

    logic [31:0] mem [0:255];

    initial begin
        for(int i = 0; i != 255; i = i + 1)
            mem[i] = 32'bx;
        $readmemb("../soc_utils/fibonacci.bin", mem);
    end
      
    always_ff @(posedge clk)
        if (port_we_i)
            mem[port_addr_i] <= port_wdata_i;

    assign port_rdata_o = mem[port_addr_i];
      
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

    assign mem_flag = mem[0];
    assign mem_result = mem[4];

endmodule
