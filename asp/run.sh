#!/bin/bash

Data=tmp/board.lp
Input=tmp/input.tmp
Problem=tmp/problem.tmp
Output=tmp/output.tmp
FormatOutput=tmp/foutput.tmp
PrettyOutput=tmp/prettyOutput.csv
Error=tmp/error.tmp
#Option=$Option' -t '$3' --time-limit='$2' '
Option=$Option' -t '$3' '


Option=$Option' --configuration='
Strategy=3
case $Strategy in
    0) Option=$Option'frumpy ';;
    1) Option=$Option'jumpy ';;    
    2) Option=$Option'handy ';;  
    3) Option=$Option'crafty ';; 
    4) Option=$Option'trendy ';; 
    5) Option=$Option'chatty ';; 
esac

cat model.lp > $Input
cat $Data >> $Input
cat $Input | gringo > $Problem

echo Option      : $Option
cat $Problem | clasp $Option 2>>$Error| tee $Output #| grep 'Optimization\|Answer\|Reading\|solving\|clasp'
cat $Output | grep 'state\|conf' |  tail -n 1 | sed 's/ /\n/g' | sed 's/$/./g' | sort  > $FormatOutput
    
cat print.pl >> $FormatOutput
prolog -f $FormatOutput -g start -t halt 2>> $Error > $PrettyOutput
cat $PrettyOutput
