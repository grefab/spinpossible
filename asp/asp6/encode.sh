#!/bin/zsh

mkdir -p tmp

echo $1 | sed 's/ \([0-9-]\)/,\1/g' | sed 's/^/init(/g' | sed 's/$/)./g' > tmp/tmp.lp
cat template.lp >> tmp/tmp.lp
gringo --text tmp/tmp.lp
