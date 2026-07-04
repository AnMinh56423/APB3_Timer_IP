task run_test();
	reg [31:0] test_wdata;
	integer i;
	begin
		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK INNIT VALUE =======================");
		$display ("=======================================================================");
		reset();
		read(ADDR_TCR);
		compare(DF_TCR);
		
		read(ADDR_TDR0);
		compare(DF_TDR0);
		
		read(ADDR_TDR1);
		compare(DF_TDR1);
		
		read(ADDR_TCMP0);
		compare(DF_TCMP0);
		
		read(ADDR_TCMP1);
		compare(DF_TCMP1);
		
		read(ADDR_TIER);
		compare(DF_TIER);

		read(ADDR_TISR);
		compare(DF_TISR);
		
		read(ADDR_THCSR);
		compare(DF_THCSR);


		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK WRITE READ ========================");
		$display ("=======================================================================");
		//TCR R/W Access
		$display ("TCR");
		wr_rd_cmp(ADDR_TCR, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TCR, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TCR, 32'haaaa_aaaa, 4'hf);

		//TDR0 R/W Access
		$display ("TDR0");
		wr_rd_cmp(ADDR_TDR0, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TDR0, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TDR0, 32'haaaa_aaaa, 4'hf); 

		//TDR1 R/W Access
		$display ("TDR1");
		wr_rd_cmp(ADDR_TDR1, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TDR1, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TDR1, 32'haaaa_aaaa, 4'hf); 

		//TCMP0 R/W Access
		$display ("TCMP0");
		wr_rd_cmp(ADDR_TCMP0, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TCMP0, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TCMP0, 32'haaaa_aaaa, 4'hf); 

		//TCMP1 R/W Access
		$display ("TCMP1");
		wr_rd_cmp(ADDR_TCMP1, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TCMP1, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TCMP1, 32'haaaa_aaaa, 4'hf); 

		//TIER R/W Access
		$display ("TIER");
		wr_rd_cmp(ADDR_TIER, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TIER, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TIER, 32'haaaa_aaaa, 4'hf); 

		//TISR R/W Access
		$display ("TISR");
		wr_rd_cmp(ADDR_TISR, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_TISR, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_TISR, 32'haaaa_aaaa, 4'hf); 
		
		//THCSR R/W Access
		$display ("THCSR");
		wr_rd_cmp(ADDR_THCSR, 32'h0000_0000, 4'hf); 
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'hf); 
		wr_rd_cmp(ADDR_THCSR, 32'h5555_5555, 4'hf); 
		wr_rd_cmp(ADDR_THCSR, 32'haaaa_aaaa, 4'hf); 
		reset();

		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK ONE HOT ===========================");
		$display ("=======================================================================");
		wr_rd_cmp (ADDR_TCR, 32'h1111_1111, 4'hf);
		wr_rd_cmp (ADDR_TDR0, 32'h2222_2222, 4'hf);
		wr_rd_cmp (ADDR_TDR1, 32'h3333_3333, 4'hf);
		wr_rd_cmp (ADDR_TCMP0, 32'h4444_4444, 4'hf);
		wr_rd_cmp (ADDR_TCMP1, 32'h5555_5555, 4'hf);
		wr_rd_cmp (ADDR_TIER, 32'h8888_8888, 4'hf);
		wr_rd_cmp (ADDR_TISR, 32'h9999_9999, 4'hf);
		wr_rd_cmp (ADDR_THCSR, 32'ha5a5_a5a5, 4'hf);
		reset();
		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK RESERVED ==========================");
		$display ("=======================================================================");

		wr_rd_cmp (12'h20, 32'haaaa_aaaa, 4'hf);
		wr_rd_cmp (12'h20, 32'h5555_5555, 4'hf);
		wr_rd_cmp (12'h800, 32'haaaa_aaaa, 4'hf);
		wr_rd_cmp (12'h800, 32'h5555_5555, 4'hf);
		wr_rd_cmp (12'h804, 32'haaaa_aaaa, 4'hf);
		wr_rd_cmp (12'h804, 32'h5555_5555, 4'hf);
		wr_rd_cmp (12'hfff, 32'haaaa_aaaa, 4'hf);
		wr_rd_cmp (12'hfff, 32'h5555_5555, 4'hf);
		reset();
		$display ("=======================================================================");
		$display ("==================== REGISTER CHECK BYTE ACCESS =======================");
		$display ("=======================================================================");
		$display ("TCR");
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_TCR, 32'hffff_ffff, 4'hC);

		$display ("TDR0");
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_TDR0, 32'hffff_ffff, 4'hC);

		$display ("TDR1");
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_TDR1, 32'hffff_ffff, 4'hC);

		$display ("TCMP0");
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'h1);
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'h2);
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'h4);
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'h8);
		wr_rd_cmp(ADDR_TCMP0, 32'h5555_5555, 4'hC);

		$display ("TCMP1");
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'h1);
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'h2);
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'h4);
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'h8);
		wr_rd_cmp(ADDR_TCMP1, 32'h5555_5555, 4'hC);

		$display ("TIER");
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_TIER, 32'hffff_ffff, 4'hC);

		$display ("TISR");
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_TISR, 32'hffff_ffff, 4'hC);

		$display ("THCSR");
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'h1);
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'h2);
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'h4);
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'h8);
		wr_rd_cmp(ADDR_THCSR, 32'hffff_ffff, 4'hC);

		//Coverage
		write(ADDR_TCR, 32'h0000_0000, 4'hf);
		repeat(10) @(posedge sys_clk) #1;

		write(ADDR_TCR, 32'h0000_0002, 4'hf);
		repeat(10) @(posedge sys_clk) #1;

		write(ADDR_TCR, 32'h0000_0000, 4'hf);
		repeat(10) @(posedge sys_clk) #1;

		write(ADDR_TCR, 32'h0000_0002, 4'hf);
		repeat(10) @(posedge sys_clk) #1;

	end
endtask
