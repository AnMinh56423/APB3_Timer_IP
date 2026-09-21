#!/usr/bin/env bash

# Source this file when you want Questa commands in the current shell:
#   source env/setup.sh

setup_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd -- "$setup_dir/.." && pwd)"
local_env="$setup_dir/local.env"

if [[ ! -f "$local_env" ]]; then
  printf 'Missing %s\n' "$local_env" >&2
  printf 'Create it with: cp %s/local.env.example %s/local.env\n' "$setup_dir" "$setup_dir" >&2
  return 1 2>/dev/null || exit 1
fi

set -a
# shellcheck disable=SC1090
source "$local_env"
set +a

if [[ -z "${QUESTA_HOME:-}" ]]; then
  printf 'QUESTA_HOME is not set in %s\n' "$local_env" >&2
  return 1 2>/dev/null || exit 1
fi

export PATH="$QUESTA_HOME/bin:$PATH"
export APB3_TIMER_ROOT="$project_dir"

printf 'APB3 Timer environment loaded from %s\n' "$local_env"
