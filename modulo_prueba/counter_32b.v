module counter_32b
#(
    parameter   DATA_WIDTH = 32
)
(
    output reg  [DATA_WIDTH-1:0]  o_count_data,
    input                         i_sw,
    input                         i_comp_reset,
    input                         i_reset,
    input                         clock
);

always @(posedge clock or posedge i_reset or posedge i_comp_reset) begin

    if(!i_reset && !i_comp_reset) begin
        
        if(i_sw) o_count_data <= o_count_data + 1;
        else     o_count_data <= o_count_data;

    end else
        o_count_data <= 0;
    
end

endmodule
