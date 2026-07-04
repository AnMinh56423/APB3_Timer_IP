# AMBA APB3 Timer IP Core

## 📌 Overview
A configurable 64-bit hardware timer IP core designed with an AMBA APB3-compatible interface.  
The project supports programmable prescalers, interrupt generation, and debug/halt mode operation for digital IC design and verification practice.

---

## 🚀 Key Features
- AMBA APB3 slave interface
- 32-bit read/write register access
- 64-bit programmable timer counter
- Programmable prescaler (divide by 2 to 256)
- Interrupt generation on compare match
- Debug/Halt mode support
- Verilog RTL implementation
- Functional verification environment

---

## 📂 Repository Structure

```text
docs/       Documentation and coverage reports
rtl/        Verilog RTL source files
tb/         Testbench and verification environment
sim/        Simulation scripts and logs
testcases/  Verification testcases
```

---

## 📊 Verification & Coverage

The design is verified using directed and constrained-random testcases.

Achieved:
- 100% Statement Coverage
- 100% Branch Coverage
- 100% Expression Coverage
- 100% Condition Coverage
- 100% Toggle Coverage

(After excluding unused or reserved bits)

Tools:
- QuestaSim
- ModelSim

---

## 🛠️ How to Run

```bash
git clone https://github.com/yourname/APB3_Timer_IP.git
cd APB3_Timer_IP/sim
do run.tcl
```

---

## 👨‍💻 Author

Huynh Minh An

RTL Design / Digital IC Design Learning Project