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
    
if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'h00000f00))
begin
    $fwrite(f,"%h\n", TOPLevel.ALUResultW);
end

if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'hcafebeef))
begin
    $finish;
end
end

// always_ff @(posedge clk)
// begin
//     // if(!TOPLevel.Alu.result_multiply)
//     $fwrite(f,"%h\n", TOPLevel.result_m);

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

