module Memory_mux (
    input logic  [31:0] toLSU,rdata,
    input logic [31:0]  addr,
    output logic [31:0] mem_out
);

always_comb begin 


    if ((addr [8] | addr[9] | addr [10] | addr[11] | addr[12] | addr[13] | addr[14] | addr[15]) & toLSU != 32'hdeadbeef & toLSU != 32'hbabecafe)
    
         mem_out =  toLSU; // Instruction Memory
    else
         mem_out =  rdata; // Data Memory   
end
    
endmodule

