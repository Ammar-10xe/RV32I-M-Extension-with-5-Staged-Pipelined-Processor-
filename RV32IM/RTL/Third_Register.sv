module third_register (
    input logic         clk,rst,reg_wrE,br_taken,lwstall,
    input logic [1:0] wb_selE,
    input logic  [2:0]  funct3E,
    input logic  [4:0]  waddrE,
    input logic  [6:0]  instr_opcodeE,
    input logic  [31:0] AddrE,ALUResult,rdata2E,InstE,SrcB,
    output logic        reg_wrM,br_takenM,lwstallM,
    output logic [1:0]  wb_selM,
    output logic [2:0]  funct3M,
    output logic  [4:0]  waddrM,
    output logic [6:0]  instr_opcodeM,funct7M,
    output logic [31:0] AddrM,ALUResultM,rdata2M,InstM
);




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
        br_takenM     <= 1'b0;
        funct7M       <= 7'b0;
        lwstallM      <= 1'b0;
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
        funct7M       <= InstE[31:25];
        lwstallM      <= lwstall;
      end
  end
    
endmodule

