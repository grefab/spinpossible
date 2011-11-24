#!/bin/zsh
for x in {00..10}; do prolog -f generate.pl -g start -t halt 1>gen_4/prob_$x.lp ; done
