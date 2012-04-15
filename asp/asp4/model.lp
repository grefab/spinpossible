% Copyrights with Martin Gebser

% grid and time

opp(x,y;;y,x).
dir(D) :- opp(D,_).

pos(x,X) :- init(X,_,_).
pos(y,Y) :- init(_,Y,_).
num(|N|) :- init(_,_,N).

end(D,Z) :- pos(D,Z), not pos(D,Z+1).

map(Z1,Z2,Z1,  Z2)   :- pos(D,Z1), end(D,Z), Z2 = Z1..Z.
map(Z1,Z2,Z3+1,Z4-1) :- map(Z1,Z2,Z3,Z4), Z3+1 < Z4.

time(1..T) :- final(T).

% moves (by row and column lines)

1 { line(D,Z1,Z1..Z2,T) : pos(D,Z1) } 1 :- end(D,Z2), time(T).

move(D,Z3,Z4,T) :- line(D,Z1,Z2,T), map(Z1,Z2,Z3,Z4).
move(D,Z,T) :- move(D,Z,_,T).
move(D,Z,T) :- move(D,_,Z,T).
 :- pos(D,Z), time(T), not { move(D,Z,_,T), move(D,_,Z,T) } 1.

% initial configuration

conf(|N|,x, X, 0) :- init(X,_,N).
conf(|N|,y, Y, 0) :- init(_,Y,N).
conf(|N|,N/|N|,0) :- init(_,_,N).

% updated configuration

stay(N,D,T+1) :- conf(N,D,Z,T), not move(D,Z,T+1), not final(T).
stay(N,T) :- stay(N,_,T).

conf(N,D,Z2,T+1) :- conf(N,D,Z1,T), move(D,Z1,Z2,T+1), opp(D,E), not stay(N,E,T+1).
conf(N,D,Z2,T+1) :- conf(N,D,Z1,T), move(D,Z2,Z1,T+1), opp(D,E), not stay(N,E,T+1).
conf(N,D,Z, T+1) :- conf(N,D,Z, T), stay(N,T+1).
 :- num(N), dir(D), time(T), not 1 { conf(N,D,_,T) } 1.

conf(N,-S,T+1) :- conf(N,S,T), not stay(N,T+1), not final(T).
conf(N, S,T+1) :- conf(N,S,T),     stay(N,T+1).
 :- conf(N,-1;1,T).
 :- num(N), time(T), not conf(N,-1;1,T).

% goal configuration

 :- num(N), final(T), end(x,X), not conf(N,x,((N-1) /    X)+1,T).
 :- num(N), final(T), end(y,Y), not conf(N,y,((N-1) #mod Y)+1,T).
 :- num(N), final(T), not conf(N,1,T).

% symmetry breaking (of successive moves)

dist(T) :- move(D,Z,T), not move(D,Z,T-1), 1 < T.
 :- time(T), not dist(T), 1 < T. % move some other grid cell than preceding move

down(D,Z,  T) :- move(D,Z,T), 1 < Z, 1 < T.
down(D,Z-1,T) :- down(D,Z,T), 2 < Z.

sort(D,T+1) :- move(D,1,T), not final(T).
sort(D,T+1) :- move(D,Z,T), down(D,Z,T+1).
 :- time(T), not sort(x,T), 1 < T. % order disjoint moves lexicographically
 :- time(T), not sort(y,T), move(x,Z,T-1), end(x,Z).
 :- time(T), not sort(y,T), move(x,1,T), 1 < T.
 :- time(T), not sort(y,T), move(x,Z,T-1;T), 1 < Z, not end(x,Z).

% output atoms

#hide.
#show move/3.
#show conf/4.
#show conf/3.
