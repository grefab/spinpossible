% Copyright with Martin Gebser 

% grid and time

dir(x;y).
amo(-1;1).

pos(x,X) :- init(X,_,_).
pos(y,Y) :- init(_,Y,_).
num(|N|) :- init(_,_,N).

end(D,Z,A) :- pos(D,Z), amo(A), not pos(D,Z+A).

time(1..T) :- final(T).

% fix initial configuration

conf(|N|,x, X, 0) :- init(X,_,N).
conf(|N|,y, Y, 0) :- init(_,Y,N).
conf(|N|,N/|N|,0) :- init(_,_,N).

% fix goal configuration

conf(N,x,((N-1) /    X)+1,T) :- num(N), final(T), end(x,X,1).
conf(N,y,((N-1) #mod Y)+1,T) :- num(N), final(T), end(y,Y,1).
conf(N,  1,               T) :- num(N), final(T).

% guess intermediate configurations

{ conf(N,D,Z,T) : pos(D,Z) } 1 :- num(N), dir(D), time(T), not final(T).
 :- num(N), dir(D), time(T), not final(T), not conf(N,D,Z,T) : pos(D,Z).

{ conf(N,1;-1,T) } :- num(N), time(T), not final(T).
 :- conf(N,1;-1,T), time(T), not final(T).
 :- num(N), time(T), not final(T), not conf(N,1;-1,T).

% rotate some (non-empty) rectangle for each transition

{ move(D,Z,T) : pos(D,Z) } :- time(T).
 :- dir(D), time(T), not move(D,Z,T) : pos(D,Z).

down(D,Z,  T) :- move(D,Z,T), 1 < Z.
down(D,Z-1,T) :- down(D,Z,T), 2 < Z.
 :- move(D,Z,T), down(D,Z+2,T), not move(D,Z+1,T).

keep(N,T) :- conf(N,D,Z,T), time(T), not move(D,Z,T).
 :- conf(N,D,Z,T), not move(D,Z,T+1), not keep(N,T+1), not final(T).
 :- time(T), keep(N,T) : num(N).

% apply spins and restrict relocations to contents of rectangle

 :- conf(N,A,T-1), not conf(N,A,T), keep(N,T).
 :- conf(N,A,T-1;T),            not keep(N,T).

 :- conf(N,D,Z,T), not conf(N,D,Z,T-1), keep(N,T).
 :- conf(N,D,Z,T), not conf(N,D,Z,T+1), keep(N,T+1).

% invert distances to rectangle borders for rotation

step(D,Z,  A,  1,T) :- move(D,Z,T), amo(A).
step(D,Z+A,A,I+1,T) :- step(D,Z,A,I,T), not end(D,Z,A).

prev(N,D,A,I,T) :- step(D,Z,A,I,T), conf(N,D,Z,T-1).
next(N,D,A,I,T) :- step(D,Z,A,I,T), conf(N,D,Z,T).
 :- prev(N,D,A,I,T), not next(N,D,-A,I,T), not keep(N,T).
 :- next(N,D,A,I,T), not prev(N,D,-A,I,T), not keep(N,T).

% some relocations inapplicable if rectangle is a line

swap(D,T) :- move(D,Z,T), down(D,Z+1,T).
 :- conf(N,D,Z,T), not conf(N,D,Z,T-1), not swap(D,T),   time(T).
 :- conf(N,D,Z,T), not conf(N,D,Z,T+1), not swap(D,T+1), not final(T).

% move some other grid cell than preceding move

dist(T) :- move(D,Z,T), not move(D,Z,T-1), 1 < T.
 :- time(T), not dist(T), 1 < T.

% order disjoint moves lexicographically

sort(D,T) :- move(D,1,T), not final(T).
sort(D,T) :- move(D,Z,T), down(D,Z,T+1).
 :- not sort(x,T), time(T), not final(T).
 :- not sort(y,T), move(x,Z,T), end(x,Z,1), not final(T).
 :- not sort(y,T), move(x,1,T+1), time(T).
 :- not sort(y,T), move(x,Z,T;T+1), 1 < Z, not end(x,Z,1).

% auxilary redundant restrictions

 :- conf(N,A,0;1), conf(N,D,Z,0), not conf(N,D,Z,1).
 :- conf(N,A,T-1;T), final(T), conf(N,D,Z,T), not conf(N,D,Z,T-1).

 :- prev(N,D,A,I,T), not next(N,D, A,I,T),     keep(N,T).
 :- next(N,D,A,I,T), not prev(N,D, A,I,T),     keep(N,T).

 :- prev(N,D,A,I,T), not next(N,D,A,I,T), not swap(D,T).
 :- next(N,D,A,I,T), not prev(N,D,A,I,T), not swap(D,T).

% output atoms

#hide.
#show move/3.
#show conf/4.
#show conf/3.
