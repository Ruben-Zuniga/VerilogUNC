module led_project
#(
    parameter   DATA_WIDTH = 32,
    parameter   R0         = 3,
    parameter   R1         = 10,
    parameter   R2         = 100,
    parameter   R3         = 5000
)
(
    output      [3:0]   o_led,
    output reg  [3:0]   o_led_b,
    output reg  [3:0]   o_led_g,
    input       [3:0]   i_sw,
    input               i_reset,
    input               clock
);

wire            valid;
wire    [3:0]   led;

assign  o_led = led;

always@(*) begin

    if(i_sw) begin
        o_led_b = led;
        o_led_g = 4'b0;

    end else begin
        o_led_b = 4'b0;
        o_led_g = led;
    end

end

count #(
    .DATA_WIDTH(DATA_WIDTH),
    .R0(R0),
    .R1(R1),
    .R2(R2),
    .R3(R3)
)
u_count(
    .i_sw(i_sw[2:0]),
    .clock(clock),
    .i_reset(i_reset)        
);

shiftreg#()
u_shiftreg(
    .o_led(led),
    .i_valid(valid),
    .i_reset(i_reset),
    .clock(clock)
);

endmodule
