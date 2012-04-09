#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..N) :- final(N). 
size(n). 

% spin
{ spin(K,X,Y,R,D) : c(X;Y) : R=0..n-X : D=0..n-Y } 1 :- k(K). 

% state update wrt. spin
state(K+1,X+X+R-X1,Y+Y+D-Y1,-V) :- 
    state(K,X1,Y1,V), 
    spin(K+1,X,Y,R,D), 
    Y <= Y1, Y1 <= Y+D, X <= X1, X1 <= X+R. 

% state update outside spin
move(K,X..X+R,Y..Y+D) :- spin(K,X,Y,R,D).

parity(K+1,X,Y) :- 
    k(K+1),
    parity(K,X,Y), 
    move(K+1,X,Y). 

parity(K+1,X,Y) :- 
    k(K+1),
    parity(K,X,Y), 
    not move(K+1,X,Y). 

state(K+1,X,Y,V) :- 
    k(K+1),
    state(K,X,Y,V), 
    not move(K+1,X,Y). 

% initial state
parity(0,X,Y) :- init(X,Y,V), V < 0.
state(0,X,Y,V) :- init(X,Y,V), V > 0.
state(0,X,Y,-V) :- init(X,Y,V), V < 0.

% final state
:- not state(N,X,Y,V), V = (n*(X-1)+Y), c(X;Y), final(N). 

%% optimization
%move(K) :- move(K,_,_).
%:- K>1, move(K), not move(K-1). 
%#minimize[move(_)].
