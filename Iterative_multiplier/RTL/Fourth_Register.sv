module fourt_register (
    input logic         clk,rst,reg_wrM,
    input logic  [1:0]  wb_selM,
    input logic  [4:0]  waddrM,
    input logic  [31:0] AddrM,ALUResultM,mem_out,InstM,
    output logic        reg_wrW,
    output logic [1:0]  wb_selW,
    output logic [4:0]  waddrW,
    output logic [31:0] AddrW,ALUResultW,mem_outW,InstW
 );

  // assign waddrW  = InstW [11:7]; 

  always_ff @(posedge clk) begin
    if( rst ) begin
        AddrW      <= 32'b0;
        ALUResultW <= 32'b0;
        mem_outW     <= 32'b0;
        InstW      <= 32'b0;
        reg_wrW    <= 1'b0;
        wb_selW    <= 2'bx;
        waddrW     <= 5'b0;
  end
    else begin
        AddrW      <= AddrM;
        ALUResultW <= ALUResultM;
        mem_outW     <= mem_out;
        InstW      <= InstM;
        reg_wrW    <= reg_wrM;
        wb_selW    <= wb_selM;
        waddrW     <= waddrM;
      end
  end 
endmodule