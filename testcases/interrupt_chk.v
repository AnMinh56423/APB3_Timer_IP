task run_test();
	begin
		$display ("=======================================================================");
		$display ("====================== INTERRUPT CHECK ================================");
		$display ("=======================================================================");
		$display ("------Check Interrupt Asserted------");
		write(ADDR_TCMP0, 32'h0000_00ff, 4'hf);
		write(ADDR_TCMP1, 32'h0000_0000, 4'hf);
		write(ADDR_TIER, 32'h0000_0001, 4'h1);
		write(ADDR_TCR, 32'h0000_0001, 4'h1);
		repeat(256 + 3) @(posedge sys_clk) #1;
		if (tim_int === 1) 
			$display("t=%0t [PASS]: Interrupt is asserted",$time);
		else begin
			$display("t=%0t [FAIL]: Interrupt is not asserted",$time);
			err = err + 1;
		end
		$display ("------Check Interrupt Status------");
		read(ADDR_TISR);
		if(rdata[0] == 1) 
			$display("t=%0t [PASS]: Interrupt status is 1 when interrupt assert",$time);
		else begin
			$display("t=%0t [FAIL]: Interrupt status is 0  when interrupt assert", $time);
			err = err + 1;
		end

		$display ("------Check Interrupt when timer int_en is disable------");
		write(ADDR_TIER, 32'h0000_0000, 4'hf);
		if(tim_int != 1) 
			$display("t=%0t [PASS]: Interrupt negated when int_en is disabled", $time);
		else begin
			$display("t=%0t [FAIL]: Interrupt is not negated when int_en is disabled", $time);
			err = err + 1;
		end

		$display ("------Check Interrupt status when timer int_en is disabled------");
		read(ADDR_TISR);
		if(rdata[0] == 1) 
			$display("t=%0t [PASS]: Interrupt status does not change when int_en is disabled", $time);
		else begin
			$display("t=%0t [FAIL]: Interrupt status change when int_en is disabled", $time);
			err = err + 1;
		end

		$display ("------Check Clear Interrupt Status------");
		write(ADDR_TISR, 32'h0000_0001, 4'h1);
		read(ADDR_TISR);
		read(ADDR_TISR);
		if(rdata[0] == 0) 
			$display("t=%0t [PASS]: Interrupt Cleared when write 1 to int_st", $time);
		else begin
			$display("t=%0t [FAIL]: Interrupt is not Cleared when write 1 to int_st", $time);
			err = err + 1;
		end

		$display ("------Check Interrupt in manual way------");
		reset();
		write(ADDR_TDR0, 32'hffff_ffff, 4'hf);
		write(ADDR_TDR1, 32'hffff_ffff, 4'hf);
		$display("==> Check if interrupt reach trigger condition when int_en = 0");
		if(tim_int == 0) 
			$display("t=%0t [PASS]: Interrupt is not asserted when reach trigger condition",$time);
		else begin
			$display("t=%0t [FAIL]: Interrupt is asserted when reach trigger condition even if int_en", $time);
			err = err + 1;
		end
		$display("==> Check if interrupt reach trigger condition when int_en = 1");
		if(tim_int == 0) 
			$display("t=%0t [PASS]: Interrupt is asserted when reach trigger condition & int_en = 1",$time);
		else begin
			$display("t=%0t [FAIL]: Interrupt is not asserted when reach trigger condition & int_en", $time);
			err = err + 1;
		end
	end
endtask
