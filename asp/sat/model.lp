#const n=3. % size of the table
size(n). 
#hide dom/4. 
#hide dom/6. 
c(0..n-1). %coordinates  
k(1..N) :- final(N). %moves
s(0..N) :- final(N). %states(=inital + moves)
v(1..n*n). %values, 0 for parity

dom(X1,Y1,X2,Y2) :- c(X1;Y1;X2;Y2), X1 <= X2, Y1 <= Y2. 
dom(X,Y,X1,Y1,X2,Y2) :- c(X;Y), dom(X1,Y1,X2,Y2), X1 <= X, X <= X2, Y1 <= Y, Y <= Y2.

% choice variables 
0 { spin(K,X1,Y1,X2,Y2) } 1  :- dom(X1,Y1,X2,Y2), k(K).
0 { state(K,X,Y,V) } 1 :- v(V), c(X;Y), k(K).
0 { state(K,X,Y,0) } 1 :- c(X;Y), k(K).
0 { equal(K,X,Y) } 1 :- c(X;Y), k(K).

:- k(K), not spin(K,X1,Y1,X2,Y2) : dom(X1,Y1,X2,Y2).

% redundant

:- state(K,X,Y,V), state(K,X,Y,VV), V != VV, V > 0, VV > 0.
:- state(K,X,Y,V), state(K,XX,Y,V), V > 0, X != XX. 
:- state(K,X,Y,V), state(K,X,YY,V), V > 0, Y != YY. 
:- state(K,X,Y,V), state(K,XX,YY,V), V > 0, Y != YY, X != XX. 
%:- k(K), not 9 { state(K,X,Y,V) : V > 0 } 9. 

% fixing final state
:-  c(X;Y), not state(N,X,Y,X*n+Y+1), final(N).  % (1)
:-  c(X;Y), state(N,X,Y,0), final(N).  % (1)
:-  c(X;Y), Z = 1..n*n, state(N,X,Y,Z), final(N), Z != X*n+Y+1. % (1)

% equality constraints 
:-  s(K;K+1), 
    state(K+1,X,Y,V), 
    not state(K,X,Y,V), 
    equal(K+1,X,Y).  % (2)

:-  s(K;K+1), 
    not state(K+1,X,Y,V), 
    state(K,X,Y,V), 
    equal(K+1,X,Y).  % (2)

:-  c(X;Y),
    not dom(X,Y,X1,Y1,X2,Y2), 
    not equal(K,X,Y), 
    spin(K,X1,Y1,X2,Y2). % (3)

:-  dom(X,Y,X1,Y1,X2,Y2), 
    equal(K,X,Y), 
    spin(K,X1,Y1,X2,Y2). % (3)

% transition constraints
:-  s(K;K+1), v(V),
    state(K+1,X1+X2-X,Y1+Y2-Y,V),
    not state(K,X,Y,V),
    spin(K+1,X1,Y1,X2,Y2),
    dom(X,Y,X1,Y1,X2,Y2). % (4)

:-  s(K;K+1), v(V), 
    not state(K+1,X1+X2-X,Y1+Y2-Y,V), 
    state(K,X,Y,V),
    spin(K+1,X1,Y1,X2,Y2),
    dom(X,Y,X1,Y1,X2,Y2). % (4)

:-  s(K;K+1), 
    state(K+1,X1+X2-X,Y1+Y2-Y,0), 
    state(K,X,Y,0), 
    spin(K+1,X1,Y1,X2,Y2), 
    dom(X,Y,X1,Y1,X2,Y2). % (5) 

:-  s(K;K+1), 
    not state(K+1,X1+X2-X,Y1+Y2-Y,0), 
    not state(K,X,Y,0), 
    spin(K+1,X1,Y1,X2,Y2), 
    dom(X,Y,X1,Y1,X2,Y2). % (5) 

% symmetry breaking constraints
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), X2 < X3.
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), Y2 < Y3.
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), 
    X1 <= X3, X2 >= X4, Y1 <= Y3, Y2 >= Y4.

% translation between sat variables and asp predicates: 
% x_i,j,k = state(K,X,Y,V) where k = K, i = <X,Y> and j = V
% e_i,k = equal(K,X,Y) where k = K, i = X,Y
% t_k,m = spin(K,X1,Y1,X2,Y2) where k = K, m = X1,Y1,X2,Y2
