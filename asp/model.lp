#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..8). 
#hide. 
#show move/5. 

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

switch(K,X,Y) :-
    switch(K,X,Y,_,_). 

switch(K,X,Y) :-
    switch(K,_,_,X,Y). 

table(K+1,X2,Y2,V2) :- 
    move(K+1),
    table(K,X1,Y1,V1), 
    switch(K+1,X1,Y1,X2,Y2), 
    switch(V1,V2). 

table(K+1,X,Y,V) :- 
    move(K+1),
    table(K,X,Y,V), 
    not switch(K+1,X,Y). 

table(0,X,Y,V) :- init(X,Y,V). 

ok(K,X,Y) :-  V = (n*(Y-1)+X), table(K,X,Y,V).

%:- K>1, move(K), not move(K-1). 
final(M) :- k(M), M = #max[move(K)=K:k(K)].
:- final(K), not ok(K,X,Y),  c(X;Y). 
%:- not 1 { final(K) : k(K) } 1. 
%
%#minimize[move(_)].

%greg level 8
init(1,1,7).
init(2,1,4).
init(3,1,-5).
init(1,2,9).
init(2,2,-2).
init(3,2,-3).
init(1,3,-8).
init(2,3,-6).
init(3,3,1).
