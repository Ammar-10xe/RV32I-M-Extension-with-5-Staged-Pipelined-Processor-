module mux_selA (
    input logic         sel_AE,
    input logic  [31:0] SrcA,AddrE,
    output logic [31:0] SrcAE
);
always_comb begin 
    case (sel_AE)
       1'b0 : SrcAE = AddrE;
       1'b1 : SrcAE = SrcA;
    endcase  
end
endmodule

