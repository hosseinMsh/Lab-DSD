module uart_tx (
    input wire clk,
    input wire rst,
    input wire start,             // فعال‌سازی ارسال
    input wire [6:0] data,        // داده ASCII
    output reg tx,                // خروجی TX
    output reg busy               // نشان‌دهنده در حال ارسال بودن
);
    reg [9:0] shift_reg;
    reg [3:0] bit_cnt;
    reg [15:0] clk_cnt;

    parameter CLK_PER_BIT = 434;  // 50_000_000 / 115200 ≈ 434

    function parity_bit;
        input [6:0] d;
        parity_bit = ^d; // XOR تمام بیت‌ها (even parity)
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            busy <= 0;
            bit_cnt <= 0;
            clk_cnt <= 0;
        end else if (start && !busy) begin
            // تشکیل فریم UART
            shift_reg <= {1'b1, parity_bit(data), data, 1'b0}; // Stop, Parity, Data, Start
            busy <= 1;
            bit_cnt <= 0;
            clk_cnt <= 0;
        end else if (busy) begin
            if (clk_cnt == CLK_PER_BIT - 1) begin
                clk_cnt <= 0;
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 9) busy <= 0;
            end else clk_cnt <= clk_cnt + 1;
        end
    end
endmodule
