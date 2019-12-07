
// Half-bridge PWM generator

module pwm(clk, rst, compare, hs, ls);
    input clk, rst;
    input [8:1] compare;    // capture/compare register
    output reg hs;          // high-side PWM output
    output reg ls;          // low-side PWM output

    reg [8:1] cnt;          // timer counter register

    parameter arr = 200;    // auto-reload register (determines frequency)
    parameter dt = 2;       // dead time

    always @(posedge clk)
    begin
        if (rst) begin
            cnt  <= 0;
            hs <= 0;
            ls <= 0;
        end
        else begin
            cnt <= cnt + 1;
            hs <= (cnt < compare);
            ls <= (cnt > compare + dt && cnt < arr - dt);
            if (cnt == arr) begin
                cnt <= 0;
            end
        end
    end
endmodule
