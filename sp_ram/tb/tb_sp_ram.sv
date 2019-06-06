module tb_sp_ram();

    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 32;
    parameter NUM_WORDS  = 256;

    logic                    clk;
    logic                    rst_n;

    logic                    req;
    logic [ADDR_WIDTH-1:0]   addr;
    logic                    we;
    logic [DATA_WIDTH-1:0]   wdata;
    logic [DATA_WIDTH/8-1:0] be;

    logic                    gnt;
    logic                    rvalid;
    logic [DATA_WIDTH-1:0]   rdata;

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

        .req_i(req),
        .addr_i(addr),
        .we_i(we),
        .wdata_i(wdata),
        .be_i(be),

        .gnt_o(gnt),
        .rvalid_o(rvalid),
        .rdata_o(rdata)

    );

    always #5 clk = ~clk;

    initial begin
        $readmemb("../soc_utils/fibonacci.bin", dut.mem);
    end

    logic [31:0] counter;
    initial begin
        $display("time |  addr  |  rdata   |  wdata   | gnt |");
        $monitor("%4t |   %h   | %b | %b |", 
                                  $time, addr,
                                  rdata,
                                  wdata
                );

        clk = 0;
        rst_n = 1;
        req = 0;
        we = 0;
        @(posedge clk);
        rst_n = 0;
        #20 rst_n = 1;

        for (counter = 32'h80; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            req = 1;
            addr = counter;
            be = 4'b0001;
            @(posedge clk);
            req = 0;
        end

        #20 $display("\nwrite time\n");

        for (counter = 32'hcc; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            req = 1;
            we = 1;
            addr = counter;
            wdata = 32'hBEEF;
            be = 4'b1111;
            @(posedge clk);
            req = 0;
            we = 0;
        end

        #20 $display("\nread again\n");

        for (counter = 32'hcc; counter < NUM_WORDS; counter = counter + 4) begin
            @(posedge clk);
            req = 1;
            addr = counter;
            be = 4'b0001;
            @(posedge clk);
            req = 0;
        end


        #100 $finish;
    end

endmodule
