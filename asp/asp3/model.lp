#const n=3. % size of the table
size(n). 
c(1..n). %coordinates
v(1..n*n). %values
k(1..N) :- final(N). %moves
s(0..N) :- final(N). %states(=inital + moves)
d(x;y). %dimensions

% choice variables 
0 { move(D,K,C) } 1  :- d(D), k(K), c(C). 
0 { state(D,K,V,C) } 1 :- d(D), k(K), c(C), v(V).
0 { parity(K,V) } 1 :- k(K), v(V).

:-  d(D), k(K), not move(D,K,C) : c(C).

% redundant
:-  state(D,K,V,C1), state(D,K,V,C2), C1 != C2. 
% the only non clause cardinality constraint
:-  d(D), k(K), c(C), not 3 { state(D,K,V,C) } 3.

%% naive alternative to the cardinality constraint. 
%:-  d(D), k(K), c(C), 
%    state(D,K,V1,C), 
%    state(D,K,V2,C), 
%    state(D,K,V3,C), 
%    state(D,K,V4,C), 
%    V1 < V2, V2 < V3, V3 < V4.
%
%:-  d(D), k(K), c(C), 
%    v(V1;V2;V3;V4;V5;V6;V7),
%    not state(D,K,V1,C), 
%    not state(D,K,V2,C), 
%    not state(D,K,V3,C), 
%    not state(D,K,V4,C), 
%    not state(D,K,V5,C), 
%    not state(D,K,V6,C), 
%    not state(D,K,V7,C), 
%    V1 < V2, V2 < V3, V3 < V4, 
%    V4 < V5, V5 < V6, V6 < V7.

% restricts set of moves to rectangles
:-  c(C2), 
    C1 < C2, C2 < C3,
    move(D,K,C1), 
    move(D,K,C3), 
    not move(D,K,C2).

