module mux_selB (
    input logic         sel_BE, 
    input logic  [31:0] ImmExtE,SrcB,
    output logic [31:0] SrcBE
);

always_comb begin 
    case (sel_BE)
       1'b0 : SrcBE = SrcB;
       1'b1 : SrcBE = ImmExtE;
    endcase
    
end
    
endmodule

