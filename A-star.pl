% example grid
succ(a,ab,2,b).
succ(b,bf,3,f).
succ(a,ac,3,c).
succ(b,bg,4,g).
succ(g,gm,2,m).
succ(c,cd,2,d).
succ(d,dm,2,m).
succ(c,ce,3,e).
succ(e,em,5,m).

% set goal
goal(m).

% basic heuristic
hScore(a,4).
hScore(b,4).
hScore(f,7).
hScore(g,1).
hScore(m,0).
hScore(c,3).
hScore(d,1).
hScore(e,4).

% Calls main program, initializes empty nodes queue and empty path
%    - InitState - initial state
%    - PathCost - resulting path cost
start_A_star(InitState, PathCost) :-
    % Initial cost based on InitState and InitScore heuristic
    score(InitState, 0, 0, InitCost, InitScore),
    % Run main procedure with Queue containing initial state and empty closed set
    search_A_star( [node(InitState, nil, nil, InitCost , InitScore ) ], [ ], PathCost) .

% Main algorithm step
search_A_star(Queue, ClosedSet, PathCost) :-
    % 'fetch' first element from queue
    fetch(Node, Queue, ClosedSet, RestQueue),
    % check Node state and end if condition is met, otherwise continue
    continue(Node, RestQueue, ClosedSet, PathCost).

% If Node state is destined end
continue(node(State, Action, Parent, Cost, _ ), _ , ClosedSet,path_cost(Path, Cost)) :-
    % Check 
    goal( State), !,
    % Build path and return it with it's cost
    build_path(node(Parent, _ , _ , _ , _ ), ClosedSet, [Action/State], Path) .

% If Node is not destinated end
continue(Node, RestQueue, ClosedSet, Path) :-
    % Expand Node neighbours
    expand(Node, NewNodes),
    % Insert Nodes to Queue
    insert_new_nodes(NewNodes, RestQueue, NewQueue),
    % Call algorithm step, moving Node to ClosedSet
    search_A_star(NewQueue,[Node| ClosedSet ],Path).

% Checks if first node in Queue is not in ClosedSet
fetch( node(State, Action, Parent, Cost, Score), 
      [node(State, Action, Parent, Cost, Score)|RestQueue], 
      ClosedSet, RestQueue) :-
    \+member(node(State, _ , _ , _ , _ ), ClosedSet), ! .

% If first node is in closed set, remove it and call for modified Queue
fetch(Node, [ _ |RestQueue], ClosedSet, NewRest):-
    fetch(Node, RestQueue, ClosedSet , NewRest).

% Constructs list of neighbours for a given Node
expand(node(State, _ ,_ , Cost, _ ), NewNodes) :-
    % Finds nodes that have given previous state
    findall(
        node(ChildState, Action, State, NewCost, ChildScore),
        (succ(State, Action, StepCost, ChildState), score(ChildState, Cost, StepCost, NewCost, ChildScore)),
        NewNodes),!.

% Calculates cost function for a State
score(State, ParentCost, StepCost, Cost, FScore) :-
    % Cost is parent cost + last step cost
    Cost is ParentCost + StepCost,
    % hScore is heuristic
    hScore(State, HScore),
    % Final Score
    FScore is Cost + HScore .

% Stop condition
insert_new_nodes( [ ], Queue, Queue) .

% (<Nodes to be inserted>, <PriorityQueue>, <ResultingQueue>)
% takes first Node and puts into PriorityQueue on each step
insert_new_nodes([Node|RestNodes], Queue, NewQueue):-
    insert_p_queue(Node, Queue, Queue1),
    insert_new_nodes(RestNodes, Queue1, NewQueue).


insert_p_queue(Node, [ ], [Node] ) :- !.
% Insert Node into PriorityQueue
insert_p_queue( node(State, Action, Parent, Cost, FScore),
               [node(State1, Action1, Parent1, Cost1, FScore1)|RestQueue],
               [node(State1, Action1, Parent1, Cost1, FScore1)|Rest1] ) :-
    FScore >= FScore1,  !,
    insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1) .

insert_p_queue(node(State, Action, Parent, Cost, FScore), Queue, [node(State, Action, Parent, Cost, FScore)|Queue]) .

build_path(node(nil, _, _, _, _ ), _, Path, Path) :- ! .
% build path from destinated end to start [which has nil preceding state]
build_path(node(EndState, _ , _ , _, _ ), Nodes, PartialPath, Path) :-
    del(Nodes, node(EndState, Action, Parent , _ , _  ) , Nodes1) ,
    build_path( node(Parent,_ ,_ , _ , _ ) , Nodes1,[Action/EndState|PartialPath],Path) .

% Deletes X element from first arg and returns R(esult)
del([X|R], X, R).
del([Y|R], X, [Y|R1]) :-
    X \= Y, del(R, X, R1).
