module CPU (
   input         clk,
   input         rst_n,
   output        hlt,
   output [7:0]  pc
);

   logic [7:0] pc_inc;
   logic [7:0] PC_out;
   logic [7:0] instr;

   fetch fetch0 (
   	.clk(clk),
      .rst_n(rst_n),
      .pc(PC_out),
      .pc_out(pc_inc),
      .instr(instr)
   );		

   logic [7:0] read_data_1;
   logic [7:0] read_data_2;
   logic MemtoReg;
   logic PCSrc;
   logic MemWrite;
   logic MemRead;
   logic [7:0] write_back_data;

   decode decode0 (
      .clk(clk),
      .rst_n(rst_n),
      .instr(instr),
      .write_back_data(write_back_data),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2),
      .MemtoReg(MemtoReg),
      .PCSrc(PCSrc),
      .MemWrite(MemWrite),
      .MemRead(MemRead)
   );

   logic [7:0] pc_ALU;
   logic [7:0] alu_result;
   logic [7:0] write_data;

   execute execute0 (
      .clk(clk),
      .rst_n(rst_n),
      .instr(instr),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2),
      .pc_ALU(pc_ALU),
      .alu_result(alu_result),
      .write_data(write_data) 
   );

   logic [7:0] read_data;

   memory memory0 (
      .clk(clk),
      .rst_n(rst_n),
      .pc_inc(pc_inc),   
      .pc_ALU(pc_ALU),       
      .address(alu_result),  
      .write_data(write_data),   
      .PCSrc(PCSrc),        
      .MemWrite(MemWrite),     
      .MemRead(MemRead),     
      .PC_out(PC_out),     
      .read_data(read_data)  
   );

   writeback writeback0 (
      .clk(clk),
      .rst_n(rst_n),
      .mem_data(read_data),
      .alu_data(alu_result),
      .MemtoReg(MemtoReg),
      .wb_data(write_back_data)
   );


   assign hlt = instr[7:6] == 2'b11 ? 1'b1 : 1'b0;
   assign pc = PC_out;

endmodule