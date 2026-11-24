
UVM Verification of CORDIC IP
Overview
This repository contains a comprehensive, industry-standard Universal Verification Methodology (UVM) testbench designed to verify a CORDIC (Coordinate Rotation Digital Computer) IP core. The DUT supports two primary modes of operation:
Angle Mode: Calculates Sine and Cosine for a given 16-bit angle.
Multiplication Mode: Performs standard multiplication of two 8-bit operands.
The testbench achieves 100% Code and Functional Coverage and incorporates advanced verification concepts, including asynchronous mid-test reset resilience, error injection (negative testing), and cycle-accurate payload assembly.
Testbench Architecture
![CORDIC UVM Testbench Architecture](cordic_tb_architecture.jpg)
The UVM environment (`cordic_env`) is structured as follows:
1. Input Agent (`cordic_in_agent` - Active)
`cordic_sequencer`: Routes randomized `cordic_seq_item` transactions from sequences to the driver.
`cordic_driver`: Translates transaction-level data into multi-cycle pin wiggling on the virtual interface. It implements advanced `fork...join_any` logic to gracefully handle asynchronous resets without hanging the UVM objection mechanism.
`cordic_in_monitor`: Passively samples the `START` and `DATA_IN` signals over multiple clock cycles, reconstructs the input payload, and broadcasts it to the scoreboard. It includes protective logic to ignore illegal transactions injected during negative testing.
2. Output Agent (`cordic_out_agent` - Passive)
`cordic_out_monitor`: Waits for the DUT's `DONE` signal and dynamically collects output bytes (`DATA_OUT`) cycle-by-cycle to assemble the final 32-bit output payload.
3. Scoreboard (`cordic_scoreboard`)
Reference Model: Implements a SystemVerilog real-math golden model (`$cos`, `$sin`, `$rtoi`) for Angle mode and exact bitwise calculations for Multiplication mode.
Comparator: Performs exact matching for multiplication and tolerance-based checking (Diff <= 11) for CORDIC trigonometric approximations.
Queue Management: Actively listens for `is_reset` flags from monitors to instantly flush stale transaction queues, preventing queue-shift mismatches during mid-test resets.
4. Subscriber (`cordic_subscriber`)
Samples transactions broadcasted by the Input Monitor to collect functional coverage (e.g., cross coverage of operation modes, data ranges, and corner cases).
5. SystemVerilog Assertions (SVA)
Bound to the DUT to monitor protocol compliance (e.g., `BUSY` duration, `DONE` assertion limits, and `ERROR` flag triggers).
Guarded with `!BUSY` antecedents to prevent false failures during intentional error injection testing.
Advanced Features
Mid-Test Reset Resilience: Monitors and Drivers utilize concurrent threads (`fork...join_any`) to abort active sampling/driving the instant `RSTn` drops, keeping the UVM pipeline perfectly synchronized with the hardware state.
Negative Testing: Custom error sequences intentionally drive `START` while the DUT is `BUSY` to verify the hardware's error-handling state machine.
Prerequisites
Simulator: Synopsys VCS / Verdi (or any standard SystemVerilog UVM 1.2 compliant simulator).
Make: GNU Make for running regressions.
Quick Start / How to Run
1. Compile the Design & Testbench:
```bash
make compile
```
2. Run a Specific Test (e.g., Random Mixed Mode):
```bash
./simv +UVM_TESTNAME=rand_mixed_mode_test -l sim.log
```
3. Run the Full Regression Suite:
```bash
make regression
```
4. View Waveforms and Coverage in Verdi:
```bash
# Open Waveforms
verdi -ssf dump.fsdb &

# Open Merged Coverage Database
verdi -cov -covdir regression_cm/merged/merged_cov.vdb &
```
