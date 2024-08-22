
    // Asignacion de i_valid
    always@(posedge clk) begin
        if($urandom_range(0,1))
            i_valid <= 1'b1                                                                     ;
        else
            i_valid <= 1'b0                                                                     ;
    end

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
        
        repeat(4) begin
            #1000                                                                                   ;
            `ifdef RANDOM_SEEDS
                while (o_lfsr != i_seed)
                    @(posedge clk)                                                                  ;
                Set_soft_reset($urandom_range(0,LFSR_SEED))                                         ;
            
            `elsif FIXED_SEED
                while (o_lfsr != LFSR_SEED)
                    @(posedge clk)                                                                  ;
                Set_soft_reset(LFSR_SEED)                                                           ;
                
            `endif
            end
                
        #10000                                                                                  ;
        @(posedge clk)                                                                          ;
        $finish                                                                                 ;
    end