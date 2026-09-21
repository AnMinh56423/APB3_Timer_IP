# APB3 Timer engineering instructions

This repository is a learning project that must be treated like a professional RTL IP project.

## Priorities

1. Functional correctness and protocol compliance.
2. Explicit hardware intent.
3. Readability and maintainability.
4. Verification evidence.
5. Conciseness.

## Working method

- Inspect the specification, RTL, testbench, file lists, and Makefiles before proposing a change.
- For non-trivial changes: explain the issue, propose a small plan, then edit only after the plan is accepted.
- Keep changes small and reviewable. Do not rewrite the complete design unless explicitly requested.
- Never claim that code is correct only because it looks plausible or compiles.
- State exactly which checks were run and which were not available.
- Do not change tool installation paths in tracked files. Local paths belong in `env/local.env`.
- Do not commit licenses, credentials, generated logs, waveforms, compiled libraries, or coverage databases.
- Do not use destructive Git or filesystem commands without explicit approval.

## Required verification

Run the narrowest relevant checks first, then expand:

1. `make doctor`
2. `make lint`
3. `make compile TEST=<testcase>`
4. `make test TEST=<testcase>`
5. `make regress` when the change can affect multiple behaviors
6. `make coverage` only when coverage evidence is required

If a required tool is unavailable, stop that verification stage and report the exact missing command.

## RTL rules

- Preserve current Verilog compatibility unless a task explicitly migrates a file to SystemVerilog.
- New SystemVerilog should use `logic`, `always_ff`, `always_comb`, typed parameters, enums, and packages where they clarify intent.
- Sequential assignments use nonblocking assignment. Combinational assignments use blocking assignment.
- Combinational outputs must be assigned on every path; inferred latches require explicit justification.
- Width, signedness, truncation, overflow, reset behavior, and clock-domain crossings must be reviewed explicitly.
- Replace magic register addresses and control values with named constants when touching related code.
- Protocol behavior must come from the relevant specification, not from memory or a random implementation.
- Testbench code, assertions, expected results, and log messages require the same review rigor as DUT RTL.

## Response format

Keep explanations compact:

- Issue: one sentence.
- Why: one to three sentences.
- Fix: changed files or code.
- Check: commands actually run and outcomes.
- Knowledge: one principle worth remembering.

Detailed project rules are in `.agents/rules/rtl-engineering.md`.
