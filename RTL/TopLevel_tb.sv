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

// always_ff @(posedge clk)
// begin
    
// if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'h00000f00))
// // if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'hff000000)) //demofile
// begin
//     $fwrite(f,"%h\n", TOPLevel.data_wr);
// end

// if((~TOPLevel.Dmem.wr) & (TOPLevel.ALUResultW == 32'hcafebeef))
// begin
//     $finish;
// end
// end



always_ff @(posedge clk)
begin
    $fwrite(f,"%h\n", TOPLevel.ALUResult);


end





initial 
begin
    rst<=1;
    #20
    rst<=0;
end

// parameter count = 500000;
parameter count = 100;
reg [31:0] loop;

initial begin
    for (loop=0 ; loop < count ; loop = loop +1) begin
        repeat (1) @ (posedge clk);
    end
    $finish;
end


endmodule

// module TopLevel_tb ();
// logic clk,rst;

// TopLevel TOPLevel (.clk(clk),.rst(rst));

// initial begin
//     clk<=0;
//     forever begin
//         #1 clk<=~clk;
//     end
// end
// initial begin
//     #1
//     rst<=1;
//     #1
//     rst<=0;
// end

// endmodule