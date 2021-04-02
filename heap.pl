is_heap(empty).

is_heap(heap(K, _, LH, RH)) :-
    integer(K),
    is_heap(LH),
    is_heap(RH).

add_to_heap(K,I,empty,heap(K,I,empty,empty)).

add_to_heap(K, I, heap(KH, IH, LH, RH), HNew) :-
    K < KH,
    add_to_heap(K, I, RH, HNewPartial),
    HNew = heap(KH,IH,HNewPartial,LH).

add_to_heap(K, I, heap(KH, IH, LH, RH), HNew) :-
    K >= KH,
    add_to_heap(KH, I, RH, HNewPartial),
    HNew = heap(K,IH,HNewPartial,LH).

remove_left_most(heap(K,I,empty,empty), K, I, empty).

remove_left_most(heap(K,I,LH,RH), KLM, ILM, HNew) :-
    remove_left_most(LH, KLM, ILM, HPartial),
    HNew = heap(K,I,RH,HPartial).

restore_heap(heap(K,I,empty,empty),heap(K,I,empty,empty)) :-
    !.

restore_heap(heap(K,I,heap(LK,LI,empty,empty),empty),HRestored) :-
    K < LK,
    HRestored = heap(LK,LI,heap(K,I,empty,empty),empty),
    !.

restore_heap(heap(K,I,heap(LK,LI,empty,empty),empty),HRestored) :-
    K >= LK,
    HRestored = heap(K,I,heap(LK,LI,empty,empty),empty),
    !.

restore_heap(heap(K,I,heap(LK,LI,LLH,LRH),heap(RK,RI,RLH,RRH)), heap(K,I,heap(LK,LI,LLH,LRH),heap(RK,RI,RLH,RRH))) :-
    max(LK,RK,Max),
    K =:= Max.

restore_heap(heap(K,I,heap(LK,LI,LLH,LRH),heap(RK,RI,RLH,RRH)), HRestored) :-
    K < LK,
    LK > RK,
    restore_heap(heap(K,I,LLH,LRH), NewLLH),
    HRestored = heap(LK,LI,NewLLH,heap(RK,RI,RLH,RRH)).

restore_heap(heap(K,I,heap(LK,LI,LLH,LRH),heap(RK,RI,RLH,RRH)), HRestored) :-
    K < RK,
    RK >= LK,
    restore_heap(heap(K,I,RLH,RRH), NewRLH),
    HRestored = heap(RK,RI,heap(LK,LI,LLH,LRH),NewRLH).

remove_max(heap(K,I,LH,RH), K, I, empty) :-
    remove_left_most(heap(K,I,LH,RH), _, _, empty).

remove_max(heap(K,I,LH,RH), K, I, HNew) :-
    remove_left_most(heap(K,I,LH,RH), KLM, ILM, heap(_,_,LH2,RH2)),
    HNewPartial = heap(KLM, ILM, LH2,RH2),
    restore_heap(HNewPartial, HNew).

build_heap([],H,H).

build_heap([(K,I)|L], HPartial, H) :-
    add_to_heap(K,I,HPartial,HNew),
    build_heap(L,HNew,H).

dismantle_heap(empty,[]) :-
    !.

dismantle_heap(H,[(K,I)|S]) :-
    remove_max(H,K,I,NH),
    dismantle_heap(NH,S).

heap_sort_asc(L,S) :-
    build_heap(L,empty,H),
    dismantle_heap(H,S).


    
remove_element(_, [], []).

remove_element(H, [H|X], X).

remove_element(H, [Xs|X], [Xs|Z]) :-
    remove_element(H, X, Z),
    !.

delete_from_heap(I, H, NewH) :-
    dismantle_heap(H, S),
    member((_, I), S),
    remove_element((_, I), S, NewS),
    build_heap(NewS, empty, NewH),
    !.