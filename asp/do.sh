#!/bin/zsh

#for x in ../sat/tmp/*;
#do 
#    clasp --heu=VSIDS --stat $x >> output7.txt;
#done


#./start.sh  sat benchmark/b9_50_SAT.txt > output_b9_50_SAT_sat.txt 
#./start.sh asp3 benchmark/b9_50_SAT.txt > output_b9_50_SAT_asp3.txt 
./start.sh asp4 benchmark/l9_48_SAT.txt > output_b9_50_SAT_asp4.txt 

#./start.sh  sat benchmark/b9_50_UNSAT.txt > output_b9_50_UNSAT_sat.txt 
#./start.sh asp3 benchmark/b9_50_UNSAT.txt > output_b9_50_UNSAT_asp3.txt 
./start.sh asp4 benchmark/l8_48_UNSAT.txt > output_b9_50_UNSAT_asp4.txt 

#./start.sh  sat benchmark/unique_8.txt > output_unique_8_sat.txt 
#./start.sh asp3 benchmark/unique_8.txt > output_unique_8_asp3.txt 
./start.sh asp4 benchmark/l8_92_unique_SAT.txt > output_unique_8_asp4.txt 
