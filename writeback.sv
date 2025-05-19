module writeback (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  instr,
    input  logic [7:0]  mem_data,
    input  logic [7:0]  alu_data,
    input  logic        MemtoReg,
    output logic [7:0]  wb_data,
    output logic        hlt 
);

    logic memtoreg_stage1;
    logic memtoreg_stage2;

    logic [7:0] instr_stage1;
    logic [7:0] instr_stage2;
    logic [7:0] instr_stage3;

    // Two-stage flop for MemtoReg
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            memtoreg_stage1 <= 1'b0;
            memtoreg_stage2 <= 1'b0;
        end else begin
            memtoreg_stage1 <= MemtoReg;
            memtoreg_stage2 <= memtoreg_stage1;
        end
    end

    // Two-stage flop for instr
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instr_stage1 <= 8'd0;
            instr_stage2 <= 8'd0;
            instr_stage3 <= 8'd0;
        end else begin
            instr_stage1 <= instr;
            instr_stage2 <= instr_stage1;
            instr_stage3 <= instr_stage2;
        end
    end

    assign wb_data = memtoreg_stage2 ? mem_data : alu_data;
    assign hlt     = (instr_stage3[7:6] == 2'b11) ? 1'b1 : 1'b0;

endmodule
