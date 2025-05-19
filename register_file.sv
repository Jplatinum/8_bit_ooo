// module register_file (
//     input  logic        clk,
//     input  logic        rst_n,
//     input  logic [1:0]  read_register_1,
//     input  logic [1:0]  read_register_2,
//     input  logic [1:0]  write_register,
//     input  logic [7:0]  write_data,
//     input  logic        reg_write_enable,

//     output logic [7:0]  read_data_1,
//     output logic [7:0]  read_data_2
// );

//     // 8 general-purpose 8-bit registers
//     logic [7:0] registers [0:3];

//     // Read logic (combinational)
//     assign read_data_1 = registers[read_register_1];
//     assign read_data_2 = registers[read_register_2];

//     always_ff @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             // Clear all registers on reset
//             for (int i = 0; i < 4; i++) begin
//                 registers[i] <= 8'b0;
//             end
//         end else if (reg_write_enable) begin
//             registers[write_register] <= write_data;
//         end
//     end

// endmodule

module register_file (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [1:0]  read_register_1,
    input  logic [1:0]  read_register_2,
    input  logic [1:0]  write_register,
    input  logic [7:0]  write_data,
    input  logic        reg_write_enable,

    output logic [7:0]  read_data_1,
    output logic [7:0]  read_data_2
);

    logic [7:0] registers [0:3];

    // Bypass logic for read port 1
    always_comb begin
        if (reg_write_enable && (read_register_1 == write_register))
            read_data_1 = write_data;  // Bypassed value
        else
            read_data_1 = registers[read_register_1];
    end

    // Bypass logic for read port 2
    always_comb begin
        if (reg_write_enable && (read_register_2 == write_register))
            read_data_2 = write_data;  // Bypassed value
        else
            read_data_2 = registers[read_register_2];
    end

    // Synchronous register write with reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 4; i++) begin
                registers[i] <= 8'b0;
            end
        end else if (reg_write_enable) begin
            registers[write_register] <= write_data;
        end
    end

endmodule
