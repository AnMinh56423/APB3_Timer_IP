#!/usr/bin/env bash
set -u

required_tools=(make vlib vmap vlog vsim)
optional_tools=(verible-verilog-format verible-verilog-lint verilator vcover yosys python3 git)

failures=0

printf '%-28s %s\n' TOOL STATUS
printf '%-28s %s\n' '----------------------------' '----------------------------'

for tool in "${required_tools[@]}"; do
  if tool_path="$(command -v "$tool" 2>/dev/null)"; then
    printf '%-28s OK\t%s\n' "$tool" "$tool_path"
  else
    printf '%-28s MISSING (required)\n' "$tool"
    failures=$((failures + 1))
  fi
done

for tool in "${optional_tools[@]}"; do
  if tool_path="$(command -v "$tool" 2>/dev/null)"; then
    printf '%-28s OK\t%s\n' "$tool" "$tool_path"
  else
    printf '%-28s MISSING (optional)\n' "$tool"
  fi
done

printf '\nConfiguration\n'
printf '  QUESTA_HOME=%s\n' "${QUESTA_HOME:-not set}"
if [[ -n "${LM_LICENSE_FILE:-}" ]]; then
  printf '  LM_LICENSE_FILE=set\n'
else
  printf '  LM_LICENSE_FILE=not set\n'
fi
if [[ -n "${SALT_LICENSE_SERVER:-}" ]]; then
  printf '  SALT_LICENSE_SERVER=set\n'
else
  printf '  SALT_LICENSE_SERVER=not set\n'
fi

if (( failures > 0 )); then
  printf '\nDoctor failed: %d required tool(s) missing.\n' "$failures" >&2
  printf 'Configure env/local.env, then run: source env/setup.sh\n' >&2
  exit 1
fi

printf '\nDoctor passed: required Questa commands are available.\n'
