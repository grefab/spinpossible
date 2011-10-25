#!/bin/zsh
#echo gregor
#for x in {0..24}; do echo $x; ./run.sh data/gregor8.lp $x 300 >> output/output9.txt; done
#echo mareike
#for x in {0..24}; do echo $x; ./run.sh data/mareike.lp $x 800 >> output/output9.txt; done

# 100 randomly generated puzzles
for x in {11,17}
do 
echo $x
   for p in data/gen_3/gen_*; 
   do
      echo $p
      ./run.sh $p $x 300 | grep -v 'size' >> output/strategy-$x-gen-500-fixed.txt ;
   done;
done;
       
