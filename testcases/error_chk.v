task run_test();
	begin
		$display ("=======================================================================");
   		$display ("====================== ERROR PROHIBIT CHECK ===========================");
		$display ("=======================================================================");
		write(ADDR_TCR, {20'h0000_0, $urandom_range(4'b1001, 4'b1111), 6'd0, 2'b11}, 4'b0010);
		read(ADDR_TCR);
		if(rdata != 32'h0000_0100) begin
			err = err + 1;
			$display("t=%0t [FAIL]: Successfully wrote the prohibit value to TCR", $time);
		end else
			$display("t=%0t [PASS]: Write failed when div_val is prohibit", $time);
		reset();

		$display ("=======================================================================");
   		$display ("====================== ERROR DIV_EN CHANGE DURING TIMER_EN = 1 ========");
		$display ("=======================================================================");
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		repeat(10) @(posedge sys_clk) #1;
		write(ADDR_TCR, 32'h0000_0003, 4'hf);
		read(ADDR_TCR);
		if(rdata != 32'h0000_0001) begin
			err = err + 1;
			$display("t=%0t [FAIL]: Change div_en when timer_en = 1", $time);
		end else 
			$display("t=%0t [PASS]: Write failed div_en is not changed when timer_en = 1", $time);
		reset();


		$display ("=======================================================================");
   		$display ("====================== ERROR DIV_VAL CHANGE DURING TIMER_EN = 1 =======");
		$display ("=======================================================================");
		write(ADDR_TCR, 32'h0000_0001, 4'hf);
		write(ADDR_TCR, 32'h0000_0501, 4'hf);
		read(ADDR_TCR);
		if(rdata != 32'h0000_0001) begin
			err = err + 1;
			$display("t=%0t [FAIL]: Change div_val when timer_en = 1", $time);
		end else 
			$display("t=%0t [PASS]: Write failed div_val is not changed when timer_en = 1", $time);
		reset();
	end
endtask




