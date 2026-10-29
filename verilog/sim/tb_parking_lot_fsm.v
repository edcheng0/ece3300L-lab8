`timescale 1ns / 1ps
// Tests the FSM by itself: a car entering, a car exiting, and a pedestrian.
module tb_parking_lot_fsm;

    reg clk = 0, reset_n = 0;
    reg a = 0, b = 0;
    wire car_enter, car_exit;

    parking_lot_fsm uut(
        .clk(clk), .reset_n(reset_n),
        .a(a), .b(b),
        .car_enter(car_enter), .car_exit(car_exit)
    );

    always #5 clk = ~clk;   // 100 MHz clock

    // Set the sensors, then wait 3 clock cycles
    // (#1 = change inputs just after a rising edge, like the real debounced signals)
    task sense(input [1:0] ab);
    begin
        {a, b} = ab;
        repeat (3) @(posedge clk);
        #1;
    end
    endtask

    initial begin
        $monitor("t=%0t  ab=%b%b  car_enter=%b  car_exit=%b", $time, a, b, car_enter, car_exit);

        #12 reset_n = 1;

        // Car enters: 00 -> 10 -> 11 -> 01 -> 00  (expect car_enter pulse)
        sense(2'b10); sense(2'b11); sense(2'b01); sense(2'b00);

        // Car exits: 00 -> 01 -> 11 -> 10 -> 00   (expect car_exit pulse)
        sense(2'b01); sense(2'b11); sense(2'b10); sense(2'b00);

        // Pedestrian: 00 -> 10 -> 00               (expect no pulse)
        sense(2'b10); sense(2'b00);

        $finish;
    end
endmodule
