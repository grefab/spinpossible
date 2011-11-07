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

dom(X1,Y1,X2,Y2) :- c(X1;Y1;X2;Y2), X1 <= X2, Y1 <= Y2. 
dom(X,Y,X1,Y1,X2,Y2) :- c(X;Y), dom(X1,Y1,X2,Y2), X1 <= X, X <= X2, Y1 <= Y, Y <= Y2.

% choice variables 
1 { move(K,X1,Y1,X2,Y2) : dom(X1,Y1,X2,Y2) } 1 :- k(K).
1 { state(K,X,Y,V) : v(V) } 1 :- c(X;Y), k(K).
0 { state(K,X,Y,0) } 1 :- c(X;Y), k(K).

% fixing final state
:- c(X;Y), not state(final,X,Y,X*n+Y+1).  % (1)
:- c(X;Y), state(final,X,Y,0).  % (1)
:- c(X;Y), Z = 1..n*n, state(final,X,Y,Z), Z != X*n+Y+1. % (1)

% equality constraints 
:- s(K;K+1), state(K+1,X,Y,V), not state(K,X,Y,V), not move(K+1,X,Y).  % (2)
:- s(K;K+1), not state(K+1,X,Y,V), state(K,X,Y,V), not move(K+1,X,Y).  % (2)

% transition constraints
move(K,X1..X2,Y1..Y2) :- move(K,X1,Y1,X2,Y2). % (3)

% (4)
:-  s(K;K+1), v(V),
    state(K+1,X1+X2-X,Y1+Y2-Y,V),
    not state(K,X,Y,V),
    move(K+1,X1,Y1,X2,Y2),
    dom(X,Y,X1,Y1,X2,Y2).

:-  s(K;K+1), v(V), 
    not state(K+1,X1+X2-X,Y1+Y2-Y,V), 
    state(K,X,Y,V),
    move(K+1,X1,Y1,X2,Y2),
    dom(X,Y,X1,Y1,X2,Y2).

% (5)
:-  s(K;K+1), 
    state(K+1,X1+X2-X,Y1+Y2-Y,0), 
    state(K,X,Y,0), 
    move(K+1,X1,Y1,X2,Y2), 
    dom(X,Y,X1,Y1,X2,Y2). 

:-  s(K;K+1), 
    not state(K+1,X1+X2-X,Y1+Y2-Y,0), 
    not state(K,X,Y,0), 
    move(K+1,X1,Y1,X2,Y2), 
    dom(X,Y,X1,Y1,X2,Y2). 
%

% symmetry breaking constraints
% spin 1,2 do not intersect, and 1 > 2
order(X11,Y11,X12,Y12,X21,Y21,X22,Y22) :- % non intersecting  
    dom(X11,Y11,X21,Y21), 
    dom(X12,Y12,X22,Y22), 
    X22 <=  X11, Y22 <=  Y11.

% spin 2 contains spin 1
order(X11,Y11,X12,Y12,X21,Y21,X22,Y22) :- 
    dom(X11,Y11,X21,Y21), 
    dom(X12,Y12,X22,Y22), 
    X12 <= X11, X21 <= X22, Y12 <= Y11, Y21 <= Y22. 

:- k(K;K+1), order(X11,Y11,X12,Y12,X21,Y21,X22,Y22), move(K,X11,Y11,X12,Y12), move(K+1,X21,Y21,X22,Y22).  


% translation between sat variables and asp predicates: 
% x_i,j,k = state(K,X,Y,V) where k = K, i = <X,Y> and j = V
% e_i,k = not move(K,X,Y) where k = K, i = X,Y
% t_k,m = move(K,X1,Y1,X2,Y2) where k = K, m = X1,Y1,X2,Y2
