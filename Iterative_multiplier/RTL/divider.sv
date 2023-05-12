module divider_32bit (
    input logic clk, rst, startD,
    input logic [1:0] div_opcode,
    input logic [31:0] operand1, operand2,
    output logic doneD,
    output logic [31:0] result_divide
);

    logic [31:0] divisor, remainder;
    logic [31:0] quotient;
    logic [5:0] cycle_counter;
    logic busy;

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            cycle_counter <= 6'b0;
            doneD <= 1'b0;
            result_divide <= 32'b0;
            busy <= 1'b0;
        end else if (startD && !busy) begin
            divisor <= operand2;
            remainder <= operand1;
            quotient <= 32'b0;
            cycle_counter <= 6'b1;
            busy <= 1'b1;
            doneD <= 1'b0;
        end else if (cycle_counter != 6'b0) begin
            // Shift operation
            remainder <= {remainder[30:0], quotient[31]};
            quotient <= quotient << 1;
            // Subtraction operation
            case(div_opcode)
                2'b00, 2'b10: // DIV, REM
                    if ($signed(remainder) >= $signed(divisor)) begin
                        remainder <= $signed(remainder) - $signed(divisor);
                        quotient[0] <= 1'b1;
                    end
                2'b01, 2'b11: // DIVU, REMU
                    if (remainder >= divisor) begin
                        remainder <= remainder - divisor;
                        quotient[0] <= 1'b1;
                    end
            endcase
            cycle_counter <= cycle_counter + 6'b1;
            if (cycle_counter == 6'b100000) begin
                doneD <= 1'b1;
                case(div_opcode)
                    2'b00, 2'b01: // DIV, DIVU
                        result_divide <= quotient;
                    2'b10, 2'b11: // REM, REMU
                        result_divide <= remainder;
                endcase
                busy <= 1'b0;
            end
        end
    end
endmodule
