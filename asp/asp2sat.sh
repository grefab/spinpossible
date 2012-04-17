#!/bin/bash

# $1: encoding
# $2: benchmark
# $3: output folder

mkdir -p $3

I=1

cat $2 | while read X 
do
        echo $X;
        echo $I;

        if [[ $I -lt 10 ]];
            then Output=$3/p0$I.cnf;
            else Output=$3/p$I.cnf;
        fi;

        echo $X | sed 's/ \([0-9-]\)/,\1/g' | sed 's/^/init(/g' | sed 's/$/)./g' > $3/tmp.lp
        cat $1/model.lp >> $3/tmp.lp
        cat $1/template.lp >> $3/tmp.lp
        lp2satpipe.sh $3/tmp.lp > $Output

        I=$((I+1));
done


