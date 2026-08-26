#!/bin/bash
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

log="rep.log"
rm -f "$log"
touch "$log"

printf "|-----------------------------------------------------------------------------------------------|\n" >> "$log"
printf "|%-40s |%-30s |%-20s |\n" " PAT_NAME" " RUN_DATE" " RESULT" >> "$log"
printf "|-----------------------------------------------------------------------------------------------|\n" >> "$log"

mapfile -t patterns < <(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' pat.list)
for pat in "${patterns[@]}"; do
    sim_log="log/${pat}.log"
    if [[ ! -f "$sim_log" ]]; then
        printf "|%-40s |%-30s |%-20s |\n" " $pat" " NA" " NO_LOG" >> "$log"
        continue
    fi

    tm=$(grep "End time" "$sim_log" | awk -F"[ :,]" '{print $5 ":" $6 ":" $7 " " $9 " " $10 " " $11}')
    res=$(grep "Test_result" "$sim_log" | awk '{print $3}')
    [[ -n "$res" ]] || res="UNKNOWN"
    printf "|%-40s |%-30s |%-20s |\n" " $pat" " $tm" " $res" >> "$log"
done

printf "|-----------------------------------------------------------------------------------------------|\n" >> "$log"
cat "$log"
