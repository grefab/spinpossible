#const n=3. 
#hide.
#show size/1. 
#show move/3. 
#show cell/5. 
#show upperLeft/3. 
#show isSingle/1. 
size(n). 
c(0..n-1). 
delta(-(n-1)..n-1).
k(1..9). 
s(K) :- k(K).
s(0). 
d(x;y).
e(x;y;p).
p(0..1). 

%switch(move,dim,from,to)
{ switch(K,D,A,B) : A <= B : c(B) } 1 :- c(A), k(K), d(D). 
:- d(D), c(B), k(K), 2 { switch(K,D,A,B) }. 
:- d(D), c(B), k(K), 2 { switch(K,D,A,A) }. 
:- switch(K,D,A,B), B - A > 1, not switch(K,D,A+1,B-1), k(K), d(D). 
:- switch(K,D,A,B), switch(K,D,C,E), k(K), d(D), A <= B, C <= E, A < C, B < E. 
switch(K,D,B,A) :- switch(K,D,A,B), A < B. 

%update
cell(K+1,x,X2,Y2,X1-X2+V) :- 
        cell(K,x,X1,Y1,V), 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2).

cell(K+1,y,X2,Y2,Y1-Y2+V) :- 
        cell(K,y,X1,Y1,V), 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2).

cell(K+1,p,X2,Y2,1-P) :- 
        cell(K,p,X1,Y1,P), 
        switch(K+1,x,X1,X2),
        switch(K+1,y,Y1,Y2).

cell(K+1,E,X,Y,V) :- 
        move(K+1),
        e(E), 
        cell(K,E,X,Y,V), 
        not move(K+1,X,Y).

move(K,X,Y) :- 
        switch(K,x,X,_),
        switch(K,y,Y,_).

move(K) :- switch(K,_,_,_). 

final(K) :- 
    s(K),
    { not cell(K,x,X,Y,0) : c(X;Y),
      not cell(K,y,X,Y,0) : c(X;Y),
      not cell(K,p,X,Y,0) : c(X;Y) } 0.

:- move(K), final(F), k(K), K > F. 
:- k(K), move(K+1), not move(K). 
:- { final(K) : s(K) } 0. 

#minimize[move(_)].

%% single ones in the end
isSingle(K) :- move(K), { move(K,X,Y) } 1. 
:- move(K;K+1), isSingle(K), not isSingle(K+1). 
%
%% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- move(K,X,Y), not move(K,X-1,Y), not move(K,X,Y-1). 
:- not isSingle(K+1), not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) > (n*(YY-1)+XX).  

%
%% containment
containing(K) :- move(K;K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).

%initilizing: 
cell(0,x,X,Y,DV) :- 
    init(X,Y,V), 
    DV = ((#abs(V)-1) #div n) - X.

cell(0,y,X,Y,DV) :- 
    init(X,Y,V), 
    DV = ((#abs(V)-1) #mod n) - Y.   

cell(0,p,X,Y,0) :- 
    init(X,Y,V), V > 0. 
cell(0,p,X,Y,1) :- 
    init(X,Y,V), V < 0. 

