#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..N) :- final(N). 
s(0). 
s(K) :- k(K).
size(n). 
#show move/3. 
#show state/4. 
#show size/1.

1 { spin(K,X,Y,R,D) : c(X;Y) : R=0..n-X : D=0..n-Y } 1 :- k(K). 

move(K,X..X+R,Y..Y+D) :- spin(K,X,Y,R,D).
move(K) :- move(K,_,_).

switch(K,X,Y,X+R,Y+D) :- spin(K,X,Y,R,D). 
switch(K,X1+1,Y1,X2-1,Y2) :-
    switch(K,X1,Y1,X2,Y2),
    move(K,X1+1,Y1),
    move(K,X2-1,Y2). 

switch(K,X1,Y1+1,X2,Y2-1) :-
    switch(K,X1,Y1,X2,Y2),
    move(K,X1,Y1+1),
    move(K,X2,Y2-1). 

state(K+1,X2,Y2,-V) :- 
    state(K,X1,Y1,V), 
    switch(K+1,X1,Y1,X2,Y2).

state(K+1,X,Y,V) :- 
    s(K+1),
    state(K,X,Y,V), 
    not move(K+1,X,Y). 

%initial and final state
state(0,X,Y,V) :- init(X,Y,V). 
:-  not state(N,X,Y,V), V = (n*(X-1)+Y), c(X;Y), final(N). 
:- K>1, move(K), not move(K-1). 

%#minimize[move(_)].

% symmetry breaker
% no repetitive squares
:- s(K;K+1), spin(K,X,Y,R,D), spin(K+1,X,Y,R,D). 
%
%% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- spin(K,X,Y,_,_). 
:- not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(X-1)+Y) > (n*(XX-1)+YY).  
%
%% containment
containing(K) :- move(K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).
