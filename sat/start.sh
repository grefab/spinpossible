#!/bin/zsh

mkdir -p tmp
I=1

cat $1 | while read X 
do
    echo $X;
    echo $I;
    echo $X | xargs ./encode > tmp/p$I.cnf
    I=$((I+1));
done
