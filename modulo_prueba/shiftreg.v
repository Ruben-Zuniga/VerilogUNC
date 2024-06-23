module shiftreg 
(
    output reg  [3:0]   o_led,
    input               i_valid,
    input               i_reset,
    input               clock
);

always @(posedge clock) begin
    
    if(!i_reset) begin

        if(i_valid) 
            o_led <= o_led << 1;

        else
            o_led <= o_led;

    end 
    else 
        o_led <= 4'b0;

end

endmodule
