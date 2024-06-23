module mux
#(  
    parameter   DATA_WIDTH = 32,
    parameter   R0         = 3,
    parameter   R1         = 10,
    parameter   R2         = 100,
    parameter   R3         = 5000
 )
(
    output reg  [DATA_WIDTH-1:0] o_mux_data,
    input       [1:0]            i_sw
);

always@(*) begin
    case (i_sw)
    
        2'b00:       o_mux_data = R0;
        2'b01:       o_mux_data = R1;
        2'b10:       o_mux_data = R2;
        2'b11:       o_mux_data = R3;
        default:     o_mux_data = {DATA_WIDTH{1'b0}};

    endcase
end

endmodule
