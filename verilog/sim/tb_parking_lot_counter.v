`timescale 1ns / 1ps
// Tests FSM + up/down counter: 3 cars enter, 1 exits, 1 pedestrian.
// Expected final count = 2.
module tb_parking_lot_counter;

    reg clk = 0, reset_n = 0;
    reg a = 0, b = 0;
    wire car_enter, car_exit;
    wire [7:0] count;

    parking_lot_counter #(.BITS(8)) uut(
        .clk(clk), .reset_n(reset_n),
        .a(a), .b(b),
        .car_enter(car_enter), .car_exit(car_exit),
        .count(count)
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

    task car_in;      begin sense(2'b10); sense(2'b11); sense(2'b01); sense(2'b00); end endtask
    task car_out;     begin sense(2'b01); sense(2'b11); sense(2'b10); sense(2'b00); end endtask
    task pedestrian;  begin sense(2'b10); sense(2'b00);                             end endtask

    initial begin
        #12 reset_n = 1;

        car_out;     $display("Exit on empty lot -> count = %0d (expect 0)", count);
        car_in;      $display("Car in            -> count = %0d (expect 1)", count);
        car_in;      $display("Car in            -> count = %0d (expect 2)", count);
        car_in;      $display("Car in            -> count = %0d (expect 3)", count);
        car_out;     $display("Car out           -> count = %0d (expect 2)", count);
        pedestrian;  $display("Pedestrian        -> count = %0d (expect 2)", count);

        $finish;
    end
endmodule
