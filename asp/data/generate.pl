start :- makeList(9,L), shuffle(L,LL), printList(LL).

writeL([]).
writeL([X|Y]):- write(X), writeL(Y). 

printEntry(X,Y,E) :- 
    writeL(['init(',X,',',Y,',',E,').']), nl.

printList([]). 
printList([H|R]) :- 
    length([H|R],K), 
    X is ((K-1) mod 3) +1,
    Y is round((K+1)/3),
    printEntry(X,Y,H), 
    printList(R). 

makeList(K,L) :- 
    makeList(K,[],L). 
makeList(0,L,L) :- !. 
makeList(N,L,LL) :- 
    NN is N - 1, 
    K is (1-2*random(2))*N,
    makeList(NN,[K|L],LL).

shuffle(L,LL) :- 
    length(L,N),
    shuffleList(N,L,LL). 
    
shuffleList(1,L,L) :- !. 
shuffleList(K,L,[X|RL]) :- 
    R is random(K), 
    KK is K - 1, 
    removeList(R,L,LL,X), 
    shuffleList(KK,LL,RL). 


removeList(0,[X|Y],Y,X) :- !. 
removeList(N,[X|Y],[X|Z],R) :- 
    NN is N - 1, 
    removeList(NN,Y,Z,R). 
