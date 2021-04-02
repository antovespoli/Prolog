%% File: syllogisms.pl
%% Name: Antonio Vespoli
%% Date: 25/11/2020
%%
%% This program is a solution to Prolog Assessed Exercise 5 'Syllogisms'
%% The exercise is to develop a parser and meta-interpreter for syllogistic
%% sentences, and use these to build a tool to determine the validity of a
%% syllogistic argument.

%% ---------------------------- Step 1 ---------------------------------------%%

%% opposite(+L, -Opp)

%% Opposite is returned by first matching form and no backtracking is performed

opposite([a,B,is,Article,C], [some,B,is,not,Article,C]).

opposite([every,B,is,Article,C], [some,B,is,not,Article,C]).

opposite([a,B,is,C], [some,B,is,not,C]).

opposite([every,B,is,C], [some,B,is,not,C]).

opposite([some,B,is,not,Article,C], [a,B,is,Article,C]).

opposite([some,B,is,not,C], [a,B,is,C]).

opposite([no,B,is,Article,C], [some,B,is,Article,C]).

opposite([no,B,is,C], [some,B,is,C]).

opposite([some,B,is,C], [no,B,is,C]).

opposite([some,B,is,Article,C], [no,B,is,Article,C]).

%% ---------------------------- Step 2 ---------------------------------------%%

%% syllogism(-Clauses)

% Each DCG rule converts a sentence in the respective list of clauses

article --> [a].
article --> [every].

optionalArticle --> [a].
optionalArticle --> [].

syllogism(Cl) -->
    article,
    [B,is],
    optionalArticle,
    [C],
    { 
        Cl1 =.. [C,X],
        Cl2 =.. [B,X],
        Cl = [(Cl1 :- Cl2)]
    }.

syllogism(Cl) -->
    [some,B,is,not],
    optionalArticle,
    [C],
    {
        Cl1 =.. [some,B,C],
        Cl2 =.. [B,Cl1],
        Cl3 =.. [C,Cl1],
        Cl = [ (Cl2 :- true), ( Cl3 :- true) ]
    }.

syllogism(Cl) -->
    [no,B,is],
    optionalArticle,
    [C],
    {
        Cl1 =.. [B,X],
        Cl2 =.. [C,X],
        Cl = [ (false :- Cl1,Cl2) ]
    }.

syllogism(Cl) -->
    [some,B,is],
    optionalArticle,
    [C],
    {
        Cl1 =.. [not,C],
        Cl2 =.. [some,B,Cl1],
        Cl3 =.. [B,Cl2],
        Cl4 =.. [C,Cl2],
        Cl = [ (Cl3 :- true), (false :- Cl4) ]
    }.

%% ---------------------------- Step 3 ---------------------------------------%%

%% translate(+N)

% Searches premises and conclusion, applies opposite, gets corresponding clauses and asserts them 

translate(N) :-
    p(N,A),
    p(N,B),
    B \= A,
    c(N,C),
    opposite(C,OC),
    phrase(syllogism(ClauseList1),A),
    phrase(syllogism(ClauseList2),B),
    phrase(syllogism(ClauseList3),OC),
    append(ClauseList1,ClauseList2,ClauseList4),
    append(ClauseList4,ClauseList3,ClauseList5),
    assertall(N,ClauseList5).



%% ---------------------------- Step 4 ---------------------------------------%%

%% eval(+N, +Calls)

% Recursively evaluates the clause and succeds if each condition in Calls is derivable from the clauses



%% ---------------------------- Step 5 ---------------------------------------%%

%% test(+N)
