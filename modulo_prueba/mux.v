module mux(

    output              o_mux_data,
    input       [1:0]   i_sw,
    input       [3:0]   i_r

);

case (i_sw)

    2'b00:       o_mux_data = i_r[0];
    2'b01:       o_mux_data = i_r[1];
    2'b10:       o_mux_data = i_r[2];
    2'b11:       o_mux_data = i_r[3];
    default:     o_mux_data = 1'b1; 

endcase

endmodule