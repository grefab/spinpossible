#!/bin/zsh

mkdir -p $2
I=1

cat $1 | while read X 
do
    echo $X;
    echo $I;
    if [[ $I -lt 10 ]];
    then echo $X | xargs ./encode > $2/p0$I.cnf;
    else echo $X | xargs ./encode > $2/p$I.cnf;
    fi;
    I=$((I+1));
done
