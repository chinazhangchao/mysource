color(h(C,N,P,Y,D),C).

nation(h(C,N,P,Y,D),N).

pet(h(C,N,P,Y,D),P).

yan(h(C,N,P,Y,D),Y).

drink(h(C,N,P,Y,D),D).

next(A,B,[A,B,C,D,E]).
next(B,C,[A,B,C,D,E]).
next(C,D,[A,B,C,D,E]).
next(D,E,[A,B,C,D,E]).
next(B,A,[A,B,C,D,E]).
next(C,B,[A,B,C,D,E]).
next(D,C,[A,B,C,D,E]).
next(E,D,[A,B,C,D,E]).
right(B,A,[A,B,C,D,E]).
right(C,B,[A,B,C,D,E]).
right(D,C,[A,B,C,D,E]).
right(E,D,[A,B,C,D,E]).
middle(X,[_,_,X,_,_]).
first(A,[A|X]).

solve(X,TT,TTT):-
%首先把X绑定为房间列表，注意此时的房间的属性还不能确定，所以都使用变量代表。
X=[h(C1,N1,P1,Y1,D1),h(C2,N2,P2,Y2,D2),h(C3,N3,P3,Y3,D3),h(C4,N4,P4,Y4,D4),h(C5,N5,P5,Y5,D5)],

%英国人（englishman）住在红色（red）的房子里。
member(Z1,X),  %首先从X列表中选择一个房间Z1，
color(Z1,red),  %Z1的颜色是red。
nation(Z1,englishman), %Z1里住的人是englishman。 下同。

%西班牙人（spaniard）养了一条狗（dog）。
member(Z2,X),
pet(Z2,dog),
nation(Z2,spaniard),

%挪威人（norwegian）住在左边的第一个房子里。
first(Z3,X),
nation(Z3,norwegian),

%黄房子（yellow）里的人喜欢抽kools牌的香烟。
member(Z4,X),
yan(Z4,kools),
color(Z4,yellow),

%抽chesterfields牌香烟的人与养狐狸（fox）的人是邻居。
member(Z5,X),
pet(Z5,fox),
next(Z6,Z5,X),   %用next(Z5,Z6,X)也一样。
yan(Z6,chesterfields),

%挪威人（norwegian）住在蓝色（blue）的房子旁边。
member(Z7,X),
color(Z7,blue),
next(Z8,Z7,X),
nation(Z8,norwegian),

%抽winston牌香烟的人养了一只蜗牛（Snails）。
member(Z9,X),
yan(Z9,winston),
pet(Z9,snails),


%抽Lucky Strike牌香烟的人喜欢喝桔子汁（orange juice）。
member(Z10,X),
drink(Z10,'orange juice'),
yan(Z10,'Lucky Strike'),


%乌克兰人（ukrainian）喜欢喝茶（tea）。
member(Z11,X),
nation(Z11,ukrainian),
drink(Z11,tea),


%日本人（japanese）抽parliaments牌的烟。
member(Z12,X),
nation(Z12,japanese),
yan(Z12,parliaments),

%抽kools牌的香烟的人与养马（horse）的人是邻居。
member(Z13,X),
pet(Z13,horse),
next(Z14,Z13,X),
yan(Z14,kools),


%喜欢喝咖啡（coffee）的人住在绿（green）房子里。
member(Z15,X),
color(Z15,green),
drink(Z15,coffee),


%绿（green）房子在象牙白（ivory）房子的右边（图中的右边）。
member(Z16,X),
color(Z16,ivory),
right(Z17,Z16,X),  %这里我们没有使用右边的条件，而是假设它们是邻居，所以最后的答案有两个。
color(Z17,green),  %这一点请读者自己修改，当然还需要编写一个判断右边的谓词。


%中间那个房子里的人喜欢喝牛奶（milk）。
middle(Z18,X),
drink(Z18,milk),


%以上是所有的条件，下面开始回答我们的问题。


%找出宠物为zebra的房间。
member(TT,X),
pet(TT,zebra),

%找出喝水的房间。
member(TTT,X),
drink(TTT,water).
