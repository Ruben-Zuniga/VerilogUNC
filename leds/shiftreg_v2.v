`timescale 1ns/100ps

module shiftreg_v2
    #(
        parameter   LED_WIDTH = 4
    )
    (
        output reg  [3:0]   o_led,
        input               i_valid,
        input               i_reset,
        input               clock
    );
    
    always @(posedge clock) begin
        
        if(!i_reset) begin
    
            if(i_valid) begin
                o_led    <= o_led << 1;
                o_led[0] <= o_led[LED_WIDTH-1];
    
            end else
                o_led <= o_led;
    
        end 
        else 
            o_led <= {{LED_WIDTH{1'b0}}, 1'b1};
    
    end

endmodule