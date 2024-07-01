`timescale 1ns/100ps

module top_tb;

    // Parametros
    parameter   DATA_WIDTH  = 14;
    parameter   SW_WIDTH    = 4;
    parameter   LED_WIDTH   = 4;
    
    // Seniales: las entradas deben ser Reg y las salidas Wire
    
    // Clock y reset
    reg                     clock;
    reg                     i_reset;

    // Entradas
    reg     [SW_WIDTH-1:0]  i_sw;

    // Salidas
    wire    [LED_WIDTH-1:0] o_led;
    wire    [LED_WIDTH-1:0] o_led_b;
    wire    [LED_WIDTH-1:0] o_led_g;

    // Seniales internas
    wire                        comp_reset;
    wire    [DATA_WIDTH-1:0]    count_data;
    wire                        valid;

    assign  comp_reset  = u_top.u_count_v2.comp_reset;
    assign  count_data  = u_top.u_count_v2.count_data;
    assign  valid       = u_top.valid;
    
    // Generacion de clock
    always  #10  clock = ~clock;

    // Testbench
    initial begin
    
                clock                   = 1'b0;
                i_reset                 = 1'b0;
        #2      i_reset                 = 1'b1;
        #2      i_sw                    = 4'b1001;
        #30     i_reset                 = 1'b0;
        #600    i_sw    [SW_WIDTH-1]    = 1'b0;
        #600    i_sw    [0]             = 1'b0;
        #100    i_sw    [0]             = 1'b1;
        #100    i_sw    [2:1]           = 2'b01;
        #600;
        
        $finish;
    end

    // Instanciacion
    top #(
        .DATA_WIDTH (DATA_WIDTH),
        .SW_WIDTH   (SW_WIDTH),
        .LED_WIDTH  (LED_WIDTH)
    )
    u_top (
        .o_led      (o_led),
        .o_led_b    (o_led_b),
        .o_led_g    (o_led_g),
        .i_sw       (i_sw),
        .i_reset    (i_reset),
        .clock      (clock)
    );


endmodule