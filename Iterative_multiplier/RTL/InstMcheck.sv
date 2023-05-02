module InstMcheck (
    input               clk,rst,startE,
    input  logic [4:0]  alu_opE,
    input  logic [31:0] SrcAE, SrcBE,
    output logic        flagM,
    output logic [31:0] result_m,
    //For M extension     
    output logic [31:0] operand1, operand2,
    output logic [1:0]  mul_opcode,div_opcode,
    input logic  [63:0] result_multiply,
    input logic  [31:0] result_divide,
    input logic         ready,
    input logic         mul_use
);

logic normal_mode = 1'b0;
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
    .result_multiply(result_multiply),
    .ready(ready));

divider_32bit divide(
    .div_opcode(div_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_divide(result_divide));

  always_comb begin
    flagM = 1'b0;
    result_m = 32'h0; // Reset the result_m
    operand1 = 32'h0; // Reset the operand1
    operand2 = 32'h0; // Reset the operand2
    mul_opcode = 2'b00; // Reset the mul_opcode
    div_opcode = 2'b00; // Reset the div_opcode
    case(alu_opE)
      MUL: begin // Multiplication
      operand1 = SrcAE;
      operand2 = SrcBE;
      mul_opcode = 2'b00;
      case(ready & ~mul_use)
        1'b1: begin
             result_m = result_multiply[31:0]; // Or [63:32] for higher 32 bits
             flagM = 1'b1;
        end
      endcase   
    end

    MULH: begin // Signed Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b01;
      case(ready)
          1'b1: begin 
            result_m = result_multiply[63:32];
            flagM = 1'b1;
      end
      endcase           
    end

    MULHSU: begin // Signed-Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b10;
        
      case(ready)
          1'b1: begin
           result_m = result_multiply[63:32];
           flagM = 1'b1;
      end
      endcase   
    end

    MULHU: begin // Unsigned Multiplication (upper 32 bits)
        operand1 = SrcAE;
        operand2 = SrcBE;
        mul_opcode = 2'b11;
      case(ready)
          1'b1:begin
              result_m = result_multiply[63:32];
              flagM = 1'b1;
          end  
      endcase          
    end

    DIV: begin // Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b00;
        result_m = result_divide;
    end

    DIVU: begin // Unsigned Division
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b01;
        result_m = result_divide;
    end

    REM: begin // Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b10;
        result_m = result_divide;
    end

    REMU: begin // Unsigned Remainder
        operand1 = SrcAE;
        operand2 = SrcBE;
        div_opcode = 2'b11;
        result_m = result_divide;
    end

    default:  result_m = SrcAE + SrcBE;
    endcase

  end
endmodule