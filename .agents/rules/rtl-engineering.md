# RTL engineering rule

Apply this rule to RTL, testbench, simulation, verification, and documentation work in this repository.

## Source authority

Resolve conflicts in this order:

1. IEEE or Arm standard relevant to the construct or protocol.
2. Approved project specification and register map.
3. Repository rules and accepted design decisions.
4. lowRISC RTL or DV coding style.
5. Production reference implementation such as OpenTitan.
6. Tutorials, blogs, and forum answers.

Do not silently choose between conflicting sources. Identify the conflict and ask for a decision when it changes behavior.

## Design review checklist

For every RTL change, review:

- clock and reset polarity, synchrony, and reset values;
- bit width and signedness of operands, literals, shifts, comparisons, and casts;
- sequential versus combinational intent;
- complete assignment and latch risk;
- counter wrap, overflow, underflow, and boundary values;
- APB setup/access phase behavior, PREADY stability, PSLVERR, address decode, and write behavior;
- interrupt enable, status, clear, and timing behavior;
- parameter legality and invalid configuration handling;
- synthesizability and accidental simulation-only constructs.

## Verification rules

- A testcase must fail when its target behavior is intentionally broken.
- A PASS message must agree with the condition that produced it.
- Prefer self-checking tests over visual waveform inspection.
- Do not weaken or delete a failing check merely to make a regression pass.
- When fixing a bug, add or strengthen a check that exposes the original failure.
- Separate observed facts from assumptions.
- Compile success is not functional verification.
- A regression pass is not proof that untested behavior is correct.
- Coverage numbers must be paired with the tests and commands that produced them.

## Tool flow

Use the repository interface from its root:

- `make doctor`: show tool availability and configuration.
- `make lint`: run non-mutating lint checks.
- `make compile TEST=<name>`: compile one directed test.
- `make test TEST=<name>`: compile and simulate one test.
- `make regress`: run all directed tests.
- `make coverage`: run the coverage regression and produce reports.
- `make clean`: remove generated project outputs only.

Questa is the simulation ground truth. Verible checks style/syntax; Verilator provides an independent lint pass. Do not substitute one check for another.

## Change discipline

- Read the complete module and its callers before editing an interface.
- Update file lists and tests when adding or renaming source files.
- Avoid unrelated formatting changes.
- Preserve existing behavior unless the task explicitly changes it.
- Never hard-code a workstation username, installation path, or license path.
- Never expose `env/local.env` contents.
- Do not edit generated files such as `run_test.v`, logs, UCDB, WLF, `work/`, or HTML coverage output.
- Prefer a branch and reviewed diff for structural changes.

## Learning mode

When explaining a change to the repository owner:

1. Name the hardware issue.
2. Connect it to the relevant RTL or protocol principle.
3. Show the smallest clear correction.
4. Give the command that verifies it.
5. Distinguish verified behavior from recommended future work.
