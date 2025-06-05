module uart_top (
    input wire clk_50,           // ساعت 50MHz
    input wire rst,              // ریست
    input wire btn_send,         // دکمه ارسال
    input wire [6:0] sw_data,    // ورودی داده از سوئیچ‌ها
    input wire rx,               // پین دریافت (از بیرون یا فرستنده)
    output wire tx,              // پین ارسال (به بیرون)
    output wire [6:0] leds,      // داده دریافتی
    output wire led_error        // خطای Parity
);

    // هم‌زمان‌سازی دکمه
    reg [2:0] btn_sync = 0;
    always @(posedge clk_50)
        btn_sync <= {btn_sync[1:0], btn_send};

    wire btn_rise = (btn_sync[2:1] == 2'b01);

    // ماژول فرستنده
    reg start_tx = 0;
    reg [6:0] tx_data = 0;
    wire tx_busy;

    uart_tx tx_inst (
        .clk(clk_50),
        .rst(rst),
        .start(start_tx),
        .data(tx_data),
        .tx(tx),
        .busy(tx_busy)
    );

    always @(posedge clk_50) begin
        start_tx <= 0;
        if (btn_rise && !tx_busy) begin
            tx_data <= sw_data;
            start_tx <= 1;
        end
    end

    // ماژول گیرنده
    wire [6:0] rx_data;
    wire rx_ready;
    wire rx_error;

    uart_rx rx_inst (
        .clk(clk_50),
        .rst(rst),
        .rx(rx),
        .data_out(rx_data),
        .ready(rx_ready),
        .error(rx_error)
    );

    assign leds = rx_data;
    assign led_error = rx_error;

endmodule
