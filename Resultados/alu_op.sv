// Code your design here

//`include "pack.sv"

module alu_op import alu_op_pkg::*;(
  input logic [1:0]op,
  input logic IR,
  input logic [1:0]SM,
  input logic [2:0]func3,
  output logic [0:4] out);
  
  //a entrada op indica a familia de instuções que esta sendo executada
  //se seu valor for 2'b00 a instrução é do tipo I ou do tipo R. se for 2b'01
  //é do tipo B(branch) e 2b'11 é para as demais
  
  //o sinal IR é igual a 1b'1 apenas para os sinais IR
  //o sinal de entrada SM tem valor 2'b10 se a instrução for do tipo SUB ou SRA
  //e é igual a 2b'01 se for multiplicação ou divisão
  always_comb begin
    case(op)
      //caso a instução seja do tipo I ou do tipo R
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
      //aqui as intruções do tipo B(branch) são tratadas
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
      //demais familias de instuções
      default:out=ADD;
    endcase
  end
endmodule