module tb_sp_ram();
parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 32;
parameter NUM_WORDS  = 256;

    logic                    clk;
    logic                    rst_n;

    logic                    port_req_i;
    logic [ADDR_WIDTH-1:0]   port_addr_i;
    logic                    port_we_i;
    logic [DATA_WIDTH-1:0]   port_wdata_i;
    logic                    en_i;
    logic [DATA_WIDTH/8-1:0] be_i;

    logic                    port_gnt_o;
    logic                    port_rvalid_o;
    logic [DATA_WIDTH-1:0]   port_rdata_o;

    logic        mem_flag;
    logic        mem_result;

    sp_ram dut
    (
        .clk(clk),
        .rst_n(rst_n),

        .port_req_i(port_req_i),
        .port_addr_i(port_addr_i),
        .port_we_i(port_we_i),
        .port_wdata_i(port_wdata_i),
        .en_i(en_i),
        .be_i(be_i),

        .port_gnt_o(port_gnt_o),
        .port_rvalid_o(port_rvalid_o),
        .port_rdata_o(port_rdata_o),

        .mem_flag(mem_flag),
        .mem_result(mem_result)

    );

    always #5 clk = ~clk;

    initial begin
        $display("time |  addr  |  rdata |  gnt |");
        $monitor("%4t | %h | %h |  %b  |", 
                                  $time, port_addr_i,
                                  port_rdata_o,
                                  port_gnt_o,
                );

        clk = 0;
        rst_n = 1;
        port_req_i = 0;
        #10
        rst_n = 0;
        #10
        port_req_i = 1;
        port_addr_i = 128;
        #10
        port_req_i = 0;
        #10
        port_req_i = 1;
        port_addr_i = 140;
        #10
        port_req_i = 0;
        #10
        port_req_i = 1;
        port_addr_i = 144;
        #10
        port_req_i = 0;
        #10
        port_req_i = 1;
        port_addr_i = 136;
        #10
        port_req_i = 0;


        #100 $finish;
    end

endmodule
