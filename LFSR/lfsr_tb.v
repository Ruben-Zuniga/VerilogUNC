// Clock: 10 MHz -> 100 ns

`include "lfsr.v"
`include "lfsr_checker.v"
`timescale 1ns / 100ps

module LFSR16_1002D_tb;

    // Parametros
    parameter                       LFSR_SEED       = 65535                                     ;
    parameter                       LFSR_WIDTH      = 16                                        ;

    // Clock
    reg                             clk                                                         ;

    // Puertos
    reg         [2:0]               n_test                                                      ;
    reg                             i_rst                                                       ;
    reg                             i_soft_rst                                                  ;
    reg                             i_valid                                                     ;
    reg         [LFSR_WIDTH-1:0]    i_seed                                                      ;
    reg                             i_lfsr                                                      ;
    reg                             test_flag                                                   ;
    wire        [LFSR_WIDTH-1:0]    o_lfsr                                                      ;
    wire        [LFSR_WIDTH-1:0]    o_lfsr_checker                                              ;
    wire                            o_lock                                                      ;

    wire        [1:0]               invalid_cnt                                                 ;
    wire        [2:0]               valid_cnt                                                   ;

    // Iterador
    integer                         cnt                                                         ;

    // PERIODICITY o CHECKER
    `define                         CHECKER;
    // FIXED_SEEDS o RANDOM_SEEDS
    `define                         RANDOM_SEEDS;
    // TEST_1, TEST_2, TEST_3 o TEST_4
    `define                         TEST_2;

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
    assign valid_cnt    = lfsr_checker.valid_cnt                                                ;
    assign invalid_cnt  = lfsr_checker.invalid_cnt                                              ;

    // Asignacion de i_valid
    `ifdef PERIODICITY
        always@(posedge clk) begin
            if($urandom_range(0,1))
                i_valid <= 1'b1                                                                     ;
            else
                i_valid <= 1'b0                                                                     ;
        end
    `endif

    `ifdef CHECKER
        `ifdef TEST_1
            always@(*) i_lfsr = o_lfsr[LFSR_WIDTH-1];
        `endif
    `endif    

    initial begin
        $dumpfile("lfsr_tb.vcd");
        $dumpvars(0, LFSR16_1002D_tb);

        test_flag = 1'b0;
        i_rst                                       = 1'b1                                      ;
        i_soft_rst                                  = 1'b0                                      ;
        i_seed                                      = LFSR_SEED                                 ;
        clk                                         = 1'b0                                      ;
        i_lfsr                                      = 1'b0                                      ;
        `ifdef PERIODICITY
            i_valid                                     = 1'b0                                      ;
        `elsif CHECKER
            i_valid                                     = 1'b1                                      ;
        `endif

        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        i_rst                                       = 1'b0                                      ;
        
        repeat(4) begin

            `ifdef RANDOM_SEEDS
                while (o_lfsr != i_seed) begin

                    `ifdef CHECKER
                        `ifdef TEST_2
                            repeat(4) begin
                                i_lfsr = o_lfsr[LFSR_WIDTH-1];
                                test_flag = 1'b1;
                                #100;
                                @(posedge clk);
                            end
                            i_lfsr = !o_lfsr[LFSR_WIDTH-1];
                            test_flag = 1'b0;
                        `endif
                    `endif

                    #100;
                    @(posedge clk)                                                                  ;
                end
                Set_soft_reset($urandom_range(0,LFSR_SEED))                                         ;
            
            `elsif FIXED_SEED
                while (o_lfsr != LFSR_SEED) begin

                    `ifdef CHECKER
                        `ifdef TEST_2
                            repeat(4) begin
                                i_lfsr = o_lfsr[LFSR_WIDTH-1];
                                #100;
                                @(posedge clk);
                            end
                            i_lfsr = !o_lfsr[LFSR_WIDTH-1];
                        `endif
                    `endif
                    
                    #100;
                    @(posedge clk)                                                                  ;
                end
                Set_soft_reset(LFSR_SEED)                                                           ;
                
            `endif
            #1000;
            @(posedge clk);
        end
                
        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        $finish                                                                                 ;
    end

    // Instanciacion del generador
    LFSR16_1002D #(
        .LFSR_WIDTH     (LFSR_WIDTH     )                                                       ,
        .LFSR_SEED      (LFSR_SEED      )
    ) lfsr (
        .o_lfsr         (o_lfsr         )                                                       ,
        .clk            (clk            )                                                       ,
        .i_rst          (i_rst          )                                                       ,
        .i_soft_rst     (i_soft_rst     )                                                       ,
        .i_seed         (i_seed         )                                                       ,
        .i_valid        (i_valid        )
    );

    // Instanciacion del chequeador
    LFSR16_1002D_checker #(
        .LFSR_WIDTH     (LFSR_WIDTH     )                                                       ,
        .LFSR_SEED      (LFSR_SEED      )
    ) lfsr_checker (
        .o_lfsr_checker (o_lfsr_checker )                                                       ,
        .o_lock         (o_lock         )                                                       ,
        .clk            (clk            )                                                       ,
        .i_rst          (i_rst          )                                                       ,
        .i_soft_rst     (i_soft_rst     )                                                       ,
        .i_seed         (i_seed         )                                                       ,
        .i_valid        (i_valid        )                                                       ,
        .i_lfsr         (i_lfsr         ))                                                      ;

endmodule