#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..8). 
size(n). 
#show move/3. 
#show table/4. 
#show size/1.

1 { move(K,X,Y,R,D) : c(X;Y) : R=0..n-X : D=0..n-Y } 1 :- k(K). 

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

%:- k(K), c(X;Y), 2 { table(K,X,Y,_) }.
:- K>1, move(K), not move(K-1). 
:- final(K), c(X;Y), not isOk(K,X,Y). 

%#minimize[move(_)@2].
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
:- not isSingle(K+1), not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) > (n*(YY-1)+XX).  
%
%% containment
containing(K) :- move(K;K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).

%%
fixedX(K,0;n+1) :- k(K). 
fixedY(K,0;n+1) :- k(K). 
fixedX(K,X) :- c(X), fixedX(K,X-1), n {isOk(K,X,Y) : c(Y)} n. 
fixedX(K,X) :- c(X), fixedX(K,X+1), n {isOk(K,X,Y) : c(Y)} n. 
fixedY(K,Y) :- c(Y), fixedY(K,Y-1), n {isOk(K,X,Y) : c(X)} n. 
fixedY(K,Y) :- c(Y), fixedY(K,Y+1), n {isOk(K,X,Y) : c(X)} n. 
:- fixedX(K,X), move(K+1,X,_). 
:- fixedY(K,Y), move(K+1,_,Y). 
