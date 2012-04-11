writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 
sizeList([0,1,2]) :- size(3). 
sizeList([0,1,2,3]) :- size(4). 

writeS(A) :- number(A), A < -9, !, write(A).
writeS(A) :- number(A), A < 0, !, write(' '),  write(A).
writeS(A) :- number(A), A > 9, !, write(' '), write(A).
writeS(A) :- write('  '), write(A). 

printSwitch(K,X,Y):-
    (equal(K,X,Y) ->
    writeS('-');
    writeS('*')).

printRow(K,X,Y):-
    state(K,X,Y,V),
    V > 0,
    state(K,X,Y,0),
    !,
    VV is -V,
    writeS(VV).

printRow(K,X,Y):-
    state(K,X,Y,V),
    writeS(V).

printTable(K) :- 
    sizeList(L),
    forall(member(X,L),
        ( forall(member(Y,L), printRow(K,X,Y)),nl)
    ), 
    nl. 

printSwitch(K) :- 
    sizeList(L),
    forall(member(X,L),
        ( forall(member(Y,L), printSwitch(K,X,Y)),nl)
    ), 
    nl. 

start :- 
    consult('tmp/foutput.tmp'), 
    writeL(['initial state:']),nl,
    printTable(0),
    printMoves(1). 

printMoves(K) :- 
    state(K,_,_,_), 
    !,
    writeL(['move ',K,': ']),nl,nl,
    printSwitch(K),
    printTable(K),
    KK is K+1,
    printMoves(KK).

printMoves(_) :- 
    write('finish'),nl. 
