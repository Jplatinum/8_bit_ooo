module memory (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  pc_inc,       // PC + 1
    input  logic [7:0]  pc_ALU,       // ALU result
    input  logic [7:0]  address,      // Memory address
    input  logic [7:0]  write_data,   // Data to be written
    input  logic        PCSrc,        // Select between PC + 1 and ALU result
    input  logic        MemWrite,     // Write enable
    input  logic        MemRead,      // Read enable (optional in this case)
    output logic [7:0]  PC_out,       // Updated PC
    output logic [7:0]  read_data     // Data read from memory
);

    assign PC_out = PCSrc ? pc_ALU : pc_inc;

    mem #(.LOAD_FROM_FILE(0)) data_memory (
        .addr(address),
        .data_out(read_data),
        .data_in(write_data), 
        .enable(1'b1),        
        .wr(MemWrite),         
        .clk(clk),
        .rst(~rst_n)         
    );

endmodule
