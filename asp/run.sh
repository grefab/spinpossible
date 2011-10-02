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
#Option=$Option' --threads 4 '

Strategy=x
case $Strategy in
    x) Option=$Option'--heuristic=Berkmin --berk-max=188 --threads=4';;
    0) Option=$Option'--heuristic=Berkmin --sat-prepro=-1,-1,-1,-1,2';;
    1) Option=$Option'--restart-on-model -r 4 --heuristic=Vsids --opt-heu ';;
    2) Option=$Option'--restart-on-model --save-progress -r 2 --heu=Vsids --opt-heu ';;
    3) Option=$Option'--restart-on-model --save-progress -r 64 --heu=Vsids --opt-heu ';;
    4) Option=$Option'--restart-on-model -r 32 --heuristic=Vsids --opt-heu ';;
    5) Option=$Option'--rand-freq=0.2 --restart-on-model --save-progress -r 32 --heu=Vsids --opt-heu ';;
    6) Option=$Option'--save-progress -r 32 --heuristic=Vsids --restart-on-model  ';;
    7) Option=$Option'--save-progress -r 32 --heuristic=Vsids --opt-heu ';;
    8) Option=$Option'--restart-on-model --sat-prepro -r 32 --heuristic=Vsids --opt-heu  ';;
    9) Option=$Option'--restart-on-model --save-progress -r 32 --heu=Berkmin --opt-heu ';;
    10) Option=$Option'--restart-on-model --save-progress --heu=Vmtf ';;
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
cat $Problem | clasp $Option 2>>$Error| tee $Output #| grep 'Optimization\|Answer\|Reading\|solving\|clasp'
#echo $Option                
    
cat $Output | grep 'table' |  tail -n 1 | sed 's/ /\n/g' | sed 's/$/./g' | sort  > $FormatOutput
    
#echo ------------ csv Output : $PrettyOutput ------------ 
#echo
cat print.pl >> $FormatOutput
prolog -f $FormatOutput -g start -t halt 2>> $Error > $PrettyOutput
cat $PrettyOutput
##column -t -s ';' $PrettyOutput
#echo

#echo
#echo ------------ errors while processing: $Error ------------ 
#cat $Error     
