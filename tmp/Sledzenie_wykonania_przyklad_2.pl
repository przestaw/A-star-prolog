% Przyk�ad zastosowania procedury my_trace:
% �ledzenie wykonania procedury  path_incl_nodes
%
%Procedura szuka �cie�ki w grafie zawieraj�cej wszystkie podane w�z�y
%
% Przyk�adowe wywo�anie  path_incl_nodes:

% path_incl_nodes(a,d,[c],Path).

% Po ka�dym komunikacie �ledzenia wykonania nale�y wprowadzi�:
% <dowolny znak>  <kropka>  <ENTER>
% dla procedury wbudowanej read



path_incl_nodes( X, Y, NodeList, Path)  :-
	my_trace(1,path_incl_nodes, 1,['X'/X,'Y'/Y, 'NodeList'/NodeList]),
        my_trace(2,path_incl_nodes, 1,path),
	path(X, Y, Path),
	my_trace(3,path_incl_nodes, 1,path,['Path'/Path]),
	my_trace(2,path_incl_nodes, 1,check_path),
	check_path(Path, NodeList),
	my_trace(3,path_incl_nodes,1,check_path,['�cie�ka zawiera NodeList'/NodeList]),
	my_trace(4,path_incl_nodes,1,['Path'/Path]).


check_path( _ , [ ] ) .

check_path(Path, [ X|RestNodeList]) :-
	member(X, Path) ,
	check_path(Path, RestNodeList ) .


path(Y, Y, [Y]) :- nl, nl, write('path 1').

path(X,Y,[X|RestPath])  :-
	X\=Y,nl, write('path 2    '), write('X='), write(X),
	arc(X,Z),  write('  Z='), write(Z),
	path(Z,Y,RestPath) .

arc(a, e):-write('  arc  1').
arc(a, b):-write('  arc  2').
arc(a, c ):-write('  arc 3').
arc(b, d):-write('  arc  4').
arc(c, d ):-write('  arc  5').


