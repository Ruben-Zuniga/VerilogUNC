always @(posedge clk) begin
    if($urandom_range(1,5000) == 'd1)
        Set_soft_reset($urandom_range(0,LFSR_SEED));
end

initial begin
    $dumpfile("lfsr_tb.vcd");
    $dumpvars(0, LFSR16_1002D_tb);

    $display("\n-------o_lock test monitor-------")                                     ;
    $monitor("time: %5t\t\to_lock: %0b", $time, o_lock)                                 ;

    i_rst                                       = 1'b1                                  ;
    i_soft_rst                                  = 1'b0                                  ;
    i_seed                                      = LFSR_SEED                             ;
    i_valid                                     = 1'b1                                  ;
    clk                                         = 1'b0                                  ;
    i_corrupt                                   = 1'b0                                  ;

    #1000                                                                               ;
    @(posedge clk)                                                                      ;
    i_rst                                       = 1'b0                                  ;

    `ifdef TEST_1
        repeat(10000) begin
            i_corrupt = 1'b0;
            @(posedge clk);
        end

    `elsif TEST_2
        repeat(2000) begin
            repeat(4) begin
                i_corrupt = 1'b0;
                @(posedge clk);
            end
            i_corrupt = 1'b1;
            @(posedge clk);
        end

    `elsif TEST_3
        repeat(5) begin
            i_corrupt = 1'b0;
            @(posedge clk);
        end
        repeat(3000) begin
            repeat(2) begin
                i_corrupt = 1'b1;
                @(posedge clk);
            end
            i_corrupt = 1'b0;
            @(posedge clk);
        end
        
    `elsif TEST_4
        repeat(1200) begin
            repeat(5) begin
                i_corrupt = 1'b0;
                @(posedge clk);
            end
            repeat(3) begin
                i_corrupt = 1'b1;
                @(posedge clk);
            end
        end

            
    `endif
        
    $finish                                                                             ;
end