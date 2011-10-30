#const n=3. % size of the table
#const final=1. % final move
size(n). 
c(0..n-1). 
k(1..final). 

% fixing final state
:- c(X;Y), not state(final,X,Y,X*n+Y+1).  % (1)
:- c(X;Y), Z = 1..n*n, state(final+1,X,Y,Z), Z != X*n+Y+1. % (1)

%equality constraints 
state(K+1,X,Y,V) :- k(K+1), state(K,X,Y,V), not move(K,X,Y).  % (2)

%transition constraints
1 { move(K,X1,Y1,X2,Y2) : Y1 <= Y2 : X1 <= X2 : c(X1;X2;Y1;Y2) } 1 :- k(K). % (3)
move(K,X1..X2,Y1..Y2) :- move(K,X1,Y1,X2,Y2). % (3)

state(K+1,X1+X2-X,Y1+Y2-Y,-V) :-  % (4), (5)
        k(K+1), 
        state(K,X,Y,V), 
        move(K+1,X1,Y1,X2,Y2), 
        X1 <= X, X <= X2, Y1 <= Y, Y <= Y2.
