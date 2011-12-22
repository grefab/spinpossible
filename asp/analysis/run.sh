#!/bin/zsh

cp analysis.h backup.h
#echo 1x2
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 2/g' > analysis.h
#make
#echo 1x3
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 3/g' > analysis.h
#make
#echo 1x4
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 4/g' > analysis.h
#make
#echo 1x5
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 5/g' > analysis.h
#make                                                       
#echo 1x6
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 6/g' > analysis.h
#make                                                       
#echo 1x7
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 7/g' > analysis.h
#make                                                       
#echo 1x8
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 8/g' > analysis.h
#make                                                       
#echo 1x9
#cat backup.h | sed 's/define X ./define X 1/g' | sed 's/define Y ./define Y 9/g' > analysis.h
#make    
echo 2x2
cat backup.h | sed 's/define X ./define X 2/g' | sed 's/define Y ./define Y 2/g' > analysis.h
make
echo 2x3
cat backup.h | sed 's/define X ./define X 2/g' | sed 's/define Y ./define Y 3/g' > analysis.h
make
echo 2x4
cat backup.h | sed 's/define X ./define X 2/g' | sed 's/define Y ./define Y 4/g' > analysis.h
make
echo 3x3
cat backup.h | sed 's/define X ./define X 3/g' | sed 's/define Y ./define Y 3/g' > analysis.h
make                                                        



