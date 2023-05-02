module Instruction_Fetch (
    input logic [31:0] InstD,
    output logic [4:0] raddr1D,raddr2D,waddrD
);

always_comb begin
        raddr1D = InstD [19:15];
        raddr2D = InstD [24:20];
        waddrD  = InstD [11:7];
end
endmodule