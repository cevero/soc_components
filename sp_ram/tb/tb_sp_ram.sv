module tb_sp_ram();
    logic        clk,
    logic        rst_n,

    logic        port_req_i,
    logic        port_gnt_o,
    logic        port_rvalid_o,
    logic [31:0] port_addr_i,
    logic        port_we_i,
    logic [31:0] port_rdata_o,
    logic [31:0] port_wdata_i,

    logic [31:0] mem_flag,
    logic [31:0] mem_result

    sp_ram dut
    (
        .clk(clk),
        .rst_n(rst_n),
                     
        .port_req_i(port_req_i),
        .port_gnt_o(port_gnt_o),
        .port_rvalid_o(port_rvalid_o),
        .port_addr_i(port_addr_i),
        .port_we_i(port_we_i),
        .port_rdata_o(port_rdata_o),
        .port_wdata_i(port_wdata_i),
                      
        .mem_flag(mem_flag),
        .mem_result(mem_result)  

    );

    initial begin
        //$display("time | addr | data | signal |");
        //$monitor("%4t | %4d | %4d | %6b |", $time, addr_o, data_o, signal);

        #2 $finish;
    end
endmodule
