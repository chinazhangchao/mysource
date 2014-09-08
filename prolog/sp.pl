get_integer(L,H,X):-L>H,!,fail.
get_integer(L,H,L).
get_integer(L,H,X):-L1 is L+1,get_integer(L1,H,X).

% find(A,B,C).
% find寻找在A到B之间，B的可能的因子C。之所以称之为可能，是因为find并不测试B是否能整除C。
find(Lb,Z1,M2):-
    M2 is Z1 / Lb,
    M2 =< Lb,
    !,fail.
find(Lb,Z1,Lb).
find(Lb,Z1,M2):-
    Lb1 is Lb+1,find(Lb1,Z1,M2).

% 判断M和N的乘积P是否只有M和N这一对因子。
unique_d(Lb,Hb,M,N):-
    not_unique_d(Lb,Hb,M,N),
    !,fail.
unique_d(Lb,Hb,M,N).  %采用了截断那一章所介绍的否定方法，当然也可以直接使用内部谓词not/1。

not_unique_d(Lb,Hb,M,N):-  %如果M和N的乘积P的P分析不唯一就成功，即M与N的乘积P有其它的因子。
    P is M*N,      %首先，得出M与N的乘积P。
    find(Lb,P,V),  %再来找P的其它分解，
    V =\= M,       %V不等于M，(M为小的那个因子）
    0=:=P mod V.   %但是，V也是P的因子(此句的意思是P除以V的余数为0)，所以不唯一，成功。

% 条件一，也就是S先生的第一句话。
% 条件一：把和S分成任意的两个数M和N的和之后，再判断M和N的乘积P是否只有M和N这一对因子。
%         如果只有一对因子，则S先生不能肯定 P先生不能说出这两个数。所以失败。
cond1(Lb,Hb,X,Y):-
    %Lb与Hb为X、Y的取值界限，本题中为2和99，X和Y就是要判断的一组可能情况。
    S is X+Y,            % S为S先生知道的数---两个数之和。
    H is S / 2,
    get_integer(Lb,H,M),
    N is S-M，           % M和N就是S先生的S分析，这应该不难理解。
    unique_d(Lb,Hb,M,N)，% 本句测试M和N的积的P分析是否唯一,
    !,fail.              % 唯一，就失败了。

cond1(Lb,Hb,X,Y).% 否则，就成功，条件一通过。

% 条件二
%  把X和Y的积P，分成另外一组因子M2和N2后，再用条件一判断。
%  如果条件一成功，则表示P先生的P分析有两个满足条件一，(此处已经假设X，Y满足条件一）
%  所以P先生就不能通过S先生的第一句话得出这两个数。
%  则条件二失败。
cond2(Lb,Hb,X,Y):-
    P is X*Y,
    find(Lb,P,M2),
    M2=\=X,
    0 =:=P mod M2,
    N2 is P / M2,
    N2 < Hb,
    cond1(Lb,Hb,M2,N2),
    !,fail.
cond2(Lb,Hb,X,Y). % 否则，就成功，条件二通过。

 % 条件三
 %  同条件二一样编写，如果S先生的S分析除了X和Y以外，
 %  还有可以满足条件二的S分析(M3,N3)，(此处已经假设X，Y满足条件二）
 %  就是说S先生不能通过前面的对话确定这两个数。
 %  则条件三失败，否则成功。
 cond3(Lb,Hb,X,Y):-
     S is X+Y,
     Q3 is S / 2,
     get_integer(Lb,Q3,M3),
     M3=\=X,
     N3 is S-M3,
     cond2(Lb,Hb,M3,N3),
     !,fail.
 cond3(Lb,Hb,X,Y).
% 主程序，调用方法：puzzle(2,99,X,Y).
puzzle(Lb,Hb,X,Y):-
    get_integer(Lb,Hb,X),
    get_integer(X,Hb,Y),  %首先生成可能的组合情况。
    cond1(Lb,Hb,X,Y),
    cond2(Lb,Hb,X,Y).
cond3(Lb,Hb,X,Y),!.    %再用三个条件分别测试。
