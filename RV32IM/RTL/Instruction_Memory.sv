module Instruction_Memory (
    input  logic  [31:0] Addr,          // toinstr_mem is ALUResult from LSU
    input  logic [31:0] addr,           //ALUResultM
    output logic [31:0] Inst, toLSU     // toLSU is the value against toinstr_mem address
);
logic [1023:0] kpl;
logic [31:0] inst_memory [2**27-1:0]; 

// logic [31:0] inst_memory [10023-1:0]; 

// initial begin
//     $readmemh("my.hex", inst_memory); 
// end

initial 
begin
    if($value$plusargs ("mem_init=%s", kpl))
        $readmemh(kpl, inst_memory);        
end


assign toLSU = inst_memory [addr[31:2]];  
assign Inst  = inst_memory [Addr[31:2]];//Word Addressable 


endmodule
