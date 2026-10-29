`timescale 1ns / 1ps
// Top level for the Nexys A7-100T
//   BTNL = sensor a, BTNR = sensor b (debounced)
//   CPU_RESETN = reset
//   LED[0] = a, LED[1] = b, LED[2] = car_enter, LED[3] = car_exit (very short pulses)
//   Seven-segment display = number of cars in the lot (decimal)
module parking_lot_top(
    input CLK100MHZ,
    input CPU_RESETN,
    input BTNL, BTNR,
    output [3:0] LED,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP
    );

    wire a, b;
    wire car_enter, car_exit;
    wire [7:0] count;

    // Debounce the two pushbuttons (sensor stand-ins)
    debouncer_delayed DB_A(
        .clk(CLK100MHZ),
        .reset_n(CPU_RESETN),
        .noisy(BTNL),
        .debounced(a)
    );

    debouncer_delayed DB_B(
        .clk(CLK100MHZ),
        .reset_n(CPU_RESETN),
        .noisy(BTNR),
        .debounced(b)
    );

    // FSM + up/down counter
    parking_lot_counter #(.BITS(8)) PLC0(
        .clk(CLK100MHZ),
        .reset_n(CPU_RESETN),
        .a(a),
        .b(b),
        .car_enter(car_enter),
        .car_exit(car_exit),
        .count(count)
    );

    // Display
    sseg_display DISP0(
        .clk(CLK100MHZ),
        .reset_n(CPU_RESETN),
        .value(count),
        .AN(AN),
        .sseg({CG, CF, CE, CD, CC, CB, CA}),
        .DP(DP)
    );

    assign LED = {car_exit, car_enter, b, a};
endmodule
