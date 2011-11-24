#const final=8. 
#const n=3. 
#hide.
#show size/1. 
#show move/3. 
#show state/5. 
#show parity/3. 
#show upperLeft/3. 
#show isSingle/1. 
size(n). 
c(0..n-1). 
delta(-(n-1)..n-1).
k(1..final). 
s(K) :- k(K).
s(0). 
d(x;y).

%switch(move,dim,from,to)
{ switch(K,D,A,B) : A <= B : c(B) } 1 :- c(A), k(K), d(D). 
switch(K,D,B,A) :- switch(K,D,A,B), A < B. 

:- d(D), c(B), k(K), 2 { switch(K,D,A,B) }. 
:- d(D), k(K), 2 { switch(K,D,A,A) }. 
:- switch(K,D,A,B), B - A > 1, not switch(K,D,A+1,B-1), k(K), d(D). 
:- switch(K,D,A,B), switch(K,D,C,E), k(K), d(D), A <= B, C <= E, A < C, B < E. 

%update
state(K+1,x,X2,Y2,X1-X2+V) :- 
        state(K,x,X1,Y1,V), 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2).

state(K+1,y,X2,Y2,Y1-Y2+V) :- 
        state(K,y,X1,Y1,V), 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2).

parity(K+1,X2,Y2) :- 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2),
        s(K),
        not parity(K,X1,Y1).

parity(K+1,X,Y) :- 
        k(K+1),
        not move(K+1,X,Y), 
        parity(K,X,Y). 

state(K+1,E,X,Y,V) :- 
        move(K+1),
        state(K,E,X,Y,V), 
        not move(K+1,X,Y).

move(K,X,Y) :- 
        switch(K,x,X,_),
        switch(K,y,Y,_).

move(K) :- switch(K,_,_,_). 

final(K) :- 
    s(K),
    { not state(K,x,X,Y,0) : c(X;Y),
      not state(K,y,X,Y,0) : c(X;Y),
      parity(K,X,Y) : c(X;Y) } 0.

:- move(K), final(F), k(K), K > F. 
:- k(K), move(K+1), not move(K). 
:- { final(K) : s(K) } 0. 

#minimize[move(_)].

%
%% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- move(K,X,Y), not move(K,X-1,Y), not move(K,X,Y-1). 
:- not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) > (n*(YY-1)+XX).  

% containment
containing(K) :- move(K;K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).

%initializing: 
state(0,x,X,Y,DV) :- 
    init(X,Y,V), 
    DV = ((#abs(V)-1) #div n) - X.

state(0,y,X,Y,DV) :- 
    init(X,Y,V), 
    DV = ((#abs(V)-1) #mod n) - Y.   

parity(0,X,Y) :- 
    init(X,Y,V), V < 0. 

