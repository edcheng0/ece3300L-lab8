`timescale 1ns / 1ps
// Counts from 0 to FINAL_VALUE while enabled; done = 1 for the cycle it reaches FINAL_VALUE.
// Used by debouncer_delayed (FINAL_VALUE = 1_999_999 -> 20 ms at 100 MHz).
module timer_parameter
    #(parameter FINAL_VALUE = 255)(
    input clk,
    input reset_n,
    input enable,
    output done
    );

    localparam BITS = $clog2(FINAL_VALUE + 1);

    reg [BITS - 1:0] Q_reg, Q_next;

    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else if (enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end

    // Next state logic
    always @(*)
        Q_next = done ? 'b0 : Q_reg + 1;

    // Output logic
    assign done = (Q_reg == FINAL_VALUE);
endmodule
