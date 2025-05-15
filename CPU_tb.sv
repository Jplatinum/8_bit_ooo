module cpu_tb;

   logic clk;
   logic rst_n;
   wire hlt;
   wire [7:0] pc;

   CPU cpu0 (
      .clk(clk),
      .rst_n(rst_n),
      .hlt(hlt),
      .pc(pc)
   );

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      rst_n = 0;

      repeat (2) @(negedge clk);
      rst_n = 1;

      wait (hlt == 1);

      repeat (1) @(posedge clk);

      $display("CPU halted at PC = %0d", pc);
      $stop;
   end

   initial begin
      $monitor("Time: %0t | PC: %0d | HLT: %b", $time, pc, hlt);
   end

endmodule

