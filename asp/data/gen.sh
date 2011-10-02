#!/bin/zsh
for x in {1..100}; do prolog -f generate.pl -g start -t halt 1>gen_prob_$x.lp ; done

