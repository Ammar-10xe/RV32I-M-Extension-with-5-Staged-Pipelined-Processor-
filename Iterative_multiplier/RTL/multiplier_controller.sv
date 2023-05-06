module multiplier_controller (
    input               clk,rst,startE,
    input  logic [4:0]  alu_opE,
    input  logic [31:0] SrcAE, SrcBE,
    output logic        flagM,
    output logic [31:0] result_m,
    //For M extension     
    output logic [31:0] operand1, operand2,
    output logic [1:0]  mul_opcode,div_opcode,
    input logic  [31:0] result_multiply,
    input logic  [31:0] result_divide,
    input logic         done,
    input logic         mul_use
);

logic normal_mode = 1'b0;
logic [31:0] muliply_result_input = 32'b0;
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
multiplier_iterative multiply( 
    .clk(clk),
    .rst(rst),
    .startE(startE),
    .mul_opcode(mul_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .mul_use(normal_mode),
    .result_multiply(muliply_result_input),
    .done(done));

divider_32bit divide(
    .div_opcode(div_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_divide(result_divide));


always @(posedge clk) begin
    if (rst) begin
        result_m <= 32'h0;
    end else if (done & ~mul_use) begin
        result_m <= result_multiply;
        flagM = 1'b1;
    end
    else begin
      result_m = 32'b0;
      flagM    = 1'b0;
    end

end

  always_comb begin
    operand1 = 32'h0; // Reset the operand1
    operand2 = 32'h0; // Reset the operand2
    mul_opcode = 2'bxx; // Reset the mul_opcode
    div_opcode = 2'b00; // Reset the div_opcode
    case(alu_opE)
      MUL: begin // Multiplication
      operand1 = SrcAE;
      operand2 = SrcBE;
      mul_opcode = 2'b00;
    end

    MULH: begin // Signed Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b01;       
    end

    MULHSU: begin // Signed-Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b10; 
    end

    MULHU: begin // Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b11;      
    end

    DIV: begin // Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b00;
    end

    DIVU: begin // Unsigned Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b01;
    end

    REM: begin // Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b10;
    end

    REMU: begin // Unsigned Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b11;
    end
    endcase
  end
endmodule