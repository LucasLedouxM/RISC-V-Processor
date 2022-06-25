
module pc #(
	parameter WORD_WIDTH = 32
	)(
	input logic [WORD_WIDTH-1:0] pc_in,
	input logic clk,
	input logic rstn,
    input logic branch,
	output logic [WORD_WIDTH-1:0] pc_out
	);

   logic [WORD_WIDTH-1:0] pc_aux;
   logic [WORD_WIDTH-1:0] pc_in_aux;
  
   
  
	always @(posedge clk or negedge rstn)
	begin
      if(~rstn) pc_aux<='b0;
      else if(clk) pc_aux<=pc_in_aux;
	end 
  
    always_comb
      begin
        if(branch)
          pc_out = pc_in;
        else
          pc_out = pc_aux;    
      end
  
    always_comb
      begin
        if(branch)
          pc_in_aux = pc_in+4;
        else
          pc_in_aux = pc_in;    
      end

endmodule // pc