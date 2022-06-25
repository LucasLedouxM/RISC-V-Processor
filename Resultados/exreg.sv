
module exreg #(
	parameter WORD_WIDTH = 32
	)(
	//input logic [WORD_WIDTH-1:0] pc_in,
	input logic clk,
	input logic rstn,
    input logic memRead,
    output logic memRead_ex,
    input logic memWrite,
    output logic memWrite_ex,
    input logic bctrl,
    output logic bctrl_ex,
    input logic [WORD_WIDTH-1:0] rd_data1,
    input logic [WORD_WIDTH-1:0] rd_data2, 
    output logic [WORD_WIDTH-1:0] rd_data1_ex,
    output logic [WORD_WIDTH-1:0] rd_data2_ex, 
    input logic  alu_in_sel,
    output logic alu_in_sel_ex,
    input logic  csr_ctrl,
    output logic  csr_ctrl_ex,
    input logic [WORD_WIDTH-1:0] imm,
    output logic [WORD_WIDTH-1:0] imm_ex,
    input logic dt_1_sel,
    input logic dt_2_sel,
    input logic dt_3_sel,
    output logic dt_1_sel_ex,
    output logic dt_2_sel_ex,
    output logic dt_3_sel_ex,
    input logic [2:0] funct,
    output logic [2:0] funct_ex,
    input logic [0:4] alu_op,
    output logic [0:4] alu_op_ex,
    input logic regWr,
    output logic regWr_ex,
    input logic [4:0] wr,
    output logic [4:0] wr_ex
	);

	always @(posedge clk or negedge rstn)
	begin
		if(~rstn)
          begin
           memRead_ex  <='b0;
           memWrite_ex <='b0;
           rd_data1_ex <='b0;
           rd_data2_ex <='b0;
           alu_in_sel_ex <='b0;
           csr_ctrl_ex <='b0;
           imm_ex <='b0;
           dt_1_sel_ex <='b0;
           dt_2_sel_ex <='b0;
           dt_3_sel_ex <='b0;
           alu_op_ex <='b0;
           funct_ex <='b0;
           regWr_ex <='b0;
           wr_ex <='b0;
           bctrl_ex <='b0;
          end
		else if(clk)
          begin
           memRead_ex<=memRead;
           memWrite_ex<=memWrite;
           rd_data1_ex <= rd_data1;
           rd_data2_ex <= rd_data2;
           alu_in_sel_ex <= alu_in_sel;
           csr_ctrl_ex <= csr_ctrl;
           imm_ex <=imm;
           dt_1_sel_ex <= dt_1_sel;
           dt_2_sel_ex <= dt_2_sel;
           dt_3_sel_ex <= dt_3_sel;  
           alu_op_ex <= alu_op; 
           funct_ex <= funct;
           regWr_ex <= regWr;
           wr_ex <= wr;
           bctrl_ex <=bctrl;
          end
	end 

endmodule // pc