writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 
size(3). 
sizeList([1,2,3]) :- size(3). 
sizeList([1,2,3,4]) :- size(4). 


writeS(A) :- number(A), A < -9, !, write(A).
writeS(A) :- number(A), A < 0, !, write(' '),  write(A).
writeS(A) :- number(A), A > 9, !, write(' '), write(A).
writeS(A) :- write('  '), write(A). 

move(K,X,Y) :- 
    xmov(X,K),
    ymov(Y,K).

printSwitch(K,X,Y):-
    (move(K,X,Y) ->
    writeS('*');
    writeS('-')).

state(K,X,Y,V) :- 
    xpos(V,X,K), 
    ypos(V,Y,K).

printRow(K,X,Y):-
    state(K,X,Y,V),
    spin(V,S,K),
    VV is V * S,
    writeS(VV).

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
    move(K,_X,_Y), 
    !,
    writeL(['move ',K,': ']),nl,nl,
    printSwitch(K),
    printTable(K),
    KK is K+1,
    printMoves(KK).

printMoves(_) :- 
    write('finish'),nl. 



