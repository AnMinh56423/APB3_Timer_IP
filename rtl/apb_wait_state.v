module apb_wait_state
( 
    input wire pclk,
    input wire prst_n,
    input wire psel,
    input wire pwrite,
    input wire penable,
    input wire div_en,
    input wire timer_en,
    input wire [3:0] div_val,
    input wire [11:0] paddr,
    input wire [1:0] pstrb,
    input wire [4:0] pwdata,
    output wire pready,
    output wire pslverr,
    output reg rd_en,
    output reg wr_en

);  
    wire rd_en_pre, wr_en_pre, tcr_wr_sel; 
    assign rd_en_pre = psel && ~pwrite && penable && ~rd_en;
    assign wr_en_pre = psel &&  pwrite && penable && ~wr_en;
    always @(posedge pclk or negedge prst_n) begin
        if(!prst_n) begin
            rd_en <= 1'b0;
            wr_en <= 1'b0;
        end else begin
            rd_en <= rd_en_pre;
            wr_en <= wr_en_pre;
        end
    end
    assign pready     = wr_en | rd_en;
    assign tcr_wr_sel = (paddr == 12'h0) && wr_en; 
    assign pslverr    = (((pwdata[4:1] >8) & pstrb[1]) | (timer_en & pstrb[0] & (pwdata[0] != div_en)) | (timer_en & pstrb[1] & (pwdata[4:1] != div_val))) && tcr_wr_sel;
endmodule
