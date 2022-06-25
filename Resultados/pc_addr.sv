//Neste modulo o tipo da instru��o � detectado, e a depender dele
//o endere�o da proxima instu��o � gerado.
//Apenas as instru��es do tipo B (branch) e as instru��es JAL e JALR
//provocam mudan�a no endere�o da proxima instu��o a ser executada.
//para os demais tipos de instu��o, o endere�o da instru��o seguinte
//� o endere�o dela +4.
//Na saida chamada PCin ela tras o endere�o da proxima instru��o a ser executada;


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

   //aqui � detectado se  uma instu��o do tipo B gerol salto;
   //caso positivo, o edere�o da proxima instu��o � aquele determinado pelo salto.
   //caso contrario, � o endere�o da instu��o +4 
      if(branch)
        pc_in=imm-4;
      else
        begin
        //ctrpc diz qual � a familia de instu��es que pertence a instu��o que esta sendo decodificada.
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
