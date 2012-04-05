#const n=3. 
#const final=9. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..final). 
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

state(K+1,X,Y,V) :- 
    k(K+1),
    state(K,X,Y,V), 
    not move(K+1,X,Y). 

% initial state
state(0,X,Y,V) :- init(X,Y,V). 

% final state
:- not state(final,X,Y,V), V = (n*(X-1)+Y), c(X;Y). 

% optimization
move(K) :- move(K,_,_).
:- K>1, move(K), not move(K-1). 
#minimize[move(_)].
