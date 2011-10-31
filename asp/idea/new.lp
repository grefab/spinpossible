#const n=3. 
c(0..n-1). 
v(-(n-1)..(n-1)).
t(turn(X,Y,T)) :- X=0..1, Y=0..1, T=0..1. 
        
next(turn(TX,TY,T),X1,Y1,X2,Y2) :- % 8*n^2*m^2
    c(X1;Y1;X2;Y2),
    turn(T,X1,Y1,A1,B1),
    turn(T,TX,TY,TA,TB),
    inc(TB,DB),
    mod(B1+DB,B2),
    div(B1+DB,D),
    inc(TA,DA),
    A2 = A1 + DA*D,
    turn(T,A2,B2,X2,Y2).

div(-1,1).
div(C,0) :- c(C).  
div(n,1).

mod(-1,n-1).
mod(C,C) :- c(C). 
mod(n,0).

inc(0,1).
inc(1,-1).

turn(0,X,Y,X,Y) :- c(X;Y). 
turn(1,X,Y,Y,X) :- c(X;Y). 

first(turn(X,Y,T),X*(n-1),Y*(n-1)) :- t(turn(X,Y,T)).

%state(0,0,1).
%state(0,1,1).
%state(0,2,1).
%state(1,0,1).
%state(1,1,2).
%state(1,2,0).
%state(2,0,1).
%state(2,1,0).
%state(2,2,1).
%{ state(X,Y,V) }:- c(X;Y), V=1..5.

{ state(x,X,Y,V) } :- c(X;Y), v(V), X+V<n, 0 <= X+V.
{ state(y,X,Y,V) } :- c(X;Y), v(V), Y+V<n, 0 <= Y+V.
{ parity(X,Y) } :- c(X;Y).

possible(X1,Y1,X2,Y2) :- 
    invert(TX,X1,A),
    invert(TY,Y1,B),
    turn(T,A,B,X2,Y2).

transform(t(TX,TY,T),X1,Y1,X2,Y2) :-
    invert(TX,X1,A),
    invert(TY,Y1,B),
    turn(T,A,B,X2,Y2).

invert(0,C,C) :- c(C). 
invert(1,C,n-1-C) :- c(C). 

transformDelta(turn(TV,TW,T),V1,W1,V2,W2) :-
    v(V1;W1;V2;W2),
    t(turn(TV,TW,T)),
    invertDelta(T,V1,A),
    invertDelta(T,W1,B),
    turnDelta(T,A,B,V2,W2).

invertDelta(0,V,V) :- v(V;W).
invertDelta(1,V,W) :- v(V;W), W = (-1)*V.

turnDelta(0,V,W,V,W) :- v(V;W). 
turnDelta(1,V,W,W,V) :- v(V;W). 

equalParity(X1,Y1,X2,Y2) :- 
    possible(X1,Y1,X2,Y2),
    parity(X1,Y1),
    parity(X2,Y2).

equalParity(X1,Y1,X2,Y2) :- 
    possible(X1,Y1,X2,Y2),
    not parity(X1,Y1),
    not parity(X2,Y2).

less(X1,Y1,X2,Y2) :- 
    possible(X1,Y1,X2,Y2),
    not parity(X1,Y1),
    parity(X2,Y2).

less(T1,T2,X1,Y1,X2,Y2) :- 
    possible(X1,Y1,X2,Y2),
    state(x,X1,Y1,VX1),
    state(y,X1,Y1,VY1),
    state(x,X2,Y2,VX2),
    state(y,X2,Y2,VY2),
    transformDelta(T1,VX1,VY1,WX1,WY1),
    transformDelta(T2,VX2,VY2,WX2,WY2),
    equalParity(X1,Y1,X2,Y1),
    WX1 < WX2. 
%
%less(T1,T2,X1,Y1,X2,Y2) :- 
%    state(x,X1,Y1,VX1),
%    state(y,X1,Y1,VY1),
%    state(x,X2,Y2,VX2),
%    state(y,X2,Y2,VY2),
%    transformDelta(T1,VX1,VY1,WX1,WY1),
%    transformDelta(T2,VX2,VY2,WX2,WY2),
%    equalParity(X1,Y1,X2,Y1),
%    WX1 = WX2,
%    WY1 < WY2. 

%equal(T1,T2,X1,Y1,X2,Y2) :- 
%    state(x,X1,Y1,VX1),
%    state(y,X1,Y1,VY1),
%    state(x,X2,Y2,VX2),
%    state(y,X2,Y2,VY2),
%    transformDelta(T1,VX1,VY1,WX1,WY1),
%    transformDelta(T2,VX2,VY2,WX2,WY2),
%    equalParity(X1,Y1,X2,Y1),
%    WX1 = WX2,
%    WY1 = WY2. 


%
%equal(T1,T2,X1,Y1,X2,Y2) :- 
%    state(X1,Y1,V),
%    state(X2,Y2,V).
%
%
%ord(T1,T2):-
%    first(T1,X1,Y1),
%    first(T2,X2,Y2),
%    ord(T1,T2,X1,Y1,X2,Y2).
%
%ord(T1,T2,X1,Y1,X2,Y2):-
%    t(T1;T2),
%    less(T1,T2,X1,Y1,X2,Y2).
%
%ord(T1,T2,X1,Y1,X2,Y2):- % 8*8*3n^2*3m^2*v
%    t(T1;T2),
%    equal(T1,T2,X1,Y1,X2,Y2),
%    next(T1,X1,Y1,X12,Y12),
%    next(T2,X2,Y2,X22,Y22),
%    ord(T1,T2,X12,Y12,X22,Y22).
%    
%isNextTurn(T2) :- ord(T1,T2). 
%minimalTurns(T) :- t(T), not isNextTurn(T). 
%minimalNext(turn(X1,Y1,T1),turn(X2,Y2,T2)) :- 
%            minimalTurns(turn(X1,Y1,T1);turn(X2,Y2,T2)),
%            X1*4+Y1*2+T1 < X2*4+Y2*2+T2.
%
%isNextMinimal(T2) :- t(T1;T2), minimalNext(T1,T2).
%minimumTurn(T) :- minimalTurns(T), not isNextMinimal(T). 
