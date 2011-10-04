#!/bin/zsh
echo gregor
#for x in {0..24}; do echo $x; ./run.sh data/gregor8.lp $x 300 >> output/output9.txt; done
echo mareike
#for x in {0..24}; do echo $x; ./run.sh data/mareike.lp $x 600 >> output/output9.txt; done

# 100 randomly generated puzzles
for p in data/gen/*; 
do
   echo $p
   for x in {0..24}; 
   do
       echo $x
      ./run.sh $p $x 300 >> output/output_gen.txt ;
   done;
done;
