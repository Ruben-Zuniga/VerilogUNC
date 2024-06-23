module count 
#(
    parameter   DATA_WIDTH = 32,
    parameter   R0         = 3,
    parameter   R1         = 10,
    parameter   R2         = 100,
    parameter   R3         = 5000
)
(

    output              o_valid,
    input       [2:0]   i_sw,
    input               i_reset,
    input               clock

);

wire    [DATA_WIDTH-1:0]    count_data;
wire    [DATA_WIDTH-1:0]    mux_data;
wire                        comp_reset;

mux #(
    .DATA_WIDTH(DATA_WIDTH),
    .R0(R0),
    .R1(R1),
    .R2(R2),
    .R3(R3)
)
u_mux(
    .o_mux_data(mux_data),
    .i_sw(i_sw[2:1])
);

counter_32b #(
    .DATA_WIDTH(DATA_WIDTH)
)
u_counter_32b(
    .o_count_data(count_data),
    .i_sw(i_sw[0]),
    .i_comp_reset(comp_reset),
    .i_reset(i_reset),
    .clock(clock)
);

compare#(
    .DATA_WIDTH(DATA_WIDTH)
)
u_compare(
    .o_valid(o_valid),
    .o_comp_reset(comp_reset),
    .i_count_data(count_data),
    .i_mux_data(mux_data)
);

endmodule
