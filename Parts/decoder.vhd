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
   output logic imm,
   output logic [2:0]funct,
   output logic [31:0]memWrite,
   output logic [1:0] inst_type,
   output logic R,
   output logic [1:0]SM,
   output logic dt_1_sel,
   output logic dt_2_sel,
   output logic dt_3_sel   
  );
  
  assign rd1=instr[19:15];
  assign  rd2=instr[24:20];
  assign wr=instr[11:7];
  assign funct=instr[14:12];
  assign SM[1]=instr[30];
  assign SM[0]=instr[25];
  
  always_comb
    begin
      case(instr[6:0])
      //LUI
          6'b0110111:
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
         R=0;
         dt_1_sel=1;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //AUIPC
      6'b0010111:
       begin
         ctrpc=2'b10;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out+instr[31:20]<<12;
         memWrite=0;
         inst_type=2'b00;
         R=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //JAL
          6'b1101111:
       begin
         ctrpc=2'b10;
         pc_next=pc_out+{instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out;
         memWrite=0;
         inst_type=2'b00;
         R=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end
      //JALR
     6'b1100111:
       begin
         ctrpc=2'b11;
         pc_next=instr[31:20];
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out+4;
         memWrite=0;
         inst_type=2'b00;
         R=0;
         dt_1_sel=0;
         dt_2_sel=1;
         dt_3_sel=0;  
       end        
      //BRANCH
         6'b1100011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=1;
         memRead=0;
         regWr=0;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=pc_out+{instr[31],instr[7],instr[25:20],instr[11:8],1'b0};
         memWrite=0;
         inst_type=2'b01;
         R=0;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //LOAD
         6'b0000011:
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
         R=0;
         dt_1_sel=1;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //STORE
        6'b0100011:
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
         R=0;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //I
       6'b0010011:
       begin
         ctrpc=0;
         pc_next=pc_out+4;
         bctrl=0;
         memRead=0;
         regWr=1;
         alu_in_sel=0;
         csr_ctrl=0;
         imm=instr[31:20];
         memWrite=0;
         inst_type=2'b00;
         R=1;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //R
       6'b0110011:
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
         R=1;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=0;  
       end
      //CSR
       6'b1110011:
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
         inst_type=2'b00;
         R=1;
         dt_1_sel=0;
         dt_2_sel=0;
         dt_3_sel=1;  
       end
      endcase
    end
  
endmodule
