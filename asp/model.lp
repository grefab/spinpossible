#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..9). 
#hide. 
#show move/5. 
#show move/3. 
#show table/4. 

{ move(K,X,Y,R,D) : c(X;Y) : R=0..n-X : D=0..n-Y } 1 :- k(K). 
move(K,X..X+R,Y..Y+D) :- move(K,X,Y,R,D).
move(K) :- move(K,_,_,_,_).

switch(X,-X) :- v(X). 
switch(K,X,Y,X+R,Y+D) :- move(K,X,Y,R,D). 
switch(K,X1+1,Y1,X2-1,Y2) :-
    switch(K,X1,Y1,X2,Y2),
    move(K,X1+1,Y1),
    move(K,X2-1,Y2). 

switch(K,X1,Y1+1,X2,Y2-1) :-
    switch(K,X1,Y1,X2,Y2),
    move(K,X1,Y1+1),
    move(K,X2,Y2-1). 

table(K+1,X2,Y2,V2) :- 
    move(K+1),
    table(K,X1,Y1,V1), 
    switch(K+1,X1,Y1,X2,Y2), 
    switch(V1,V2). 

table(K+1,X,Y,V) :- 
    move(K+1),
    table(K,X,Y,V), 
    not move(K+1,X,Y). 

table(0,X,Y,V) :- init(X,Y,V). 

ok(K,X,Y) :-  V = (n*(Y-1)+X), table(K,X,Y,V).

final(M) :- k(M), M = #max[move(K)=K:k(K)].
:- K>1, move(K), not move(K-1). 
:- final(K), not ok(K,X,Y),  c(X;Y). 
:- not 1 { final(K) : k(K) } 1. 

#minimize[move(_)].

% symmetry breaker
% single ones in the end
isSingle(K) :- move(K,X,Y,0,0). 
:- move(K;K+1), isSingle(K), not isSingle(K+1). 

% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- move(K,X,Y,_,_). 
:- not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) < (n*(YY-1)+XX).  

%#containment
containing(K) :- move(K;K+1), move(K+1,X,Y), not move(K,X,Y). 
:- intersecting(K), not containing(K), k(K).

