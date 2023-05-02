module AddrW_Plus4 (
  input  logic [31:0] AddrW,
  output logic [31:0] AddrWB
);

  assign AddrWB = AddrW + 32'd4;
  
endmodule
