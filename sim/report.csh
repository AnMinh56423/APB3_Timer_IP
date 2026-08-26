#!/bin/csh

set log = "rep.log"
if (-f $log) then
    rm -rf $log
endif

touch $log

printf "|-----------------------------------------------------------------------------------------------|\n" >> $log
printf "|%-40s |%-30s |%-20s |\n" " PAT_NAME" " RUN_DATE" " RESULT" >> $log
printf "|-----------------------------------------------------------------------------------------------|\n" >> $log

foreach pat (`sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' pat.list`)
    echo $pat
    set sim_log = "log/${pat}.log"
    if ( !(-f $sim_log) ) then
        printf "|%-40s |%-30s |%-20s |\n" " $pat" " NA" " NO_LOG" >> $log
    else
        set tm = `grep "End time" $sim_log | awk -F"[ :,]" '{print $5 ":" $6 ":" $7 " " $9 " " $10 " " $11}'`
        set res = `grep "Test_result" $sim_log | awk '{print $3}'`
        if ("$res" == "") set res = "UNKNOWN"
        printf "|%-40s |%-30s |%-20s |\n" " $pat" " $tm" " $res" >> $log
    endif
    printf "|-----------------------------------------------------------------------------------------------|\n" >> $log
end

cat $log
