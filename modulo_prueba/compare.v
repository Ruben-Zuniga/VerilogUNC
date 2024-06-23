`timescale 1ns/100ps

module compare
#(
    parameter   DATA_WIDTH = 32
)
(
    output reg                    o_valid,
    output reg                    o_comp_reset,
    input       [DATA_WIDTH-1:0]  i_count_data,
    input       [DATA_WIDTH-1:0]  i_mux_data
);

always@(*) begin

    if(i_count_data == i_mux_data) begin
        o_valid         = 1'b1;
        o_comp_reset    = 1'b1;
        
    end else begin
        o_valid         = 1'b0;
        o_comp_reset    = 1'b0;    
    end

end

endmodule
