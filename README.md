# AMBA APB3 Timer IP Core

## Overview

A synthesizable 64-bit Timer IP core with an AMBA APB3-compatible interface.

The project is developed in Verilog RTL and includes memory-mapped register control, programmable timer operation, interrupt generation, debug/halt support, APB wait-state support, and APB error handling.

## Key Features

- AMBA APB3 slave interface
- 32-bit APB read/write data interface
- 64-bit programmable timer counter
- Programmable prescaler
- Timer compare functionality
- Timer interrupt generation
- Debug/Halt mode support
- APB wait-state support
- APB error response using `PSLVERR`
- Verilog RTL implementation
- QuestaSim/ModelSim-based simulation and verification

## Architecture

```text
                    APB3 Interface
                          |
                          v
                    +-----------+
                    | APB Slave |
                    +-----------+
                          |
                          v
                    +-----------+
                    | Register  |
                    +-----------+
                          |
             +------------+------------+
             |                         |
             v                         v
      +--------------+          +-------------+
      | Counter Ctrl |--------->|   Counter   |
      +--------------+          +-------------+
             |
             v
      +--------------+
      |  Interrupt   |
      +--------------+
```

### Main RTL Blocks

| Block | Description |
|---|---|
| `apb_wait_state.v` | Handles APB wait-state behavior |
| `register.v` | Implements the memory-mapped timer registers |
| `counter_ctrl.v` | Controls timer counting behavior |
| `counter.v` | Implements the timer counter |
| `interrupt.v` | Generates timer interrupt behavior |
| `timer_top.v` | Top-level integration of the Timer IP |

## Repository Structure

```text
APB3_Timer_IP/
├── docs/              # Documentation
├── rtl/               # Verilog RTL source files
├── sim/               # Simulation and build scripts
├── tb/                # Testbench
├── testcases/         # Verification testcases
├── Block_Diagram.PNG  # IP block diagram
├── LICENSE
├── README.md
├── .gitignore
└── .gitattributes
```

Generated simulation files such as `work/`, logs, waveform databases, and coverage databases are excluded from version control.

## Verification

The design is verified using directed testcases.

Current verification areas include:

- Register read/write checking
- Counter operation checking
- Counting mode checking
- APB error response checking
- Interrupt checking
- Debug/Halt behavior checking

### Testcases

```text
testcases/
├── register_chk.v
├── counter_chk.v
├── counting_mode_chk.v
├── error_chk.v
├── interrupt_chk.v
└── halt_chk.v
```

## Coverage

Coverage is collected using QuestaSim.

The verification flow evaluates:

- Statement coverage
- Branch coverage
- Expression coverage
- Condition coverage
- Toggle coverage

Coverage results should be reported together with the corresponding verification run.

## Simulation

### Requirements

- Verilog simulator
- QuestaSim or ModelSim
- GNU Make
- Linux / WSL environment
- C shell (`csh`) if using the provided `.csh` scripts

### Run Simulation

```bash
cd sim
make
```

The simulation flow uses the project Makefile and file lists in the `sim/` directory.

### Clean Generated Simulation Files

To remove generated simulation files:

```bash
make clean
```

To remove generated files that should not be committed to GitHub:

```bash
make clean_git
```

## Timer Operation

The Timer IP is controlled through the APB3 interface and its memory-mapped registers.

The main functional flow is:

```text
APB3 Transaction
       |
       v
Register Access
       |
       v
Timer Configuration
       |
       v
Prescaler / Counter Control
       |
       v
64-bit Timer Counter
       |
       +------> Compare / Timer Event
                       |
                       v
                  Interrupt
```

## Tools

- Verilog
- QuestaSim
- ModelSim
- GNU Make
- Linux / WSL
- Git / GitHub

## Antigravity RTL Lab Setup

For the Ubuntu, Questa, lint, project-rule, and safety setup, see [docs/ANTIGRAVITY_SETUP.md](docs/ANTIGRAVITY_SETUP.md).

After creating `env/local.env`, run project commands from the repository root:

```bash
make doctor
make lint
make test TEST=register_chk
make regress
```

## Author

**Huynh Minh An**

RTL Design / Digital IC Design Learning Project

GitHub: https://github.com/MinhAn56423-En
