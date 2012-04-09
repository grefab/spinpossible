#!/bin/zsh

tmp=tmp/numbers.tmp

cat $1 | grep '^Time' | sed 's/^Time        : [0-9]*.[0-9]*s (Solving: [0-9]*.[0-9]*s 1st Model: \([0-9]*\).*/\1/g' > \
$tmp

sum=0; 
while read num ;
do 
    sum=$(($sum + $num)); 
done < $tmp ;

echo $sum
