//------------------------------------------------------------------
// Escala de tiempo: la unidad de tiempo es de 1 ns y la resolucion
// es de 100 ps

// Contador: R0: cuenta 320 ns
//           R1: cuenta 160 ns
//           R2: cuenta 80 ns
//           R3: cuenta 40 ns
//------------------------------------------------------------------

`timescale 1ns/100ps

module top_tb;
    //------------------------------------------------------------------
    // Parametros
    //------------------------------------------------------------------
    
    parameter   DATA_WIDTH  = 14;   // Contador de 14 bits
    parameter   SW_WIDTH    = 4;
    parameter   LED_WIDTH   = 4;
    
    //------------------------------------------------------------------
    // Puertos: las entradas deben ser Reg y las salidas Wire
    //------------------------------------------------------------------
    
    // Clock y reset
    reg                     clock;
    reg                     i_reset;

    // Entradas
    reg     [SW_WIDTH-1:0]  i_sw;

    // Salidas
    wire    [LED_WIDTH-1:0] o_led;
    wire    [LED_WIDTH-1:0] o_led_b;
    wire    [LED_WIDTH-1:0] o_led_g;

    //------------------------------------------------------------------
    // Seniales internas: se llama a las conexiones internas para que 
    // se muestren en la simulacion
    //------------------------------------------------------------------
    
    wire                        comp_reset;
    wire    [DATA_WIDTH-1:0]    count_data;
    wire                        valid;

    assign  comp_reset  = u_top.u_count_v2.comp_reset;
    assign  count_data  = u_top.u_count_v2.count_data;
    assign  valid       = u_top.valid;
    
    //------------------------------------------------------------------
    // Generacion de clock
    //------------------------------------------------------------------
    
    always  #10  clock = ~clock;    // Reloj de 50 MHz

    //------------------------------------------------------------------
    // Testbench
    //------------------------------------------------------------------
    `define TEST_1  // Elegir el test
    
    initial begin
    
                clock           = 1'b0;
                i_reset         = 1'b0;
        #2      i_reset         = 1'b1;
        #2      i_sw            = 4'b1001;  // R0
        #10     i_reset         = 1'b0;
        
        `ifdef TEST_1   // Para comprobar el tiempo que tarda en 
                        // resetearse el contador
        #330    i_sw    [2:1]   = 2'b01;    // R1
        #170    i_sw    [2:1]   = 2'b10;    // R2
        #90     i_sw    [2:1]   = 2'b11;    // R3
        #50     $finish;
        
        `elsif TEST_2   // Cuando el contador esta a una cuenta de
                        // resetearse, se cambia el valor de referencia
        #280    i_sw    [2:1]   = 2'b10;    // R2
        #60     i_sw    [2:1]   = 2'b01;    // R1
        #80     i_sw    [2:1]   = 2'b11;    // R3
        #30     i_sw    [2:1]   = 2'b10;    // R2
        #60     $finish;
        
        `elsif TEST_3   // Para comprobar el comportamiento de los leds
        #600    i_sw    [3]             = 1'b0;
        #600    i_sw    [0]             = 1'b0;
        #100    i_sw    [0]             = 1'b1;
        #100    i_sw    [2:1]           = 2'b01;
        #220    i_sw    [3]             = 1'b1;
        #400    $finish;

        `endif
    end
    
    //------------------------------------------------------------------
    // Instanciacion
    //------------------------------------------------------------------
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
