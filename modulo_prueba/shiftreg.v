module shiftreg (

    output      [3:0]   o_led,
    input               i_valid,
    input               i_reset,
    input               clock

);

always @(posedge clock) begin
    
    if(!i_reset) begin
        
        if(i_valid) begin
            
            o_led << 1;

        end

    end else begin
        
        o_led << 4'b0;

    end

end

endmodule