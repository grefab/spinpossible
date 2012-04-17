#!/bin/zsh

mkdir -p tmp
tmp=tmp/numbers.tmp

cat $1 | grep 'CPU' | sed 's/[^0-9]*\([0-9.]*\).*/\1/g' > $tmp

sum=0; 
while read num ;
do 
    sum=$(($sum + $num)); 
done < $tmp ;

cat $1 | grep 'CPU' | wc -l 
echo $sum
