#const final=8. % final move
#const n=3. % size of the table
size(n). 
c(0..n-1).  
k(1..final). 
s(0..final). 

% choice variables 
1 { move(K,X1,Y1,X2,Y2) : Y1 <= Y2 : X1 <= X2 : c(X1;X2;Y1;Y2) } 1 :- k(K).

% fixing final state
:- c(X;Y), not state(final,X,Y,X*n+Y+1).  % (1)
:- c(X;Y), state(final,X,Y,0).  % (1)
:- c(X;Y), Z = 1..n*n, state(final,X,Y,Z), Z != X*n+Y+1. % (1)

% equality constraints 
state(K+1,X,Y,V) :- s(K), state(K,X,Y,V), not move(K+1,X,Y).  % (2)

% transition constraints
move(K,X1..X2,Y1..Y2) :- move(K,X1,Y1,X2,Y2). % (3)

state(K+1,X1+X2-X,Y1+Y2-Y,V) :-  s(K), state(K,X,Y,V), V > 0,  move(K+1,X1,Y1,X2,Y2), X1 <= X, X <= X2, Y1 <= Y, Y <= Y2. % (4)

state(K+1,X1+X2-X,Y1+Y2-Y,0) :-  s(K), c(X;Y), not state(K,X,Y,0), move(K+1,X1,Y1,X2,Y2), X1 <= X, X <= X2, Y1 <= Y, Y <= Y2. % (5)

% translation between sat variables and asp predicates: 
% x_i,j,k = state(K,X,Y,V) where k = K, i = X,Y and j = V
% e_i,k = not move(K,X,Y) where k = K, i = X,Y
% t_k,m = move(K,X1,Y1,X2,Y2) where k = K, m = X1,Y1,X2,Y2
