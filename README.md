# ece3300L-lab8 : Parking Lot Occupancy Counter
## Files
### Design
- [`src/parking_lot_fsm.v`](src/parking_lot_fsm.v) – parking lot FSM (inputs a, b; outputs car_enter, car_exit)
- [`src/parking_lot_counter.v`](src/parking_lot_counter.v) – FSM + up/down counter (number of cars in the lot)
- [`src/parking_lot_top.v`](src/parking_lot_top.v) – top module, Nexys A7-100T
- [`src/sseg_display.v`](src/sseg_display.v) – multiplexed seven-segment display (decimal)
- [`src/sseg_decoder.v`](src/sseg_decoder.v) – digit to seven-segment converter
- [`src/timer_parameter.v`](src/timer_parameter.v) – parameterized timer (used by debouncer)
- [`src/udl_counter.v`](src/udl_counter.v) – starter: parameterized up/down/load counter
- [`src/debouncer_delayed.v`](src/debouncer_delayed.v) – starter: delayed debouncer
- [`src/debouncer_delayed_fsm.v`](src/debouncer_delayed_fsm.v) – starter: delayed debouncer FSM
### Sim
- [`tb/tb_parking_lot_fsm.v`](tb/tb_parking_lot_fsm.v) – FSM testbench
- [`tb/tb_parking_lot_counter.v`](tb/tb_parking_lot_counter.v) – FSM + counter testbench
### Constraints
- [`constraints/nexys_a7_100t.xdc`](constraints/nexys_a7_100t.xdc) – board constraints, Nexys A7-100T
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
- [Car entering and exiting](videos/demo.mp4)
