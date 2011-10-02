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

start :- makeList(9,L), shuffle(L,LL), printList(LL).


makeList(K,L) :- 
    makeList(K,[],L). 
makeList(0,L,L) :- !. 
makeList(N,L,LL) :- 
    NN is N - 1, 
    K is (1-2*random(2))*N,
    makeList(NN,[K|L],LL).

shuffle(L, Out) :-
        length(L, Len),
        ( Len > 1
        -> shuffle(L, [], Len, Out)
        ; Out = L).

shuffle(L, Tail, Len, Out) :-
        /* format('shuffling ~w~n', [L]), */
        ( Len > 1
        -> Len1 is Len // 2,
            Len2 is Len - Len1,
            divide_list(L, Len1, Len2, L1, L2),
            shuffle(L2, Tail, Len2, SL2),
            shuffle(L1, SL2, Len1, Out)
            /* format('shuffled ~w ==> ~w~n', [L, Out]) */
        ; L = [H|_],
            Out = [H|Tail]).

divide_list([H|T], Len1, Len2, L1, L2) :-
        ( Len1 > random(Len1 + Len2)
        -> L1 = [H|T1],
            ( Len1 = 1
            -> L2 = T
            ; succ(Len11, Len1),
                divide_list(T, Len11, Len2, T1, L2))
        ; L2 = [H|T2],
            ( Len2 = 1
            -> L1 = T
            ; succ(Len21, Len2),
                divide_list(T, Len1, Len21, L1, T2))).
