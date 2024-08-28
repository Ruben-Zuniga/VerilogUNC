// LFSR Galois top

`include "lfsr_gen.v"
`include "lfsr_checker.v"
`timescale 1ns / 100ps

module LFSR16_1002D
#(
    // Parametros
    parameter                       LFSR_SEED           = 65535                                 ,
    parameter                       LFSR_WIDTH          = 16
)
(
    // Entradas
    input   wire                    clk
);

    // Entradas VIO
    wire                            i_rst                                                       ;
    wire                            i_soft_rst                                                  ;
    wire                            i_valid                                                     ;
    wire         [LFSR_WIDTH-1:0]   i_seed                                                      ;
    wire                            i_corrupt                                                   ;

    // Salidas VIO
    wire         [LFSR_WIDTH-1:0]   o_lfsr                                                      ;
    wire         [LFSR_WIDTH-1:0]   o_lfsr_checker                                              ;
    wire                            o_lock                                                      ;

    wire         [LFSR_WIDTH-1:0]   lfsr                                                        ;

    // Corrupcion del bit 0:
    assign  lfsr = (i_corrupt)? {~o_lfsr[LFSR_WIDTH-1], o_lfsr[LFSR_WIDTH-2:0]} : o_lfsr        ;

    // Instanciacion del generador
    LFSR16_1002D_gen #(
        .LFSR_WIDTH     (LFSR_WIDTH)                                                            ,
        .LFSR_SEED      (LFSR_SEED)
    ) lfsr_gen (
        .o_lfsr         (o_lfsr)                                                                ,
        .clk            (clk)                                                                   ,
        .i_rst          (i_rst)                                                                 ,
        .i_soft_rst     (i_soft_rst)                                                            ,
        .i_seed         (i_seed)                                                                ,
        .i_valid        (i_valid)
    );

    // Instanciacion del chequeador
    LFSR16_1002D_checker #(
        .LFSR_WIDTH     (LFSR_WIDTH)                                                            ,
        .LFSR_SEED      (16'hFFFE)
    ) lfsr_checker (
        .o_lfsr_checker (o_lfsr_checker)                                                        ,
        .o_lock         (o_lock)                                                                ,
        .clk            (clk)                                                                   ,
        .i_rst          (i_rst)                                                                 ,
        .i_soft_rst     (i_soft_rst)                                                            ,
        .i_seed         (i_seed)                                                                ,
        .i_valid        (i_valid)                                                               ,
        .i_lfsr         (lfsr)
    );
    
   // Instanciacion del VIO
    vio
    u_vio (
        .clk_0          (clk)                                                                   ,
        .probe_in0_0    (o_lfsr)                                                                ,
        .probe_in1_0    (o_lfsr_checker)                                                        ,
        .probe_in2_0    (o_lock)                                                                ,
        .probe_out0_0   (i_rst)                                                                 ,
        .probe_out1_0   (i_soft_rst)                                                            ,
        .probe_out2_0   (i_valid)                                                               ,
        .probe_out3_0   (i_seed)                                                                ,
        .probe_out4_0   (i_corrupt)
    );

    // Instanciacion del ILA 
    ila
    u_ila (
        .clk_0          (clk)                                                                   ,
        .probe0_0       (o_lfsr)
    );

endmodule
