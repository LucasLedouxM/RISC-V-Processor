

module alu import alu_op_pkg::*;
  #(parameter N=32)(
  input logic [N-1:0]data_1,data_2,
  input logic [0:4] out,
  output logic zero,slt,sltu,
  output logic [N-1:0]data_out
    );
  logic [2*N-1:0]aux;
  
  always_comb 
    begin
      if(data_1==data_2)
        zero=1'b1;
      else
        zero=1'b0;
    end
  
  always_comb 
    begin
      if(signed'(data_1)<signed'(data_2))
        slt=1'b1;
      else
        slt=1'b0;
    end
  
   always_comb 
    begin
      if(data_1<data_2)
        sltu=1'b1;
      else
        sltu=1'b0;
    end
  
  always_comb 
    begin
      case(out)
        ADD:data_out=data_1+data_2;
        SUB:data_out=data_1-data_2;
        SLL:data_out=data_1<<data_2[4:0];
        SLT:data_out=signed'(data_1)<signed'(data_2);
        SLTU:data_out=data_1<data_2;
        XOR:data_out=data_1^data_2;
        SRL:data_out=data_1>>data_2[4:0];
        SRA:data_out=signed'(data_1)>>>data_2[4:0];
        OR:data_out=data_1|data_2;
        AND:data_out=data_1&data_2;
        MUL:begin
              aux=signed'(data_1)*signed'(data_2);
              data_out=aux[N-1:0];
            end
        MULH:begin
              aux=signed'(data_1)*signed'(data_2);
              data_out=aux[2*N-1:N];
            end
        MULHSU:begin
          aux=signed'(data_1)*(data_2);
              data_out=aux[2*N-1:N];
            end
        MULHU:begin
              aux=data_1*data_2;
              data_out=aux[2*N-1:N];
            end
        DIV:data_out=signed'(data_1)/signed'(data_2);
        DIVU:data_out=(data_1)/(data_2);
        REM:data_out=signed'(data_1)%signed'(data_2);
        REMU:data_out=data_1%data_2;
        NOP:data_out=0;
        default:data_out=0;
      endcase
    end
    
    
endmodule
