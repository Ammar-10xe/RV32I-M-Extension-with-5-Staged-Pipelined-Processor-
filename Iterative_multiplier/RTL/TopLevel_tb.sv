module TopLevel_tb ();
logic clk,rst;

integer  f;
reg [1023:0] mcd;
TopLevel TOPLevel (.clk(clk),.rst(rst));

initial 
begin
    clk<=0;
    forever begin
        #1 clk <=~ clk;

    end
end

initial 
begin
        if ($value$plusargs ("sig=%s", mcd))
        begin
        //  $display("STRING with FS has a value %0s", mcd);
         f = $fopen(mcd,"w"); 
        end
end

always_ff @(posedge clk)
begin
    
if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultM == 32'h00000f00))
begin
    $fwrite(f,"%h\n", TOPLevel.data_wr);
end

if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultM == 32'hcafebeef))
begin
    $finish;
end
end

// always_ff @(posedge clk)
// begin
//     // if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'h00000f00))
//         // if((TOPLevel.ALUResultW == 32'h00000f00))
//     $fwrite(f,"mul_use=%h, done=%h, start=%b, startE=%h,tmp=%b, operand1=%h, operand2=%h, mul_opcode=%b, mulresult=%h, result_m=%h,flagM=%b, alu_result=%h,alu_resultM=%h,alu_resultW=%h, alu_op=5b'%b, alu_opE=%5b'b,wr=%b, rdata2E=%h, rdata2M=%h, data_wr=%h, InstrF=%h,InstrD=%h,InstrE=%h, InstrM=%h, InstrW=%h, PC=%d\n",
//     TOPLevel.mul_use,TOPLevel.done,TOPLevel.start,TOPLevel.startE,TOPLevel.tmp,TOPLevel.operand1,TOPLevel.operand2,TOPLevel.mul_opcode,TOPLevel.result_multiply,TOPLevel.result_m,TOPLevel.flagM,TOPLevel.ALUResult,TOPLevel.ALUResultM,TOPLevel.ALUResultW,TOPLevel.alu_op,TOPLevel.alu_opE,TOPLevel.wr,TOPLevel.rdata2E,TOPLevel.rdata2M,TOPLevel.data_wr,TOPLevel.Inst,TOPLevel.InstD,TOPLevel.InstE, TOPLevel.InstM,TOPLevel.InstW,TOPLevel.Addr);

// end







initial 
begin
    rst<=1;
    #20
    rst<=0;
end

parameter count = 500000;
// parameter count = 500;
reg [31:0] loop;

initial begin
    for (loop=0 ; loop < count ; loop = loop +1) begin
        repeat (1) @ (posedge clk);
    end
    $finish;
end


endmodule

