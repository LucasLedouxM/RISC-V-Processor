// Code your testbench here
// or browse Examples
// Testbench
module test;
  bit clk;
  bit rstn;
  int i,aux;
  bit simGood;
  
  logic [31:0] instr_addr;
  logic [31:0] instr;
  
  top tp
  ( .clk,
    .rstn,
    .instr_addr,
    .instr
  );
  
  //rst
  initial begin
    rstn = 1;
    #1;
    rstn = 0;
    #3;
    rstn = 1;
  end
  
  
  //clk
  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end
    
  
  // instructions
    always_comb 
    begin
      case(instr_addr)
        //addi x15,x0,100    x[15] = 170
        32'h00000000:instr=32'b000010101010_00000_000_01111_0010011;
        //addi x14,x0,25     x[14] = 85            
        32'h00000004:instr=32'b000001010101_00000_000_01110_0010011; 
        //addi x1,x0,1       x[1] = 1            
        32'h00000008:instr=32'b000000000001_00000_000_00001_0010011; 
        //add x12,x14,x15    x[12] = 255
        32'h0000000C:instr=32'b0000000_01111_01110_000_01100_0110011;
        //and x10,x15,x14    x[10] = 0
        32'h00000010:instr=32'b0000000_01110_01111_111_01010_0110011;
        //or  x11,x14,x15    x[11] = 255
        32'h00000014:instr=32'b0000000_01111_01110_110_01011_0110011;
        //sub x10,x11,x14    x[10] = 170 
        32'h00000018:instr=32'b0100000_01110_01011_000_01010_0110011;
        //xor x14,x14,x1     x[14] = 84
        32'h0000001C:instr=32'b0000000_01110_00001_100_01110_0110011;
        //addi x15,x0,10    x[15] = 10
        32'h00000020:instr=32'b000000001010_00000_000_01111_0010011;
        //addi x14,x0,25     x[14] = 4            
        32'h00000024:instr=32'b000000000100_00000_000_01110_0010011;
        //sll x10,x15,x14    x[10] = 160 
        32'h00000028:instr=32'b0000000_01110_01111_001_01010_0110011;
        //srl x10,x10,x14    x[10] = 10 
        32'h0000002C:instr=32'b0000000_01110_01010_101_01010_0110011;
        //lui x15,4095       x[15] = -4096  
        32'h00000030:instr=32'b11111111111111111111_01111_0110111;
        //srl x20,x15,x14   
        32'h00000034:instr=32'b0000000_01110_01111_101_10100_0110011;
        //sra x21,x15,x14
        32'h00000038:instr=32'b0100000_01110_01111_101_10101_0110011;
        //slt x26,x15,x14    x[26] = 1  
        32'h0000003C:instr=32'b0000000_01110_01111_010_11010_0110011;
        //sltu x26,x15,x14   x[26] = 0   
        32'h00000040:instr=32'b0000000_01110_01111_011_11010_0110011;
        //sltu x26,x14,x15   x[26] = 1   
        32'h00000044:instr=32'b0000000_01111_01110_011_11010_0110011;
        //mul x26,x14,x14    x[26] = 16  
        32'h00000048:instr=32'b0000001_01110_01110_000_11010_0110011;
        //addi x26,x26,4     x[26] = 20            
        32'h0000004C:instr=32'b000000000100_11010_000_11010_0010011; 
        //addi x14,x14,4       x[4] = 8            
        32'h00000050:instr=32'b000000000100_01110_000_01110_0010011; 
        //rem x26,x26,x14    x[26] = 4  
        32'h00000054:instr=32'b0000001_01110_11010_110_11010_0110011;
        default:instr=32'h00000000;
        endcase
    end 
    
      
  //test check

      
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    simGood=1;
    @(posedge clk)
    @(posedge clk)
    check(15,170);
    check(14,85);
    check(1,1);
    check(12,255);
    check(10,0);
    check(11,255);
    check(10,170);
    check(14,84);
    check(15,10);
    check(14,4);
    check(10,160);
    check(10,10);
    check(15,-4096);
    @(posedge clk) 
    #1
    $display("reg[%2d] = %b",15,aux);
    aux = test.tp.cpu.reg_bk.registers[20];
    $display("reg[%2d] = %b",20,aux);
    @(posedge clk)
    #1
    aux = test.tp.cpu.reg_bk.registers[21];
    $display("reg[%2d] = %b",21,aux);
    
    check(26,1);
    check(26,0);
    check(26,1);
    check(26,16);
    check(26,20);
    check(14,8);
    check(26,4);
    
    
    if(simGood)
      $display("TEST PASS");
    else
      $display("TEST FAIL");
    $stop;

   
  end
  
  task check(input int i,input int expc);
    @(posedge clk)
    #1
    aux = test.tp.cpu.reg_bk.registers[i];
    $display("reg[%2d] = %2d",i,aux);
    if(aux == expc)
      begin
      $display("good value for reg %2d",i);
        simGood=simGood&1;
      end
    else
      begin
       $error("wrong value for reg %2d",i);
       simGood=0;
      end  
  endtask
  
endmodule