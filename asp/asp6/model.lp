#const n=3. % size of the table
size(n). 
#hide dom/4. 
#hide dom/6. 
c(1..n). %coordinates
v(1..n*n). %values
k(1..N) :- final(N). %moves
s(0..N) :- final(N). %states(=inital + moves)
d(x;y). %dimensions

% choice variables 
0 { move(D,K,X) } 1  :- d(D), k(K), c(C). 
0 { state(D,K,V,X) } 1 :- d(D), k(K), c(C), v(V).
0 { parity(K,V) } 1 :- d(D), k(K), v(V).

:- state(D,K,V,X1), state(D,K,V,X2), X1 != X2. 
:- d(D), k(K), c(X), 4 { state(D,K,V,X) }.

% restricts set of moves to rectangles
:- move(D,K,X1), move(D,K,X3), not move(D,K,X2), X1 < X2, X2 < X3.  

% fixing final state
:- c(X), final(N), not state(x,N,V,V/n).
:- c(Y), v(V), final(N), not state(y,N,V,V #mod n).
:-  v(V), final(N), not parity(N,V).


% equality constraints 
:-  state(D,K,V,X), 
    not move(D,K,X), 
    not state(D,K+1,V,X). 


% transition constraints
:-  s(K;K+1), 
    state(D,K,V,X), 
    move(D,K,X1), move(D,K,X2), not move(D,K,X3),
    X1 = X2+1, X1 != X3, X2 != X3, X != X3, 
    D != DD, state(DD,K,Y), state(DD,K+1,Y), 
    not state(D,K+1,V,X1+X2-X). 

% symmetry breaking constraints
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), X2 < X3.
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), Y2 < Y3.
:-  s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), 
    X1 <= X3, X2 >= X4, Y1 <= Y3, Y2 >= Y4.

% translation between sat variables and asp predicates: 
% x_i,j,k = state(K,X,Y,V) where k = K, i = <X,Y> and j = V
% e_i,k = equal(K,X,Y) where k = K, i = X,Y
% t_k,m = spin(K,X1,Y1,X2,Y2) where k = K, m = X1,Y1,X2,Y2
