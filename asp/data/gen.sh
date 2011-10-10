#!/bin/zsh
for x in {1..10}; do prolog -f generate.pl -g start -t halt 1>gen_4/gen_4_prob_$x.lp ; done
