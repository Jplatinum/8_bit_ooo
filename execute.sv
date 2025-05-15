module execute (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  instr,
    input  logic [7:0]  read_data_1,
    input  logic [7:0]  read_data_2,
    output logic [7:0]  pc_ALU,
    output logic [7:0]  alu_result,
    output logic [7:0]  write_data  // Only used for store
);

    // Instruction decoding fields
    logic [1:0] opcode;
    logic [1:0] rs;
    logic [1:0] rt;
    logic [1:0] funct;
    logic [1:0] imm;
    logic [5:0] jmp_addr;

    assign opcode   = instr[7:6];
    assign rs       = instr[5:4];
    assign rt       = instr[3:2];
    assign funct    = instr[1:0];     // R-type
    assign imm      = instr[1:0];     // I-type
    assign jmp_addr = instr[5:0];     // J-type

    always_comb begin
        alu_result = 8'b0;
        pc_ALU     = 8'b0;
        write_data = 8'b0;

        case (opcode)
            2'b00: begin // R-type: rt = rs op rt
                case (funct)
                    2'b00: alu_result = read_data_1 + read_data_2; // ADD
                    2'b01: alu_result = read_data_1 - read_data_2; // SUB
                    2'b10: alu_result = read_data_1 & read_data_2; // AND
                    2'b11: alu_result = read_data_1 | read_data_2; // OR
                endcase
            end

            2'b01: begin // I-type
                case (rs)
                    2'b00: begin // ADDI: rt = rs + imm
                        alu_result = read_data_1 + imm;
                    end
                    2'b01: begin // LD: rt = MEM[rs + imm]
                        alu_result = read_data_1 + imm;
                    end
                    2'b10: begin // ST: MEM[rs + imm] = rt
                        alu_result = read_data_1 + imm; // Effective addr
                        write_data = read_data_2;       // Data to store
                    end
                    2'b11: begin // CMP: if rs == rt
                        alu_result = (read_data_1 == read_data_2) ? 8'd1 : 8'd0;
                        // No write_data for CMP yet
                    end
                endcase
            end

            2'b10: begin // J-type
                pc_ALU = {2'b00, jmp_addr};
            end

            2'b11: begin // HALT
                // No action taken in execute stage
            end
        endcase
    end

endmodule
