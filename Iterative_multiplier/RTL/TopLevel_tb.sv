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
//     // if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultM == 32'h00000f00))
//         // if((TOPLevel.ALUResultM == 32'h00000f00))
//     $fwrite(f,"InsrtE=%h, startD=%b, doneD=%b, div_opcode=%b, result_divide=%h, operand1=%h, operand2=%h, flagD=%b,result_m=%h\n",TOPLevel.InstE,TOPLevel.startD,TOPLevel.doneD,TOPLevel.div_opcode,TOPLevel.result_divide,TOPLevel.operand1,TOPLevel.operand2,TOPLevel.flagD,TOPLevel.result_m);

// end







initial 
begin
    rst<=1;
    #20
    rst<=0;
end

// parameter count = 500000;
parameter count = 500;
reg [31:0] loop;

initial begin
    for (loop=0 ; loop < count ; loop = loop +1) begin
        repeat (1) @ (posedge clk);
    end
    $finish;
end


endmodule

