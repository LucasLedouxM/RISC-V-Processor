module register_bank #(parameter WORD_SIZE=32,
                       parameter BANK_SIZE=32)
  (input logic clk,rstn,write_enable,
   input logic [4:0] rd_read1, rd_read2, write_addr,
   input logic [WORD_SIZE-1:0]data_in,
   output logic [WORD_SIZE-1:0]data_out1,data_out2);

  logic[BANK_SIZE-1:0]registers[WORD_SIZE-1:0];  
  integer i;
 
  always_ff @(posedge clk, negedge rstn)
    begin
      if (~rstn)
        begin
          for(i=0;i<BANK_SIZE;i++)
            registers[i]<='0;            
        end
      else if(write_enable)
        registers[write_addr]<=data_in;
    end
 
  always_comb
    begin
      if((rd_read1 == write_addr)&write_enable)
      data_out1 =data_in;  
      else  
      data_out1=registers[rd_read1];
    end
  
  always_comb
    begin
      if((rd_read2 == write_addr)&write_enable)
      data_out2 = data_in;  
      else  
      data_out2=registers[rd_read2];
    end
 
   
 
endmodule