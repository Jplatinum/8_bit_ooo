module CPU (
   input         clk,
   input         rst_n,
   output        hlt,
   output [7:0]  pc
);

   logic [7:0] pc_inc;
   logic [7:0] instr;

   fetch fetch0 (
   	.clk(clk),
      .rst_n(rst_n),
      .pc(pc_inc),
      .pc_out(pc_inc),
      .instr(instr)
   );		

   assign hlt = instr[7:6] == 2'b11 ? 1'b1 : 1'b0;
   assign pc = pc_inc;

endmodule