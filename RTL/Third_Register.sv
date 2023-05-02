module third_register (
    input logic         clk,rst,reg_wrE,br_taken,
    input logic  [1:0]  wb_selE,
    input logic  [2:0]  funct3E,
    input logic  [4:0]  waddrE,
    input logic  [6:0]  instr_opcodeE,
    input logic  [31:0] AddrE,ALUResult,rdata2E,InstE,SrcB,
    output logic        reg_wrM,br_takenM,
    output logic [1:0]  wb_selM,
    output logic [2:0]  funct3M,
    output logic  [4:0]  waddrM,
    output logic [6:0]  instr_opcodeM,
    output logic [31:0] AddrM,ALUResultM,rdata2M,InstM
);

// assign waddrM = InstM [11:7]; 

  always_ff @( posedge clk ) begin
    if ( rst ) begin
        AddrM         <= 32'b0;
        ALUResultM    <= 32'b0;
        rdata2M       <= 32'b0;
        InstM         <= 32'b0;
        reg_wrM       <= 1'b0;
        wb_selM       <= 2'bx;
        funct3M       <= 3'bx;
        instr_opcodeM <= 7'bx;
        waddrM        <= 5'b0;
        br_takenM      <= 1'b0;
  end
    else begin
        AddrM         <= AddrE;
        ALUResultM    <= ALUResult;
        rdata2M       <=  SrcB;
        InstM         <= InstE;
        reg_wrM       <= reg_wrE;
        wb_selM       <= wb_selE;
        funct3M       <= funct3E;
        instr_opcodeM <= instr_opcodeE;
        waddrM        <= waddrE;
        br_takenM     <= br_taken;
      end
  end
    
endmodule

