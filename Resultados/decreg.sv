module decreg #(
	parameter WORD_WIDTH = 32
	)(
  input logic [WORD_WIDTH-1:0] instr_dec,
	input logic clk,
	input logic rstn,
    input logic branch,
  output logic [WORD_WIDTH-1:0] instr
	);

  logic [WORD_WIDTH-1:0] instr_aux;
  
	always @(posedge clk or negedge rstn)
	begin
      if(~rstn) instr_aux<='b0;
      else if(clk) instr_aux<=instr_dec;
	end 
  
    always_comb 
      begin
        if(branch)
          instr = 'b0;  
        else  
          instr = instr_aux;
      end

endmodule // pc