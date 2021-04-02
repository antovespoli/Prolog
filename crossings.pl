wolf_goat(Bank) :-
    \+ member(f, Bank),
    member(w, Bank),
    member(g, Bank).

goat_cabbage(Bank) :-
    \+ member(f, Bank),
    member(c, Bank),
    member(g, Bank).

safe(Bank) :-
    \+ wolf_goat(Bank),
    \+ goat_cabbage(Bank).


count(_, [], A, A).

count(K, [S|List], Acc, N) :-
    K \= S,
    count(K, List, Acc, N).

count(K, [K|List], Acc, N) :-
    NewAcc is Acc+1,
    count(K, List, NewAcc, N).

goal([]-South) :-
    G=1,
    count(g, South, 0, G),
    count(c, South, 0, G),
    count(f, South, 0, G),
    count(w, South, 0, G),
    count(b, South, 0, G),
    length(South, 5).

remove_first(X, [X|T], T).

remove_first(X, [Y|T], [Y|T2]) :-
    X \= Y,
    remove_first(X, T, T2).

equiv_bank([], []).

equiv_bank([E|B1],B2) :-
    remove_first(E, B2, B2New),
    equiv_bank(B1,B2New).

equiv(N1-S1, N2-S2) :-
    equiv_bank(N1,N2),
    equiv_bank(S1,S2).

visited(State, Sequence) :-
    member(AnyState, Sequence),
    equiv(State, AnyState).

choose(Items, Bank) :-
    remove_first(f, Bank, NewBank),
    safe(NewBank),
    Items = [f].

choose(Items, Bank) :-
    remove_first(f, Bank, NewBank),
    member(AnyElement, NewBank),
    remove_first(AnyElement, NewBank, NewNewBank),
    safe(NewNewBank),
    Items = [f, AnyElement].

list_diff([], [], []).

list_diff([E|S],I,NS) :-
    member(E, I),
    remove_first(E,I,NewI),
    list_diff(S,NewI,NS).

list_diff([E|S],I,[E|NS]) :-
    \+ member(E, I),
    list_diff(S,I,NS).

journey(N1-S1, N2-S2) :-
    member(f,N1),
    choose(Items, N1),
    append(S1,Items,S2),
    list_diff(N1, Items, N2).

journey(N1-S1, N2-S2) :-
    member(f,S1),
    choose(Items, S1),
    append(N1,Items,N2),
    list_diff(S1, Items, S2).

extend_rec(S1,NewN,S1) :-
    goal(NewN).

extend_rec(S1,N,S2) :-
    \+ goal(N),
    journey(N,NewN),
    \+ visited(NewN, S1),
    append(S1, [NewN], S1New),
    extend_rec(S1New,NewN,S2).

succeeds(Sequence) :-
    extend_rec([ [f,w,g,c,b]-[] ], [f,w,g,c,b]-[], Sequence).

fees(1, 2).

fee(N1-_, N2-_, Fee) :-
    length(N1,L1),
    length(N2,L2),
    1 =:= (L1-L2)**2,
    fees(Fee,_).

fee(N1-_, N2-_, Fee) :-
    length(N1,L1),
    length(N2,L2),
    4 =:= (L1-L2)**2,
    fees(_,Fee).

cost_rec([_],A,A).

cost_rec([E1,E2|S], Acc, Cost) :-
    fee(E1,E2,NewCost),
    NewAcc is Acc+NewCost,
    cost_rec([E2|S],NewAcc,Cost).

cost(Sequence, Cost) :-
    succeeds(Sequence),
    cost_rec(Sequence,0,Cost).