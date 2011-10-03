#!/bin/bash

#Data=data/p1.lp
Data=$1
Model=model.lp
UniqueFolder=tmp

Input=$UniqueFolder/input.tmp
Problem=$UniqueFolder/problem.tmp
Output=$UniqueFolder/output.tmp
FormatOutput=$UniqueFolder/foutput.tmp
PrettyOutput=$UniqueFolder/prettyOutput.csv
Error=$UniqueFolder/error.tmp
Option=$Option' --threads 4 --stat '

Strategy=$2
case $Strategy in
    0) Option=$Option'--heuristic=Berkmin --berk-max=163';;
    1) Option=$Option'--restarts=100,1.5,1000 --local-restart --save-progress';;
    2) Option=$Option'--heuristic=VSIDS';;
    3) Option=$Option'--deletion=1,1,1 --reduce-on-restart';;
    4) Option=$Option' --heu=VSIDS --sat-pre=20,25,120 --trans-ext=dynamic --loops=no --loops-in-heu=0';;
    5) Option=$Option'--restarts=100,1.5,1000 --save-progress';;
    6) Option=$Option'--otfs=1 --recursive-str --reverse-arcs=2 --sat-pre=20,25,120,-1,2';;
    7) Option=$Option'--sat-pre=20,25,120';;
    8) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --backprop';;
    9) Option=$Option'--heu=VSIDS --sat-pre=20,25,120 --trans-ext=dynamic';;
    10) Option=$Option'--restarts=256 --save-progress';;
    11) Option=$Option'--heu=VSIDS --sat-pre=20,25,120 --trans-ext=integ';;
    #9) Option=$Option'--restarts=16000';;
    #4) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --initial-look=10 --restarts=no --recursive-str';;
    #7) Option=$Option'--restarts=100,1.5,1000 --local-restart';;
    #12) Option=$Option'--heuristic=Berkmin --berk-max=512';;
    #13) Option=$Option'--dinit=800,10000 --dsched=5000,1.1 --deletion=3,1.1,10000';;
    #14) Option=$Option'--sat-pre=20,25,120 --trans-ext=dynamic --initial-look=10 --restarts=no --recursive-str';;
    #15) Option=$Option'--restarts=256 --local-restart';;
    #16) Option=$Option'--eq=20 --backprop';;
    #18) Option=$Option'--heuristic=Berkmin --berk-max=512 --berk-huang';;
    #19) Option=$Option'--restarts=256';;
    #22) Option=$Option'--restarts=256 --local-restart --save-progress';;
    #23) Option=$Option'--heuristic=Bekmin --berk-ma';;
    #24) Option=$Option'--restarts=100,1.5,1000';;
esac


echo Setup: 
echo Option = $Option
echo Model = $Model
echo Data = $Data

echo
cat $Model > $Input
cat $Data >> $Input

echo ------------ Grounding: $Input to $Problem  ------------
cat $Input | gringo > $Problem
echo ------------ $Problem \> searching... \> $Output------------  

#cat $Problem | clasp $Option
cat $Problem | timeout $3 clasp $Option 2>>$Error| tee $Output #| grep 'Optimization\|Answer\|Reading\|solving\|clasp'
#echo $Option                
    
cat $Output | grep 'table' |  tail -n 1 | sed 's/ /\n/g' | sed 's/$/./g' | sort  > $FormatOutput
    
#echo ------------ csv Output : $PrettyOutput ------------ 
#echo
cat print.pl >> $FormatOutput
prolog -f $FormatOutput -g start -t halt 2>> $Error > $PrettyOutput
#cat $PrettyOutput
##column -t -s ';' $PrettyOutput
#echo

#echo
#echo ------------ errors while processing: $Error ------------ 
#cat $Error     
