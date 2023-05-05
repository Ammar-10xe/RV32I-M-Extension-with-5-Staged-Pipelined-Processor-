module TopLevel (input logic clk,rst);

    logic        reg_wr,reg_wrE,reg_wrM,reg_wrW,sel_A,sel_AE,sel_B,sel_BE,cs,wr,br_taken,br_takenM,StallF,StallD,FlushD,FlushE;
    logic [1:0]  wb_sel,wb_selE,wb_selM,wb_selW,forwardAE,forwardBE;
    logic [2:0]  ImmSrcD,funct3,funct3E,funct3M;
    logic [3:0]  mask;
    logic [4:0]  raddr1,raddr1D,raddr1E,raddr2,raddr2D,raddr2E,waddr,waddrD,waddrE,waddrM,waddrW,alu_op,alu_opE;
    logic [6:0]  instr_opcode,instr_opcodeE,instr_opcodeM;
    logic [31:0] Addr,AddrD,AddrE,AddrM,AddrW,AddrWB,PC,Inst,InstD,InstE,InstM,InstW,PCF,wdata,rdata1,rdata1E,rdata2,rdata2E,rdata2M,ImmExtD,ImmExtE,SrcA,SrcAE,SrcB,SrcBE,ALUResult,ALUResultM,ALUResultW,rdata,rdataW,data_rd,addr,addr_DM,data_wr,toLSU,mem_out;
    logic [31:0] mem_outW;
    
    //for Alu M extension 
    logic [31:0] operand1, operand2, result_divide, ALU_result_divide,result_m;
    logic [63:0]  ALU_result_multiply;

    logic [31:0] result_multiply,ALU_operand1, ALU_operand2;
    logic [1:0]  mul_opcode,div_opcode;
    logic done,flagM,start,startE,mul_use;


InstMcheck Mcheck (
    .clk(clk),
    .rst(rst),
    .startE(startE),
    .mul_use(mul_use),
    .alu_opE(alu_opE),
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .flagM(flagM),
    .result_m(result_m),
    .operand1(operand1),
    .operand2(operand2),
    .mul_opcode(mul_opcode),
    .div_opcode(div_opcode),
    .result_multiply(result_multiply),
    .result_divide(result_divide),
    .done(done));


multiplier_iterative multiplier (
    .clk(clk),
    .rst(rst),
    .startE(startE),
    .mul_opcode(mul_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_multiply(result_multiply),
    .done(done),
    .mul_use(mul_use)
    );

divider_32bit divider_inst (
    .div_opcode(div_opcode),
    .operand1(operand1),
    .operand2(operand2),
    .result_divide(result_divide));




Mux_PC MuxPC(
    .br_takenM(br_taken),
    .PCF(PCF),
    .ALUResultM(ALUResult),
    .PC(PC));

PCPlus4 PCplus4 (
    .Addr(Addr),
    .PCF(PCF));

program_counter ProgCouner (
    .clk(clk),
    .rst(rst),
    .StallF(StallF),
    .mul_use(mul_use),
    .startE(startE),
    .PC(PC),
    .Addr(Addr));

Instruction_Memory InstMem(
    .Addr(Addr),
    .addr(addr),
    .Inst(Inst),
    .toLSU(toLSU));

first_register FirstReg(
    .clk(clk),
    .rst(rst),
    .StallD(StallD),
    .FlushD(FlushD),
    .Addr(Addr),
    .Inst(Inst),
    .AddrD(AddrD),
    .InstD(InstD)); 

Instruction_Fetch Fetch(
    .InstD(InstD),
    .raddr1D(raddr1D),
    .raddr2D(raddr2D),
    .waddrD(waddrD));

Register_file RegsiterFile(
    .clk(clk),
    .rst(rst),
    .reg_wrW(reg_wrW),
    .raddr1(raddr1D),
    .raddr2(raddr2D),
    .waddr(waddrW),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2));

immediate_gen Immediate(
    .InstD(InstD),
    .ImmSrcD(ImmSrcD),
    .ImmExtD(ImmExtD));

second_register SecondReg(
    .clk(clk),
    .rst(rst),
    .start(start),
    .startE(startE),
    .reg_wr(reg_wr),
    .sel_A(sel_A),
    .sel_B(sel_B),
    .FlushE(FlushE),
    .wb_sel(wb_sel),
    .funct3(funct3),
    .alu_op(alu_op),
    .raddr1D(raddr1D),
    .raddr2D(raddr2D),
    .waddrD(waddrD),
    .instr_opcode(instr_opcode),
    .AddrD(AddrD),
    .rdata1(rdata1),
    .rdata2(rdata2),
    .ImmExtD(ImmExtD),
    .InstD(InstD),
    .reg_wrE(reg_wrE),
    .sel_AE(sel_AE),
    .sel_BE(sel_BE),
    .wb_selE(wb_selE),
    .funct3E(funct3E),
    .alu_opE(alu_opE),
    .raddr1E(raddr1E),
    .raddr2E(raddr2E),
    .waddrE(waddrE),
    .instr_opcodeE(instr_opcodeE),
    .AddrE(AddrE),
    .rdata1E(rdata1E),
    .rdata2E(rdata2E),
    .ImmExtE(ImmExtE),
    .InstE(InstE));

