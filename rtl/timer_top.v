module timer_top
(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire tim_psel,
    input wire tim_pwrite,
    input wire tim_penable,
    input wire [11:0] tim_paddr,
    input wire [31:0] tim_pwdata,
    input wire [3:0] tim_pstrb,
    input wire dbg_mode,
    output wire [31:0] tim_prdata,
    output wire tim_pready,
    output wire tim_pslverr,
    output wire tim_int
);
    
    //Connect Wiring
    wire div_en, timer_en, rd_en, wr_en, cnt_en, cnt_clr, tdr1_wr_sel, tdr0_wr_sel;
    wire int_en, int_st, halt_req;
    wire [3:0] div_val;
    wire [63:0] cnt;
    wire [4:0] pwdata;
    assign pwdata = {tim_pwdata [11:8], tim_pwdata [1]};

   
    //APB wait state instance 
    apb_wait_state apb_wait_state_inst
    (
        .pclk(sys_clk),
        .prst_n(sys_rst_n),
        .psel(tim_psel),
        .pwrite(tim_pwrite),
        .penable(tim_penable),
        .div_en(div_en),
        .timer_en(timer_en),
        .div_val(div_val),
        .paddr(tim_paddr), 
        .pstrb(tim_pstrb[1:0]), 
        .pwdata(pwdata),
        .pready(tim_pready),
        .pslverr(tim_pslverr), 
        .rd_en(rd_en),
        .wr_en(wr_en)
    );

    //Register instance
    register register_inst
    (
       .clk(sys_clk),
       .rst_n(sys_rst_n),
       .wr_en(wr_en),
       .rd_en(rd_en), 
       .addr(tim_paddr), 
       .wdata(tim_pwdata),
       .tim_pstrb(tim_pstrb),
       .cnt(cnt),
       .dbg_mode(dbg_mode), 
       .pslverr(tim_pslverr),
       .rdata(tim_prdata),
       .timer_en(timer_en), 
       .div_en(div_en),
       .div_val(div_val),
       .tdr0_wr_sel(tdr0_wr_sel),
       .tdr1_wr_sel(tdr1_wr_sel), 
       .int_en(int_en), 
       .int_st(int_st),
       .halt_req(halt_req)
    );

    //Counter Control Instance 
    counter_ctrl counter_ctrl_inst 
    (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .div_en(div_en),
        .timer_en(timer_en),
        .div_val(div_val),
        .halt_req(halt_req),
        .cnt_en(cnt_en),
	.cnt_clr(cnt_clr),
	.dbg_mode(dbg_mode)
    );

    //Counter instance 
    counter counter_inst
    (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
	.cnt_clr(cnt_clr),
        .cnt_en(cnt_en),
	.tim_pstrb(tim_pstrb),
	.wdata(tim_pwdata),
        .tdr0_wr_sel(tdr0_wr_sel),
        .tdr1_wr_sel(tdr1_wr_sel),  
        .cnt(cnt)
    );
    
    //Interrupt instance
    interrupt interrupt_inst
    (
        .int_en(int_en),
        .int_st(int_st),
        .tim_int(tim_int)
    );



endmodule
