`timescale 1ns/100ps

module top
    #(
        parameter   DATA_WIDTH  = 32,
        parameter   SW_WIDTH    = 4,
        parameter   LED_WIDTH   = 4
    )
    (
        output      [LED_WIDTH-1:0] o_led,
        output reg  [LED_WIDTH-1:0] o_led_b,
        output reg  [LED_WIDTH-1:0] o_led_g,
        input       [SW_WIDTH-1:0]  i_sw,
        input                       i_reset,
        input                       clock
    );
    
    wire                    valid;
    wire    [LED_WIDTH-1:0] led;
    
    
    always@(*) begin
    
        if(i_sw[SW_WIDTH-1]) begin
            o_led_b = led;
            o_led_g = 4'b0;
    
        end else begin
            o_led_b = 4'b0;
            o_led_g = led;
        end
    
    end
    
    count_v2 #(
        .DATA_WIDTH(DATA_WIDTH),
        .SW_WIDTH(SW_WIDTH)
    )
    u_count_v2(
        .o_valid(valid),
        .i_sw(i_sw[2:0]),
        .clock(clock),
        .i_reset(i_reset)        
    );
    
    shiftreg_v2 #(
        .LED_WIDTH(LED_WIDTH)
    )
    u_shiftreg_v2(
        .o_led(led),
        .i_valid(valid),
        .i_reset(i_reset),
        .clock(clock)
    );
    
    assign  o_led = led;

endmodule