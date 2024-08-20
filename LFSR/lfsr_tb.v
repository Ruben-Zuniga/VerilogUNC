// Clock: 10 MHz -> 100 ns
`timescale 1ns / 100ps

module LFSR16_1002D_tb;

    // Parametros
    parameter                       LFSR_SEED       = 65535                                     ;
    parameter                       LFSR_WIDTH      = 16                                        ;

    // Clock
    reg                             clk                                                         ;

    // Puertos
    reg                             i_rst                                                       ;
    reg                             i_soft_rst                                                  ;
    reg                             i_valid                                                     ;
    reg         [LFSR_WIDTH-1:0]    i_seed                                                      ;
    wire        [LFSR_WIDTH-1:0]    o_lfsr                                                      ;

    // Seeds $random
    integer                         s_soft_reset    = 100                                       ;
    integer                         s_hard_reset    = 200                                       ;
    integer                         s_valid         = 300                                       ;
    integer                         delay                                                       ;

    `define                         RANDOM_SEEDS    = 1'b1                                      ; 

    // Tarea que cambia el valor de i_seed
    task Change_seed
    (
        input   [LFSR_WIDTH-1:0]    new_seed
    );
        i_seed  = new_seed                                                                      ;

    endtask

    // Tarea que setea el soft reset
    task Set_soft_reset
    (
        input   [LFSR_WIDTH-1:0]    new_seed 
    ); begin

        i_soft_rst                                  = 1'b1                                      ;
        Change_seed(new_seed)                                                                   ;
        #($urandom_range(200,1000))                                                             ;
        @(posedge clk)                                                                          ;
        i_soft_rst                                  = 1'b0                                      ;

    end
    endtask

    // Tarea que setea el hard reset
    task Set_hard_reset; begin

        i_rst                                       = 1'b1                                      ;
        #($urandom_range(200,1000))                                                             ;
        @(posedge clk)                                                                          ;
        i_rst                                       = 1'b0                                      ;

    end
    endtask

    // Clock de 10 MHz
    always #50 clk = ~clk                                                                       ;

    // Asignacion de i_valid
    always@(posedge clk) begin
        if($urandom_range(0,1))
            i_valid                                 <= 1'b1                                     ;
        else
            i_valid                                 <= 1'b0                                     ;
    end

    initial begin
        $dumpfile("Modulos/LFSR/lfsr_tb.vcd");
        $dumpvars(0, LFSR16_1002D_tb);

        i_rst                                       = 1'b1                                      ;
        i_soft_rst                                  = 1'b0                                      ;
        i_seed                                      = 1'b0                                      ;
        i_valid                                     = 1'b0                                      ;
        clk                                         = 1'b0                                      ;

        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        i_rst                                       = 1'b0                                      ;

        repeat(5) begin
        #1000                                                                                   ;
        if(RANDOM_SEEDS) begin
            while (o_lfsr != i_seed)
                @(posedge clk)                                                                  ;
            Set_soft_reset($urandom_range(0,LFSR_SEED))                                         ;
        end
        else begin
            while (o_lfsr != LFSR_SEED)
                @(posedge clk)                                                                  ;
            Set_soft_reset(LFSR_SEED)                                                           ;
        end
        end
        
        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        $finish                                                                                 ;
    end

    // Instanciacion del diseño
    LFSR16_1002D #(
        .LFSR_WIDTH (LFSR_WIDTH)                                                                ,
        .LFSR_SEED  (LFSR_SEED)
    ) dut (
        .o_lfsr     (o_lfsr)                                                                    ,
        .clk        (clk)                                                                       ,
        .i_rst      (i_rst)                                                                     ,
        .i_soft_rst (i_soft_rst)                                                                ,
        .i_seed     (i_seed)                                                                    ,
        .i_valid    (i_valid)
    );

endmodule