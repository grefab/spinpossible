#!/bin/zsh

for x in *
do 
    if [[ -d $x ]];
    then cd $x; 
        for y in *.cnf
        do 
            minisat22 $y 1>> output.txt
        done;
    cd -;
    fi;
done

