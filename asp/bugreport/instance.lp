#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..9). 
size(n). 
#hide. 
#show move/5. 

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
    table(K,X1,Y1,V1), 
    switch(K+1,X1,Y1,X2,Y2), 
    switch(V1,V2). 

table(K+1,X,Y,V) :- 
    move(K+1),
    table(K,X,Y,V), 
    not move(K+1,X,Y). 

%initial and final state
table(0,X,Y,V) :- init(X,Y,V). 
final(K) :- K = { move(N) : k(N) }.
isOk(K,X,Y) :-  table(K,X,Y,V), V = (n*(Y-1)+X), c(X;Y). 

:- K>1, move(K), not move(K-1). 
:- final(K), c(X;Y), not isOk(K,X,Y). 

#minimize[move(_)@2].
:- final(0). 

% symmetry breaker
% no repetitive squares
:- move(K;K+1), move(K,X,Y,R,D), move(K+1,X,Y,R,D). 

%% single ones in the end
isSingle(K) :- move(K,X,Y,0,0). 
:- move(K;K+1), isSingle(K), not isSingle(K+1). 
%
%% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- move(K,X,Y,_,_). 
:- not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) > (n*(YY-1)+XX).  
%
%% containment
containing(K) :- move(K;K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).

%
surround(X,Y,XX,Y) :- c(X;Y), XX = X-1. 
surround(X,Y,XX,Y) :- c(X;Y), XX = X+1. 
surround(X,Y,YY,XX) :- surround(X,Y,XX,YY).
fixed(K,0;n+1,Y) :- c(Y), move(K). 
fixed(K,X,0;n+1) :- c(X), move(K). 
fixed(K,X,Y) :- isOk(K,X,Y), 3 {fixed(K,XX,YY) : surround(X,Y,XX,YY) }. 
:- fixed(K,X,Y), move(K+1,X,Y). 

% simple problem
init(1,1,9).
init(2,1,2).
init(3,1,3).
init(1,2,4).
init(2,2,5).
init(3,2,6).
init(1,3,7).
init(2,3,8).
init(3,3,1).

