module multiplier_booth (
    input logic  clk, rst,startE,
    input logic  [1:0]  mul_opcode,
    input logic  [31:0] operand1, operand2,
    output logic [63:0] result_multiply,
    output logic ready
);

parameter [1:0] MUL     = 2'b00;
parameter [1:0] MULH    = 2'b01;
parameter [1:0] MULHSU  = 2'b10;
parameter [1:0] MULHU   = 2'b11;

typedef enum logic [1:0] {IDLE, COMPUTING, READY} state_t;
state_t current_state, next_state;

logic [63:0] P; // Partial product
logic signed [33:0] A, B; // Extended operands for signed multiplication
logic [33:0] U, V; // Extended operands for unsigned multiplication
logic [5:0] count; // Booth's algorithm loop counter

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    logic [63:0] temp_P;
    logic signed [33:0] temp_A, temp_B;
    logic [33:0] temp_U, temp_V;

    case (current_state)
        IDLE: begin
            ready = 0;
            if (startE && mul_opcode != 2'b00) begin
                next_state = COMPUTING;
            end else begin
                next_state = IDLE;
            end
        end

        COMPUTING: begin
            ready = 0;
            case (mul_opcode)
                MUL: begin
                    temp_A[31:0] = $signed(operand1);
                    temp_B[31:0] = $signed(operand2);
                    temp_A[33:32] = operand1[31]; // Sign extension
                    temp_B[33:32] = operand2[31];
                    temp_P = booth_mult_32bit(temp_A, temp_B, 0);
                end
                MULH: begin
                    temp_A[31:0] = $signed(operand1);
                    temp_B[31:0] = $signed(operand2);
                    temp_A[33:32] = operand1[31];
                    temp_B[33:32] = operand2[31];
                    temp_P = booth_mult_32bit(temp_A, temp_B, 0);
                end
                MULHSU: begin
                    temp_A[31:0] = $signed(operand1);
                    temp_B[31:0] = operand2;
                    temp_A[33:32] = operand1[31];
                    temp_B[33:32] = 1'b0;
                    temp_P = booth_mult_32bit(temp_A, temp_B, 0);
                end
                MULHU: begin
                    temp_U[31:0] = operand1;
                    temp_V[31:0] = operand2;
                    temp_U[33:32] = 2'b00;
                    temp_V[33:32] = 2'b00;
                    temp_P = booth_mult_32bit(temp_U, temp_V, 0);
                end

            endcase
        end
            READY: begin
            ready = 1;
            next_state = IDLE;
            // Update the result
            result_multiply = temp_P;
             end
        endcase


end

    // Perform 32-bit Booth's multiplication
    function automatic [63:0] booth_mult_32bit;
        input logic signed [33:0] a, b;
        input bit unsigned_mode;

        booth_mult_32bit = 64'h0;
        count = 6'd0;

        for (count = 0; count < 32; count++) begin
            if (a[0] == 1'b1 && a[1] == 1'b0) begin
                booth_mult_32bit[31:0] = booth_mult_32bit[31:0] + b[31:0];
            end else if (a[0] == 1'b0 && a[1] == 1'b1) begin
                booth_mult_32bit[31:0] = booth_mult_32bit[31:0] - b[31:0];
            end

            // Arithmetic shift right for signed multiplication
            if (!unsigned_mode) begin
                booth_mult_32bit = $signed(booth_mult_32bit) >>> 1;
            end
            // Logical shift right for unsigned multiplication
            else begin
                booth_mult_32bit = booth_mult_32bit >>> 1;
            end
            a = a >>> 1;
        end
    endfunction



endmodule
