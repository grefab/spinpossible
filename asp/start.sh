#!/bin/zsh

echo running encoding $1

cat $2 |
while read L; do
    cd $1
    rm -fr tmp
    mkdir -p tmp
    echo 
    echo board ${L}
    echo
    ./encode.sh ${L} > tmp/board.lp
    ../run.sh 26 10000
    cd -
done
