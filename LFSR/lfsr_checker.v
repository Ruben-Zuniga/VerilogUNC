// o_lfsr Galois

`timescale 1ns / 100ps

module LFSR16_1002D_checker
#(
    parameter                       LFSR_WIDTH          = 16                                    ,
    parameter                       LFSR_SEED           = 65535
)
(
    input   wire                    i_rst                                                       ,
    input   wire                    i_soft_rst                                                  ,
    input   wire                    i_valid                                                     ,
    input   wire [LFSR_WIDTH-1:0]   i_seed                                                      ,
    input   wire                    i_lfsr                                                      ,
    output  reg  [LFSR_WIDTH-1:0]   o_lfsr_checker                                              ,
    output  wire                    o_lock
);

    localparam                      UNLOCKED            = 2'b00                                 ;
    localparam                      VALID               = 2'b01                                 ;
    localparam                      INVALID             = 2'b10                                 ;
    localparam                      LOCKED              = 2'b11                                 ;

    wire                            feedback                                                    ;
    wire                            test                                                        ;
    reg          [1:0]              state                                                       ;
    reg          [1:0]              state_next                                                  ;
    reg                             lock                                                        ;
    reg                             lock_next                                                   ;

    always @(posedge i_valid or posedge i_rst) begin

        if(i_rst) begin
            o_lfsr          <= LFSR_SEED                                                        ;
        end
        else if(i_soft_rst) begin
            o_lfsr          <= i_seed                                                           ;
        end
        else begin
            o_lfsr[0]       <= i_lfsr                                                           ;
            o_lfsr[1]       <= o_lfsr[0]                                                        ;
            o_lfsr[2]       <= o_lfsr[1] ^ feedback                                             ;
            o_lfsr[3]       <= o_lfsr[2] ^ feedback                                             ;
            o_lfsr[4]       <= o_lfsr[3]                                                        ;
            o_lfsr[5]       <= o_lfsr[4] ^ feedback                                             ;
            o_lfsr[15:6]    <= o_lfsr[14:5]                                                     ;
        end

        case (state)
            : 
            default: 
        endcase
    end

    assign  feedback        = o_lfsr[15] ^ !o_lfsr                                              ;
    assign  test            = i_lfsr     ^ feedback                                             ;
    assign  o_lock          = lock                                                              ;


endmodule
