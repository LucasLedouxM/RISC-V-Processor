module decoder 
  (input logic [31:0]instr,
   input logic [31:0]pc_out,
   output logic [1:0]ctrpc,
   output logic [31:0]pc_next,
   output logic bctrl,
   output logic memRead,
   output logic [4:0]rd1,
   output logic [4:0]rd2,
   output logic [4:0]wr,
   output logic regWr,
   output logic alu_in_sel,
   output logic csr_ctrl,
   output logic [31:0] imm,
   output logic [2:0]funct,
   output logic memWrite,
   output logic [1:0] inst_type,
   output logic IR,
   output logic [1:0]SM,
   output logic dt_1_sel,
   output logic dt_2_sel,
   output logic dt_3_sel   
  );
  
  assign rd1=instr[19:15];
  assign rd2=instr[24:20];
  assign wr=instr[11:7];
  assign funct=instr[14:12];
  assign SM[1]=instr[30];
  assign SM[0]=instr[25];
  
  always_comb
    begin
      case(instr[6:0])
      //LUI
       7'b0110111:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=instr[31:12]<<12;
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=1;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //AUIPC
      7'b0010111:
       begin
         ctrpc=2'b00;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=(pc_out-4)+{instr[31:12],12'h000};
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //JAL
       7'b1101111:
       begin
         ctrpc=2'b10;
         if(instr[31])
           pc_next=(pc_out-4)+{11'hFFF,instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
         else
           pc_next=(pc_out-4)+{instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out;
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //JALR
     7'b1100111:
       begin
         ctrpc=2'b11;
         if(instr[31])
           pc_next={20'hFFFFF,instr[31:20]};
         else
           pc_next={instr[31:20]};
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out;
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end        
      //BRANCH
         7'b1100011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=1;
         memRead=0;
         regWr=0;
         alu_in_sel=0;
         csr_ctrl=0;
         if(instr[31])
           imm=pc_out+{19'hFFFFF,instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
         else
           imm=pc_out+{instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
         memWrite=0;
         inst_type=2'b01;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //LOAD
         7'b0000011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=1;
         regWr=1;
         alu_in_sel=1;
         csr_ctrl=0;
         imm=instr[31:20];
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=1;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //STORE
        7'b0100011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=0;
         alu_in_sel=1;
         csr_ctrl=0;
         imm={instr[31:25],instr[11:7]};
         memWrite=1;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //I
       7'b0010011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=1;
         csr_ctrl=0;
         if(instr[31])
           imm={20'hFFFFF,instr[31:20]};
         else  
           imm=instr[31:20];
         memWrite=0;
         inst_type=2'b00;
         if({SM[1],funct} == 4'b1101)
          IR=1;
         else
          IR=0; 
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //R
       7'b0110011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=0;
         memWrite=0;
         inst_type=2'b00;
         IR=1;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //CSR
       7'b1110011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=1;
         imm=instr[19:15];
         memWrite=0;
         inst_type=2'b11;
         IR=0;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=1;  
       end
       default 
       begin
         //ctrpc sera zero para todas as familias d einstu??es
         //pore para JAL sera 2b'10 e para JALPR 2b'11
         ctrpc=0;
         //pc_next ? usado pelo calculo do endere?o da isntu??o seguinte
         //para todas as familias de instu??es, o endere?o da instu??o
         //seguinte, ? o seu endere?o atual +4. 
         //apenas as intu??es JAL, JALR e do tipo B provocam mudan?a de fluxo
         //e podem trazer valor diferente
         pc_next=pc_out+4;
         //bctrl indica se a instu??es ? ou nao do tipo B. esse sinal tera o valor
         // de 1b'1 apenas se uma intru??o do tipo B estiver sendo decodificada
         bctrl=0;
         //memRead tera valor igual a 1b'1 apenas se uma instu??o de leitura de
         //memoria estiver sendo executada, para as demais ? zero
         memRead=0;
         //regWR tera o valor igual a 1 apenas se houver a instu??o escrever algo no resgistrado
         //instu??es tipo R e do tipo I e do tipo L escrevem algo no registrador, logo apenas
         //para elas este sinal ? 1
         regWr=0;
         //este sinal ? usado por um multiplexador que seleciona que uma das entradas da ALU vem
         //do registerData2 ou se ela ? uma constante.Para instu??es do tipo R, ou do tipo B o sinal
         //que vem do registrador ? selecionado, portando o valor de alu-in-sel ? zero.
         //para instru??es do tipo I e do tipo S (STORE) e do tipo L (LOAD) a constante ? selecionada
         //portanto o valor ? 1. Para os demais tipos, a alu n?o ? usada e o valor de tal sinal ? diferente.
         alu_in_sel=0;
         //o sinal csr_ctrl ? igual a 1 apenas se a instu??o a ser executada ? do tipo crsr.
         csr_ctrl=0;
         //imm tem 32 bits e transmite a constante para as instu??es tipo B, tipo I, tipo S e tipo L.
         //para as intru??es tipo JAL e JALR, imm transmite o endere?o destas instu??es
         imm=0; 
         //este sinal tem o valor igual a 1 apenas para as intru??es que escrevem na memoria. As unicas
         //instru??es que escrevem na memoria s?o do tipo S
         memWrite=0;
         //inst_type indica o tipo de instu??es enviado ao bloco Alu_op. Seu valor ? 2b'00 para as instu??es
         //tipo I e tipo R, enquanto que o seu valor ? 2b'01 para as instru??es tipo Branch e enqautno ? 2b'11 
         //para as demais
         inst_type=2'b11;
         //esse sinal ? igual a 1 para as instru??es tipo R e 0 para as demais.
         IR=0;
         //este sinal ? igual a 1 se a saida da memoria for escolhida para propagar, caso 0, ele vai fazer
         //propagar a saida da ALU. Apenas as isntu??es do tipo L(load) fazem com que a saida da memoria propaguem
         //para o registrador
         dt_1_sel=0;
         //caso este sinal seja igual a 0, ele vai propagar o sinal que sai de dt_1_sel. Caso seja 1, ele vai propagar
         //a constante que esta no sinal imm. Apenas as instu??es tipo I, JAL e JALR fazem com que o sinal imm propaguem
         dt_2_sel=0;
         //caso este sinal seja 0, ele vai fazer propagar a saida de dt_2_sel. Caso seja 1, ele vai propagar o resultado
         //de uma isntu??o tipo csr. Este cinal ? apenas 1 para sinais do tipo csr.
         dt_3_sel=0;  
       end
      endcase
    end
  
endmodule