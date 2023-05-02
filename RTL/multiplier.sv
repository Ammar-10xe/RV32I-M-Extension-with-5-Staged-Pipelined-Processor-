module multiplier_32bit (
    input logic  [1:0] mul_opcode,
    input logic  [31:0] operand1, operand2,
    output logic [63:0] result_multiply
);


parameter [1:0] MUL     = 2'b00;
parameter [1:0] MULH    = 2'b01;
parameter [1:0] MULHSU  = 2'b10;
parameter [1:0] MULHU   = 2'b11;


always_comb begin
    case (mul_opcode)
        MUL:    result_multiply = $signed(operand1) * $signed(operand2); // MUL
        MULH:   result_multiply = $signed(operand1) * $signed(operand2); // MULH
        MULHSU: result_multiply = $signed(operand1) * $unsigned(operand2); // MULHSU
        MULHU:  result_multiply= $unsigned(operand1) * $unsigned(operand2); // MULHU
        default: result_multiply = 64'h0; // Default case
    endcase
end
endmodule

// module multiplier_32bit (
//     input logic  [1:0]  mul_opcode,
//     input logic  [31:0] operand1, operand2,
//     output logic [63:0] result_multiply
// );

// parameter [1:0] MUL     = 2'b00;
// parameter [1:0] MULH    = 2'b01;
// parameter [1:0] MULHSU  = 2'b10;
// parameter [1:0] MULHU   = 2'b11;

// function [63:0] booth_mult;
//     input signed [31:0] op1;
//     input signed [31:0] op2;
//     reg [63:0] product;
//     integer i;
//     begin
//         product = 64'h0;
//         for (i = 0; i < 32; i++) begin
//             if (op2[0] == 1'b1 && op2[1] == 1'b0)
//                 product[31:0] = product[31:0] + op1;
//             else if (op2[0] == 1'b0 && op2[1] == 1'b1)
//                 product[31:0] = product[31:0] - op1;

//             op1 = $signed({op1[30:0], op1[31]}); // Arithmetic right shift
//             op2 = op2 >> 1;
//         end
//         booth_mult = product;
//     end
// endfunction

// always_comb begin
//     case (mul_opcode)
//         MUL:    result_multiply = {32'h0, booth_mult($signed(operand1), $signed(operand2))[31:0]}; // MUL
//         MULH:   result_multiply = {booth_mult($signed(operand1), $signed(operand2))[63:32], 32'h0}; // MULH
//         MULHSU: result_multiply = {booth_mult($signed(operand1), $unsigned(operand2))[63:32], 32'h0}; // MULHSU
//         MULHU:  result_multiply = {booth_mult($unsigned(operand1), $unsigned(operand2))[63:32], 32'h0}; // MULHU
//         default: result_multiply = 64'h0; // Default case
//     endcase
// end

// endmodule


