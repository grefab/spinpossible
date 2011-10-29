#!/bin/zsh
#echo gregor
#for x in {0..24}; do echo $x; ./run.sh data/gregor8.lp $x 300 >> output/output9.txt; done
#echo mareike
#for x in {0..24}; do echo $x; ./run.sh data/mareike.lp $x 800 >> output/output9.txt; done

# 100 randomly generated puzzles
#for x in {17}
#do 
    echo $x
    for m in {model.lp,model-fixed.lp} 
    do
        echo $m
        for p in data/gen_3/gen_prob*
        do 
           echo $p;
           #./run.sh $p $x 300 $m | grep -v 'size' | tee - a output/out-$x-$m.txt | grep '^Time\|Optimization'
           ./run.sh $p 17 300 $m| grep -v 'size' >>  output/out-$x-$m.txt  
        done
    done;
#done;
       
