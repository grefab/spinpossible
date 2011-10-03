#!/bin/zsh
echo gregor
for x in {1..12}; do echo $x; ./run.sh data/gregor8.lp $x 100 >> output/output3.txt; done

echo mareike
for x in {1..12}; do echo $x; ./run.sh data/mareike.lp $x 1000 >> output/output4.txt; done
