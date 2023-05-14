module forward_muxB (
    input logic  [1:0]  forwardBE,
    input logic  [31:0] rdata2E,ALUResultM,wdata,
    output logic [31:0] SrcB
);
always_comb begin 
    case (forwardBE)
       2'b00 : SrcB = ALUResultM;
       2'b01 : SrcB = rdata2E;
       2'b10 : SrcB = wdata;
    endcase  
end
endmodule

