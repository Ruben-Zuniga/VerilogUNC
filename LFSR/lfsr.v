// o_lfsr Galois

`timescale 1ns / 100ps

module LFSR16_1002D
#(
    parameter                       LFSR_WIDTH  = 16                                        ,
    parameter                       LFSR_SEED   = 65535
)
(
    input   wire                    i_rst                                                   ,
    input   wire                    i_soft_rst                                              ,
    input   wire                    i_valid                                                 ,
    input   wire [LFSR_WIDTH-1:0]   i_seed                                                  ,
    output  reg  [LFSR_WIDTH-1:0]   o_lfsr
);

    wire    feedback;

    always @(posedge i_valid or posedge i_rst) begin

        if(i_rst) begin
            o_lfsr          <= LFSR_SEED                                                        ;
        end
        else if(i_soft_rst) begin
            o_lfsr          <= i_seed                                                           ;
        end
        else begin
            o_lfsr[0]       <= feedback                                                         ;
            o_lfsr[1]       <= o_lfsr[0]                                                        ;
            o_lfsr[2]       <= o_lfsr[1] ^ feedback                                             ;
            o_lfsr[3]       <= o_lfsr[2] ^ feedback                                             ;
            o_lfsr[4]       <= o_lfsr[3]                                                        ;
            o_lfsr[5]       <= o_lfsr[4] ^ feedback                                             ;
            o_lfsr[15:6]    <= {o_lfsr[14:5]}                                                   ;
        end

    end

    assign  feedback        = o_lfsr[15] ^ !o_lfsr;

endmodule
