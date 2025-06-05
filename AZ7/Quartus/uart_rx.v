module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [6:0] data_out,
    output reg ready,
    output reg error
);
    parameter CLK_PER_BIT = 434;

    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;
    reg [15:0] clk_cnt;
    reg receiving;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            receiving <= 0;
            bit_cnt <= 0;
            clk_cnt <= 0;
            ready <= 0;
            error <= 0;
        end else begin
            ready <= 0;
            if (!receiving && rx == 0) begin
                receiving <= 1;
                clk_cnt <= CLK_PER_BIT / 2;
                bit_cnt <= 0;
            end else if (receiving) begin
                if (clk_cnt == CLK_PER_BIT - 1) begin
                    clk_cnt <= 0;
                    shift_reg <= {rx, shift_reg[9:1]};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 10) begin
                        receiving <= 0;
                        data_out <= shift_reg[7:1];
                        error <= (^shift_reg[7:1] != shift_reg[8]); // Parity check
                        ready <= 1;
                    end
                end else clk_cnt <= clk_cnt + 1;
            end
        end
    end
endmodule
