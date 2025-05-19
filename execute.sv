module execute (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  instr,
    input  logic [7:0]  read_data_1,
    input  logic [7:0]  read_data_2,

    output logic [7:0]  pc_ALU_out,
    output logic [7:0]  alu_result_out,
    output logic [7:0]  write_data_out
);

    // Decode instruction fields
    logic [1:0] opcode;
    logic [1:0] rs;
    logic [1:0] rt;
    logic [1:0] funct;
    logic [1:0] imm;
    logic [5:0] jmp_addr;

    assign opcode   = instr[7:6];
    assign rs       = instr[5:4];
    assign rt       = instr[3:2];
    assign funct    = instr[1:0];
    assign imm      = instr[1:0];
    assign jmp_addr = instr[5:0];

    // Combinational results
    logic [7:0] alu_result;
    logic [7:0] pc_ALU;
    logic [7:0] write_data;

    always_comb begin
        alu_result = 8'b0;
        pc_ALU     = 8'b0;
        write_data = 8'b0;

        case (opcode)
            2'b00: begin // R-type
                case (funct)
                    2'b00: alu_result = read_data_1 + read_data_2;
                    2'b01: alu_result = read_data_1 - read_data_2;
                    2'b10: alu_result = read_data_1 & read_data_2;
                    2'b11: alu_result = read_data_1 | read_data_2;
                endcase
            end

            2'b01: begin // I-type
                case (rs)
                    2'b00: alu_result = read_data_1 + imm;            // ADDI
                    2'b01: alu_result = read_data_1 + imm;            // LD
                    2'b10: begin                                       // ST
                        alu_result = read_data_1 + imm;
                        write_data = read_data_2;
                    end
                    2'b11: alu_result = (read_data_1 == read_data_2) ? 8'hFF : 8'h00; // CMP
                endcase
            end

            2'b10: begin // JMP
                pc_ALU = {2'b00, jmp_addr};
            end

            2'b11: begin
                // HALT — do nothing
            end
        endcase
    end

    // Pipeline register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_result_out <= 8'd0;
            pc_ALU_out     <= 8'd0;
            write_data_out <= 8'd0;
        end else begin
            alu_result_out <= alu_result;
            pc_ALU_out     <= pc_ALU;
            write_data_out <= write_data;
        end
    end

endmodule
