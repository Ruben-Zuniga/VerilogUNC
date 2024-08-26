// LFSR Galois top

`timescale 1ns / 100ps

module LFSR16_1002D
#(
    // Parametros
    parameter                       LFSR_SEED           = 65535                                 ,
    parameter                       LFSR_WIDTH          = 16
)
(
    // Entradas
    input   wire                    clk                                                         ,
    input   wire                    i_rst                                                       ,
    input   wire                    i_soft_rst                                                  ,
    input   wire                    i_valid                                                     ,
    input   wire [LFSR_WIDTH-1:0]   i_seed                                                      ,
    input   wire                    i_corrupt                                                   ,

    // Salidas
    output  wire [LFSR_WIDTH-1:0]   o_lfsr                                                      ,
    output  wire [LFSR_WIDTH-1:0]   o_lfsr_checker                                              ,
    output  wire                    o_lock
);

    wire         [LFSR_WIDTH-1:0]   lfsr;

    // Corrupcion del bit 0:
    assign  lfsr = (i_corrupt)? {~o_lfsr[LFSR_WIDTH-1], o_lfsr[LFSR_WIDTH-2:0]} : o_lfsr;

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
        .LFSR_SEED      (LFSR_SEED)
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

endmodule
