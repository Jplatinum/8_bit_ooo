module CPU (
   input         clk,
   input         rst_n,
   output        hlt,
   output [7:0]  pc
);

   logic [7:0] pc_inc;
   logic [7:0] PC_out;
   logic [7:0] instr_FD;

   fetch fetch0 (
   	.clk(clk),
      .rst_n(rst_n),
      .pc(PC_out),
      .pc_out(pc_inc),
      .instr_out(instr_FD)
   );		

   logic [7:0] read_data_1;
   logic [7:0] read_data_2;
   logic MemtoReg;
   logic PCSrc;
   logic MemWrite;
   logic MemRead;
   logic [7:0] write_back_data;
   logic [7:0] instr_DE;

   decode decode0 (
      .clk(clk),
      .rst_n(rst_n),
      .instr(instr_FD),
      .write_back_data(write_back_data),
      .read_data_1_out(read_data_1),
      .read_data_2_out(read_data_2),
      .MemtoReg_out(MemtoReg),
      .PCSrc_out(PCSrc),
      .MemWrite_out(MemWrite),
      .MemRead_out(MemRead),
      .instr_out(instr_DE)
   );

   logic [7:0] pc_ALU;
   logic [7:0] alu_result_EM;
   logic [7:0] write_data;

   execute execute0 (
      .clk(clk),
      .rst_n(rst_n),
      .instr(instr_DE),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2),
      .pc_ALU_out(pc_ALU),
      .alu_result_out(alu_result_EM),
      .write_data_out(write_data) 
   );

   logic [7:0] read_data;
   logic [7:0] alu_result_MW;

   memory memory0 (
      .clk(clk),
      .rst_n(rst_n),
      .pc_inc(pc_inc),   
      .pc_ALU(pc_ALU),       
      .address(alu_result_EM),  
      .write_data(write_data),   
      .PCSrc(PCSrc),        
      .MemWrite(MemWrite),     
      .MemRead(MemRead),     
      .PC_out(PC_out),     
      .read_data(read_data),
      .alu_result_out(alu_result_MW)
   );

   writeback writeback0 (
      .clk(clk),
      .rst_n(rst_n),
      .instr(instr_DE),
      .mem_data(read_data),
      .alu_data(alu_result_MW),
      .MemtoReg(MemtoReg),
      .wb_data(write_back_data),
      .hlt(hlt)
   );


   // assign hlt = instr_FD[7:6] == 2'b11 ? 1'b1 : 1'b0;
   assign pc = PC_out;

endmodule