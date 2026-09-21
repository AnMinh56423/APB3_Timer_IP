# Antigravity setup for APB3 Timer

This setup keeps Antigravity as the editor and agent layer. The repository remains executable from any terminal through GNU Make, and Questa remains the simulation ground truth.

## 1. Install Antigravity on Ubuntu

Use Google's current Linux instructions:

- https://antigravity.google/download/linux/
- https://antigravity.google/docs/getting-started/

At the time this file was written, the official Debian/Ubuntu repository installation is:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg |
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" |
  sudo tee /etc/apt/sources.list.d/antigravity.list >/dev/null

sudo apt update
sudo apt install antigravity
```

Check the official page before installing because repository details may change.

## 2. Clone and open this repository

```bash
git clone https://github.com/AnMinh56423/APB3_Timer_IP.git
cd APB3_Timer_IP
antigravity .
```

If `antigravity .` is not registered as a shell command, open the standalone IDE and select this repository directory.

Antigravity reads the project instructions from:

- `AGENTS.md`
- `.agents/rules/rtl-engineering.md`

Do not place workstation paths or license values in either file.

## 3. Configure the local Questa installation

Create the ignored local configuration:

```bash
cp env/local.env.example env/local.env
```

Edit `env/local.env`:

```bash
QUESTA_HOME=/home/your-user/intelFPGA_lite/25.1/questa_fse
LM_LICENSE_FILE=/home/your-user/intelFPGA_lite/licenses/license.dat
SALT_LICENSE_SERVER=/home/your-user/intelFPGA_lite/licenses/license.dat
```

Load it into an interactive terminal:

```bash
source env/setup.sh
```

The root `Makefile` also reads `env/local.env`, so project commands work without permanently changing your shell profile.

## 4. Install supporting tools

Required for the existing flow:

- GNU Make
- Questa or ModelSim commands: `vlib`, `vmap`, `vlog`, `vsim`

Recommended:

- Verible: formatter and SystemVerilog style/syntax lint
- Verilator: independent RTL lint
- Git
- Python 3
- Yosys: later synthesis exercises

Install packages using sources appropriate for your Ubuntu version. Verify command availability rather than assuming an installation succeeded:

```bash
make doctor
```

## 5. First verification run

From the repository root:

```bash
make doctor
make lint
make compile TEST=register_chk
make test TEST=register_chk
make regress
```

Coverage is deliberately separate because it takes longer:

```bash
make coverage
```

Open a waveform for one testcase:

```bash
make wave TEST=interrupt_chk
```

## 6. Recommended Antigravity permissions

Start with review prompts enabled for writes and terminal commands. Do not enable unrestricted or turbo-style execution for an RTL repository that can invoke shell cleanup commands.

Review these actions manually:

- recursive deletion or cleanup outside the repository;
- Git reset, force push, branch deletion, or history rewriting;
- any command that prints or modifies license configuration;
- simulator or package installation using `sudo`;
- changes that weaken tests, assertions, lint, or warning settings.

Allow routine read-only inspection and narrow project commands after you understand what they execute.

## 7. Suggested prompts

Review only:

```text
Review @rtl/counter_ctrl.v using the repository rules. Do not edit.
Report width/signedness, reset, overflow, and test gaps. Cite exact signals.
```

Small implementation:

```text
Explore the failing behavior first. Propose a minimal plan and wait for approval.
After approval, implement it and run make test TEST=<name>.
Do not claim regression success unless make regress was actually run.
```

Learning:

```text
Explain this issue using: Issue, Why, Fix, Check, Knowledge.
Keep the explanation concise and connect it to the hardware that will be inferred.
```

## 8. Current project boundary

This setup does not migrate the RTL from Verilog to SystemVerilog and does not introduce UVM. Those should be separate reviewed changes after the existing regression baseline is reproducible.
