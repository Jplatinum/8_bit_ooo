module decode (
	input  logic        clk,
	input  logic        rst_n,
	input  logic [7:0]  instr,
	input  logic [7:0]  write_back_data,

	output logic [7:0]  read_data_1,
	output logic [7:0]  read_data_2,
	output logic        MemtoReg,
	output logic        PCSrc,
	output logic        MemWrite,
	output logic        MemRead
);

	// Extract instruction fields
	logic [1:0] opcode;
	logic [1:0] rs;
	logic [1:0] rt;
	logic [1:0] imm_or_funct;

	assign opcode         = instr[7:6];
	assign rs             = instr[5:4];
	assign rt             = instr[3:2];
	assign imm_or_funct   = instr[1:0]; // Used in ALU or mem address calc

	// Control signal logic
	assign MemtoReg  = (opcode == 2'b01) && (rs == 2'b01); // LD
	assign MemWrite  = (opcode == 2'b01) && (rs == 2'b10); // ST
	assign MemRead   = (opcode == 2'b01) && (rs == 2'b01); // LD
	assign PCSrc     = (opcode == 2'b10);                  // JMP

	// Register file instantiation
	register_file reg_file0 (
	    .clk(clk),
	    .rst_n(rst_n),
	    .read_register_1(rs),
	    .read_register_2(rt),
	    .write_register(rt),           // You may change this if WB stage needs a different dest
	    .write_data(write_back_data),
	    .reg_write_enable((opcode == 2'b00) ||            // R-type
	                      ((opcode == 2'b01) && (rs == 2'b00)) ||  // ADDI
	                      ((opcode == 2'b01) && (rs == 2'b01))     // LD
	                     ),
	    .read_data_1(read_data_1),
	    .read_data_2(read_data_2)
	);

endmodule
