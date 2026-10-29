# ece3300L-lab8 : Parking Lot Occupancy Counter
## Files
### Design
- [`verilog/design/parking_lot_fsm.v`](verilog/design/parking_lot_fsm.v) – parking lot FSM (inputs a, b; outputs car_enter, car_exit)
- [`verilog/design/parking_lot_counter.v`](verilog/design/parking_lot_counter.v) – FSM + up/down counter (number of cars in the lot)
- [`verilog/design/parking_lot_top.v`](verilog/design/parking_lot_top.v) – top module, Nexys A7-100T
- [`verilog/design/sseg_display.v`](verilog/design/sseg_display.v) – multiplexed seven-segment display (decimal)
- [`verilog/design/sseg_decoder.v`](verilog/design/sseg_decoder.v) – digit to seven-segment converter
- [`verilog/design/timer_parameter.v`](verilog/design/timer_parameter.v) – parameterized timer (used by debouncer)
- [`verilog/design/udl_counter.v`](verilog/design/udl_counter.v) – starter: parameterized up/down/load counter
- [`verilog/design/debouncer_delayed.v`](verilog/design/debouncer_delayed.v) – starter: delayed debouncer
- [`verilog/design/debouncer_delayed_fsm.v`](verilog/design/debouncer_delayed_fsm.v) – starter: delayed debouncer FSM
### Sim
- [`verilog/sim/tb_parking_lot_fsm.v`](verilog/sim/tb_parking_lot_fsm.v) – FSM testbench
- [`verilog/sim/tb_parking_lot_counter.v`](verilog/sim/tb_parking_lot_counter.v) – FSM + counter testbench
### Constraints
- [`verilog/constraints/nexys_a7_100t.xdc`](verilog/constraints/nexys_a7_100t.xdc) – board constraints, Nexys A7-100T
## Part 1: Parking Lot FSM
State diagram:
![FSM state diagram](screenshots/fsm_state_diagram.png)
Simulation waveform:
![FSM waveform](screenshots/fsm_waveform.png)
## Part 2: Occupancy Counter
Block diagram:
![Counter block diagram](screenshots/counter_blockdiagram.png)
Simulation waveform:
![Counter waveform](screenshots/counter_waveform.png)
## Part 3: FPGA Implementation
Schematic:
![Top schematic](screenshots/top_schematic.png)
Demo video:
https://github.com/user-attachments/assets/c62f9b89-0d17-410e-92c2-9205dcefd015 
