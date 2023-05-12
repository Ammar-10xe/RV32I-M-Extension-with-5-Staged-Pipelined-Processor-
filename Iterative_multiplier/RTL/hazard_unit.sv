module Hazard_Unit (
    input clk,rst,
    input  logic       reg_wrM,reg_wrW,br_taken,startE,
    input logic  [1:0] wb_selE,
    input  logic [4:0] raddr1D,raddr2D,raddr1E,raddr2E,waddrE,waddrM,waddrW,
    output logic       StallF,StallD,FlushD,FlushE,FlushES,StallM,
    output logic [1:0] forwardAE,forwardBE
    
);

// Check the validity of the source operands from EXE stage
  logic rs1_valid;
  logic rs2_valid;
  logic lwstall;
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

reg lwstall_prev; // This is a new signal that stores the previous value of lwstall

// This block updates lwstall_prev on each clock edge
always @(posedge clk) begin
  if (rst) begin
    lwstall_prev <= 1'b0;
  end else begin
    lwstall_prev <= lwstall;
  end
end

// This block calculates lwstall and controls StallF, StallD, and FlushE
always_comb begin
  lwstall = (((wb_selE == 2'b10) & ((raddr1D == waddrE) | (raddr2D == waddrE))));
  if (lwstall && !lwstall_prev) begin
    StallF = 1'b1; 
    StallD = StallF;
    FlushE = StallD;
  end 
  else if ( startE )begin
    StallM = 1'b1;
  end
  else begin
    StallF = 1'b0; 
    StallD = StallF;
    FlushE = StallD;
    StallM = FlushE;
  end
end

//Hazard detecting for flushing 
always_comb begin begin
  if ( br_taken ) begin
    FlushD = 1'b1;
    FlushES = FlushD;
  end

  else begin
    FlushD = 1'b0;
    FlushES = FlushD;
  end
  
end
  
end

endmodule

