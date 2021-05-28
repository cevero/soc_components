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
        $readmemb("../soc_utils/fibonacci_byte.bin", dut.mem);
    end

    logic [31:0] counter;
    initial begin
        $display("time |  addr  |  rdata   |  wdata   | gnt |");
        $monitor("%4t |   %h   | %b | %b |", $time, addr, rdata, wdata);

		//init signals	
        clk = 0;
        rst_n = 1;
        req = 0;
        we = 0;
        @(posedge clk);
        rst_n = 0;

        @(posedge clk);
        rst_n = 1;

		#10   //wait

		req = 1;
		addr = 32'h80;
		we = 0;
		be = 4'b1111;

		#10
		addr = 32'hxx;
		req = 0;
		
		#10 rst_n = 0;
        #10 rst_n = 1;
		addr = 32'hxx;

		#20 //write test
		
		req = 1;
		addr = 32'h80;
		we = 1;
		wdata = 32'hdeadbeef;
		be = 4'b1111;
	
		#10 
		req = 0;
		we =0;
		wdata = 32'hxxxxxxxx;
		addr = 32'hxx;
		
		#20 //wait


		#10;
		req = 1;
		addr = 32'h80;
		we = 0;
		be = 4'b1111;
		#10;
		req = 1;
		addr = 32'h84;
		we = 0;
		be = 4'b1111;
		#10;
		req = 1;
		addr = 32'h88;
		we = 0;
		be = 4'b1111;
		#10;
		req = 1;
		addr = 32'h8c;
		we = 0;
		be = 4'b1111;
		
		#5;
		req = 0;

		@(posedge clk);

		for (counter = 32'h90; counter < 32'h90 + 4*5; counter = counter + 4) begin
			#10
            req = 1;
            we = 1;
            addr = counter;
            wdata = 32'hBEEF0000 + (counter - 32'h90);
            be = 4'b1111;
        end

		#5;
		req = 0;

		#5;

		for (counter = 32'h90; counter < 32'h90 + 4*5; counter = counter + 4) begin
			#10
            req = 1;
            we = 0;
            addr = counter;
            wdata = 32'hBEEF0000 ;
            be = 4'b1111;
        end

		#5;
		req = 0;
        #100 $finish;
    end

endmodule
