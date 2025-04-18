module incubator_control(
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,  // سنسور دما
    output reg heater,              // هیتر
    output reg cooler,              // کولر
    output reg fan                  // فن
);

    // تعریف حالات
    parameter S1 = 2'b00; // Heater: OFF, Cooler: OFF
    parameter S2 = 2'b01; // Heater: OFF, Cooler: ON
    parameter S3 = 2'b10; // Heater: ON, Cooler: OFF
    
    reg [1:0] state, next_state;
    
    // FSM برای کنترل هیتر و کولر
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S1; // بازنشانی به حالت اولیه
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            S1: begin
                heater = 0;
                cooler = 0;
                fan = 0;
                if (temperature < 25) begin
                    next_state = S3; // تغییر به حالت S3
                end else if (temperature > 36) begin
                    next_state = S2; // تغییر به حالت S2
                end else begin
                    next_state = S1; // باقی ماندن در S1
                end
            end
            
            S2: begin
                heater = 0;
                cooler = 1;
                fan = 1;
                if (temperature < 25) begin
                    next_state = S3; // تغییر به حالت S3
                end else if (temperature >= 36) begin
                    next_state = S2; // باقی ماندن در S2
                end else begin
                    next_state = S1; // برگشت به S1
                end
            end
            
            S3: begin
                heater = 1;
                cooler = 0;
                fan = 1;
                if (temperature >= 36) begin
                    next_state = S2; // تغییر به حالت S2
                end else if (temperature < 25) begin
                    next_state = S3; // باقی ماندن در S3
                end else begin
                    next_state = S1; // برگشت به S1
                end
            end
            
            default: begin
                next_state = S1; // حالت پیش فرض
            end
        endcase
    end
endmodule