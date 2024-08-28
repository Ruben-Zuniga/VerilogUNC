// Clock: 10 MHz -> 100 ns

//`include "lfsr.v"
`timescale 1ns / 100ps

module LFSR16_1002D_tb;

    // Parametros
    parameter                       LFSR_SEED       = 65535                                     ;
    parameter                       LFSR_WIDTH      = 16                                        ;

    // Clock
    reg                             clk                                                         ;

    // Puertos
    reg                             test_flag                                                   ;
    reg                             i_rst                                                       ;
    reg                             i_soft_rst                                                  ;
    reg                             i_valid                                                     ;
    reg         [LFSR_WIDTH-1:0]    i_seed                                                      ;
    reg                             i_corrupt                                                   ;
    wire        [LFSR_WIDTH-1:0]    o_lfsr                                                      ;
    wire        [LFSR_WIDTH-1:0]    o_lfsr_checker                                              ;
    wire                            o_lock                                                      ;

    wire        [1:0]               invalid_cnt                                                 ;
    wire        [2:0]               valid_cnt                                                   ;

    // PERIODICITY o CHECKER
    `define                         CHECKER;
    // FIXED_SEEDS o RANDOM_SEEDS
    `define                         RANDOM_SEEDS;
    // TEST_1, TEST_2, TEST_3 o TEST_4
    `define                         TEST_4;

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

        $display("Soft reset at %0t ns", $time)                                             ;
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

    // Contadores
    assign valid_cnt    = dut.lfsr_checker.valid_cnt                                                ;
    assign invalid_cnt  = dut.lfsr_checker.invalid_cnt                                              ;

    `ifdef PERIODICITY
        `include "lfsr_tb_periodicity.v"

    `elsif CHECKER
        `include "lfsr_tb_checker.v"

    `endif

    // Instanciacion del modulo
    LFSR16_1002D #(
        .LFSR_WIDTH     (LFSR_WIDTH)                                                            ,
        .LFSR_SEED      (LFSR_SEED)
    ) dut (
        .o_lfsr         (o_lfsr)                                                                ,
        .o_lfsr_checker (o_lfsr_checker)                                                        ,
        .o_lock         (o_lock)                                                                ,
        .clk            (clk)                                                                   ,
        .i_rst          (i_rst)                                                                 ,
        .i_soft_rst     (i_soft_rst)                                                            ,
        .i_seed         (i_seed)                                                                ,
        .i_valid        (i_valid)                                                               ,
        .i_corrupt      (i_corrupt)
    );

endmodule