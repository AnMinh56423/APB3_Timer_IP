task run_test();
	begin
		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK WRITE READ ========================");
		$display ("=======================================================================");
		$display ("========== Check counter when enabled halt_req (No debug mode) ========");
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat(256) @(posedge sys_clk);
		write(ADDR_THCSR, 32'h0000_0001, 4'hf);
		repeat(20) @(posedge sys_clk);
		read(ADDR_TDR0);
		if(rdata > 256 && rdata < 256 + 7) begin
			$display("t=%0t [FAIL]: Counter stopped when halt_req = 1 even if dbg_mode = 0",$time);
			err = err + 1;
		end else 
			$display("t=%0t [PASS]: Counter does not stop when halt_req = 1 & dbg_mode = 0",$time);

		$display ("========== Check Halt_ack when enabled halt_req (Not in dbg_mode) =====");
		read(ADDR_THCSR);
		if(rdata[1] != 0) begin
			$display("t=%0t [FAIL]: Halt_ack = %b when halt_req = 1 even if dbg_mode = 0",$time, rdata[1]);
			err = err + 1;
		end else 
			$display("t=%0t [PASS]: Halt_ack = %b when halt_req = 1 & dbg_mode = 0", $time, rdata[1]);
		reset();
		$display ("========== Check counter when enabled halt_req (Debug mode) ============");
		dbg_mode = 1;
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat(256) @(posedge sys_clk);
		write(ADDR_THCSR, 32'h0000_0001, 4'hf);
		repeat(20) @(posedge sys_clk);
		read(ADDR_TDR0);
		if(rdata < 256 && rdata > 256 + 7) begin
			$display("t=%0t [FAIL]: Counter does not stop when halt_req = 1 & dbg_mode = 1",$time);
			err = err + 1;
		end else 
			$display("t=%0t [PASS]: Counter stopped when halt_req = 1 & dbg_mode = 0",$time);

		$display ("========== Check Halt_ack when enabled halt_req (Debug mode) ============");
		read(ADDR_THCSR);
		if(rdata[1] != 1) begin
			$display("t=%0t [FAIL]: Halt_ack = %b when halt_req = 1 & dbg_mode = 1",$time, rdata[1]);
			err = err + 1;
		end else 
			$display("t=%0t [PASS]: Halt_ack = %b when halt_req = 1 & dbg_mode = 1", $time, rdata[1]);
		reset();
	end
endtask

