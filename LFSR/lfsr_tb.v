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

    // Tarea que cambia el valor de i_seed
    task Change_seed
    (
        input   [LFSR_WIDTH-1:0]    i_new_seed
    );
        i_seed  = i_new_seed                                                                    ;

    endtask

    // Tarea que setea el soft reset
    task Set_soft_reset
    (
        input   [LFSR_WIDTH-1:0]    i_new_seed 
    ); begin

        i_soft_rst                                  = 1'b1                                      ;
        Change_seed(i_new_seed)                                                                 ;

        while (!($random(s_soft_reset) % 2)) begin
            #1000                                                                               ;
        end

        @(posedge i_valid)                                                                      ;
        i_soft_rst                                  = 1'b0                                      ;

    end
    endtask

    // Tarea que setea el hard reset
    task Set_hard_reset; begin

        i_rst                                       = 1'b1                                      ;

        while (!($random(s_hard_reset) % 2)) begin
            #1000                                                                               ;
        end

        @(posedge i_valid)                                                                      ;
        i_rst                                       = 1'b0                                      ;

    end
    endtask

    // Clock de 10 MHz
    always #50 clk = ~clk                                                                       ;

    // Asignacion de i_valid
    always@(posedge clk) begin

        if($random(s_valid) % 2)
            i_valid                                 <= 1'b1                                     ;
        else
            i_valid                                 <= 1'b0                                     ;

    end

    initial begin
        i_rst                                       = 1'b1                                      ;
        i_soft_rst                                  = 1'b0                                      ;
        i_seed                                      = 1'b0                                      ;
        i_valid                                     = 1'b0                                      ;
        clk                                         = 1'b0                                      ;

        #10000                                                                                  ;
        @(posedge i_valid)                                                                      ;
        i_rst                                       = 1'b0                                      ;

        #10                                                                                     ;
        @(o_lfsr == LFSR_SEED)                                                                  ;
        Set_soft_reset( {$random(s_soft_reset)} % LFSR_SEED )                                   ;
        
        #10000                                                                                  ;
        @(posedge i_valid)                                                                      ;
        Set_soft_reset( {$random(s_soft_reset)} % LFSR_SEED )                                   ;

        #10000                                                                                  ;
        @(posedge i_valid)                                                                      ;
        Set_soft_reset( {$random(s_soft_reset)} % LFSR_SEED )                                   ;

        #10000                                                                                  ;
        @(posedge i_valid)                                                                      ;
        $finish                                                                                 ;
    end

    // Instanciacion del diseño
    LFSR16_1002D #(
        .LFSR_WIDTH (LFSR_WIDTH)                                                                ,
        .LFSR_SEED  (LFSR_SEED)
    ) dut (
        .o_lfsr     (o_lfsr)                                                                    ,
        .i_rst      (i_rst)                                                                     ,
        .i_soft_rst (i_soft_rst)                                                                ,
        .i_seed     (i_seed)                                                                    ,
        .i_valid    (i_valid)
    );

endmodule


        /*
         * Para setear cada tiempo random el reset

        while (!i_soft_rst) begin
            #1000;
            @(posedge i_valid);

            if($random(s_soft_reset) % 2)
                i_soft_rst = 1'b1;
            else
                i_soft_rst = 1'b0;

        end

        #1000
        @(posedge i_valid);
        i_soft_rst = 1'b0;
        */
