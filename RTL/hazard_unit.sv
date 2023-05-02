module Hazard_Unit (
    input  logic       reg_wrM,reg_wrW,br_taken,
    input logic  [1:0] wb_sel,
    input  logic [4:0] raddr1D,raddr2D,raddr1E,raddr2E,waddrE,waddrM,waddrW,
    output logic       StallF,StallD,FlushD,FlushE, 
    output logic [1:0] forwardAE,forwardBE
    
);

// Check the validity of the source operands from EXE stage
  logic rs1_valid;
  logic rs2_valid;
  assign rs1_valid = |raddr1E;
  assign rs2_valid = |raddr2E;

// Hazard detection for forwarding 

  always_comb begin
    if ((( raddr1E == waddrM )  & (reg_wrM)) & (rs1_valid)) begin
      forwardAE = 2'b00;
    end
    else if ((( raddr1E == waddrW )  & (reg_wrW)) & (rs1_valid)) begin
      forwardAE = 2'b10;
    end
    else begin
      forwardAE = 2'b01;
    end

  end

  always_comb begin
    if ((( raddr2E == waddrM )  & (reg_wrM)) & (rs2_valid)) begin
      forwardBE = 2'b00;
    end
    else if ((( raddr2E == waddrW )  & (reg_wrW)) & (rs2_valid)) begin
      forwardBE = 2'b10;
    end
    else begin
      forwardBE = 2'b01;
    end

  end

// // Hazard detection for Stalling

always_comb begin 
    if (( ( wb_sel == 2'b10 ) & ((raddr1D == waddrE) | (raddr2D == waddrE))  )) begin 
        StallD       = 1'b1;
        StallF       = StallD;   
    end
    else begin
        StallD       = 1'b0;
        StallF       = StallD;   

    end
end

//Hazard detecting for flushing 
always_comb begin begin
  if ( br_taken ) begin
    FlushD = 1'b1;
    FlushE = FlushD;
  end
  else begin
    FlushD = 1'b0;
    FlushE = FlushD;
  end
  
end
  
end

endmodule