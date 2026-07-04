task run_test();
	reg [31:0] tdr0_value;
	reg [63:0] cnt;
	begin

		$display ("=======================================================================");
                $display ("====================== CHECK TIMER ENABLE =============================");
                $display ("=======================================================================");
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat (10) @(posedge sys_clk) #1;
		read (ADDR_TDR0);
		if (rdata < 32'h0000_000A) begin
			$display("t=%0t [FAIL]: TDR0 = 32'h%h | Counter does not count up when timer_en assert", $time, rdata);
			err = err + 1;
		end else
			$display("t=%0t [PASS]: TDR0 = 32'h%h | Counter count up when timer_en assert", $time, rdata);
		write (ADDR_TCR, 32'h0000_0000, 4'hf);
		read (ADDR_TDR0);
		tdr0_value = rdata;
		read (ADDR_TDR0);
		if (rdata != tdr0_value) begin
			$display ("t=%0t [FAIL]: Counter does not stop when timer_en = 0 ",$time);
			err = err + 1;
		end else 
			$display("t=%0t [PASS]: Counter stopped when timer_en = 0 ",$time);
		reset();

		$display ("=======================================================================");
                $display ("====================== COUNTER CHECK COUNTING UP ======================");
                $display ("=======================================================================");
		write(ADDR_TDR0, 32'hffff_ff00, 4'hf);
		write(ADDR_TDR1, 32'h0000_0000, 4'hf);
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat(256) @(posedge sys_clk) #1;
		read(ADDR_TDR0);
		cnt[31:0] = rdata;
		read(ADDR_TDR1);
		cnt[63:32] = rdata;
		if (cnt[63:32] == 1 && cnt[31:0] < 10)
			$display("t=%0t [PASS]: cnt = 64'h%h match exp value ",$time,cnt);
		else begin
			$display("t=%0t [FAIL]: cnt = 64'h%h does not match exp value ",$time, cnt);
			err = err + 1;
		end
		reset();


		$display ("=======================================================================");
                $display ("====================== COUNTER CHECK CLEAR ============================");
                $display ("=======================================================================");
		write(ADDR_TDR0, 32'hffff_0000, 4'hf);
		write(ADDR_TDR1, 32'h0000_0001, 4'hf);
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat(10) @(posedge sys_clk) #1;
		write(ADDR_TCR, 32'h0000_0000, 4'hf);
		read(ADDR_TDR0);
		cnt[31:0] = rdata;
		read(ADDR_TDR1);
		cnt[63:32] = rdata;
		if(cnt[63:0] == 0)
			$display("t=%0t [PASS]: Counter clear when wimer_en goes high to low ",$time);
		else begin
			$display("t=%0t [FAIL]: Counter does not clear when timer_en goes high to low ",$time);
			err = err + 1;
		end
		reset();
	end
endtask
