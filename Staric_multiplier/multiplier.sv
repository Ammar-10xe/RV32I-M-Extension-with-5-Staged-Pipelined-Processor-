module multiplier_32bit (
    input logic  [1:0] mul_opcode,
    input logic  [31:0] operand1, operand2,
    output logic [63:0] result_multiply
);

parameter [1:0] MUL     = 2'b00;
parameter [1:0] MULH    = 2'b01;
parameter [1:0] MULHSU  = 2'b10;
parameter [1:0] MULHU   = 2'b11;

assign operand1_signed = $signed(operand1);
assign operand2_unsigned = operand2;


always_comb begin
    case (mul_opcode)

        MUL:    result_multiply = $signed(operand1) * $signed(operand2); // MUL
        MULH:   result_multiply = $signed(operand1) * $signed(operand2); // MULH
        MULHSU:result_multiply = operand1_signed *   operand2_unsigned; // MULHSU
        MULHU:  result_multiply = $unsigned(operand1) * $unsigned(operand2); // MULHU
        default: result_multiply = 64'h0; // Default case
    endcase
end
endmodule

