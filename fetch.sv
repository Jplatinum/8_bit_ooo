// module fetch (
//     input  logic       clk,
//     input  logic       rst_n,
//     input  logic [7:0] pc,
//     output logic [7:0] pc_out,
//     output logic [7:0] instr
// );

//     always_ff @(posedge clk or negedge rst_n) begin
//         if (~rst_n)
//             pc_out <= 8'd0;
//         else
//             pc_out <= pc + 8'd1;
//     end

//     mem imem (
//         .addr(pc_out),
//         .data_out(instr),
//         .data_in(8'h00), 
//         .enable(1'b1),   
//         .wr(1'b0),         
//         .clk(clk),
//         .rst(~rst_n)    
//     );

// endmodule

module fetch (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] pc,
    output logic [7:0] pc_out,
    output logic [7:0] instr_out
);

    logic [7:0] instr_mem;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_out <= 8'd0;
            instr_out <= 8'd0;
        end else begin
            pc_out <= pc + 8'd1;
            instr_out <= instr_mem;
        end
    end

    mem imem (
        .addr(pc_out),
        .data_out(instr_mem),
        .data_in(8'h00), 
        .enable(1'b1),   
        .wr(1'b0),         
        .clk(clk),
        .rst(~rst_n)    
    );

endmodule
