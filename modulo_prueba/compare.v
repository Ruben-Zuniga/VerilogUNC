module compare(

    output              o_valid,
    output              o_comp_reset,
    input       [31:0]  i_count,
    input               i_mux_data

);

if() begin

    o_valid         = 1'b1;
    o_comp_reset    = 1'b1;

end else begin

    o_valid         = 1'b0;
    o_comp_reset    = 1'b0;
    
end

endmodule