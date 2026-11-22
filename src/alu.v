module alu (
    input  wire [5:0] op,
    input  wire [5:0] a,
    input  wire [5:0] b,
    input  wire [5:0] imm,
    input  wire [5:0] m,     //odczyt z RAM
    output reg  [5:0] y,
    output reg        wr,    // 1=zapisz y do rd
    output reg        st     // 1=zapisz a do ram[imm]
);
    always @* begin
        y  = 0;
        wr = 1;
        st = 0;
        case (op)
            6'h01: y = imm;          
            6'h02: y = a + b;       
            6'h03: y = a - b;        
            6'h04: y = a & b;       
            6'h05: y = a | b;   
            // 06 dla fsm jako jump
            6'h07: begin wr = 0; st = 1; end   
            6'h08: y = m;            
            default: wr = 0;         
        endcase
    end
endmodule