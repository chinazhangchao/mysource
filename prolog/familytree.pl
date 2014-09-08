male(di).
male(jianbo).
female(xin).
female(yuan).
female(yuqing).
father(jianbo,di).
father(di,yuqing).
mother(xin,di).
mother(yuan,yuqing).

grandfather(X,Y):-father(X,Z),father(Z,Y).
grandmother(X,Y):-mother(X,Z),father(Z,Y).
daughter(X,Y):-father(X,Y),female(Y).

parent(keyuan,jianbo).
parent(jianbo,di).
parent(di,yuqing).

ancestor(X,Y):-parent(X,Y).
ancestor(X,Y):-parent(X,Z),ancestor(Z,Y).
