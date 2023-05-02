module program_counter (
	input  logic clk,rst,StallF,ready,
	input  logic [31:0] PC,
	output logic [31:0] Addr
);

	always_ff @( posedge clk or posedge rst ) begin
	 if (rst) 
	   		Addr <= 32'd0;
	 else if ( StallF | ready)
			Addr <= Addr;
	 else if ( ~ StallF )
			Addr <= PC;
	end	
endmodule
