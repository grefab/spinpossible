#!/bin/zsh


./start.sh asp5 benchmark/l9_48_SAT.txt > output_l9_48_SAT_asp5.txt 
./start.sh asp5 benchmark/l8_48_UNSAT.txt > output_l8_48_UNSAT_asp5.txt 
./start.sh asp5 benchmark/l8_92_unique_SAT.txt > output_l8_92_unique_SAT_asp5.txt 

#./start.sh asp4 benchmark/l9_48_SAT.txt > output_l9_48_SAT_asp4.txt 
#./start.sh asp4 benchmark/l8_48_UNSAT.txt > output_l8_48_UNSAT_asp4.txt 
#./start.sh asp4 benchmark/l8_92_unique_SAT.txt > output_l8_92_unique_SAT_asp4.txt 

./start.sh asp3 benchmark/l9_48_SAT.txt > output_l9_48_SAT_asp3.txt 
./start.sh asp3 benchmark/l8_48_UNSAT.txt > output_l8_48_UNSAT_asp3.txt 
./start.sh asp3 benchmark/l8_92_unique_SAT.txt > output_l8_92_unique_SAT_asp3.txt 

./start.sh sat benchmark/l9_48_SAT.txt > output_l9_48_SAT_sat.txt 
./start.sh sat benchmark/l8_48_UNSAT.txt > output_l8_48_UNSAT_sat.txt 
./start.sh sat benchmark/l8_92_unique_SAT.txt > output_l8_92_unique_SAT_sat.txt 

