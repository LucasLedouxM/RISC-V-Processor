module sram          #(parameter WORD_SIZE=32,
                       parameter BANK_SIZE=256)
  (input logic clk,rstn,write_enable,read_enable,
   input logic [WORD_SIZE-1:0]data_in,addr,
   output logic [WORD_SIZE-1:0]data_out);

  logic[WORD_SIZE-1:0]registers[BANK_SIZE-1:0];  
  logic [7:0]addr_in;
  
  integer i;
 
  assign addr_in = addr[9:2];
  
  always_ff @(posedge clk, negedge rstn)
    begin
      if (~rstn)
        begin
          for(i=0;i<BANK_SIZE;i++)
            registers[i]<='0;            
        end
      else if(write_enable)
        registers[addr_in]<=data_in;
      //else if(read_enable)
      //  data_out <= registers[addr_in];
      //else
      //   data_out <= '0;
    end

  assign  data_out = (read_enable) ? registers[addr_in] : {'bz};
   
 
endmodule