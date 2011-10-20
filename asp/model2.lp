#const n=3. 
v(-n*n..-1;1..n*n).  
c(1..n). 
k(1..9). 
size(n). 
#hide. 
#show move/5. 
#show move/3. 
#show table/4. 
#show final/1.
#show isOk/3.
#show size/1.

dom(AX,AY,BX,BY,X,Y) :- 
    c(AX;AY;X;Y),
    BX=AX..n,
    BY=AX..n, 
    AX <= X, X <= BX, AY <= Y, Y <= BY. 

{ move(K,AX,AY,BX,BY) : dom(AX,AY,BX,BY,_,_) } 1 :- k(K). 

move(K,X..R,Y..D) :- move(K,X,Y,R,D).
move(K) :- move(K,_,_,_,_).

table(K+1,X,Y,-V) :- 
    table(K,AX+BX-X,AY+BY-Y,V), 
    move(K+1,AX,AY,BX,BY), 
    dom(AX,AY,BX,BY,X,Y).

table(K+1,X,Y,V) :- 
    table(K,X,Y,V), 
    move(K+1,AX,AY,BX,BY), 
    not dom(AX,AY,BX,BY,X,Y).

%initial and final state
table(0,X,Y,V) :- init(X,Y,V). 
final(K) :- K = { move(N) : k(N) }.
isOk(K,X,Y) :-  table(K,X,Y,V), V = (n*(Y-1)+X), c(X;Y). 

:- K>1, move(K), not move(K-1). 
:- final(K), c(X;Y), not isOk(K,X,Y). 

#minimize[move(_)].

% symmetry breaker
% no repetitive squares
:- move(K;K+1), move(K,AX,AY,BX,BY), move(K+1,AX,AY,BX,BY).

%% single ones in the end
isSingle(K) :- move(K,X,Y,X,Y). 
:- move(K;K+1), isSingle(K), not isSingle(K+1). 
%
%% nonintersecting:
intersecting(K) :- move(K,X,Y), move(K+1,X,Y). 
upperLeft(K,X,Y) :- move(K,X,Y,_,_). 
:- not intersecting(K), upperLeft(K,X,Y), upperLeft(K+1,XX,YY), (n*(Y-1)+X) < (n*(YY-1)+XX).  
%
%% containment
containing(K) :- move(K;K+1), move(K,X,Y), not move(K+1,X,Y). 
:- intersecting(K), not containing(K), k(K).
