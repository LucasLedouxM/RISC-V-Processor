module csr_ctrl #(parameter N=32)
  (input logic clk,rstn,en,
   input logic [N-1:0]reg_out,imm,
   input logic [2:0]funct,
   output logic [N-1:0]csr_out     
  );
  
  logic[N-1:0]csr_m,csr;
  
  always_comb
    begin
      case(funct)
        //csrrw
        3'b001:csr_m=reg_out;
        //csrrwi
        3'b101:csr_m=imm;
        //csrrs
        3'b010:csr_m=csr|reg_out;
        //csrrsi
        3'b110:csr_m=csr|imm;
        //csrrc
        3'b011:csr_m=csr&reg_out;
        //csrrci
        3'b111:csr_m=csr&imm;    
        default:csr_m=0;
      endcase
    end  
  
  always_ff@(posedge clk,negedge rstn)
    begin
      if (~rstn)
        csr=0;
      else
        begin
          if (en)
            csr=csr_m;
        end        
    end
  
  assign csr_out=csr;  
endmodule
