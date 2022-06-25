`include "decoder.sv"
`include "pc_addr.sv"
`include "csr_ctrl.sv"
`include "branch_control.sv"
`include "wr_dt_ctrl.sv"
`include "rd_dt_ctrl.sv"
`include "mux.sv"
`include "register_bank.sv"
`include "alu_op_pkg.sv"
`include "alu_op.sv"
`include "alu.sv"
`include "pc.sv"
`include "exreg.sv"
`include "decreg.sv"
// Code your design here
// Code your design here

module riscv #(parameter N=32)
  ( input logic clk,
    input logic rstn,
    output logic memRead_ex,
    output logic memWrite_ex,
    output logic[N-1:0]alu_result,
    output logic[N-1:0]instr_addr,
    output logic[N-1:0]dt_in,
    input logic[N-1:0]instr_dec,
    input logic[N-1:0]dt_out
  );
  
  
  // Insternal connections
  
  wire [1:0]ctrpc;
  wire [N-1:0]pc_next;
  
  wire bctrl;
  wire bctrl_ex;
  
  wire [4:0]rd1;
  wire [4:0]rd2;
  wire [4:0]wr;
  wire [4:0]wr_ex;
  
  wire regWr;
  wire regWr_ex;
  wire alu_in_sel;
  wire alu_in_sel_ex;
  wire csr_ctrl;
  wire csr_ctrl_ex;
  wire dt_1_sel;
  wire dt_2_sel;
  wire dt_3_sel;
  wire dt_1_sel_ex;
  wire dt_2_sel_ex;
  wire dt_3_sel_ex;
 
  wire memRead;
  wire memWrite;
  
  wire [N-1:0]imm;
  wire [2:0]funct;
  wire [N-1:0]imm_ex;
  wire [2:0]funct_ex;
  
  wire [1:0] inst_type;
  wire IR;
  wire [1:0]SM;
  
  wire branch;
  wire zero;
  wire slt;
  wire sltu;
  
  //wire [N-1:0] ;
  wire [N-1:0] instr;
  wire [N-1:0] mem_out;
  wire [N-1:0] wr_data;
  wire [N-1:0] rd_data1;
  wire [N-1:0] rd_data2;
  wire [N-1:0] rd_data1_ex;
  wire [N-1:0] rd_data2_ex;
  wire [N-1:0] csr_out;
  wire [N-1:0] din_0;
  wire [N-1:0] din_1;
  wire [N-1:0] alu_in;
  wire [N-1:0] pc_out;
  wire [N-1:0] pc_in;
  
  logic [0:4] alu_op;
  logic [0:4] alu_op_ex;
  
  // multiplexers
  mux dt_1(
    .sel(dt_1_sel_ex),
    .dt_0(alu_result),
    .dt_1(mem_out),
    .data_out(din_0));
  
  mux dt_2(
    .sel(dt_2_sel_ex),
    .dt_0(din_0),
    .dt_1(imm_ex),
    .data_out(din_1));
  
  mux dt_3(
    .sel(dt_3_sel_ex),
    .dt_0(din_1),
    .dt_1(csr_out),
    .data_out(wr_data));
  
  mux alu_in_m(
    .sel(alu_in_sel_ex),
    .dt_0(rd_data2_ex),
    .dt_1(imm_ex),
    .data_out(alu_in));
  
  mux instr_mux(
    .sel(ctrpc[1]),
    .dt_0(pc_out),
    .dt_1(pc_in-4),
    .data_out(instr_addr));
  
  // instantiate decoder
  decoder d1 
  (.instr,
   .pc_out,
   .ctrpc,
   .pc_next,
   .bctrl,
   .memRead,
   .rd1,
   .rd2,
   .wr,
   .regWr,
   .alu_in_sel,
   .csr_ctrl,
   .imm,
   .funct,
   .memWrite,
   .inst_type,
   .IR,
   .SM,
   .dt_1_sel,
   .dt_2_sel,
   .dt_3_sel   
  );
  
  // Pipeline registers
  
  exreg ex_reg (
	.clk,
	.rstn,
    .memRead,
    .memRead_ex,
    .memWrite,
    .memWrite_ex,
    .rd_data1,
    .rd_data2, 
    .rd_data1_ex,
    .rd_data2_ex, 
    .alu_in_sel,
    .alu_in_sel_ex,
    .csr_ctrl,
    .csr_ctrl_ex,
    .bctrl,
    .bctrl_ex,
    .imm,
    .imm_ex,
    .dt_1_sel,
    .dt_2_sel,
    .dt_3_sel,
    .dt_1_sel_ex,
    .dt_2_sel_ex,
    .dt_3_sel_ex,
    .funct,
    .funct_ex,
    .alu_op,
    .alu_op_ex,
    .regWr,
    .regWr_ex,
    .wr,
    .wr_ex
	);

  decreg dec_reg(
    .instr_dec,
	.clk,
	.rstn,
    .branch,
    .instr
	);
  
  // Instantiate PC addr control
  pc_addr pcaddr
  (.branch,
   .ctrpc,
   .pc_next,
   .reg_out(rd_data1),
   .imm(imm_ex),
   .pc_in
  );
  
  // Instantiate CSR ctrl
  csr_ctrl csr
  (.clk,
   .rstn,
   .csr_ctrl(csr_ctrl_ex),
   .reg_out(rd_data2_ex),
   .imm(imm_ex),
   .funct(funct_ex),
   .csr_out     
  );
  
  // Instantiate branch controll
  branch_control branch_ctrl(
  .bctrl(bctrl_ex),
  .funct(funct_ex),
  .zero,
  .slt,
  .sltu,
  .branch
  );
  
  // Instantiate wr_dt_ctl
  wr_dt_ctrl wr_ctrl
  (.reg_out(rd_data2_ex),
   .memWr(memWrite_ex),
   .funct(funct_ex),
   .mdata(dt_in) 
  );
  
  
   rd_dt_ctrl rd_ctrl
  (
    .memRd(memRead_ex),
    .funct(funct_ex),
    .dt_out,
    .mem_out 
  );
  
  // Instantiate reg bank
  register_bank reg_bk
  (.clk,
   .rstn,
   .write_enable(regWr_ex),
   .rd_read1(rd1), 
   .rd_read2(rd2), 
   .write_addr(wr_ex),
   .data_in(wr_data),
   .data_out1(rd_data1),
   .data_out2(rd_data2) );
 
  // ALU
  alu_op aluop(
    .op(inst_type),
    .IR,
    .SM,
    .func3(funct),
    .out(alu_op));
  
  alu alu_syst
  (
    .data_1(rd_data1_ex),
    .data_2(alu_in),
    .out(alu_op_ex),
    .zero,
    .slt,
    .sltu,
    .data_out(alu_result)
    );
  
  // Program counter
   pc pcount (
    .pc_in,
	.clk,
	.rstn,
	.pc_out,
    .branch
	);

  
endmodule