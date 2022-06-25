module mux #(parameter WORD_SIZE=32)
  (
    input logic sel,
    input logic [WORD_SIZE-1:0]dt_0,dt_1,
    output logic [WORD_SIZE-1:0]data_out);

 
  always_comb
    begin
      case(sel)
       1'b0:data_out=dt_0;
       1'b1:data_out=dt_1;
      endcase

    end
 
   
 
endmodule