#const final=9. % final move
#const n=3. % size of the table
v(-n*n..-1;1..n*n).  
c(1..n). %coordinates  
k(1..final). %moves
size(n). 

% choice variables 
{ spin(K,X1,Y1,X2,Y2) : X1 > 1 : X1 <= X2 : Y1 <= Y2 : c(X1;X2;Y1;Y2) } 1  :- k(K).  

% state update wrt. spin
state(K+1,X1+X2-X,Y1+Y2-Y,-V) :- 
    state(K,X,Y,V), 
    spin(K+1,X1,Y1,X2,Y2), 
    X1 <= X, X <= X2, Y1 <= Y, Y <= Y2.

% state update outside spin
move(K,X1..X2,Y1..Y2) :- spin(K,X1,Y1,X2,Y2).
           
state(K+1,X,Y,V) :- 
    k(K+1),
    state(K,X,Y,V), 
    not move(K+1,X,Y). 

% initial state
state(0,X,Y,V) :- init(X,Y,V). 

% final state
:- not state(final,X,Y,V), V = (n*(X-1)+Y), c(X;Y). 

% optimization
move(K) :- move(K,_,_).
:- K>1, move(K), not move(K-1). 
#minimize[move(_,_,_)@1].
#minimize[move(_)@2].

% symmetry breaking constraints
:-  k(K+1), spin(K+1,X1,Y1,X2,Y2), spin(K,X3,Y3,X4,Y4), X2 < X3.
:-  k(K+1), spin(K+1,X1,Y1,X2,Y2), spin(K,X3,Y3,X4,Y4), Y2 < Y3.
:-  k(K+1), spin(K+1,X1,Y1,X2,Y2), spin(K,X3,Y3,X4,Y4), 
    X1 <= X3, X2 >= X4, Y1 <= Y3, Y2 >= Y4.

% redundant
:- c(X;Y), k(K), 2 { state(K,X,Y,V) }.
:- k(K), not 9 { state(K,X,Y,V) } 9. 
:- state(K,X,Y,V), state(K,X,Y,-V). 
:- state(K,X,Y,V), state(K+1,X,Y,V), move(K+1,X,Y). 
