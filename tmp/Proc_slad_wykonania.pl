% PROCEDURY my_trace, my_trace_rec
% ---my_trace_rec DO �LEDZENIA PROCEDUR REKURENCYJNYCH
%
% Ka�da z procedur ma cztery warianty
% --wyprowadzaj� komunikaty i warto�ci zmiennych odpowiednio:
% 1)po wej�ciu do �ledzonej procedury,
% 2)przed wywo�aniem innej procedury,
% 3)po powrocie z innej procedury,
% 4)na zako�czenie wykonania �ledzonej procedury.
%
% W komunikatach nazwa �ledzonej procedury i numer klauzuli,
%  ---procedura my_trace_rec wyprowadza dodatkowo poziom rekurencji
%        ---wymaga u�ycia dodatkowego argumentu w procedurze �ledzonej
%
% PO WYPROWADZENIU KOMUNIKATU JEST WYWO�YWANA WBUDOWANA PROCEDURA read
% W CELU WYMUSZENIA ZATRZYMANIA WYKONANIA.
% ABY KONTYNUOWA� UZYTKOWNIK WPROWADZA Z KLAWIATURY
% CI�G ZNAK�W ZAKO�CZONY <kropka> <ENTER>
%
%
% PRZYK�AD U�YCIA w pliku Sledzenie_wykonania_przyklad



%PROCEDURA  my_trace
%
%
% wariant 1: w celu wyprowadzenia warto�ci zmiennych
% na wej�ciu do procedury
my_trace(1,ProcName, Clause, ArgList) :-
	nl, nl, nl, write(ProcName),
	write('   klauzula   '), write(Clause),
	write('    wej�cie'),
	write_args(ArgList), nl, read(_).

%wariant 2:  w celu wyprowadzenia komunikatu o wywo�aniu innej procedury
my_trace(2,ProcName, Clause, ProcName2) :-
	nl, write(ProcName),
	write('   klauzula   '), write(Clause),
	nl,write('wywo�anie   '), write(ProcName2), nl.

% wariant 3: w celu wyprowadzenia warto�ci zmiennych
% po powrocie z innej procedury
my_trace(3,ProcName, Clause, ProcName2, ArgList) :-
	nl, write(ProcName),
	write('   klauzula   '), write(Clause),
	nl,write('po wykonaniu   '), write(ProcName2),
	write_args(ArgList), nl, read(_).

% wariant 4:w celu wyprowadzenia warto�ci zmiennych na zako�czenie
% wykonania procedury na danym poziomie rekurencji
my_trace(4,ProcName, Clause, ArgList) :-
	nl, write(ProcName),
	write('   klauzula   '), write(Clause),
	nl,write('KONIEC WYKONANIA'),
	write_args(ArgList),nl,nl, nl.


write_args([]).


write_args([First|Rest]) :-
	write_one_arg(First),
	write_args(Rest).


write_one_arg(Name/Val)  :-
	nl, write(Name), write('='), write(Val).




%PROCEDURA  my_trace_rec
%
% wymaga dodatkowego argumentu wej�ciowego
% w procedurze �ledzonej: argument Level
% okre�la aktualny poziom rekurencji.
% Nale�y zainicjalizowa� jako 0.
%
%
% wariant1: w celu wyprowadzenia warto�ci zmiennych
% na wej�ciu do procedury
my_trace_rec(1,ProcName, Clause,Level, ArgList) :-
	nl, nl, nl, write(ProcName),
	write('   poziom   '), write(Level),
	write('   klauzula   '), write(Clause),
	write('    wej�cie'),
	write_args(ArgList), nl, read(_).


% wariant2: w celu wyprowadzenia komunikatu o wywo�aniu innej procedury
my_trace_rec(2,ProcName, Clause, Level, ProcName2) :-
	nl, write(ProcName),
	write('   poziom   '), write(Level),
	write('   klauzula   '), write(Clause),
	nl,write('wywo�anie   '), write(ProcName2), nl.

% wariant3:w celu wyprowadzenia warto�ci zmiennych
% po powrocie z innej procedury
my_trace_rec(3,ProcName, Clause, Level,ProcName2, ArgList) :-
	nl, write(ProcName),
	write('   poziom   '), write(Level),
	write('   klauzula   '), write(Clause),
	nl,write('po wykonaniu   '), write(ProcName2),
	write_args(ArgList), nl, read(_).

% wariant 4:w celu wyprowadzenia warto�ci zmiennych
% na zako�czenie wykonania procedury na danym poziomie rekurencji
my_trace_rec(4,ProcName, Clause,Level, ArgList) :-
	nl, write(ProcName),
	write('   poziom   '), write(Level),
	write('   klauzula   '), write(Clause),
	nl,write('KONIEC WYKONANIA NA POZIOMIE  '),write(Level),
	write_args(ArgList),
	end_trace(Level, ProcName).


end_trace(0,ProcName)  :-
	nl,  nl,  write('KONIEC �LEDZENIA  '), write(ProcName), nl, nl.

end_trace(Level,_)  :-
	Level >0,
	nl, read(_).
