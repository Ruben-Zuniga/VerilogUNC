/*
 Modulo extraido y adaptado del articulo:
 "How to Code a State Machine in Verilog", de Kaitlyn Franz.
 Referencia: https://digilent.com/blog/how-to-code-a-state-machine-in-verilog
*/

`timescale 1ns / 100ps

module stepper_motor
#(

)
(
    input   clk         ,
    input   rst         ,
    input   i_dir       ,
    input   i_en        ,
    output  o_signal
);

localparam          sig4            = 3'b001    ;
localparam          sig3            = 3'b011    ;
localparam          sig2            = 3'b010    ;
localparam          sig1            = 3'b110    ;
localparam          sig0            = 3'b100    ;

reg         [2:0]   present_state               ;
reg         [2:0]   next_state                  ;

always @(*) begin
    case (present_state)

        sig4: begin
            if (en)
                if (dir)
                    next_state  = sig1          ;
                else
                    next_state  = sig3          ;
            else
                next_state      = sig0          ;

        end
        sig3: begin
            if (en)
                if (dir)
                    next_state  = sig4          ;
                else
                    next_state  = sig2          ;
            else
                next_state      = sig0          ;
        end
        sig2: begin
            if (en)
                if (dir)
                    next_state  = sig3          ;
                else
                    next_state  = sig1          ;
            else
                next_state      = sig0          ;
        end
        sig1: begin
            if (en)
                if (dir)
                    next_state  = sig2          ;
                else
                    next_state  = sig4          ;
            else
                next_state      = sig0          ;
        end
        sig0: begin
            if (en)
                next_state      = sig1          ;
            else
                next_state      = sig0          ;
        end

        default: 
            next_state          = sig0          ;

    endcase
end

always @(posedge clk) begin
    case (present_state)
        sig4:
            o_signal            = 4'b1000       ;
        
        sig3:
            o_signal            = 4'b0100       ;
        
        sig2:
            o_signal            = 4'b0010       ;
        
        sig1:
            o_signal            = 4'b0001       ;
        
        sig0:
            o_signal            = 4'b0000       ;
        
        default:
            o_signal            = 4'b0000       ;
        
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst)
        present_state           <= sig0         ;
    else
        present_state           <= next_state   ;
end

endmodule