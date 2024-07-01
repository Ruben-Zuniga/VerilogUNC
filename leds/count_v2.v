`timescale 1ns/100ps

module count_v2
    #(
        parameter   DATA_WIDTH = 32,
        parameter   SW_WIDTH = 4
    )
    (
    
        output                  o_valid,
        input   [SW_WIDTH-2:0]  i_sw,
        input                   i_reset,
        input                   clock
    
    );
    
    localparam R0 = (2**(DATA_WIDTH-10))-1;
    localparam R1 = (2**(DATA_WIDTH-11))-1;
    localparam R2 = (2**(DATA_WIDTH-12))-1;
    localparam R3 = (2**(DATA_WIDTH-13))-1;
    
    wire                        comp_reset;
    reg    [DATA_WIDTH-1:0]     count_data;
    reg    [DATA_WIDTH-1:0]     mux_data;
    
    // Mux
    always@(*) begin
        case (i_sw[2:1])
        
            2'b00:  mux_data = R0;
            2'b01:  mux_data = R1;
            2'b10:  mux_data = R2;
            2'b11:  mux_data = R3;
            //default: mux_data = {DATA_WIDTH{1'b0}};
    
        endcase
    end
    
    // Compare
    assign  o_valid     = (count_data == mux_data)? 1'b1 : 1'b0;
    assign  comp_reset  = (count_data == mux_data)? 1'b1 : 1'b0;
    
    // Counter 32b
    always @(posedge clock) begin
    
        if(!i_reset && !comp_reset) begin
            
            if(i_sw[0])
                count_data  <= count_data + {{DATA_WIDTH-1{1'b0}}, 1'b1};
            else
                count_data  <= count_data;
    
        end
        else
            count_data <= {DATA_WIDTH{1'b0}};
        
    end
    
endmodule