task run_test();
	reg [15:0] cycle_delay;
	reg [63:0] tdr;
	reg [63:0] count_begin;
	reg [16:0] div;
	reg [2:0] add_delay;
	reg [4:0] mode;
	integer i;
	begin
		$display ("=======================================================================");
		$display ("====================== CHECK DEFAULT MODE =============================");
		$display ("=======================================================================");
		repeat(3) begin
			write(ADDR_TDR0, $urandom, 4'hf);
			read(ADDR_TDR0);
			count_begin[31:0] = rdata;
			write(ADDR_TDR1, $urandom, 4'hf);
			read(ADDR_TDR1);
			count_begin [63:32] = rdata;
			write(ADDR_TCR, 32'h0000_0001, 4'hf);
			cycle_delay = $urandom_range(0,1000);
			repeat(cycle_delay) @(posedge sys_clk) #1;
			read(ADDR_TDR0);
			tdr[31:0] = rdata;
			read(ADDR_TDR1);
			tdr[63:32] = rdata;
			if ((tdr > cycle_delay + count_begin) && (tdr < cycle_delay + count_begin + 10))
				$display("t=%0t [PASS]: Count in default mode match exp value | ACT: 64'h%h | CYCLE: 64'h%h", $time, tdr, cycle_delay);
			else begin
				$display("t=%0t [FAIL]: Count in default mode does not match exp value | ACT: 64'h%h | CYCLE: 64'h%h", $time, tdr, cycle_delay);
				err = err + 1;
			end
			reset();
		end
		div = 1;
		mode = 4'b0000;
		$display ("=======================================================================");
		$display ("====================== CHECK CONTROL MODE =============================");
		$display ("=======================================================================");
		for (i=0;i<=8;i=i+1) begin
			$display ("=======================================================================");
			$display ("====================== COUNTER DIVIDED BY %d ==========================",div);
			$display ("=======================================================================");
			write(ADDR_TDR0, $urandom, 4'hf);
			read(ADDR_TDR0);
			count_begin[31:0] = rdata;
			write(ADDR_TDR1, $urandom, 4'hf);
			read(ADDR_TDR1);
			count_begin[63:32] = rdata;
			write(ADDR_TCR, {20'h0000_0,mode,8'h03},4'hf);
			cycle_delay = $urandom_range(1000,2000);
			repeat(cycle_delay) @(posedge sys_clk) #1;
			read(ADDR_TDR0);
			tdr[31:0] = rdata;
			read(ADDR_TDR1);
			tdr[63:32] = rdata;
			if(div == 1)
				add_delay = 3;
			else if (div == 64 | div == 128 | div == 256)
				add_delay = 0;
			else
				add_delay = 1;
			if ((tdr >= (cycle_delay/div) + count_begin) && (tdr <= (cycle_delay/div) + count_begin + add_delay))
				$display("t=%0t [PASS]: Count in div %d mode match exp value | ACT: 64'h%h | CYCLE: 64'h%h", $time, div, tdr, cycle_delay);
			else begin 
				$display("t=%0t [FAIL]: Count in div %d mode does not match exp value | ACT: 64'h%h | CYCLE: 64'h%h", $time, div, tdr, cycle_delay);
				err = err + 1;
			end
			reset();
			div = div * 2;
			mode = mode + 1;
		end
	end
endtask


			
