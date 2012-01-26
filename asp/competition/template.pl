init(0,0,A0) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z). 
init(0,1,A1) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(0,2,A2) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(1,0,B0) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(1,1,B1) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(1,2,B2) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(2,0,C0) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(2,1,C1) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).
init(2,2,C2) :- problem(A0,A1,A2,B0,B1,B2,C0,C1,C2,Z).

final(Z) :- problem(A1,A2,A3,B1,B2,B3,C1,C2,C3,Z). 


state(0,X,Y,K) :- init(X,Y,K), K > 0.
state(0,X,Y,-K) :- init(X,Y,K), K < 0.
state(0,X,Y,0) :- init(X,Y,K), K < 0. 




