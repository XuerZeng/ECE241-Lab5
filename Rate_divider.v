

module part2(ClockIn, Reset, Speed, CounterValue);

    input ClockIn, Reset;
    input [1:0] Speed;
    output [3:0] CounterValue;
    reg [10:0] MAX;

        always @(Speed, Reset)
        begin
            if(Reset) MAX = 11'b1;
            else
                begin
                    case(Speed)
                        2'b00: MAX = 11'b1;
                        2'b01: MAX = 11'd499;
                        2'b10: MAX = 11'd999;
                        2'b11: MAX = 11'd1999;
                    endcase
                end
        end
   DisplayCounter u1(.Clock(ClockIn), .MAX(MAX), .CounterValue(CounterValue), .Reset(Reset));

endmodule


module RateDivider(Clock, MAX, Enable, Reset);

    input Clock, Reset;
    input [10:0] MAX;
    output Enable;

    reg [10:0] counter = 0;
    reg En = 0;
    assign Enable = En;
    
    always @(posedge Clock)
    begin
        if (Reset || MAX == 1)
            En <= ~En;
        else if (counter)
            begin
                counter <= counter - 1;
                En <= 0;
            end
        else
            begin
                counter <= MAX;
                En <= 1;
            end
    end
    
    always @(negedge Clock)
        begin
            if(Reset || MAX == 1)
                En <= ~En;
        end
        
endmodule


module DisplayCounter(Clock, CounterValue, MAX, Reset);

input Clock, Reset;
input [10:0] MAX;
output reg [3:0] CounterValue;
wire w1;
    
    RateDivider u2(.Clock(Clock), .MAX(MAX), .Enable(En), .Reset(Reset));
    
    always @(posedge En, posedge Reset)
        begin
            if (Reset)
                CounterValue <= 0;
            else if(CounterValue == 4'b1111)
                CounterValue <= 0;
            else
                CounterValue <= CounterValue + 1;
        end
    
endmodule
