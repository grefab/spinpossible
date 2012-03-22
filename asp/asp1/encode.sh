#!/bin/zsh

cat ../benchmark/mareike.txt | sed 's/ \([0-9-]\)/,\1/g' | sed 's/^/init(/g' | sed 's/$/)./g' > tmp/tmp.lp
cat template.lp >> tmp/tmp.lp
gringo --text tmp/tmp.lp
