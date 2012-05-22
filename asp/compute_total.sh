#!/bin/zsh

mkdir -p tmp
tmp=tmp/numbers.tmp

# compute number of problems
echo number of problems: 
cat $1 | grep '^c* *Time' | wc -l 

# comput number of satisfiable
echo number of satisfiable: 
cat $1 | grep '^SATISFIABLE' | wc -l 
echo number of unsatisfiable: 
cat $1 | grep '^UNSATISFIABLE' | wc -l 

# compute total time
echo time
cat $1 | grep '^c* *Time' | sed 's/^c* *Time *: \([0-9]*.[0-9]*\)s (Solving: [0-9]*.[0-9]*s 1st Model: \([0-9]*\).*/\1/g' > \
$tmp

sum=0; 
while read num ;
do 
    sum=$(($sum + $num)); 
done < $tmp ;

echo $sum "s"


# compute total conflicts
cat $1 | grep '^c* *Conflicts' | sed 's/^c* *Conflicts *: \([0-9]*\).*/\1/g' > \
$tmp

sum=0; 
while read num ;
do 
    sum=$(($sum + $num)); 
done < $tmp ;
                   
echo $sum "conflicts"
