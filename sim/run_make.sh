#!/bin/bash
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/home/minhan/intelFPGA_lite/25.1/questa_fse/bin:$PATH"
export LM_LICENSE_FILE="/home/minhan/intelFPGA_lite/licenses/license.dat"
export SALT_LICENSE_SERVER="/home/minhan/intelFPGA_lite/licenses/license.dat"

cd "$SCRIPT_DIR"

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
