module uart_top_test (
    input wire clk_50,
    input wire rst,
    output wire [6:0] leds1,
    output wire [6:0] leds2,
    output wire err1,
    output wire err2
);

    // اتصال داخلی بین فرستنده و گیرنده
    wire tx1, tx2;

    // ---------- Transmitter 1 ----------
    reg [6:0] tx1_data = 7'h41;  // 'A'
    reg tx1_start = 0;
    wire tx1_busy;

    uart_tx tx1_inst (
        .clk(clk_50),
        .rst(rst),
        .start(tx1_start),
        .data(tx1_data),
        .tx(tx1),
        .busy(tx1_busy)
    );

    // ---------- Transmitter 2 ----------
    reg [6:0] tx2_data = 7'h42;  // 'B'
    reg tx2_start = 0;
    wire tx2_busy;

    uart_tx tx2_inst (
        .clk(clk_50),
        .rst(rst),
        .start(tx2_start),
        .data(tx2_data),
        .tx(tx2),
        .busy(tx2_busy)
    );

    // ---------- Receiver 1 ----------
    wire [6:0] rx1_data;
    wire rx1_ready;
    wire rx1_error;

    uart_rx rx1_inst (
        .clk(clk_50),
        .rst(rst),
        .rx(tx1),  // اتصال به خروجی TX1
        .data_out(rx1_data),
        .ready(rx1_ready),
        .error(rx1_error)
    );

    // ---------- Receiver 2 ----------
    wire [6:0] rx2_data;
    wire rx2_ready;
    wire rx2_error;

    uart_rx rx2_inst (
        .clk(clk_50),
        .rst(rst),
        .rx(tx2),  // اتصال به خروجی TX2
        .data_out(rx2_data),
        .ready(rx2_ready),
        .error(rx2_error)
    );

    // ارسال یک‌باره از هر TX
    reg [2:0] counter = 0;
    always @(posedge clk_50) begin
        counter <= counter + 1;
        if (counter == 3'd1) tx1_start <= 1;
        else tx1_start <= 0;

        if (counter == 3'd3) tx2_start <= 1;
        else tx2_start <= 0;
    end

    assign leds1 = rx1_data;
    assign leds2 = rx2_data;
    assign err1 = rx1_error;
    assign err2 = rx2_error;

endmodule
