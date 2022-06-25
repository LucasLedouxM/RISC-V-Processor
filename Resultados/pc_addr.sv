//Neste modulo o tipo da instrução é detectado, e a depender dele
//o endereço da proxima instução é gerado.
//Apenas as instruções do tipo B (branch) e as instruções JAL e JALR
//provocam mudança no endereço da proxima instução a ser executada.
//para os demais tipos de instução, o endereço da instrução seguinte
//é o endereço dela +4.
//Na saida chamada PCin ela tras o endereço da proxima instrução a ser executada;


module pc_addr #(parameter N=32)
  (input logic branch,
   input logic [1:0]ctrpc,
   input logic [N-1:0]pc_next,
   input logic [N-1:0]reg_out,
   input logic [N-1:0]imm,
   output logic [N-1:0] pc_in
  );

  always_comb
    begin

   //aqui é detectado se  uma instução do tipo B gerol salto;
   //caso positivo, o edereço da proxima instução é aquele determinado pelo salto.
   //caso contrario, é o endereço da instução +4 
      if(branch)
        pc_in=imm-4;
      else
        begin
        //ctrpc diz qual é a familia de instuções que pertence a instução que esta sendo decodificada.
          case(ctrpc)
          //JAL
            2'b10:pc_in=pc_next+4;
          //JALR
            2'b11:pc_in=reg_out+pc_next+4;
            default:pc_in=pc_next;
            
          endcase
        end        
    end
  
endmodule
