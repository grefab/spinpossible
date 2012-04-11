writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 
size(3). 
sizeList([1,2,3]) :- size(3). 
sizeList([1,2,3,4]) :- size(4). 


writeS(A) :- number(A), A < -9, !, write(A).
writeS(A) :- number(A), A < 0, !, write(' '),  write(A).
writeS(A) :- number(A), A > 9, !, write(' '), write(A).
writeS(A) :- write('  '), write(A). 

move2(K,X,Y) :- 
    move(x,K,X),
    move(y,K,Y).

printSwitch(K,X,Y):-
    (move2(K,X,Y) ->
    writeS('*');
    writeS('-')).

state2(K,X,Y,V) :- 
    state(x,K,V,X), 
    state(y,K,V,Y).


printRow(K,X,Y):-
    state2(K,X,Y,V),
    VV is -V,
    (parity(K,V) ->
     writeS(VV);
     writeS(V)).

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
    move(_D,K,_C), 
    !,
    writeL(['move ',K,': ']),nl,nl,
    printSwitch(K),
    printTable(K),
    KK is K+1,
    printMoves(KK).

printMoves(_) :- 
    write('finish'),nl. 



