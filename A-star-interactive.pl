start_A_star(InitState, PathCost, N, MaxStepLimit):-
	score(InitState, 0, 0, InitCost, InitScore),
	search_A_star([node(InitState, nil, nil, InitCost , InitScore )], [], PathCost, N, 1, MaxStepLimit).

search_A_star(Queue, ClosedSet, PathCost, N, StepCounter, MaxStepLimit):-
	StepCounter < MaxStepLimit, ! ,
	write("Krok nr. : "),
	write(StepCounter), nl,
	fetch_new(Node, Queue, ClosedSet, RestQueue, N),
	NewStepCounter is StepCounter + 1,
	continue(Node, RestQueue, ClosedSet, PathCost, N, NewStepCounter, MaxStepLimit).

search_A_star(Queue, ClosedSet, PathCost, N, StepCounter, MaxStepLimit):-
	write("Krok nr. : "),
	write(StepCounter), nl,
	output_nodes(Queue, N, ClosedSet, _),
	write('Osiągnięto limit krokow. Zwiekszyc limit? (t/n)'), nl,
	read('t'),
	NewLimit is MaxStepLimit + 1,
	fetch_new(Node, Queue, ClosedSet, RestQueue, N),
	NewStepCounter is StepCounter + 1,
	continue(Node, RestQueue, ClosedSet, PathCost, N, NewStepCounter, NewLimit).

continue(node(State, Action, Parent, Cost, _), _, ClosedSet, path_cost(Path, Cost), _, _, _):-
	goal(State),!,
	build_path(node(Parent, _, _, _, _), ClosedSet, [Action/State], Path).

continue(Node, RestQueue, ClosedSet, Path, N, StepCounter, MaxStepLimit):-
	expand(Node, NewNodes),
	insert_new_nodes(NewNodes, RestQueue, NewQueue),
	search_A_star(NewQueue, [Node| ClosedSet], Path, N, StepCounter, MaxStepLimit).

fetch_new(Node, Queue, ClosedSet, RestQueue, N):-
	get_user_decisions(Queue, N, ClosedSet, Decisions),
	get_index(Index, Decisions),
	get_element_at_index(Index, Node, Queue, ClosedSet, RestQueue).

get_user_decisions(Queue, N, ClosedSet, Decisions):-
	output_nodes(Queue, N, ClosedSet, Diff),
	write('Podaj indeksy: '), nl,
	NewN is N - Diff,
	input_decisions(NewN, Decisions).

output_nodes(_, 0, _, 0):- ! .

output_nodes([], N, _, N).

output_nodes([X|R], N, ClosedSet, N2):-
	member(X, ClosedSet), !,
	output_nodes(R, N, ClosedSet, N2).

output_nodes([X|R], N, ClosedSet, N2):-
	write(X), nl,
	NewN is N - 1,
	output_nodes(R, NewN, ClosedSet, N2).

input_decisions(0, []):- ! .

input_decisions(N, [D|RestDecisions]):-
	read(D),
	NewN is N - 1,
	input_decisions(NewN, RestDecisions).

get_index(X, [X|_]).

get_index(X, [_|R]):-
	get_index(X, R).

get_element_at_index(1, X, [X|R], ClosedSet, R):-
	\+ member(X, ClosedSet), ! .

get_element_at_index(Index, Node, [X|R], ClosedSet,[X|RestQueue]):-
	\+ member(X, ClosedSet), ! ,
	NewIndex is Index - 1,
	get_element_at_index(NewIndex, Node, R, ClosedSet, RestQueue).

get_element_at_index(Index, Node, [X|R], ClosedSet, [X|RestQueue]):-
	get_element_at_index(Index, Node, R, ClosedSet, RestQueue).

expand(node(State, _ ,_ , Cost, _ ), NewNodes):-
	findall(node(ChildState, Action, State, NewCost, ChildScore),
			(succ(State, Action, StepCost, ChildState), score(ChildState, Cost, StepCost, NewCost, ChildScore)),
			NewNodes), ! .

score(State, ParentCost, StepCost, Cost, FScore):-
	Cost is ParentCost + StepCost,
	hScore(State, HScore),
	FScore is Cost + HScore.

insert_new_nodes( [ ], Queue, Queue) .

insert_new_nodes( [Node|RestNodes], Queue, NewQueue):-
	insert_p_queue(Node, Queue, Queue1),
	insert_new_nodes( RestNodes, Queue1, NewQueue) .

insert_p_queue(Node,  [ ], [Node] ):- ! .

insert_p_queue(node(State, Action, Parent, Cost, FScore),
		[node(State1, Action1, Parent1, Cost1, FScore1)|RestQueue],
		[node(State1, Action1, Parent1, Cost1, FScore1)|Rest1]):-
	FScore >= FScore1, ! ,
	insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1).

insert_p_queue(node(State, Action, Parent, Cost, FScore), Queue, [node(State, Action, Parent, Cost, FScore)|Queue]).

build_path(node(nil, _, _, _, _ ), _, Path, Path):- ! .

build_path(node(EndState, _ , _ , _, _ ), Nodes, PartialPath, Path):-
	del(Nodes, node(EndState, Action, Parent , _ , _  ) , Nodes1) ,
	build_path(node(Parent,_ ,_ , _ , _ ) , Nodes1, [Action/EndState|PartialPath],Path).

del([X|R],X,R).

del([Y|R],X,[Y|R1]):-
	X\=Y,
	del(R,X,R1). 
