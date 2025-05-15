module writeback (
	input  logic 	   clk,
	input  logic       rst_n,
	input  logic [7:0] mem_data,
	input  logic [7:0] alu_data,
	input  logic       MemtoReg,
	output logic [7:0] wb_data
);

	assign wb_data = MemtoReg ? mem_data : alu_data;

endmodule
