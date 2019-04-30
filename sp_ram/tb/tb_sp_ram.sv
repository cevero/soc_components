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

    sp_ram 
    #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_WORDS(NUM_WORDS)
    )dut(
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
        $readmemb("../soc_utils/fibonacci.bin", dut.mem);
    end

    logic [31:0] counter;
    initial begin
        $display("time |  addr  |  rdata   |  wdata   | gnt |");
        $monitor("%4t |   %h   | %h | %h | %b  |", 
                                  $time, port_addr_i,
                                  port_rdata_o,
                                  port_wdata_i,
                                  port_gnt_o
                );

        clk = 0;
        rst_n = 1;
        port_req_i = 0;
        port_we_i = 0;
        en_i = 1;
        @(posedge clk);
        rst_n = 0;

        for (counter = 32'h80; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            port_req_i = 1;
            port_addr_i = counter;
            be_i = 4'b0001;
            @(posedge clk);
            port_req_i = 0;
        end

        #20 $display("\nwrite time\n");

        for (counter = 32'hcc; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            port_req_i = 1;
            port_we_i = 1;
            port_addr_i = counter;
            port_wdata_i = 32'hBEEF;
            be_i = 4'b1111;
            @(posedge clk);
            port_req_i = 0;
            port_we_i = 0;
        end

        #20 $display("\nread again\n");

        for (counter = 32'hcc; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            port_req_i = 1;
            port_addr_i = counter;
            be_i = 4'b0001;
            @(posedge clk);
            port_req_i = 0;
        end


        #100 $finish;
    end

endmodule
