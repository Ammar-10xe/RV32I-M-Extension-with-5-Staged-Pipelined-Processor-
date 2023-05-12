module second_register (
    input  logic         clk,rst,reg_wr,sel_A,sel_B,FlushE,
    input  logic [1:0]  wb_sel,
    input  logic [2:0]  funct3,
    input  logic [4:0]  alu_op,raddr1D,raddr2D,waddrD,
    input  logic [6:0]  instr_opcode,
    input  logic [31:0] AddrD,rdata1,rdata2,ImmExtD,InstD,
    output logic        reg_wrE,sel_AE,sel_BE,
    output logic [1:0]  wb_selE,
    output logic [2:0]  funct3E,
    output logic [4:0]  alu_opE,raddr1E,raddr2E,waddrE,
    output logic [6:0]  instr_opcodeE,
    output logic [31:0] AddrE,rdata1E,rdata2E,ImmExtE,InstE

);


    always_ff @( posedge clk ) begin 
        if ( rst ) begin
            AddrE         <= 32'b0;
            rdata1E       <= 32'b0;
            rdata2E       <= 32'b0;
            ImmExtE       <= 32'b0;
            InstE         <= 32'b0;
            reg_wrE       <= 1'b0;
            sel_AE        <= 1'bx;
            sel_BE        <= 1'bx;
            wb_selE       <= 2'bx;
            funct3E       <= 3'bx;
            instr_opcodeE <= 7'bx;
            alu_opE       <= 5'b0;
            raddr1E       <= 5'b0;
            raddr2E       <= 5'b0;
            waddrE        <= 5'b0;

        end
        else if ( FlushE ) begin
            AddrE         <= 32'b0;
            rdata1E       <= 32'b0;
            rdata2E       <= 32'b0;
            ImmExtE       <= 32'b0;
            InstE         <= 32'h00000013;
            reg_wrE       <= 1'b0;
            sel_AE        <= 1'bx;
            sel_BE        <= 1'bx;
            wb_selE       <= 2'bx;
            funct3E       <= 3'bx;
            instr_opcodeE <= 7'bx;
            alu_opE       <= 5'b0;
            raddr1E       <= 5'b0;
            raddr2E       <= 5'b0;
            waddrE        <= 5'b0;
            
        end
        else begin
            AddrE         <= AddrD;
            rdata1E       <= rdata1;
            rdata2E       <= rdata2;
            ImmExtE       <= ImmExtD;
            InstE         <= InstD;
            reg_wrE       <= reg_wr;
            sel_AE        <= sel_A;     
            sel_BE        <= sel_B;
            wb_selE       <= wb_sel;
            funct3E       <= funct3;
            instr_opcodeE <= instr_opcode;
            alu_opE       <= alu_op;
            raddr1E       <= raddr1D;
            raddr2E       <= raddr2D;
            waddrE        <= waddrD;
        end

    end
    
endmodule