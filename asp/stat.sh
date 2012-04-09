#!/bin/zsh

cat $1 | sed 's/^Time        : [0-9]*.[0-9]*s (Solving: [0-9]*.[0-9]*s 1st Model: \([0-9]*\).*/\1/g' > numbers.txt

sum=0; 
while read num ;
do 
    sum=$(($sum + $num)); 
done < numbers.txt ;

echo $sum
