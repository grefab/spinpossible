writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 


writeS(A) :- number(A), A < 0, !, write(A).
writeS(A) :- write(' '), write(A). 

printSwitch(K,X,Y):-
    (move(K,X,Y) ->
    writeS('*');
    writeS('-')).

printRow(K,X,Y):-
    table(K,X,Y,V),
    writeS(V).

printTable(K) :- 
    forall(member(Y,[1,2,3]),
        ( forall(member(X,[1,2,3]), printRow(K,X,Y)),nl)
    ), 
    nl. 

printSwitch(K) :- 
    forall(member(Y,[1,2,3]),
        ( forall(member(X,[1,2,3]), printSwitch(K,X,Y)),nl)
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
    %XX is X + R,
    %YY is Y + D,
    %writeL(['move ',K,': (',X,',',Y,') to (',XX,',',YY,')']),nl,nl,
    writeL(['move ',K,': ']),nl,nl,
    printSwitch(K),
    printTable(K),
    KK is K+1,
    printMoves(KK).

printMoves(_) :- 
    write('finish'),nl. 



