module ALU (
    input  logic [4:0]  alu_opE,
    input  logic [31:0] SrcAE, SrcBE,
    output logic [1:0]  mul_opcode,div_opcode,
    output logic [31:0] ALUResult,
    output logic [31:0] operand1, operand2,
    output logic [63:0] result_multiply,
    output logic [31:0] result_divide
);

//For Interger Type
parameter [4:0] ADD  = 5'b00000;
parameter [4:0] SUB  = 5'b00001;
parameter [4:0] SLL  = 5'b00010;
parameter [4:0] SLT  = 5'b00011;
parameter [4:0] SLTU = 5'b00100;
parameter [4:0] XOR  = 5'b00101;
parameter [4:0] SRL  = 5'b00110;
parameter [4:0] SRA  = 5'b00111;
parameter [4:0] OR   = 5'b01000;
parameter [4:0] AND  = 5'b01001;
parameter [4:0] LUI  = 5'b01010;

//For M extension 
parameter [4:0] MUL     = 5'b01011;
parameter [4:0] MULH    = 5'b01100;
parameter [4:0] MULHSU  = 5'b01101;
parameter [4:0] MULHU   = 5'b01110;
parameter [4:0] DIV     = 5'b01111;
parameter [4:0] DIVU    = 5'b10000;
parameter [4:0] REM     = 5'b10001;
parameter [4:0] REMU    = 5'b10010;

// instances of multiplier and divider modules
multiplier_32bit multiply1( 
    .mul_opcode(mul_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_multiply(result_multiply));

divider_32bit divide(
    .div_opcode(div_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_divide(result_divide));

always_comb begin
  case(alu_opE)
    
    ADD: ALUResult = SrcAE + SrcBE ;                             //Addition

    SUB: ALUResult = SrcAE - SrcBE ;                             //Subtraction

    SLL: ALUResult = SrcAE << SrcBE[4:0];                        //Shift Left Logical

    SLT: ALUResult = ($signed(SrcAE) < $signed(SrcBE)) ? 1 : 0;  //Set Less than

    SLTU: ALUResult = (SrcAE < SrcBE) ? 1 : 0;                    //Set Less than unsigned

    XOR: ALUResult = SrcAE ^ SrcBE;                              //LOgical xor

    SRL: ALUResult = SrcAE >> SrcBE[4:0];                        //Shift Right Logical

    SRA: ALUResult = $signed(SrcAE) >>> SrcBE[4:0];              //Shift Right Arithmetic

    OR: ALUResult = SrcAE | SrcBE;                              //Logical Or

    AND: ALUResult = SrcAE & SrcBE;                              //Logical and

    LUI: ALUResult = SrcBE;                                      //Load Upper Immediate
  



    MUL: begin // Multiplication
      operand1 = SrcAE;
      operand2 = SrcBE;
      mul_opcode = 2'b00;
      ALUResult = result_multiply[31:0]; // Or [63:32] for higher 32 bits
    end

    MULH: begin // Signed Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b01;
        ALUResult = result_multiply[63:32];
    end

    MULHSU: begin // Signed-Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b10;
        ALUResult = result_multiply[63:32];
    end

    MULHU: begin // Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b11;
        ALUResult = result_multiply[63:32];
    end

    DIV: begin // Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b00;
        ALUResult = result_divide;
    end

    DIVU: begin // Unsigned Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b01;
        ALUResult = result_divide;
    end

    REM: begin // Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b10;
        ALUResult = result_divide;
    end

    REMU: begin // Unsigned Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b11;
        ALUResult = result_divide;
    end

    default:  ALUResult = SrcAE + SrcBE;
    endcase

  end
endmodule