module counter
(
    input wire clk,
    input wire rst_n,
    input wire cnt_en,
    input wire cnt_clr,
    input wire [3:0] tim_pstrb,
    input wire [31:0] wdata,
    input wire tdr0_wr_sel,
    input wire tdr1_wr_sel,
    output reg [63:0] cnt
);
    wire [63:0] count;

    assign count [7:0] = (tdr0_wr_sel && tim_pstrb [0]) ? wdata [7:0] : cnt [7:0];
    assign count [15:8] = (tdr0_wr_sel && tim_pstrb [1]) ? wdata [15:8] : cnt [15:8];
    assign count [23:16] = (tdr0_wr_sel && tim_pstrb [2]) ? wdata [23:16] : cnt [23:16];	    
    assign count [31:24] = (tdr0_wr_sel && tim_pstrb [3]) ? wdata [31:24] : cnt [31:24];
    assign count [39:32] = (tdr1_wr_sel && tim_pstrb [0]) ? wdata [7:0] : cnt [39:32];
    assign count [47:40] = (tdr1_wr_sel && tim_pstrb [1]) ? wdata [15:8] : cnt [47:40];
    assign count [55:48] = (tdr1_wr_sel && tim_pstrb [2]) ? wdata [23:16] : cnt [55:48];
    assign count [63:56] = (tdr1_wr_sel && tim_pstrb [3]) ? wdata [31:24] : cnt [63:56];
    always @(posedge clk or negedge rst_n) begin
	    if(!rst_n) begin
		    cnt <= 0;
	    end else if (cnt_clr) begin
		    cnt <= 0;
	    end else if (tdr0_wr_sel) begin
		    cnt [31:0] <= count [31:0];
	    end else if (tdr1_wr_sel) begin 
	    	    cnt [63:32] <= count [63:32];
	    end else if (cnt_en) begin
		    cnt <= cnt + 1;
	    end else begin
		    cnt <= cnt;
	    end
    end
endmodule
