module uart_tb;
    reg clk = 0;
    always #5 clk = ~clk;  // 100 MHz clock

    reg rst = 1;
    reg start = 0;
    reg [6:0] data = 7'd65; // ASCII 'A'
    wire tx_line;
    wire [6:0] received;
    wire valid;

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data(data),
        .tx(tx_line),
        .busy()
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(tx_line),
        .data_out(received),
        .valid(valid)
    );

    initial begin
        #10 rst = 0;
        #20 start = 1;
        #10 start = 0;
        #200 $finish;
    end

    initial begin
        $monitor("Time: %0t | Received: %c | Valid: %b", $time, received, valid);
    end
endmodule
