module register 
(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire pslverr,
    input wire [11:0] addr,
    input wire [31:0] wdata,
    input wire [3:0] tim_pstrb,
    input wire dbg_mode,
    input wire [63:0] cnt,
    output reg [31:0] rdata,
    output reg timer_en,
    output reg div_en,
    output reg [3:0] div_val,
    output wire tdr0_wr_sel,
    output wire tdr1_wr_sel,
    output reg int_en,
    output reg int_st,
    output reg halt_req
);
    wire [63:0] tcmp;
    
    //TCR 
    wire tcr_wr_sel;
    wire timer_en_pre, div_en_pre;
    wire [3:0] div_val_pre; 

    //TDR0, TDR1, TCMP0, TCMP1 
    wire tcmp0_wr_sel, tcmp1_wr_sel;
    wire [31:0]  tcmp0_pre, tcmp1_pre, tdr0_pre, tdr1_pre;
    reg [31:0] tdr0, tdr1, tcmp0, tcmp1;

    //TIER, TISR  
    wire tier_wr_sel, tisr_wr_sel, int_set, int_clr; 
    wire int_en_pre, int_st_pre;
   
    //THCSR 
    wire thcsr_wr_sel;
    wire halt_req_pre, halt_ack_pre;
    reg halt_ack;
    //Logic TCR
    assign tcr_wr_sel   = (addr == 12'h0) && wr_en && ~pslverr;
    assign timer_en_pre = (tcr_wr_sel && tim_pstrb[0]) ? wdata[0] : timer_en; 
    assign div_en_pre   = (tcr_wr_sel && tim_pstrb[0]) ? wdata[1] : div_en;
    assign div_val_pre  = (tcr_wr_sel && tim_pstrb[1] && wdata[11:8] < 9) ? wdata[11:8] : div_val;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            timer_en <= 1'b0;
            div_en <= 1'b0;
            div_val <= 4'b0001;
        end
        else begin
           timer_en <= timer_en_pre;
           div_en <= div_en_pre;
           div_val <= div_val_pre;
        end
    end 
    //Logic TDR0, TDR1
    assign tdr0_wr_sel =  (addr == 12'h4) && wr_en;
    assign tdr0_pre[7:0] = (tdr0_wr_sel && tim_pstrb[0]) ? wdata[7:0] : cnt[7:0]; 
    assign tdr0_pre[15:8] = (tdr0_wr_sel && tim_pstrb[1]) ? wdata[15:8] : cnt[15:8]; 
    assign tdr0_pre[23:16] = (tdr0_wr_sel && tim_pstrb[2]) ? wdata[23:16] : cnt[23:16]; 
    assign tdr0_pre[31:24] = (tdr0_wr_sel && tim_pstrb[3]) ? wdata[31:24] : cnt[31:24]; 

    assign tdr1_wr_sel =  (addr == 12'h8) && wr_en;
    assign tdr1_pre[7:0] = (tdr1_wr_sel && tim_pstrb[0]) ? wdata[7:0] : cnt[39:32]; 
    assign tdr1_pre[15:8] = (tdr1_wr_sel && tim_pstrb[1]) ? wdata[15:8] : cnt[47:40]; 
    assign tdr1_pre[23:16] = (tdr1_wr_sel && tim_pstrb[2]) ? wdata[23:16] : cnt[55:48]; 
    assign tdr1_pre[31:24] = (tdr1_wr_sel && tim_pstrb[3]) ? wdata[31:24] : cnt[63:56]; 
    always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    tdr0 <= 32'h0;
		    tdr1 <= 32'h0;
	    end else begin
		    tdr0 <= tdr0_pre;
		    tdr1 <= tdr1_pre;
	    end 
    end
    //Logic TCMP0
    assign tcmp0_wr_sel =  (addr == 12'hC) && wr_en;
    assign tcmp0_pre[7:0] = (tcmp0_wr_sel && tim_pstrb[0]) ? wdata[7:0] : tcmp0[7:0]; 
    assign tcmp0_pre[15:8] = (tcmp0_wr_sel && tim_pstrb[1]) ? wdata[15:8] : tcmp0[15:8]; 
    assign tcmp0_pre[23:16] = (tcmp0_wr_sel && tim_pstrb[2]) ? wdata[23:16] : tcmp0[23:16]; 
    assign tcmp0_pre[31:24] = (tcmp0_wr_sel && tim_pstrb[3]) ? wdata[31:24] : tcmp0[31:24]; 

    assign tcmp1_wr_sel =  (addr == 12'h10) && wr_en;
    assign tcmp1_pre[7:0] = (tcmp1_wr_sel && tim_pstrb[0]) ? wdata[7:0] : tcmp1[7:0]; 
    assign tcmp1_pre[15:8] = (tcmp1_wr_sel && tim_pstrb[1]) ? wdata[15:8] : tcmp1[15:8]; 
    assign tcmp1_pre[23:16] = (tcmp1_wr_sel && tim_pstrb[2]) ? wdata[23:16] : tcmp1[23:16]; 
    assign tcmp1_pre[31:24] = (tcmp1_wr_sel && tim_pstrb[3]) ? wdata[31:24] : tcmp1[31:24]; 
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            tcmp0 <= 32'hffff_ffff;
            tcmp1 <= 32'hffff_ffff;
        end
        else begin
           tcmp0 <= tcmp0_pre;
           tcmp1 <= tcmp1_pre;
        end
    end 
    assign tcmp = {tcmp1, tcmp0};
    
    //Logic TIER, TISR 
    assign tier_wr_sel =  (addr == 12'h14) && wr_en;
    assign int_en_pre = (tier_wr_sel && tim_pstrb[0]) ? wdata[0] : int_en; 

    
    assign tisr_wr_sel =  (addr == 12'h18) && wr_en;
    assign int_set = (cnt == tcmp);
    assign int_clr = tisr_wr_sel && (wdata[0] == 1'b1) && (tim_pstrb[0]);
    assign int_st_pre = int_clr ? 1'b0: (int_set? 1'b1: int_st); 
  
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            int_en <= 1'b0;
            int_st <= 1'b0;
        end
        else begin
           int_en <= int_en_pre;
           int_st <= int_st_pre;
        end
    end 
    //Logic THCSR
    assign thcsr_wr_sel =  (addr == 12'h1C) && wr_en;
    assign halt_req_pre = (thcsr_wr_sel && tim_pstrb[0]) ? wdata[0] : halt_req;
    assign halt_ack_pre = dbg_mode && halt_req;

    
  
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            halt_req <= 1'b0;
            halt_ack <= 1'b0;
        end
        else begin
           halt_req <= halt_req_pre;
           halt_ack <= halt_ack_pre;
        end
    end 
    //Read Data Logic
     always @(*) begin 
        case(rd_en)
            1'b0: rdata = 32'h0;
            default: begin 
                  case(addr)
                      12'h0: rdata  = {20'd0, div_val, 6'd0, div_en, timer_en};
                      12'h4: rdata  = tdr0; 
                      12'h8: rdata  = tdr1;
                      12'hC: rdata  = tcmp0;
                      12'h10: rdata = tcmp1;
                      12'h14: rdata = {31'd0, int_en};
                      12'h18: rdata = {31'd0, int_st};
                      12'h1C: rdata = {30'h0, halt_ack, halt_req};
                      default: rdata = 32'h0;
                  endcase
              end
        endcase

    end 

endmodule
