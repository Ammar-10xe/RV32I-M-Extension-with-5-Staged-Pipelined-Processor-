module multiplier_iterative1 (
    input logic clk, rst, startE,
    input logic [1:0] mul_opcode,
    input logic [31:0] operand1, operand2,
    output logic [63:0] result_multiply,
    output logic ready
);

    parameter [1:0] MUL     = 2'b00;
    parameter [1:0] MULH    = 2'b01;
    parameter [1:0] MULHSU  = 2'b10;
    parameter [1:0] MULHU   = 2'b11;

    logic [31:0] multiplicand_reg;
    logic [31:0] multiplier_reg;
    logic signed [31:0] signed_operand1;
    logic signed [31:0] signed_operand2;
    logic [63:0] product_reg;
    logic [5:0] counter;
    logic processing;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            multiplicand_reg <= 32'b0;
            multiplier_reg <= 32'b0;
            product_reg <= 64'b0;
            counter <= 6'b0;
            ready <= 1'b0;
            processing <= 1'b0;
        end else begin
            if (startE) begin
                case (mul_opcode)
                    MUL: begin
                        multiplicand_reg <= operand1;
                        multiplier_reg <= operand2;
                    end
                    MULH: begin
                        signed_operand1 <= operand1;
                        signed_operand2 <= operand2;
                        multiplicand_reg <= signed_operand1;
                        multiplier_reg <= signed_operand2;
                    end
                    MULHSU: begin
                        signed_operand1 <= operand1;
                        multiplicand_reg <= signed_operand1;
                        multiplier_reg <= operand2;
                    end
                    MULHU: begin
                        multiplicand_reg <= operand1;
                        multiplier_reg <= operand2;
                    end
                endcase
                product_reg <= 64'b0;
                counter <= 6'b0;
                ready <= 1'b0;
                processing <= 1'b1;
            end

            if (processing) begin
                if (counter < 32) begin
                    if (multiplier_reg[0] == 1'b1) begin
                        product_reg <= {product_reg[62:31], product_reg[30:0] + multiplicand_reg};
                    end
                    multiplicand_reg <= multiplicand_reg << 1;
                    multiplier_reg <= multiplier_reg >> 1;
                    counter <= counter + 1'b1;
                end else begin
                    processing <= 1'b0;
                    ready <= 1'b1;
                    case (mul_opcode)
                        MUL: begin
                            result_multiply <= product_reg;
                        end
                        MULH, MULHSU, MULHU: begin
                            result_multiply <= product_reg[63:32];
                        end
                    endcase
                end
            end
        end
    end
endmodule
