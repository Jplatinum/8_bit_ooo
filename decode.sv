module decode (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  instr,
    input  logic [7:0]  write_back_data,

    output logic [7:0]  read_data_1_out,
    output logic [7:0]  read_data_2_out,
    output logic        MemtoReg_out,
    output logic        PCSrc_out,
    output logic        MemWrite_out,
    output logic        MemRead_out,
    output logic [7:0]  instr_out
);

    // Internal wires
    logic [1:0] opcode;
    logic [1:0] rs;
    logic [1:0] rt;
    logic [1:0] imm_or_funct;

    logic [7:0] read_data_1;
    logic [7:0] read_data_2;

    logic MemtoReg;
    logic MemWrite;
    logic MemRead;
    logic PCSrc;

    // Decode instruction fields
    assign opcode         = instr[7:6];
    assign rs             = instr[5:4];
    assign rt             = instr[3:2];
    assign imm_or_funct   = instr[1:0];

    // Control logic
    assign MemtoReg  = (opcode == 2'b01) && (rs == 2'b01); // LD
    assign MemWrite  = (opcode == 2'b01) && (rs == 2'b10); // ST
    assign MemRead   = (opcode == 2'b01) && (rs == 2'b01); // LD
    assign PCSrc     = (opcode == 2'b10);                  // JMP

    // Register file
    register_file reg_file0 (
        .clk(clk),
        .rst_n(rst_n),
        .read_register_1(rs),
        .read_register_2(rt),
        .write_register(rt),  // May need to change for WB stage support
        .write_data(write_back_data),
        .reg_write_enable((opcode == 2'b00) || 
                          ((opcode == 2'b01) && (rs == 2'b00)) ||  // ADDI
                          ((opcode == 2'b01) && (rs == 2'b01)) ||  // LD
                          ((opcode == 2'b01) && (rs == 2'b11))),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Flop all outputs for pipelining
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_1_out <= 8'd0;
            read_data_2_out <= 8'd0;
            MemtoReg_out    <= 1'b0;
            PCSrc_out       <= 1'b0;
            MemWrite_out    <= 1'b0;
            MemRead_out     <= 1'b0;
            instr_out       <= 8'b0;
        end else begin
            read_data_1_out <= read_data_1;
            read_data_2_out <= read_data_2;
            MemtoReg_out    <= MemtoReg;
            PCSrc_out       <= PCSrc;
            MemWrite_out    <= MemWrite;
            MemRead_out     <= MemRead;
            instr_out       <= instr;
        end
    end

endmodule
