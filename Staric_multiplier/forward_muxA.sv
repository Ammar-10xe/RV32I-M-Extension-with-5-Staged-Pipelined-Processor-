module forward_muxA (
    input logic  [1:0]  forwardAE, 
    input logic  [31:0] rdata1E,ALUResultM,wdata,
    output logic [31:0] SrcA
);
always_comb begin 
    case (forwardAE)
       2'b00 : SrcA = ALUResultM;
       2'b01 : SrcA = rdata1E;
       2'b10 : SrcA = wdata;
    endcase  
end
endmodule

