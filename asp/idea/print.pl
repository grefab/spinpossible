writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 
sizeList([0,1,2]) :- size(3). 
sizeList([0,1,2,3]) :- size(4). 


writeS(A) :- number(A), A < -9, !, write(A).
writeS(A) :- number(A), A < 0, !, write(' '),  write(A).
writeS(A) :- number(A), A > 9, !, write(' '), write(A).
writeS(A) :- write('  '), write(A). 

printSwitch(K,X,Y):-
    (move(K,X,Y) ->
    writeS('*');
    writeS('-')).

printRow(K,X,Y):-
    table(K,X,Y,V),
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
    move(K,_X,_Y), 
    !,
    writeL(['move ',K,': ']),nl,nl,
    printSwitch(K),
    printTable(K),
    KK is K+1,
    printMoves(KK).

printMoves(_) :- 
    write('finish'),nl. 

% transformation
table(K,X,Y,V) :- 
    cell(K,x,X,Y,DX),
    cell(K,y,X,Y,DY),
    cell(K,p,X,Y,P),
    size(N),
    V is (1-2*P)*((DX+X) * N + (Y+DY) + 1).

