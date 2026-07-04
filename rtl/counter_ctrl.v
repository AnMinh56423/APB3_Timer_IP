module counter_ctrl
(
    input wire clk,
    input wire rst_n,
    input wire div_en,
    input wire timer_en,
    input wire dbg_mode,
    input wire [3:0] div_val,
    input wire halt_req,
    output wire cnt_en,
    output wire cnt_clr
);
    
    wire [7:0] limit, int_cnt_pre;
    wire cnt_rst;
    reg timer_en_pre;
    reg [7:0] int_cnt;
    wire  cnt_en_1, cnt_en_2 , cnt_en_3, int_cnt_en; 
   
    assign limit = (1<<div_val) - 1;
    assign cnt_rst = (limit == int_cnt) || (~timer_en) || (~div_en); 
    assign int_cnt_en = timer_en && div_en && (div_val !=0); 
   
    assign cnt_en_1 = (int_cnt == limit) && div_en && timer_en && (div_val !=0); 
    assign cnt_en_2 = ~div_en && timer_en;
    assign cnt_en_3 = (div_val == 0) && div_en && timer_en; 

    assign int_cnt_pre =  (halt_req && dbg_mode) ? int_cnt     : 
	    		  (cnt_rst		 ? 8'h0        : 
			  int_cnt_en 		 ? int_cnt + 1 : int_cnt);
    always @(posedge clk or negedge rst_n) begin
            if(!rst_n)
                timer_en_pre <= 0;
            else
                timer_en_pre <= timer_en;
    end 

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            int_cnt <= 8'h0;
        else
            int_cnt <= int_cnt_pre; 
    end 
    assign cnt_clr = !timer_en && timer_en_pre;
    assign cnt_en = (halt_req && dbg_mode) ? 0 : (cnt_en_1 || cnt_en_2 || cnt_en_3);
                    
endmodule
