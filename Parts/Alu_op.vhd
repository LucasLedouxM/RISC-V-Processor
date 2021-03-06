// Code your design here

`include "pack.sv"

module ALU_op import alu_op_pkg::*;(
  input logic [1:0]op,
  input logic IR,
  input logic [1:0]SM,
  input logic [2:0]func3,
  output ALU_op_t out);
   
  always_comb begin
    case(op)
      2'b00:
        begin
          case({IR,SM})
            3'b110:begin
              case(func3)
                3'b000:out=SUB;
                3'b101:out=SRA;
                default:out=NOP;
              endcase
            end
            3'b101:begin
              case(func3)
                3'b000:out=MUL;
                3'b001:out=MULH;
                3'b010:out=MULHSU;
                3'b011:out=MULHU;
                3'b100:out=DIV;
                3'b101:out=DIVU;
                3'b110:out=REM;
                3'b111:out=REMU;                                
              endcase
            end
            default:begin
              case(func3)
                3'b000:out=ADD;
                3'b001:out=SLL;
                3'b010:out=SLT;
                3'b011:out=SLTU;
                3'b100:out=XOR;
                3'b101:out=SRL;
                3'b110:out=OR;
                3'b111:out=AND;  
              endcase
            end
          endcase
        end
      2'b01:        
        begin
          case (func3)
          3'b000:out=SUB;
          3'b001:out=SUB;
          3'b100:out=SLT;
          3'b101:out=SLT;
          3'b110:out=SLTU;
          3'b111:out=SLTU;
          default:out=NOP;
          endcase
        end
      default:out=ADD;
    endcase
  end
endmodule
