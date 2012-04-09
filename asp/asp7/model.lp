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

xlow(X,I) :- xpos(X), xmov(X+1,I), 1 < I.
xlow(X,I) :- xpos(X), xlow(X+1,I).

xtop(X,I) :- xpos(X), xmov(X-1,I), 1 < I.
xtop(X,I) :- xpos(X), xtop(X-1,I).

ylow(Y,I) :- ypos(Y), ymov(Y+1,I), 1 < I.
ylow(Y,I) :- ypos(Y), ylow(Y+1,I).

ytop(Y,I) :- ypos(Y), ymov(Y-1,I), 1 < I.
ytop(Y,I) :- ypos(Y), ytop(Y-1,I).

dist(I) :- xmov(X,I), final(F), I = 1..F-1, xpos(X-1), not xlow(X-1,I+1).
dist(I) :- xmov(X,I), final(F), I = 1..F-1, xpos(X+1), not xtop(X+1,I+1).
dist(I) :- ymov(Y,I), final(F), I = 1..F-1, ypos(Y-1), not ylow(Y-1,I+1).
dist(I) :- ymov(Y,I), final(F), I = 1..F-1, ypos(Y+1), not ytop(Y+1,I+1).
:- final(F), I = 1..F-1, not dist(I).

xint(I) :- xmov(X,I), final(F), I = 1..F-1, xlow(X-1,I+1) : xpos(X-1), xtop(X+1,I+1) : xpos(X+1).
yint(I) :- ymov(Y,I), final(F), I = 1..F-1, ylow(Y-1,I+1) : ypos(Y-1), ytop(Y+1,I+1) : ypos(Y+1).
:- final(F), I = 1..F-1, not xint(I),              xmov(X,I), xtop(X,I+1).
:- final(F), I = 1..F-1,     xint(I), not yint(I), ymov(Y,I), ytop(Y,I+1).

% output atoms
%
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