% fixing final state
:-  final(N), v(V), not state(x,N,V,((V-1) #div n)+1).
:-  final(N), v(V), not state(y,N,V,((V-1) #mod n)+1).
:-  final(N), parity(N,V).

% equality constraints 

:-  s(K;K+1), 
    state(D,K,V,C), 
    not move(D,K+1,C), 
    not state(D,K+1,V,C). 

:-  s(K;K+1), 
    not parity(K,V), 
    state(D,K,V,C),
    not move(D,K+1,C),
    parity(K+1,V). 

:-  s(K;K+1), 
    parity(K,V), 
    state(D,K,V,C),
    not move(D,K+1,C),
    not parity(K+1,V). 
                                        
:-  s(K;K+1), 
    state(D,K,V,C),
    not parity(K,V), 
    not parity(K+1,V),
    not state(D,K+1,V,C).

:-  s(K;K+1), 
    state(D,K,V,C),
    parity(K,V), 
    parity(K+1,V),
    not state(D,K+1,V,C).




% transition constraints

% the following two clauses say that 
% if a number is in C1,C2 then the parity 
% needs to change.
:-  s(K;K+1), 
    parity(K,V), 
    state(D,K,V,C1),
    state(DD,K,V,C2),
    D < DD,
    move(D,K+1,C1),
    move(DD,K+1,C2),
    parity(K+1,V). 

:-  s(K;K+1), 
    not parity(K,V), 
    state(D,K,V,C1),
    state(DD,K,V,C2),
    D < DD,
    move(D,K+1,C1),
    move(DD,K+1,C2),
    not parity(K+1,V). 

% 1 row/column touched
:-  s(K;K+1), 
    c(C2;C3),
    state(D,K,V,2), 
    not move(D,K+1,1), not move(D,K+1,3),
    not state(D,K+1,V,2). 

:-  s(K;K+1), 
    c(C2;C3),
    state(D,K,V,C), 
    not move(D,K+1,2),
    C != 2,
    not state(D,K+1,V,C). 

% 2 row/column touched
:-  s(K;K+1), 
    c(C3),
    state(D,K,V,C), 
    move(D,K+1,C1), move(D,K+1,C2), not move(D,K+1,C3),
    C1 = C2+1, C1 != C3, C2 != C3, C != C3, 
    parity(K,V), not parity(K+1,V), 
    not state(D,K+1,V,C1+C2-C). 

:-  s(K;K+1), 
    c(C3),
    state(D,K,V,C), 
    move(D,K+1,C1), move(D,K+1,C2), not move(D,K+1,C3),
    C1 = C2+1, C1 != C3, C2 != C3, C != C3, 
    not parity(K,V), parity(K+1,V), 
    not state(D,K+1,V,C1+C2-C). 

% 3 row/column touched
:-  s(K;K+1), 
    state(D,K,V,C), 
    move(D,K+1,C1), move(D,K+1,C2), move(D,K+1,C3),
    not parity(K,V), parity(K+1,V), 
    C1 < C2, C2 < C3,
    not state(D,K+1,V,C1+C3-C). 

:-  s(K;K+1), 
    state(D,K,V,C), 
    move(D,K+1,C1), move(D,K+1,C2), move(D,K+1,C3),
    parity(K,V), not parity(K+1,V), 
    C1 < C2, C2 < C3,
    not state(D,K+1,V,C1+C3-C). 

% symmetry breaking constraints
:-  move(D,K,C1),
    not move(D,K,C1+1),
    not move(D,K+1,C2-1),
    move(D,K+1,C2),
    C1 < C2.
  
:-  not move(x,K,X1-1),
    move(x,K,X1),
    move(x,K,X2),
    not move(x,K,X2+1),
    X1 <= X2,
    not move(y,K,Y1-1),
    move(y,K,Y1),
    move(y,K,Y2),
    not move(y,K,Y2+1),
    Y1 <= Y2,
    not move(x,K+1,X3-1),
    move(x,K+1,X3),
    move(x,K+1,X4),
    not move(x,K+1,X4+1),
    X3 <= X4,
    not move(y,K+1,Y3-1),
    move(y,K+1,Y3),
    move(y,K+1,Y4),
    not move(y,K+1,Y4+1),
    Y3 <= Y4,
    X1 <= X3, X2 >= X4, Y1 <= Y3, Y2 >= Y4.
%%
% An alternative way to state that if 
% a number is swapped, then orientation needs to 
% change. 
% But it is indeed very expensive (100K)
%:-  s(K;K+1), 
%    state(D,K,V1,C),
%    state(D,K,V2,C),
%    state(D,K,V3,C),
%    V1 != V2, V2 != V3, V1 != V3,
%    move(D,K+1,C),
%    parity(K,V1), parity(K+1,V1),
%    parity(K,V2), parity(K+1,V2),
%    parity(K,V3), parity(K+1,V3).
%
%:-  s(K;K+1), 
%    state(D,K,V1,C),
%    state(D,K,V2,C),
%    state(D,K,V3,C),
%    V1 != V2, V2 != V3, V1 != V3,
%    move(D,K+1,C),
%    not parity(K,V1), not parity(K+1,V1),
%    parity(K,V2), parity(K+1,V2),
%    parity(K,V3), parity(K+1,V3).
%
%:-  s(K;K+1), 
%    state(D,K,V1,C),
%    state(D,K,V2,C),
%    state(D,K,V3,C),
%    V1 != V2, V2 != V3, V1 != V3,
%    move(D,K+1,C),
%    not parity(K,V1), not parity(K+1,V1),
%    not parity(K,V2), not parity(K+1,V2),
%    parity(K,V3), parity(K+1,V3).
%
%:-  s(K;K+1), 
%    state(D,K,V1,C),
%    state(D,K,V2,C),
%    state(D,K,V3,C),
%    V1 != V2, V2 != V3, V1 != V3,
%    move(D,K+1,C),
%    not parity(K,V1), not parity(K+1,V1),
%    not parity(K,V2), not parity(K+1,V2),
%    not parity(K,V3), not parity(K+1,V3).
%
%:-  s(K;K+1), v(V),
%    move(,K+1,1),
%    move(,K+1,2),
%    move(,K+1,3),
%    not parity(K,V), 
%    not parity(K+1,V).
%
%:-  move(x,K+1,1),
%    move(x,K+1,2),
%    move(x,K+1,3),
%    move(y,K+1,1),
%    move(y,K+1,2),
%    move(y,K+1,3),
%    parity(K,V), 
%    parity(K+1,V).
