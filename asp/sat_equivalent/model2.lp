#const final=8. % final move
#const n=3. % size of the table
size(n). 
#hide dom/4. 
#hide dom/6. 
#hide order/8. 
c(0..n-1). %coordinates  
k(1..final). %moves
s(0..final). %states(=inital + moves)
v(1..9). %values, 0 for parity

% choice variables 
1 { spin(K,X1,Y1,X2,Y2) } 1 :- k(K), c(X1;Y1;X2;Y2), X1 <= X2, Y1 <= Y2.
1 { state(K,X,Y,V) : v(V) } 1 :- c(X;Y), k(K).
0 { state(K,X,Y,0) } 1 :- c(X;Y), k(K).

% fixing final state (1)
state(final,X,Y,X*n+Y+1) :- c(X;Y).  
not state(final,X,Y,0) :- c(X;Y). 
not state(final,X,Y,Z) :- c(X;Y), Z = 1..n*n, Z != X*n+Y+1.

% equality constraints (2)
state(K,X,Y,V) :- s(K;K+1), state(K+1,X,Y,V), equal(K+1,X,Y).  
state(K+1,X,Y,V) :- s(K;K+1), state(K,X,Y,V), equal(K+1,X,Y).  

% transition constraints (3)
equal(K,X,Y) :- spin(K,X1,Y1,X2,Y2), X >= X1, X <= X2, Y >= Y1, Y <= Y2.

% (4)
state(K,X,Y,V) :-  s(K;K+1), v(V),
    state(K+1,X1+X2-X,Y1+Y2-Y,V),
    spin(K+1,X1,Y1,X2,Y2).

state(K+1,X1+X2-X,Y1+Y2-Y,V) :-  s(K;K+1), v(V), 
    state(K,X,Y,V),
    spin(K+1,X1,Y1,X2,Y2).

% (5)
not state(K,X,Y,0) :-  s(K;K+1), 
    state(K+1,X1+X2-X,Y1+Y2-Y,0), 
    spin(K+1,X1,Y1,X2,Y2). 

state(K+1,X1+X2-X,Y1+Y2-Y,0) :-  s(K;K+1), 
    not state(K,X,Y,0), 
    spin(K+1,X1,Y1,X2,Y2). 

% symmetry breaking constraints
:- s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), X2 < X3.
:- s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), Y2 < Y3.
:- s(K;K+1), spin(K,X1,Y1,X2,Y2), spin(K+1,X3,Y3,X4,Y4), X1 <= X3, X2 => X4, Y1 <= Y3. Y2 >= Y4.

% translation between sat variables and asp predicates: 
% x_i,j,k = state(K,X,Y,V) where k = K, i = <X,Y> and j = V
% e_i,k = equal(K,X,Y) where k = K, i = X,Y
% t_k,m = spin(K,X1,Y1,X2,Y2) where k = K, m = X1,Y1,X2,Y2
