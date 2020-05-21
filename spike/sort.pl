% insert(X, List, Result)
% X is inserted into sorted List saved as Result 
insert(X,[],[X]).
insert(X,[Y|L],[Y|R]):-
    X > Y, !,
    insert(X,L,R).
insert(X,[Y|L],[X,Y|L]):-
    not(X > Y).

quicksort([], []).
quicksort([P|B], R):-
    partition(P, B, L1, L2),
    quicksort(L1, R1),
    quicksort(L2, R2),
	conc(R1,[P|R2], R).
		
partition(_, [], [], []).
partition(P, [A|R], [A|L1], L2):-
    A < P, ! , partition(P, R, L1, L2).

partition(P, [A|R], L1, [A|L2]):-
    partition(P, R, L1, L2).

% merge sort
merge_sort(L,L):-
	length(L, 1).
    
merge_sort(L,R):-
    div(L, L1, L2),
    merge_sort(L1, R1), merge_sort(L2, R2),
    merge_list(R1,R2,R).

merge_sort([], []).

% merge_list(X,Y,R)
% merges sorted lists X and Y into R
merge_list([],[],[]).
merge_list([],Y,Y).
merge_list(X,[],X).
merge_list([X|L1], [Y|L2], [X|R]):-
    X < Y,
    merge_list(L1, [Y|L2], R).
merge_list([X|L1], [Y|L2], [Y|R]):-
    X >= Y, 
    merge_list([X|L1], L2, R).

% bublesort

bubble_sort(List,R):-
    swap(List,T),
    bubble_sort(T,R).

bubble_sort(L,L):-
    not(swap(L,_)).

swap([X,Y|L],[Y,X|L]):-
    X > Y.

swap([X, Y|L],[X|R]):-
    X =< Y, swap([Y|L],R).
