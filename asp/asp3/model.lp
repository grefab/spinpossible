#const final=9.
#const n=3. 
size(n). 
c(0..n-1). 
k(1..final). 
v(0..n-1). 
s(K) :- k(K).
s(0). 
d(x;y).

% switch(step,dim,from, to)
{ spin_a(K,D,A) : c(A) } 1 :- k(K), d(D). 
{ spin_b(K,D,B) : c(B) } 1 :- k(K), d(D). 

spin(K) :- spin_a(K,_,_). 
spin(K) :- spin_b(K,_,_). 

:- spin_a(K,D,A), spin_b(K,D,B), A > B.

turn(x,A,B,A,B) :- c(A;B). 
turn(y,A,B,B,A) :- c(A;B).

equal(K,X,Y) :- 
    c(X;Y), k(K), 
    not spin(K). 

equal(K,X,Y) :-
    spin_a(K,D,T), 
    c(A;B), 
    A < T, 
    turn(D,A,B,X,Y). 

equal(K,X,Y) :-
    spin_b(K,D,T), 
    c(A;B), 
    T < A, 
    turn(D,A,B,X,Y). 

spin_d(K,D,A+B) :- 
    spin_a(K,D,A), 
    spin_b(K,D,B),
    A <= B. 

state(K+1,D,X,Y,V) :- 
    k(K+1),
    equal(K+1,X,Y), 
    state(K,D,X,Y,V). 

state(K+1,D,DX-X,DY-Y,V) :- 
    k(K+1), c(DX-X;DY-Y),
    not equal(K+1,X,Y), 
    state(K,D,X,Y,V), 
    spin_d(K+1,x,DX),
    spin_d(K+1,y,DY). 

parity(K+1,X,Y) :- 
    k(K+1),
    equal(K+1,X,Y), 
    parity(K,X,Y). 

parity(K+1,DX-X,DY-Y) :- 
    s(K+1;K), c(DX-X;DY-Y;X;Y),
    not equal(K+1,X,Y), 
    not parity(K,X,Y), 
    spin_d(K+1,x,DX),
    spin_d(K+1,y,DY). 


%redundent
:- v(T), d(D), s(K), not n { state(K,D,X,Y,T) } n. 
:- c(X;Y), d(D), s(K), 2 { state(K,D,X,Y,V) : v(V) }. 
:- K>1, spin(K), not spin(K-1). 


% final state
:- not state(final,x,X,Y,X), c(X;Y).
:- not state(final,y,X,Y,Y), c(X;Y).
:- parity(final,X,Y), c(X;Y).

#minimize[spin(_)].

%% initial 
pos(V,V) :- V = 1..9. 
pos(-V,V) :- V = 1..9.
state(0,x,X,Y,T) :- init(X,Y,V), pos(V,VV), T = (VV-1)/n. 
state(0,y,X,Y,T) :- init(X,Y,V), pos(V,VV), T = (VV-1) #mod n. 
parity(0,X,Y) :- init(X,Y,V), V < 0. 

% symmetry breaking

:- spin_a(K,D,A), spin_b(K+1,D,B), B < A. % disjoint
:- spin_a(K,x,XA1), spin_b(K,x,XB1),
   spin_a(K+1,x,XA2), spin_b(K+1,x,XB2),
   spin_a(K,y,YA1), spin_b(K,y,YB1),
   spin_a(K+1,y,YA2), spin_b(K+1,y,YB2),
   XA1 <= XB1, XA2 <= XB2, YA1 <= YB1, YA2 <= YB2, 
   XA1 >= XA2, XB1 <= XB2, YA1 >= YA2, YB1 <= YB2.
