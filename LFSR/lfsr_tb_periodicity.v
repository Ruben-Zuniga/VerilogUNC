
    // Asignacion de i_valid
    always@(posedge clk) begin
        if($urandom_range(0,1))
            i_valid <= 1'b1                                                                     ;
        else
            i_valid <= 1'b0                                                                     ;
    end

    // Condiciones frontera del o_lock
    `ifdef TEST_1
        always@(*) i_lfsr = o_lfsr[LFSR_WIDTH-1];

    `elsif TEST_2
        always@(posedge clk) begin
            if(!i_rst && i_valid) begin
                repeat(4) begin
                    i_lfsr = o_lfsr[LFSR_WIDTH-1];
                end
                i_lfsr = !o_lfsr[LFSR_WIDTH-1];
            end
        end
    `endif
    

    initial begin
        $dumpfile("Modulos/LFSR/lfsr_tb.vcd");
        $dumpvars(0, LFSR16_1002D_tb);

        i_rst                                       = 1'b1                                      ;
        i_soft_rst                                  = 1'b0                                      ;
        i_seed                                      = LFSR_SEED                                 ;
        i_valid                                     = 1'b0                                      ;
        clk                                         = 1'b0                                      ;
        i_lfsr                                      = 1'b0                                      ;

        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        i_rst                                       = 1'b0                                      ;
        
        `ifdef PERIODICITY
            `include "tb_periodicity.v"
        `elsif CHECKER
            $display("\n-----o_lock test monitor-----")                                         ;
            
            $display("\nTEST 1: all valid")                                                     ;
            $monitor("time: %0t\to_lock: %0b", $time, o_lock)                                   ;

            `include "tb_periodicity.v"
            
        `endif
                
        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        $finish                                                                                 ;
    end