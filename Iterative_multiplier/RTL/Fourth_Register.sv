module fourt_register (
    input logic         clk,rst,reg_wrM,valid,
    input logic  [1:0]  wb_selM,
    input logic  [4:0]  waddrM,
    input logic  [31:0] AddrM,ALUResultM,mem_out,InstM,
    output logic        reg_wrW,valid_done,
    output logic [1:0]  wb_selW,
    output logic [4:0]  waddrW,
    output logic [31:0] AddrW,ALUResultW,mem_outW,InstW
 );
// logic [6:0] func7;
// logic [4:0] waddrM;
// logic [4:0] 11;7

// // assign instr_opcode = InstD[6:0];
// // assign func7       = InstD[31:25];
// // assign funct3       = InstD[14:12];
// assign func7M   = InstrM[31:25];
// assign waddrM  = InstM[11:7];

always_ff @(posedge clk) begin
  if( valid == 1'b1) begin
    valid_done = 1'b1;
  end
  else  begin 
    valid_done = 1'b0;
  end
end



  always_ff @(posedge clk) begin
    if( rst ) begin
        AddrW      <= 32'b0;
        ALUResultW <= 32'b0;
        mem_outW   <= 32'b0;
        InstW      <= 32'b0;
        reg_wrW    <= 1'b0;
        wb_selW    <= 2'bx;
        waddrW     <= 5'b0;
  end
    else begin
        AddrW      <= AddrM;
        ALUResultW <= ALUResultM;
        mem_outW   <= mem_out;// Hazard detection for forwarding  mem_out;
        InstW      <= InstM;
        reg_wrW    <= reg_wrM;
        wb_selW    <= wb_selM;
        waddrW     <= waddrM;
      end
  end 
endmodule