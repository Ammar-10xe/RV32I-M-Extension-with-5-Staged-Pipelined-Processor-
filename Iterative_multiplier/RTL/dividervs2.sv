der_32bit (
    input logic clk, rst, startD,
    input logic [1:0] div_opcode,
    input logic [31:0] operand1, operand2,
    output logic doneD,
    output logic [31:0] result_divide
);

    logic [31:0] dividend;
    logic [62:0] divisor;
    logic [31:0] quotient;
    logic [31:0] q_mask;
    logic busy;
    logic invert_res;

    wire signed_operation = div_opcode[1];
    wire div_operation = ~div_opcode[0];

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            busy <= 1'b0;
            dividend <= 32'b0;
            divisor <= 63'b0;
            invert_res <= 1'b0;
            quotient <= 32'b0;
            q_mask <= 32'b0;
        end else if (startD) begin
            busy <= 1'b1;

            if (signed_operation && operand1[31])
                dividend <= -operand1;
            else
                dividend <= operand1;

            if (signed_operation && operand2[31])
                divisor <= {-operand2, 31'b0};
            else
                divisor <= {operand2, 31'b0};

            invert_res <= (div_opcode == 2'b00 && (operand1[31] != operand2[31]) && operand2 != 0) || 
                          (div_opcode == 2'b10 && operand1[31]);

            quotient <= 32'b0;
            q_mask <= 32'h80000000;
        end else if (!q_mask && busy) begin
            busy <= 1'b0;
        end else if (busy) begin
            if (divisor <= {31'b0, dividend}) begin
                dividend <= dividend - divisor[31:0];
                quotient <= quotient | q_mask;
            end

            divisor <= {1'b0, divisor[62:1]};
            q_mask <= {1'b0, q_mask[31:1]};
        end
    end

    logic [31:0] div_result;
    always_comb begin
        if (div_operation)
            div_result = invert_res ? -quotient : quotient;
        else
            div_result = invert_res ? -dividend : dividend;
    end

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            doneD <= 1'b0;
            result_divide <= 32'b0;
        end else if (!q_mask && busy) begin
            doneD <= 1'b1;
            result_divide <= div_result;
        end else if (startD) begin
            doneD <= 1'b0;
        end
    end
endmodule

