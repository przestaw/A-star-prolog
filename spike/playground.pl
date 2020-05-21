conc([],B,B).
conc([A|R], B, [A|R2]):-
    conc(R,B,R2).

sublist(L, R):-
    prefix(L, R) .
sublist(L, [ _| R]):-
    sublist(L, R).

prefix([ ], _) .
prefix([X|L], [X|R]):-
    prefix(L, R).

% subset(X,R)
% true if R is subset of X
subset(_,[]).
subset([_|R],R).
subset([X|R],[X|S]):-
    subset(R,S).

all_subsets(X,R):-
    findall(T,subset(X,T),R).
    
% insert(X, List, Result)
% X is inserted into sorted List saved as Result 
insert(X,[],[X]).
insert(X,[Y|L],[Y|R]):-
    X > Y, !,
    insert(X,L,R).
insert(X,[Y|L],[X,Y|L]):-
    not(X > Y).

% merge_list(X,Y,R)
% merges sorted lists X and Y into R
merge_list([],[],[]).
merge_list([],Y,Y).
merge_list(X,[],X).
merge_list([X|L1], [Y|L2], [X|R]):-
    X < Y,
    merge_list(L1, [Y|L2], R).
merge_list([X|L1], [Y|L2], [Y|R]):-
    not(X < Y), 
    merge_list([X|L1], L2, R).

% member(X, ListSet)
% true if X is a member of the list
member(_,[]):- false.
member(X,[X|_]).
member(X,[Y|L]):-
    X \= Y, member(X,L).

% intersectrion(X,Y,R)
% true if R is X and Y intersection
intersection([],_,[]).
intersection(_,[],[]).
intersection([X|L1], L2, [X|R]):-
    member(X, L2), !,
    intersection(L1,L2,R).
intersection([X|L1], L2, R):-
    not(member(X, L2)),
    intersection(L1,L2,R).

% delete(X,Y)
% delete first X from Y - true if X is in Y
delete(_,[],[]):-false.
delete(X,[Y|L],[Y|R]):-
    X \= Y,
    delete(X,L,R).
delete(X,[Y|L],L):-
    X = Y.

% subset_incl_elem(X,Y,R)
% R is subset of X containing Y
subset_incl_elem(_,[],[]).
subset_incl_elem([X|L1],Y,[X|R]):-
    delete(X,Y,Y2),
    subset_incl_elem(L1,Y2,R).
subset_incl_elem([X|L1],Y,[X|R]):-
    not(delete(X,Y,_)),
    subset_incl_elem(L1,Y,R).
subset_incl_elem([X|L1],Y,R):-
    not(delete(X,Y,_)),
    subset_incl_elem(L1,Y,R).

% check_list(X,Y)
% checks if list X contains elements from Y in any order
check_list(_,[]).
check_list(X,[Y|L]):-
    member(Y,X),
    check_list(X,L).

% process_list checks if any given list contains given set
process_lists([],_,_).
process_lists([X|L],S,[X|R]):-
    check_list(X,S),
    process_lists(L,S,R).
process_lists([X|L],S,R):-
    not(check_list(X,S)),
    process_lists(L,S,R).
    
% scan_lists(X,Y,N)
% checks if X contains N elements equal to Y elements
scan_lists(_,_,0).
scan_lists([X|L1], L2, I):-
    member(X,L2), J is I-1,
    scan_lists(L1,L2,J).
scan_lists([X|L1], L2, I):-
    not(member(X,L2)),
    scan_lists(L1,L2,I).

% process_bag(X, Y, L, R)
% replace all X occurances with Y excluding first occurance
process_bag(X, Y, L, R):-
    process_bag(X, Y, L, R, 0).
process_bag(_, _, [ ], [ ], _).
process_bag(X, Y, [Z|L], [Z|R], F):-
    Z \= X,
    process_bag(X, Y, L, R, F).
process_bag(X, Y, [X|L], [Y|R], 0):-
    process_bag(X, Y, L, R, 1).
process_bag(X, Y, [X|L], [Y|R], 1):-
    process_bag(X, Y, L, R, 1).
