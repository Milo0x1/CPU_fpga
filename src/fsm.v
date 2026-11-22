module fsm (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] instr,
    input  wire        alu_wr,
    input  wire        alu_st,
    output reg  [3:0]  pc = 0,
    output reg  [15:0] ir = 0,
    output wire        we,     //zapis do rejestrow
    output wire        mwe     //zapis do RAM
);
    reg state = 0;   

    always @(posedge clk)
        if (rst) begin
            pc <= 0; ir <= 0; state <= 0;
        end else if (state == 0) begin
            ir    <= instr;
            pc    <= pc + 1'b1;
            state <= 1;
        end else begin
            if (ir[15:10] == 6'h06) pc <= ir[3:0];   // JMP
            state <= 0;
        end

    assign we  = state & alu_wr;
    assign mwe = state & alu_st;
endmodule