#const n=2. 
c(0..n-1). 
d(0..1). 

init(0,0,1).
init(0,1,3).
init(1,0,4).
init(1,1,2). 

diff(X,Y,DX,DY) :- 
    init(X,Y,V), 
    DX = ((V-1) #div n) - X,
    DY = ((V-1) #mod n) - Y.   

less(X,Y,XX,YY) :- 
    c(X;Y;XX;YY), 
    X < XX. 
    
less(X,Y,XX,YY) :- 
    c(X;Y;XX;YY), 
    X = XX, 
    Y < YY. 

corner(X,Y,D) :- 
    d(X;Y;D).

less(X1,Y1,D1,X2,Y2,D2) :- 
    d(D1;D2),
    diff(X1,Y1,DX1,DY1), 
    diff(X2,Y2,DX2,DY2), 
    less(DX1,DY1,DX2,DY2).

next(X1,Y1,X2,Y2) :-
    c(X1;X2;Y1;Y2),
    V = X1 * (n-1) + Y1 + 1,
    X2 = V #div (n-1),
    Y2 = V #mod (n-1).

%less(X1,Y1,D1,X2,Y2,D2) :- 
%    diff(X1,Y1,V1), 
%    diff(X2,Y2,V2). 
%
    


