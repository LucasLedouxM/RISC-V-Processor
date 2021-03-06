module instruction_memory #(parameter N=32)
  (input logic[N-1:0]pc_out,
   output logic[N-1:0]instr
  );
  
  always_comb 
    begin
      case(pc_out)
        //addi x7,x0,2
        32'h00000000:instr=32'b000000000010_00000_000_00111_0010011;
        //addi x8,x0,10
        32'h00000004:instr=32'b000000001010_00000_000_01000_0010011;
        //and x10,x8,x7
        32'h00000008:instr=32'b0000000_01000_00111_111_01010_0110011;
        //or x10,x8,x7
        32'h0000000C:instr=32'b0000000_01000_00111_110_01010_0110011;
        //xor x10,x8,x7
        32'h00000010:instr=32'b0000000_01000_00111_100_01010_0110011;
        //sub x10,x8,x7
        32'h00000014:instr=32'b0100000_01000_00111_000_01010_0110011;
        default:instr=32'h00000000;
      endcase
    end
  
endmodule
