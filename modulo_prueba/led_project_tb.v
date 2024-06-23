`timescale 1ns/100ps

module led_project_tb;

    // Parametros
    parameter   DATA_WIDTH = 32;
    parameter   R0         = 3;
    parameter   R1         = 10;
    parameter   R2         = 20;
    parameter   R3         = 24;
    
    // Clock y reset
    reg             clock;
    reg             i_reset;

    // Entradas
    reg     [3:0]   i_sw;

    // Salidas
    wire    [3:0]   o_led;
    wire    [3:0]   o_led_b;
    wire    [3:0]   o_led_g;

    /*
    // Señales internas
    wire                        comp_reset;
    wire    [DATA_WIDTH-1:0]    count_data;
    wire                        valid;

    assign  comp_reset  = dut.u_count.comp_reset;
    assign  count_data  = dut.u_count.count_data;
    assign  valid       = dut.valid;
    */
    
    // Generacion de clock
    always  #10  clock = ~clock;

    // Testbench
    initial begin
    
                clock       = 1'b0;
                i_reset     = 1'b0;
        #2      i_reset     = 1'b1;
        #2      i_sw        = 4'b1001;
        #30     i_reset     = 1'b0;
        #600    i_sw[3]     = 1'b0;
        #600    i_sw[0]     = 1'b0;
        #100    i_sw[0]     = 1'b1;
        #100    i_sw[2:1]   = 2'b01;
        #600;
        
        $finish;
    end


    // Instanciacion
    led_project#(
        .DATA_WIDTH(DATA_WIDTH),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3))
    dut(
        .o_led(o_led),
        .o_led_b(o_led_b),
        .o_led_g(o_led_g),
        .i_sw(i_sw),
        .i_reset(i_reset),
        .clock(clock));


endmodule