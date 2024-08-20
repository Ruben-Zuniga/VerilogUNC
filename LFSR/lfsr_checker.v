// o_lfsr_checker Galois

`timescale 1ns / 100ps

module LFSR16_1002D_checker
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
    input   wire                    i_lfsr                                                      ,

    // Salidas
    output  reg  [LFSR_WIDTH-1:0]   o_lfsr_checker                                              ,
    output  wire                    o_lock
);

    // Estados
    localparam                      UNLOCKED            = 2'b00                                 ;
    localparam                      VALID               = 2'b01                                 ;
    localparam                      INVALID             = 2'b10                                 ;
    localparam                      LOCKED              = 2'b11                                 ;

    wire                            feedback                                                    ;
    wire                            test                                                        ;
    reg          [1:0]              state                                                       ;
    reg          [1:0]              state_next                                                  ;
    reg          [1:0]              invalid_cnt                                                 ;
    reg          [1:0]              invalid_cnt_next                                            ;
    reg          [2:0]              valid_cnt_next                                              ;
    reg          [2:0]              valid_cnt                                                   ;
    reg                             lock                                                        ;
    reg                             lock_next                                                   ;

    always @(*) begin

        case (state)
            UNLOCKED: begin
                lock_next           = 1'b0                                                      ;
                valid_cnt_next      = 3'd0                                                      ;
                invalid_cnt_next    = 2'd0                                                      ;
                if (test)
                    state_next      = VALID                                                     ;
                else
                    state_next      = INVALID                                                   ;
            end
            VALID: begin
                lock_next           = lock                                                      ;
                valid_cnt_next      = valid_cnt + 3'd1                                          ;
                invalid_cnt_next    = 2'd0                                                      ;
                if (test)
                    if(valid_cnt == 3'd5)
                        state_next  = LOCKED                                                    ;
                    else
                        state_next  = VALID                                                     ;
                else
                    state_next      = INVALID                                                   ;
            end
            INVALID: begin
                lock_next           = lock                                                      ;
                valid_cnt_next      = 3'd0                                                      ;
                invalid_cnt_next    = invalid_cnt + 2'd1                                        ;
                if(test)
                    state_next      = VALID                                                     ;
                else if(invalid_cnt == 2'd3)
                    state_next      = UNLOCKED                                                  ;
                else
                    state_next      = INVALID                                                   ;
            end
            LOCKED: begin
                lock_next           = 1'b1                                                      ;
                valid_cnt_next      = 3'd0                                                      ;
                invalid_cnt_next    = 2'd0                                                      ;
                if(test)
                    state_next      = VALID                                                     ;
                else
                    state_next      = INVALID                                                   ;
            end
            default: begin
                lock_next           = 1'b0                                                      ;
                valid_cnt_next      = 3'd0                                                      ;
                invalid_cnt_next    = 2'd0                                                      ;
                if (test)
                    state_next      = VALID                                                     ;
                else
                    state_next      = INVALID                                                   ;
            end
        endcase
    
    end

    always @(posedge clk or posedge i_rst) begin


        if(i_rst) begin
            o_lfsr_checker          <= LFSR_SEED                                                ;
            valid_cnt               <= 3'd0                                                     ;
            invalid_cnt             <= 2'd0                                                     ;
            lock                    <= 1'd0                                                     ;
            state                   <= UNLOCKED                                                 ;
        end
        else if(i_soft_rst) begin
            o_lfsr_checker          <= i_seed                                                   ;
            valid_cnt               <= 3'd0                                                     ;
            invalid_cnt             <= 2'd0                                                     ;
            lock                    <= 1'd0                                                     ;
            state                   <= UNLOCKED                                                 ;
        end
        else if(i_valid) begin
            o_lfsr_checker[0]       <= i_lfsr                                                   ;
            o_lfsr_checker[1]       <= o_lfsr_checker[0]                                        ;
            o_lfsr_checker[2]       <= o_lfsr_checker[1] ^ feedback                             ;
            o_lfsr_checker[3]       <= o_lfsr_checker[2] ^ feedback                             ;
            o_lfsr_checker[4]       <= o_lfsr_checker[3]                                        ;
            o_lfsr_checker[5]       <= o_lfsr_checker[4] ^ feedback                             ;
            o_lfsr_checker[15:6]    <= o_lfsr_checker[14:5]                                     ;
            
            valid_cnt               <= valid_cnt_next                                           ;
            invalid_cnt             <= invalid_cnt_next                                         ;
            lock                    <= lock_next                                                ;
            state                   <= state_next                                               ;
        end
        else
            o_lfsr_checker          <= o_lfsr_checker                                           ;
            valid_cnt               <= valid_cnt_next                                           ;
            invalid_cnt             <= invalid_cnt_next                                         ;
            lock                    <= lock_next                                                ;
            state                   <= state_next                                               ;

    end

    assign  feedback                = o_lfsr_checker[15] ^ !o_lfsr_checker                      ;
    assign  test                    = !(i_lfsr ^ feedback)                                      ;
    assign  o_lock                  = lock                                                      ;


endmodule