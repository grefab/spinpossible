init(1,1,X11) :- init(X11,_X12,_X13,_X21,_X22,_X23,_X31,_X32,_X33,_N).
init(1,2,X12) :- init(_X11,X12,_X13,_X21,_X22,_X23,_X31,_X32,_X33,_N).
init(1,3,X13) :- init(_X11,_X12,X13,_X21,_X22,_X23,_X31,_X32,_X33,_N).
init(2,1,X21) :- init(_X11,_X12,_X13,X21,_X22,_X23,_X31,_X32,_X33,_N).
init(2,2,X22) :- init(_X11,_X12,_X13,_X21,X22,_X23,_X31,_X32,_X33,_N).
init(2,3,X23) :- init(_X11,_X12,_X13,_X21,_X22,X23,_X31,_X32,_X33,_N).
init(3,1,X31) :- init(_X11,_X12,_X13,_X21,_X22,_X23,X31,_X32,_X33,_N).
init(3,2,X32) :- init(_X11,_X12,_X13,_X21,_X22,_X23,_X31,X32,_X33,_N).
init(3,3,X33) :- init(_X11,_X12,_X13,_X21,_X22,_X23,_X31,_X32,X33,_N).
final(N) :- init(_X11,_X12,_X13,_X21,_X22,_X23,_X31,_X32,_X33,N).

state(x,0,V,X) :- init(X,_Y,V), V > 0.
state(y,0,V,Y) :- init(_X,Y,V), V > 0.
state(x,0,|V|,X) :- init(X,_Y,V), V < 0.
state(y,0,|V|,Y) :- init(_X,Y,V), V < 0.

parity(0,|V|) :- init(X,Y,V), V < 0.
