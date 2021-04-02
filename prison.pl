/*

    Prolog
    Exercise No.4  (prison)

*/


% May be helpful for testing

% generate_integer(+Min, +Max, -I)
%   I is an integer in the range Min <= I <= Max

generate_integer(Min,Max,Min):-
  Min =< Max.
generate_integer(Min,Max,I) :-
  Min < Max,
  NewMin is Min + 1,
  generate_integer(NewMin,Max,I).
  
  
% Uncomment this line to use the provided database for Problem 2.
% You MUST recomment or remove it from your submitted solution.
% :- include(prisonDb).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


make_list(0, _, []).

make_list(N, Item, [Item|List]) :-
  N > 0,
  NewN is N-1,
  make_list(NewN, Item, List).

extract_indices_rec(_, [], _, []).

extract_indices_rec(N, [E|List], Item, Indices) :-
  E \= Item,
  extract_indices_rec(N, List, Item, Indices).

extract_indices_rec(N, [Item|List], Item, [N|Indices]) :-
  NewN is N+1,
  extract_indices_rec(NewN, List, Item, Indices).

extract_indices(List, Item, Indices) :-
  extract_indices_rec(1, List, Item, Indices).

make_run(_,[],[],_).

make_run(N,[E|Initial],[E|Final], Counter) :-
  0 =\= Counter mod N,
  NewCounter is Counter+1,
  make_run(N,Initial,Final,NewCounter).

make_run(N,[E|Initial],[F|Final], Counter) :-
  0 =:= Counter mod N,
  NewCounter is Counter+1,
  (E = locked -> F = unlocked ; F = locked),
  make_run(N,Initial,Final,NewCounter).

run_warders(W,W,Initial,Final) :-
  make_run(W,Initial,Final,1).

run_warders(N, W, Initial, Final) :-
  N<W,
  make_run(N,Initial,NewInitial, 1),
  NewN is N+1,
  run_warders(NewN, W, NewInitial, Final).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switchDoor(locked,unlocked).
switchDoor(unlocked,locked).

has_psyco(Cell) :-
  prisoner(Surname, FirstName, Cell, _, _, _),
  psychopath(Surname,FirstName).

cell_status_rec(Cell,_,_,_,T) :-
  has_psyco(Cell),
  T=locked,
  !.

cell_status_rec(_,N,NewN,T,T) :-
  NewN =:= N+1.

cell_status_rec(Cell,N,M,Temp,Status) :-
  M=<N,
  NewM is M+1,
  ( 0 =:= Cell mod M -> switchDoor(Temp,NewTemp) ; NewTemp=Temp),
  cell_status_rec(Cell,N,NewM,NewTemp,Status).

cell_status(Cell, N,Status) :-
  cell_status_rec(Cell,N,1,locked,Status).

escaped(Surname, FirstName) :-
  prisoner(Surname, FirstName, Cell, _, _, _),
  warders(W),
  cell_status(Cell,W,Status),
  Status = unlocked.

escapers(List) :-
  setof((Surname,FirstName), escaped(Surname, FirstName), List).