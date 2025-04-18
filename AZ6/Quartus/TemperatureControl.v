module TemperatureControl(
    input wire clk,
    input wire reset,
    input wire signed [7:0] temperature,
    output reg heater,
    output reg cooler,
    output reg [3:0] crs
);

  parameter  S1 = 2'b00; // Heater: OFF, Cooler: OFF
  parameter  S2 = 2'b01; // Heater: OFF, Cooler: ON
  parameter  S3 = 2'b10; // Heater: ON, Cooler: OFF

  reg [1:0]  current_state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state = S1;
        cooler = 0;
        heater = 0;
        crs = 0;
    end else begin
        current_state = next_state; 

    heater = 0; 
    cooler = 0;
    next_state = current_state;
	 

    case (current_state)
        S1: begin
            crs = 0;
            if (temperature < 15) begin
                heater = 1;
                next_state = S3;
            end else if (temperature > 35) begin
                cooler = 1;
                next_state = S2;
            end
        end
		  
        S2: begin
            if (temperature < 25) begin
                next_state = S1;
					crs = 0;
            end else begin 
                cooler = 1;
					if (crs == 0) begin
                        if (temperature > 35) begin
                            crs = 4;
                        end
                    end

                    else if (crs == 4) begin
                        if (temperature > 40) begin
                            crs = 6;
                        end else if (temperature < 25) begin
                            crs = 0;
                        end
                    end

                    else if (crs == 6) begin
                        if (temperature > 45) begin
                            crs = 8;
                        end else if (temperature < 35) begin
                            crs = 4;
                        end
                    end

                    else if (crs == 8) begin
                        if (temperature < 40) begin
                            crs = 6;
                        end
                    end
            end
        end
		  
        S3: begin
            crs = 0;
            if (temperature > 30) begin
                next_state = S1;
            end else begin
                heater = 1;
                next_state = S3;
            end
        end
        default: next_state = S1;
    endcase
    end
end

endmodule