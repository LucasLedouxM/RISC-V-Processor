module wr_dt_ctrl #(parameter N=32)
  (input logic[N-1:0]reg_out,
   input logic memWr,
   input logic[2:0]funct,
   output logic[N-1:0]mdata 
  );
  
  always_comb
    begin
      if(memWr)
        begin
          case (funct)
          //SB
            3'b000:mdata={24'h000000,reg_out[7:0]};
          //SH          
            3'b001:mdata={16'h0000,reg_out[15:0]};
          //SW  
            3'b010:mdata=reg_out;
            default:mdata=0;
          endcase
        end
      else
        mdata=0;
          
    end
  
  
  
endmodule
