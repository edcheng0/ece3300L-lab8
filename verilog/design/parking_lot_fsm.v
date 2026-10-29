`timescale 1ns / 1ps
// Parking lot FSM
// Inputs : a, b  (sensor outputs, 1 = object detected)
// Outputs: car_enter, car_exit (each high for ONE clock cycle)
//
// Car entering : ab = 00 -> 10 -> 11 -> 01 -> 00
// Car exiting  : ab = 00 -> 01 -> 11 -> 10 -> 00
// Any other pattern (pedestrian, car backing out) returns to IDLE with no output.
module parking_lot_fsm(
    input clk, reset_n,
    input a, b,
    output car_enter, car_exit
    );

    reg [2:0] state_reg, state_next;
    localparam IDLE   = 0,
               ENTER1 = 1,  // ab = 10
               ENTER2 = 2,  // ab = 11
               ENTER3 = 3,  // ab = 01
               EXIT1  = 4,  // ab = 01
               EXIT2  = 5,  // ab = 11
               EXIT3  = 6;  // ab = 10

    // Sequential state register
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= IDLE;
        else
            state_reg <= state_next;
    end

    // Next state logic
    always @(*)
    begin
        state_next = state_reg;
        case (state_reg)
            IDLE:   case ({a, b})
                        2'b10:   state_next = ENTER1;
                        2'b01:   state_next = EXIT1;
                        default: state_next = IDLE;
                    endcase

            // ---------- entering ----------
            ENTER1: case ({a, b})
                        2'b10:   state_next = ENTER1;  // wait
                        2'b11:   state_next = ENTER2;  // next step
                        default: state_next = IDLE;    // backed out / invalid
                    endcase
            ENTER2: case ({a, b})
                        2'b11:   state_next = ENTER2;
                        2'b01:   state_next = ENTER3;
                        2'b10:   state_next = ENTER1;  // moved back one step
                        default: state_next = IDLE;
                    endcase
            ENTER3: case ({a, b})
                        2'b01:   state_next = ENTER3;
                        2'b00:   state_next = IDLE;    // car fully entered
                        2'b11:   state_next = ENTER2;  // moved back one step
                        default: state_next = IDLE;
                    endcase

            // ---------- exiting ----------
            EXIT1:  case ({a, b})
                        2'b01:   state_next = EXIT1;
                        2'b11:   state_next = EXIT2;
                        default: state_next = IDLE;
                    endcase
            EXIT2:  case ({a, b})
                        2'b11:   state_next = EXIT2;
                        2'b10:   state_next = EXIT3;
                        2'b01:   state_next = EXIT1;
                        default: state_next = IDLE;
                    endcase
            EXIT3:  case ({a, b})
                        2'b10:   state_next = EXIT3;
                        2'b00:   state_next = IDLE;    // car fully exited
                        2'b11:   state_next = EXIT2;
                        default: state_next = IDLE;
                    endcase

            default: state_next = IDLE;
        endcase
    end

    // Output logic (Mealy): pulse on the last transition back to IDLE.
    // Next state is IDLE, so the pulse lasts exactly one clock cycle.
    assign car_enter = (state_reg == ENTER3) & ~a & ~b;
    assign car_exit  = (state_reg == EXIT3)  & ~a & ~b;
endmodule
