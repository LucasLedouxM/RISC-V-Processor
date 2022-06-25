// Code your design here
module branch_control(
  input logic bctrl,
  input logic [2:0]funct,
  input logic zero,slt,sltu,
  output logic branch
);
 //o cinal bctrl diz se instru��o que esta sendo tratada � do tipo B, e atraves de funct qual fun��o
 //do tipo B esta sendo tratada
 always_comb 
   begin
     if(bctrl)
       begin             
         case(funct)
       //BEQ 
       3'b000:begin
                if(zero)
                  branch=1'b1;
                  else
                  branch=1'b0;
          end
       
       //BNE 
       3'b001:begin
                if(zero)
                  branch=1'b0;
                  else
                  branch=1'b1;
       end
       
       //BLT 
       3'b100:begin
                if(slt)
                  branch=1'b1;
                  else
                  branch=1'b0;
       end
       
       //BGE 
       3'b101:begin
                if(slt)
                  branch=1'b0;
                  else
                  branch=1'b1;
       end
       
       //BLTU 
       3'b110:begin
                if(sltu)
                  branch=1'b1;
                  else
                  branch=1'b0;
       end
       
       //BGEU 
       3'b111:begin
                if(sltu)
                  branch=1'b0;
                  else
                  branch=1'b1;
       end
       
       default:branch=1'b0;
       
     endcase
   end
   else
      branch=1'b0;
  end
  
endmodule