`include "riscv.sv"
`include "sram.sv"
`include "flash.sv"

// Code your design here

module top #(parameter N=32)
  ( input logic clk,
    input logic rstn,
    output logic [N-1:0] instr_addr,
    input logic  [N-1:0]  instr
  );
  
   
  
  
  wire memRead_ex;
  wire memWrite_ex;
  wire [N-1:0] alu_result;
  wire [N-1:0] dt_out;
  wire [N-1:0] dt_in;
  
  // CPU
  riscv cpu
  ( .clk,
    .rstn,
    .memRead_ex,
    .memWrite_ex,
    .alu_result,
    .instr_addr,
   .instr_dec(instr),
    .dt_out,
    .dt_in
  );
 
  
 // inst mem
  //flash inst_mem
  //(.pc_out,
  // .instr
  //);
  
  
 // data mem 
  sram   data_mem  
  (.clk,
   .rstn,
   .write_enable(memWrite_ex),
   .read_enable(memRead_ex),
   .data_in(dt_in),
   .addr(alu_result),
   .data_out(dt_out));
 
  

  
endmodule
  
