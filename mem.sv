//////////////////////////////////////
//
// Memory -- single cycle version (8-bit)
// Written for 8-bit single-cycle processor
//
// Byte-addressable
// 8-bit data width
// Reads are combinational (zero delay)
// Writes occur on rising edge of clock
// No concurrent read & write
//
// Loads from file "loadfile_8bit.img" on reset
//
//////////////////////////////////////

module mem #(
    parameter LOAD_FROM_FILE = 1
)(
    output [7:0] data_out,
    input  [7:0] data_in,
    input  [7:0] addr,       // 8-bit address space => 256 bytes
    input        enable,
    input        wr,
    input        clk,
    input        rst
);

    parameter MEM_SIZE = 256;
    reg [7:0] mem [0:MEM_SIZE-1];
    reg       loaded;

    // Combinational Read
    assign data_out = (enable & ~wr) ? mem[addr] : 8'b0;

    initial begin
        loaded = 0;
    end

    // Write and Reset Behavior
    always @(posedge clk) begin
        if (rst) begin
            if (!loaded && LOAD_FROM_FILE) begin
                $readmemh("piptest.txt", mem);
                loaded = 1;
            end
        end else begin
            if (enable & wr) begin
                mem[addr] <= data_in;
            end
        end
    end

endmodule

