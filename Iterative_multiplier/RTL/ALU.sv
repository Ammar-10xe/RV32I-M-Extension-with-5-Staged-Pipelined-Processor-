module ALU (
    input logic         flagM,mul_use,
    input  logic [4:0]  alu_opE,
    input  logic [31:0] SrcAE, SrcBE,result_m,
    output logic [31:0] ALUResult
);

//For Interger Type
parameter [4:0] ADD  = 5'b00000;
parameter [4:0] SUB  = 5'b00001;
parameter [4:0] SLL  = 5'b00010;
parameter [4:0] SLT  = 5'b00011;
parameter [4:0] SLTU = 5'b00100;
parameter [4:0] XOR  = 5'b00101;
parameter [4:0] SRL  = 5'b00110;
parameter [4:0] SRA  = 5'b00111;
parameter [4:0] OR   = 5'b01000;
parameter [4:0] AND  = 5'b01001;
parameter [4:0] LUI  = 5'b01010;

//For M extension 
parameter [4:0] MUL     = 5'b01011;
parameter [4:0] MULH    = 5'b01100;
parameter [4:0] MULHSU  = 5'b01101;
parameter [4:0] MULHU   = 5'b01110;
parameter [4:0] DIV     = 5'b01111;
parameter [4:0] DIVU    = 5'b10000;
parameter [4:0] REM     = 5'b10001;
parameter [4:0] REMU    = 5'b10010;




  always_comb begin

    if (flagM ) begin
        ALUResult = result_m;
    end


  case(alu_opE)
    
    ADD: ALUResult = SrcAE + SrcBE ;                             //Addition

    SUB: ALUResult = SrcAE - SrcBE ;                             //Subtraction

    SLL: ALUResult = SrcAE << SrcBE[4:0];                        //Shift Left Logical

    SLT: ALUResult = ($signed(SrcAE) < $signed(SrcBE)) ? 1 : 0;  //Set Less than

    SLTU:ALUResult = (SrcAE < SrcBE) ? 1 : 0;                    //Set Less than unsigned

    XOR: ALUResult = SrcAE ^ SrcBE;                              //LOgical xor

    SRL: ALUResult = SrcAE >> SrcBE[4:0];                        //Shift Right Logical

    SRA: ALUResult = $signed(SrcAE) >>> SrcBE[4:0];              //Shift Right Arithmetic

    OR:  ALUResult = SrcAE | SrcBE;                              //Logical Or

    AND: ALUResult = SrcAE & SrcBE;                              //Logical and

    LUI: ALUResult = SrcBE;                                      //Load Upper Immediate

   

   
    

    // default:  ALUResult = SrcAE + SrcBE;
        // default:  ALUResult = 32'b0;
    endcase

  end
endmodule