forward_muxA Forwd_MuxA(
    .forwardAE(forwardAE),
    .rdata1E(rdata1E),
    .ALUResultM(ALUResultM),
    .wdata(wdata),
    .SrcA(SrcA)
);

forward_muxB Forwd_MuxB(
    .forwardBE(forwardBE),
    .rdata2E(rdata2E),
    .ALUResultM(ALUResultM),
    .wdata(wdata),
    .SrcB(SrcB)
);

mux_selA MuxselA(
    .sel_AE(sel_AE),
    .SrcA(SrcA),
    .AddrE(AddrE),
    .SrcAE(SrcAE));

mux_selB MuxselB(
    .sel_BE(sel_BE),
    .ImmExtE(ImmExtE),
    .SrcB(SrcB),
    .SrcBE(SrcBE));

BranchCond Branchcond(
    .funct3E(funct3E),
    .instr_opcodeE(instr_opcodeE),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .br_taken(br_taken));

ALU Alu(
    .alu_opE(alu_opE),
    .flagM(flagM),
    .mul_use(mul_use),
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .result_m(result_m),
    .ALUResult(ALUResult));


third_register ThirdReg(
    .clk(clk),
    .rst(rst),
    // .flagM(flagM),
    // .result_m(result_m),
    .reg_wrE(reg_wrE),
    .br_taken(br_taken),
    .wb_selE(wb_selE),
    .funct3E(funct3E),
    .waddrE(waddrE),
    .SrcB(SrcB),
    .instr_opcodeE(instr_opcodeE),
    .AddrE(AddrE),
    .ALUResult(ALUResult),
    .rdata2E(rdata2E),
    .InstE(InstE),
    .reg_wrM(reg_wrM),
    .br_takenM(br_takenM),
    .wb_selM(wb_selM),
    .funct3M(funct3M),
    .waddrM(waddrM),
    .instr_opcodeM(instr_opcodeM),
    .AddrM(AddrM),
    .ALUResultM(ALUResultM),
    .rdata2M(rdata2M),
    .InstM(InstM));

LoadStore_Unit loadstore(
    .funct3M(funct3M),
    .instr_opcodeM(instr_opcodeM),
    .data_rd(data_rd),
    .rdata2M(rdata2M),
    .ALUResultM(ALUResultM),
    .cs(cs),
    .wr(wr),
    .mask(mask),
    .addr(addr),
    .data_wr(data_wr),
    .rdata(rdata));


Data_Memory Dmem(
    .clk(clk),
    .rst(rst),
    .cs(cs),
    .wr(wr),
    .mask(mask),
    .addr(addr),
    .data_wr(data_wr),
    .data_rd(data_rd));


fourt_register FourtReg(
    .clk(clk),
    .rst(rst),
    .reg_wrM(reg_wrM),
    .wb_selM(wb_selM),
    .waddrM(waddrM),
    .AddrM(AddrM),
    .ALUResultM(ALUResultM),
    .mem_out(mem_out),
    .InstM(InstM),
    .reg_wrW(reg_wrW),
    .wb_selW(wb_selW),
    .waddrW(waddrW),
    .AddrW(AddrW),
    .ALUResultW(ALUResultW),
    .mem_outW(mem_outW),
    .InstW(InstW));


AddrW_Plus4 addrW_Plus4(
    .AddrW(AddrW),
    .AddrWB(AddrWB));

MuxResult Muxresult(
    .wb_selW(wb_selW),
    .ALUResultW(ALUResultW),
    .mem_outW(mem_outW),
    .AddrWB(AddrWB),
    .wdata(wdata));

controller Controller(
    .mul_use(mul_use),
    .startE(startE),
    .start(start),
    .InstD(InstD),
    .reg_wr(reg_wr),
    .sel_A(sel_A),
    .sel_B(sel_B),
    .wb_sel(wb_sel),
    .ImmSrcD(ImmSrcD),
    .funct3(funct3),
    .alu_op(alu_op),
    .instr_opcode(instr_opcode));

Hazard_Unit HazardUnit(
    .reg_wrM(reg_wrM),
    .reg_wrW(reg_wrW),
    .br_taken(br_taken),
    .mul_use(mul_use),
    .startE(startE),
    .wb_sel(wb_selE),
    .raddr1D(raddr1D),
    .raddr2D(raddr2D),
    .raddr1E(raddr1E),
    .raddr2E(raddr2E),
    .waddrE(waddrE),
    .waddrM(waddrM),
    .waddrW(waddrW),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE));
    
Memory_mux Memory_mux(
    .toLSU(toLSU),
    .rdata(rdata),
    .addr(Addr),
    .mem_out(mem_out));

endmodule