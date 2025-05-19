module memory (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  pc_inc,         // PC + 1 (from fetch)
    input  logic [7:0]  pc_ALU,         // ALU result (from execute)
    input  logic [7:0]  address,        // Effective memory address
    input  logic [7:0]  write_data,     // Data to be written
    input  logic        PCSrc,          // Select PC source
    input  logic        MemWrite,       // Memory write enable
    input  logic        MemRead,        // Memory read enable
    output logic [7:0]  PC_out,         // Pipelined PC (after two flops)
    output logic [7:0]  read_data,      // Memory read data (pipelined)
    output logic [7:0]  alu_result_out  // Forwarded ALU result (pipelined)
);

    logic [7:0] next_PC;
    logic [7:0] mem_read_data;

    // Two-stage pipeline for pc_inc
    logic [7:0] pc_inc_stage1;
    logic [7:0] pc_inc_stage2;

    // One-stage pipeline for control signals
    logic PCSrc_reg;
    logic MemWrite_reg;
    logic MemRead_reg;

    assign next_PC = PCSrc_reg ? pc_ALU : pc_inc_stage2;

    // Memory instance
    mem #(.LOAD_FROM_FILE(0)) data_memory (
        .addr(address),
        .data_out(mem_read_data),
        .data_in(write_data), 
        .enable(1'b1),
        .wr(MemWrite_reg),
        .clk(clk),
        .rst(~rst_n)
    );

    // Pipeline flops for pc_inc
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_inc_stage1 <= 8'd0;
            pc_inc_stage2 <= 8'd0;
        end else begin
            pc_inc_stage1 <= pc_inc;
            pc_inc_stage2 <= pc_inc_stage1;
        end
    end

    // Pipeline flops for control signals
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PCSrc_reg     <= 1'b0;
            MemWrite_reg  <= 1'b0;
            MemRead_reg   <= 1'b0;
        end else begin
            PCSrc_reg     <= PCSrc;
            MemWrite_reg  <= MemWrite;
            MemRead_reg   <= MemRead;
        end
    end

    // Pipeline flops for outputs
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC_out         <= 8'd0;
            read_data      <= 8'd0;
            alu_result_out <= 8'd0;
        end else begin
            PC_out         <= next_PC;
            read_data      <= mem_read_data;
            alu_result_out <= address;
        end
    end

endmodule
