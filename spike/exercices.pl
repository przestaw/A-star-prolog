% zad 0
%path([arc (a, e), arc (a, b), arc (a, c ) , arc (b, d), arc ( c, d ) ],a, d, Path).

path(_, Y, Y, [Y]).
path(Graph, X, Y, [ X | L ] ):-
	member(arc( X, Z ), Graph),
	path(Graph, Z, Y, L).

member(_,[]):- false.
member(X,[X|_]).
member(X,[_|R]):-
    member(X,R).

sublist(L, R):-
    prefix(L, R) .
sublist(L, [ _| R]):-
    sublist(L, R).

prefix([ ], _) .
prefix([X|L], [X|R]):-
    prefix(L, R).

% zad 1
% find_and_swap([a,e,g,k,m,t],F,R).
cond(a,g).
cond(e,k).
cond(e,m).
cond(k,t).

find_and_swap([],P,P).
find_and_swap([E|RestList],P,R):-
	findall([Elem1|Rest1], process_one_elem(E, RestList, Elem1, Rest1), Rests),
    conc(P,Rests,PR),
    find_and_swap(RestList,PR,R).

process_one_elem(E, [F|RestList], Elem1, [F|ResultList]):-
    process_one_elem(E, RestList, Elem1, ResultList).

process_one_elem(E, [F|RestList], F, [E|RestList]):-
    cond(E,F).
    
conc([],B,B).
conc([A|R], B, [A|R2]):-
    conc(R,B,R2).
    
    
% zad 2

% find_paths([arc(a,b),arc(b,c),arc(b,d),arc(b,e),arc(a,g),arc(a,f),arc(g,h),arc(g,i),arc(i,j),arc(f,k),arc(k,l)],a,[a,i],Paths).

find_paths(Graph, F, C, Paths):-
	findall(Path, find_one_path(Graph, F, C, Path), Paths).

find_one_path(Graph,Node,[],[Node]):-
    not(member(arc(Node,_), Graph)), !.

find_one_path(G, N, [N|C], [N|P]):-
	member( arc(N,New), G),
    find_one_path(G,New,C,P).

find_one_path(G, N, C, [N|P]):-
    member( arc(N,New), G),
    find_one_path(G,New,C,P).

% member(X, ListSet)
% true if X is a member of the list
member(_,[]):- false.
member(X,[X|_]).
member(X,[_|L]):-
    member(X,L).
    
    
% zad 3

conc([],B,B).
conc([A|R], B, [A|R2]):-
    conc(R,B,R2).

process_list_pairs([], []).

process_list_pairs([L1|L], R) :- 
    process_one_list(L1, L, R1),
    process_list_pairs(L, R2),
    conc(R1,R2,R).
    
process_one_list(_, [], []).

process_one_list(L, [A1|A], [pair(L,A1)|R]):-
    check(L,A1), !,
    process_one_list(L,A,R).

process_one_list(L, [_|A], R):-
    process_one_list(L,A,R).

check(L,R):-
	check_first(L,R), !.
check(L,R):-
    check_last(L,R).

check_first([First|_], [First|_]). 

check_last(F,[F1|_]):-
    last(F,F1).

last([A], A).
last([_|R],B) :- 
    last(R,B).
