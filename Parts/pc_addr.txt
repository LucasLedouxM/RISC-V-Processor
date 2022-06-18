module pc_addr #(parameter N=32)
  (input logic branch,
   input logic [1:0]ctrpc,
   input logic [N-1:0]pc_next,
   input logic [N-1:0]reg_out,
   input logic [N-1:0]imm,
   output logic [N-1:0] pc_in
  );

  always_comb
    begin
      if(branch)
        pc_in=imm;
      else
        begin
          case(ctrpc)
          //AUIPC
            2'b01:pc_in=imm;
          //JAL
            2'b10:pc_in=pc_next;
          //JALR
            2'b11:pc_in=reg_out+pc_next;
            default:pc_in=pc_next;
            
          endcase
        end        
    end
  
endmodule

