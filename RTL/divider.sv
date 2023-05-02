module divider_32bit (
    input logic [1:0] div_opcode,
    input logic [31:0] operand1, operand2,
    output logic [31:0] result_divide
);

always_comb begin
    case (div_opcode)
        2'b00: // DIV
            if (operand2 == 0) begin
                result_divide = 32'hFFFFFFFF;
            end else begin
                result_divide = $signed(operand1) / $signed(operand2);
            end
        2'b01: // DIVU
            if (operand2 == 0) begin
                result_divide = 32'hFFFFFFFF;
            end else begin
                result_divide = $unsigned(operand1) / $unsigned(operand2);
            end
        2'b10: // REM
            if (operand2 == 0) begin
                result_divide = operand1;
            end else begin
                result_divide = $signed(operand1) % $signed(operand2);
            end
        2'b11: // REMU
            if (operand2 == 0) begin
                result_divide = operand1;
            end else begin
                result_divide = $unsigned(operand1) % $unsigned(operand2);
            end
        default: result_divide = 32'h0; // Default case
    endcase
end


endmodule
