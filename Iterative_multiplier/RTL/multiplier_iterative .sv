module multiplier_iterative (
    input logic clk, rst, startM,
    input logic [1:0] mul_opcode,
    input logic [31:0] operand1, operand2,
    output logic [31:0] result_multiply,
    output logic done,
    output logic mul_use
);
    logic signed [31:0] multiplicand_signed;
    logic signed [31:0] multiplier_signed;
    logic unsigned [31:0] multiplier_unsigned;

    parameter [1:0] MUL     = 2'b00;
    parameter [1:0] MULH    = 2'b01;
    parameter [1:0] MULHSU  = 2'b10;
    parameter [1:0] MULHU   = 2'b11;

    logic [31:0] multiplicand_reg;
    logic [31:0] multiplier_reg;
    logic signed [63:0] signed_product_reg;
    logic [63:0] product_reg;
    logic [63:0] temp_result;
    logic [5:0] counter;
    logic processing;
    logic [1:0] current_mul_opcode;

    logic signed [63:0] multiplicand_signed_64;
    logic signed [63:0] multiplier_signed_64;
    logic signed [63:0] shifted_multiplicand;
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        multiplicand_reg <= 32'b0;
        multiplier_reg <= 32'b0;
        signed_product_reg <= 64'b0;
        product_reg <= 64'b0;
        counter <= 6'b0;
        done <= 1'b0;
        processing <= 1'b0;
        mul_use <= 1'b0;
        current_mul_opcode <= 2'b0;
        result_multiply <= 32'b0;
    end 
    else begin
        if (startM && !processing) begin
            mul_use <= 1'b1;
            current_mul_opcode <= mul_opcode;
            case (mul_opcode)
                MUL, MULHU: begin
                    multiplicand_reg <= operand1;
                    multiplier_reg   <= operand2;
                end
                // MULH: begin
                //     multiplicand_signed <= $signed({1'b0, operand1[31:0]});
                //     multiplier_signed   <= $signed({1'b0, operand2[31:0]});
                //     signed_product_reg  <= multiplicand_signed * multiplier_signed;
                // end
                MULH: begin
                    multiplicand_signed <= $signed({1'b0, operand1[31:0]});
                    multiplier_signed   <= $signed({1'b0, operand2[31:0]});
                    signed_product_reg  <= 64'b0;
                end
                MULHSU: begin
                    multiplicand_signed <= $signed({1'b0, operand1[31:0]});
                    multiplier_unsigned <= operand2;
                    signed_product_reg  <= 64'b0;
                end
            endcase
            product_reg <= 64'b0;
            counter <= 6'b0;
            done <= 1'b0;
            processing <= 1'b1;
            result_multiply <= 32'b0;
        end
        if (processing) begin
            mul_use <= 1'b1;
        if (counter < 32) begin
            case (current_mul_opcode)
                MUL, MULHU: begin
                    if (multiplier_reg[0] == 1'b1) begin
                        product_reg <= product_reg + ({32'b0, multiplicand_reg} << counter);
                    end
                end
                MULH: begin
                    signed_product_reg <= multiplicand_signed * multiplier_signed;
                end

                MULHSU: begin
                    if (multiplier_unsigned[counter] == 1'b1) begin
                        signed_product_reg <= signed_product_reg + ($signed({{32{multiplicand_signed[31]}}, multiplicand_signed[31:0]}) << counter);
                    end
                end
            endcase

            multiplier_reg <= multiplier_reg >> 1;
            counter <= counter + 1'b1;
        end
            else begin
                processing <= 1'b0;
                done <= 1'b1;
                mul_use <= 1'b0;
                case (current_mul_opcode)
                    MUL: begin
                        result_multiply <= product_reg[31:0];
                    end
                    MULH: begin
                        result_multiply <= signed_product_reg[63:32];
                    end
                     MULHSU:begin
                        result_multiply <= signed_product_reg[63:32];
                     end
                    MULHU: begin
                        result_multiply <= product_reg[63:32];
                    end
                endcase
            end
        end else begin
            mul_use <= startM;
            done <= 1'b0;
        end
    end
end
endmodule






