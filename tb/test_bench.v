
`timescale 1ns/1ns
module test_bench;
	reg sys_clk;
	reg sys_rst_n;
	reg tim_psel, tim_pwrite, tim_penable;
	reg [11:0] tim_paddr;
	reg [31:0] tim_pwdata;
	reg [3:0] tim_pstrb;
	reg dbg_mode;
	wire [31:0] tim_prdata;
	wire tim_pready, tim_pslverr;
	wire tim_int;
	integer err;
	integer tcr_pslverr;
	reg [31:0] rdata;

	//Address
	localparam ADDR_TCR   = 12'h0;
	localparam ADDR_TDR0  = 12'h4;
	localparam ADDR_TDR1  = 12'h8;
	localparam ADDR_TCMP0 = 12'hC;
	localparam ADDR_TCMP1 = 12'h10;
	localparam ADDR_TIER  = 12'h14;
	localparam ADDR_TISR  = 12'h18;
	localparam ADDR_THCSR = 12'h1C;

	//Default Value
	localparam DF_TCR   = 32'h00000100;
	localparam DF_TDR0  = 32'h00000000;
	localparam DF_TDR1  = 32'h00000000;
	localparam DF_TCMP0 = 32'hFFFFFFFF;
	localparam DF_TCMP1 = 32'hFFFFFFFF;
	localparam DF_TIER  = 32'h00000000;
	localparam DF_TISR  = 32'h00000000;
	localparam DF_THCSR = 32'h00000000;
	

	timer_top timer_top_dut
	(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.tim_psel(tim_psel),
		.tim_pwrite(tim_pwrite),
		.tim_penable(tim_penable),
		.tim_pstrb(tim_pstrb),
		.tim_paddr(tim_paddr),
		.tim_pwdata(tim_pwdata),
		.dbg_mode(dbg_mode),
		.tim_pready(tim_pready),
		.tim_prdata(tim_prdata),
		.tim_int(tim_int),
		.tim_pslverr(tim_pslverr)
	);

	`include "run_test.v"

	//`include "../testcases/register_chk.v"

	initial begin
		sys_clk = 0;
		forever #5 sys_clk = ~sys_clk;
	end

	initial begin
		sys_rst_n = 0;
		err = 0;
		tim_psel = 0;
		tim_pwrite = 0;
		tim_penable = 0;
		tim_pstrb = 4'b0000;
		dbg_mode = 0;
		#50;
		sys_rst_n = 1;
		@(posedge sys_clk);
		run_test();
		if (err == 0)
			$display ("Test_result PASSED ");
		else
			$display ("Test_result FAILED ");
		#100;
		$finish;
	end
	//Task Write
	task write(
		input [31:0] addr,
		input [31:0] wdata,
		input [3:0] pstrb
	);
		begin
			$display ("t = %10d Write data to address 12'h%h | Data = 32'h%h | pstrb = 4'b%b", $time, addr, wdata, pstrb);
			@(posedge sys_clk) #1;
			tim_penable = 0;
			tim_pwrite = 1;
			tim_psel = 1;
			tim_paddr = addr;
			tim_pwdata = wdata;
			tim_pstrb = pstrb;
			@(posedge sys_clk) #1;
			tim_penable = 1;
			wait(tim_pready);
			#1;
			if (tim_pslverr && (tim_paddr == ADDR_TCR)) begin
				$display ("PSLVERR ON");
				tcr_pslverr = 1;
			end else begin
				$display ("PSLVERR OFF");
				tcr_pslverr = 0;
			end
			@(posedge sys_clk) #1;
			tim_psel = 0;
			tim_paddr = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			tim_pstrb = 4'b0000;
		end
	endtask
	//Task Read
	task read(
		input [31:0] addr
	);
		begin
			@(posedge sys_clk) #1;
			tim_penable = 0;
			tim_psel = 1;
			tim_pwrite = 0;
			tim_paddr = addr;
			@(posedge sys_clk) #1;
			tim_penable = 1;
			wait (tim_pready);
			#1;
			rdata = tim_prdata;
			@(posedge sys_clk) #1;
			tim_psel = 0;
			tim_paddr = 0;
			tim_pwrite = 0;
			tim_penable = 0;
			$display("t = %10d Reading from address 12'h%h | Get prdata = 32'h%h", $time, addr, rdata);
		end
	endtask
	//Task Compare
	task compare(
		input [31:0] data_exp
	);
		begin
			@(posedge sys_clk) #1;
			
			if(rdata !== data_exp) begin
				$display ("t = %10d [FAIL]: prdata = 32'h%h is not correct | EXP: prdata = 32'h%h", $time, rdata, data_exp);
				$display ("--------------------------------------------------------------------");
				err = err + 1;
			end else begin
				$display ("t = %10d [PASS]: prdata = 32'h%h is correct", $time, rdata);
				$display ("--------------------------------------------------------------------");
			end
		end
	endtask


	task wr_rd_cmp(
		input [31:0] addr,
		input [31:0] wdata,
		input [3:0] strobe
	);
	reg [31:0] mask;
	reg [31:0] strobe_mask;
		begin 
			@(posedge sys_clk) #1;
			write (addr, wdata, strobe);
			read (addr);
			strobe_mask[7:0]   = strobe[0] ? tim_pwdata[7:0]   : rdata[7:0];
			strobe_mask[15:8]  = strobe[1] ? tim_pwdata[15:8]  : rdata[15:8];
			strobe_mask[23:16] = strobe[2] ? tim_pwdata[23:16] : rdata[23:16];
			strobe_mask[31:24] = strobe[3] ? tim_pwdata[31:24] : rdata[31:24];

			case (addr)
				ADDR_TCR:   mask = 32'h0000_0F03;
				ADDR_TDR0:  mask = 32'hFFFF_FFFF;
				ADDR_TDR1:  mask = 32'hFFFF_FFFF;
				ADDR_TCMP0: mask = 32'hFFFF_FFFF;
				ADDR_TCMP1: mask = 32'hFFFF_FFFF;
				ADDR_TIER:  mask = 32'h0000_0001;
				ADDR_TISR:  mask = 32'h0000_0000;
				ADDR_THCSR: mask = 32'h0000_0001;
				default:    mask = 32'h0000_0000;
			endcase
			$display("MASK = 32'h%h, STOBE_MASK = 32'h%h", mask, strobe_mask);
			if (tcr_pslverr) begin
				compare (DF_TCR);
			end else begin
				compare(mask & strobe_mask);
			end
			#1;
			reset();
		end
	endtask
	task reset();
		begin
			@(posedge sys_clk) #1;
			sys_rst_n = 0;
			@(posedge sys_clk) #1;
			sys_rst_n = 1;
		end
	endtask
	endmodule
