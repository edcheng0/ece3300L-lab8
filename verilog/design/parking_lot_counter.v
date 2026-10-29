`timescale 1ns / 1ps
// FSM + one up/down counter = number of cars in the lot.
//   car_enter -> count up,  car_exit -> count down
//   Counter is held at 0 (no underflow) and at MAX (no overflow).
module parking_lot_counter
    #(parameter BITS = 8)(
    input clk, reset_n,
    input a, b,
    output car_enter, car_exit,
    output [BITS - 1:0] count
    );

    parking_lot_fsm FSM0(
        .clk(clk),
        .reset_n(reset_n),
        .a(a),
        .b(b),
        .car_enter(car_enter),
        .car_exit(car_exit)
    );

    wire empty = (count == 0);
    wire full  = (count == {BITS{1'b1}});

    udl_counter #(.BITS(BITS)) C0(
        .clk(clk),
        .reset_n(reset_n),
        .enable((car_enter & ~full) | (car_exit & ~empty)),
        .up(car_enter),         // 1 = up (enter), 0 = down (exit)
        .load(1'b0),
        .D({BITS{1'b0}}),
        .Q(count)
    );
endmodule
