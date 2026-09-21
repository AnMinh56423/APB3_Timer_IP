#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd -- "$script_dir/.." && pwd)"

# Keep workstation-specific Questa and license paths out of the repository.
# shellcheck disable=SC1091
source "$project_dir/env/setup.sh"

cd "$script_dir"

case "${1:-rtl}" in
  rtl|normal)
    make clean
    make all_testcase
    ;;
  cov|coverage)
    make clean
    make all_testcase_cov
    make gen_cov
    make gen_html
    ;;
  *)
    printf 'Usage: %s [rtl|cov]\n' "$0" >&2
    exit 2
    ;;
esac
