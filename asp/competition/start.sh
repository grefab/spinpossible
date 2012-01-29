#!/bin/zsh

while read L; do
    cat template.pl > tmp/problem.pl

    echo ${L} | sed 's/\(.\)$/,\1)./g' |
        sed 's/\([1-9]\)\1/-\1/g' | 
        sed 's/\([0-9]\)\([0-9-]\)/\1,\2/g' | 
        sed 's/\([0-9]\)\([0-9-]\)/\1,\2/g' |
        sed 's/^/problem(/g' >> tmp/problem.pl
    ./run.sh tmp/problem.pl 17 20 
done
