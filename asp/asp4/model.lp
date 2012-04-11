% Copyrights with Martin Gebser


% possible swaps

xpos(X)  :- init(X,_,_).
ypos(Y)  :- init(_,Y,_).
num(|N|) :- init(_,_,N).

xmax(X) :- xpos(X), not xpos(X+1).
ymax(Y) :- ypos(Y), not ypos(Y+1).

xrot(X1,X2) :- xpos(X1;X2), X1 <= X2.
yrot(Y1,Y2) :- ypos(Y1;Y2), Y1 <= Y2.

xmap(X1,X2,X,X2-X+X1) :- xrot(X1,X2), xpos(X), X1 <= X, X <= X2.
ymap(Y1,Y2,Y,Y2-Y+Y1) :- yrot(Y1,Y2), ypos(Y), Y1 <= Y, Y <= Y2.

% initial configuration

xpos(|N|,X,    0) :- init(X,_,N).
ypos(|N|,Y,    0) :- init(_,Y,N).
spin(|N|,N/|N|,0) :- init(_,Y,N).

% moves

1 { xrot(X1,X2,I) : xrot(X1,X2) } 1 :- final(F), I = 1..F.
1 { yrot(Y1,Y2,I) : yrot(Y1,Y2) } 1 :- final(F), I = 1..F.

xmov(X,XX,I) :- xrot(X1,X2,I), xmap(X1,X2,X,XX).
ymov(Y,YY,I) :- yrot(Y1,Y2,I), ymap(Y1,Y2,Y,YY).

xmov(X,I) :- xmov(X,_,I).
ymov(Y,I) :- ymov(Y,_,I).

xnum(N,I) :- xpos(N,X,I-1), xmov(X,I).
ynum(N,I) :- ypos(N,Y,I-1), ymov(Y,I).

stay(N,I) :- num(N), final(F), I = 1..F, not xnum(N,I).
stay(N,I) :- num(N), final(F), I = 1..F, not ynum(N,I).

% effects

xpos(N,XX,I+1) :- xpos(N,X,I), xmov(X,XX,I+1), ynum(N,I+1).
ypos(N,YY,I+1) :- ypos(N,Y,I), ymov(Y,YY,I+1), xnum(N,I+1).
spin(N,-S,I+1) :- spin(N,S,I), final(F), I < F, not stay(N,I+1).

% inertia

xpos(N,X,I+1) :- xpos(N,X,I), stay(N,I+1).
ypos(N,Y,I+1) :- ypos(N,Y,I), stay(N,I+1).
spin(N,S,I+1) :- spin(N,S,I), stay(N,I+1).

% goal configuration

:- num(N), final(F), xmax(X), not xpos(N,((N-1) /    X)+1,F).
:- num(N), final(F), ymax(Y), not ypos(N,((N-1) #mod Y)+1,F).
:- num(N), final(F), not spin(N,1,F).

% redundant constraints

:- num(N), final(F), I = 1..F, not { xpos(N,_,I) } 1.
:- num(N), final(F), I = 1..F, not { ypos(N,_,I) } 1.
:- num(N), final(F), I = 1..F, not { spin(N,_,I) } 1.

% symmetry breaking

dir(-1;1).

xord(X,D,I) :- xpos(X), xmov(X-D,I), dir(D), 1 < I.
xord(X,D,I) :- xpos(X), xord(X-D,D,I).

yord(Y,D,I) :- ypos(Y), ymov(Y-D,I), dir(D), 1 < I.
yord(Y,D,I) :- ypos(Y), yord(Y-D,D,I).

dist(I) :- xmov(X,I), final(F), I = 1..F-1, dir(D), xpos(X+D), not xord(X+D,D,I+1).
dist(I) :- ymov(Y,I), final(F), I = 1..F-1, dir(D), ypos(Y+D), not yord(Y+D,D,I+1).
:- final(F), I = 1..F-1, not dist(I).

xint(I) :- xmov(X,I), final(F), I = 1..F-1, xord(X+D,D,I+1) : dir(D) : xpos(X+D).
yint(I) :- ymov(Y,I), final(F), I = 1..F-1, yord(Y+D,D,I+1) : dir(D) : ypos(Y+D).
:- final(F), I = 1..F-1, not xint(I), xmov(X,I), xpos(X-1), xord(X+1,1,I+1) : xpos(X+1).
:- final(F), I = 1..F-1, not yint(I), ymov(Y,I), ypos(Y-1), yord(Y+1,1,I+1) : ypos(Y+1), xint(I).

% output atoms

state.

#hide.
#show spin/3.
#show state/0.
#show xmov/2.
#show ymov/2.
#show xpos/3.
#show ypos/3.
#show xrot/3.
#show yrot/3.
