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
