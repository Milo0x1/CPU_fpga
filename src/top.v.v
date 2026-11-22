module top (
    input  wire       clk,
    input  wire       rst,
    output wire [5:0] led
);
    reg [23:0] div = 0;
    always @(posedge clk) div <= div + 1'b1;
    wire cclk = div[23];

    //program
    reg [15:0] rom [0:15];
    initial $readmemh("/home/milo/projects/CPU_fpga/program.mem", rom);

    //rejestry
    reg [5:0] r [0:3];
    initial begin r[0] = 0; r[1] = 0; r[2] = 0; r[3] = 0; end

    //ram
    reg [5:0] ram [0:63];
    integer i;
    initial for (i = 0; i < 64; i = i + 1) ram[i] = 0;

    wire [3:0]  pc;
    wire [15:0] ir;
    wire [5:0]  y;
    wire        alu_wr, alu_st, we, mwe;

    fsm f (
        .clk(cclk), .rst(rst),
        .instr(rom[pc]), .alu_wr(alu_wr), .alu_st(alu_st),
        .pc(pc), .ir(ir), .we(we), .mwe(mwe)
    );

    alu u (
        .op(ir[15:10]), .a(r[ir[9:8]]), .b(r[ir[7:6]]), .imm(ir[5:0]),
        .m(ram[ir[5:0]]),
        .y(y), .wr(alu_wr), .st(alu_st)
    );

    
    always @(posedge cclk)
        if (rst) begin
            r[0] <= 0; r[1] <= 0; r[2] <= 0; r[3] <= 0;
        end else if (we)
            r[ir[9:8]] <= y;


    always @(posedge cclk)
        if (mwe)
            ram[ir[5:0]] <= r[ir[9:8]];

    assign led = ~r[0];
endmodule