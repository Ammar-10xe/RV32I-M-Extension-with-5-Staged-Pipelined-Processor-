module divider_32bit (
    input logic        clk, rst, startD,
    input logic [1:0] div_opcode,
    input logic [31:0] operand1, operand2,
    output logic       doneD,
    output logic [31:0] result_divide
);

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            doneD <= 1'b0;
            result_divide <= 32'b0;
        end
        else begin
            doneD <= 1'b0;
            case (div_opcode)
                2'b00: // DIV
                    if (operand2 == 0) begin
                        result_divide <= 32'hFFFFFFFF;
                        doneD <= 1'b1;
                    end 
                    else if ( operand1 == 32'h80000000 && operand2 == 32'hffffffff) begin
                        result_divide <= operand1;
                        doneD <= 1'b1;
                    end
                    else if (startD) begin
                        result_divide <= $signed(operand1) / $signed(operand2);
                        doneD <= 1'b1;
                    end

                2'b01: // DIVU
                    if (operand2 == 0) begin
                        result_divide <= 32'hFFFFFFFF;
                        doneD <= 1'b1;
                    end else if (startD) begin
                        result_divide <= $unsigned(operand1) / $unsigned(operand2);
                        doneD <= 1'b1;
                    end
                2'b10: // REM
                    if (operand2 == 0) begin
                        result_divide <= operand1;
                        doneD <= 1'b1;
                    end else if (startD) begin
                        result_divide <= $signed(operand1) % $signed(operand2);
                        doneD <= 1'b1;
                    end
                2'b11: // REMU
                    if (operand2 == 0) begin
                        result_divide <= operand1;
                        doneD <= 1'b1;
                    end else if (startD) begin
                        result_divide <= $unsigned(operand1) % $unsigned(operand2);
                        doneD <= 1'b1;
                    end
                default: result_divide <= 32'h0; // Default case
            endcase
        end
    end
endmodule
