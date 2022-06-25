// Code your design here
module rd_dt_ctrl
  #(parameter N=32)(
    input logic memRd,
    input logic [2:0]funct,
    input logic [N-1:0]dt_out,
    output logic  [N-1:0]mem_out 
  );
  
  always_comb
        begin
          if(memRd)
            begin
              case(funct)
                //LB
                3'b000:
                  begin 
                    case(dt_out[7])
                      1'b0:mem_out={24'h000000,dt_out[7:0]};
                      1'b1:mem_out={24'hFFFFFF,dt_out[7:0]};
                    endcase

                  end
                //LH
                3'b001:                
                  begin 
                    case(dt_out[15])
                      1'b0:mem_out={16'h0000,dt_out[15:0]};
                      1'b1:mem_out={16'hFFFF,dt_out[15:0]};
                    endcase
                   end
                //LW
                3'b010:mem_out={16'h0000,dt_out[15:0]};
                //LBU
                3'b100:mem_out={24'h000000,dt_out[7:0]};
                //LHU
                3'b101:mem_out={16'h0000,dt_out[15:0]};
                
              endcase
            end
          else
            mem_out=0;
          
        end
endmodule