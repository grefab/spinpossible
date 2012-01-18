ASP Solution to Spinpossible
============================


This project contains several parts: 

1) Several attempts to solve the spinpossible ridle with asp. The different
encodings are organizied in different subfolders.  
    * aps1: 
    * asp2: 
    * asp3: 
    ...     

2) Problem analysis written in c++. Here we exhausitvely analyze nxm boards. In
particular we analyze the idea to fix column and rows at the side as soon as
they are solved. The problem analyzer came up with counter examples.  Also, we
generate the most difficult 3x3 problems, namely those that one have exactly one
solution. Finally we completely categorize all boards with mxn<10 regarding
#solutions with 1..k steps. Interestingly we find many counter examples to the
inital idea that nxm boards need maximally m*n steps. 
