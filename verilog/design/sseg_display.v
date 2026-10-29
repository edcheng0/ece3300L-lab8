`timescale 1ns / 1ps
// Shows an 8-bit value (0-255) in decimal on the right 3 digits of the
// Nexys A7 display. Digits are time-multiplexed (~1 ms each at 100 MHz).
module sseg_display(
    input clk, reset_n,
    input [7:0] value,
    output reg [7:0] AN,     // active-low digit enables
    output [6:0] sseg,       // active-low segments {CG..CA}
    output DP
    );

    // Split value into decimal digits
    wire [3:0] ones     = value % 10;
    wire [3:0] tens     = (value / 10) % 10;
    wire [3:0] hundreds = value / 100;

    // Refresh counter: top 2 bits pick the digit
    reg [18:0] refresh;
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            refresh <= 0;
        else
            refresh <= refresh + 1;
    end

    reg [3:0] digit;
    always @(*)
    begin
        case (refresh[18:17])
            2'd0:    begin AN = 8'b1111_1110; digit = ones;     end
            2'd1:    begin AN = 8'b1111_1101; digit = tens;     end
            2'd2:    begin AN = 8'b1111_1011; digit = hundreds; end
            default: begin AN = 8'b1111_1111; digit = 4'hF;     end  // unused slot
        endcase
    end

    sseg_decoder D0(.num(digit), .sseg(sseg));

    assign DP = 1'b1;  // decimal point off
endmodule
