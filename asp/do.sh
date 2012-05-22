#!/bin/zsh

./start.sh asp5 benchmark/l9_48_SAT.txt 4 > output_l9_48_SAT_asp5_t4.txt 
./start.sh asp5 benchmark/l8_48_UNSAT.txt 4 > output_l8_48_UNSAT_asp5_t4.txt 
./start.sh asp5 benchmark/l8_92_unique_SAT.txt 4 > output_l8_92_unique_SAT_asp5_t4.txt 

./start.sh asp4 benchmark/l9_48_SAT.txt 4 > output_l9_48_SAT_asp4_t4.txt 
./start.sh asp4 benchmark/l8_48_UNSAT.txt 4 > output_l8_48_UNSAT_asp4_t4.txt 
./start.sh asp4 benchmark/l8_92_unique_SAT.txt 4 > output_l8_92_unique_SAT_asp4_t4.txt 

./start.sh asp3 benchmark/l9_48_SAT.txt 4 > output_l9_48_SAT_asp3_t4.txt 
./start.sh asp3 benchmark/l8_48_UNSAT.txt 4 > output_l8_48_UNSAT_asp3_t4.txt 
./start.sh asp3 benchmark/l8_92_unique_SAT.txt 4 > output_l8_92_unique_SAT_asp3_t4.txt 


./start.sh asp5 benchmark/l9_48_SAT.txt 1 > output_l9_48_SAT_asp5_t1.txt 
./start.sh asp5 benchmark/l8_48_UNSAT.txt 1 > output_l8_48_UNSAT_asp5_t1.txt 
./start.sh asp5 benchmark/l8_92_unique_SAT.txt 1 > output_l8_92_unique_SAT_asp5_t1.txt 

./start.sh asp4 benchmark/l9_48_SAT.txt 1 > output_l9_48_SAT_asp4_t1.txt 
./start.sh asp4 benchmark/l8_48_UNSAT.txt 1 > output_l8_48_UNSAT_asp4_t1.txt 
./start.sh asp4 benchmark/l8_92_unique_SAT.txt 1 > output_l8_92_unique_SAT_asp4_t1.txt 

./start.sh asp3 benchmark/l9_48_SAT.txt 1 > output_l9_48_SAT_asp3_t1.txt 
./start.sh asp3 benchmark/l8_48_UNSAT.txt 1 > output_l8_48_UNSAT_asp3_t1.txt 
./start.sh asp3 benchmark/l8_92_unique_SAT.txt 1 > output_l8_92_unique_SAT_asp3_t1.txt 

#./start.sh sat benchmark/l9_48_SAT.txt > output_l9_48_SAT_sat.txt 
#./start.sh sat benchmark/l8_48_UNSAT.txt > output_l8_48_UNSAT_sat.txt 
#./start.sh sat benchmark/l8_92_unique_SAT.txt > output_l8_92_unique_SAT_sat.txt 

