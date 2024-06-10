module counter_32b(

    output      [31:0]  o_count,
    input               i_sw,
    input               i_comp_reset,
    input               i_reset,
    input               clock

);

always @(posedge clock) begin

    if(!i_reset and !i_comp_reset) begin
        
        if(i_sw) begin

            o_count = o_count + 1;

        end

    end else begin
        
        o_count = 0;

    end
    
end

endmodule