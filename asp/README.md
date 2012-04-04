ASP Solution to Spinpossible
============================


This project contains several parts: 

Different Encodings
-------------------

Several attempts to solve the spinpossible puzzle with ASP. The different encodings are organizes in different sub
folders.  
* aps1: 
* asp2: 
* asp3: 
* asp4: 
* asp5: 
* sat-equivalent:

The Benchmarks are in benchmark/. There are currently the following benchmarks available. 

There is a script start.sh that is called with the encoding and the benchmark set. 

    ./start.sh asp1 benchmark/b9_50_UNSAT.txt

2) Problem analysis written in c++. Here we exhaustively analyze nxm boards. In particular we analyze the idea to fix
column and rows at the side as soon as they are solved. The problem analyzer came up with counter examples.  Also, we
generate the most difficult 3x3 problems, namely those that one have exactly one solution. Finally we completely
categorize all boards with mxn<10 regarding #solutions with 1..k steps. Interestingly we find many counter examples to
the inital idea that nxm boards need maximally m*n steps. 
