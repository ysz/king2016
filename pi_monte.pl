%% -*- Mode: prolog; Author: ysz; -*-

sum_list(Lst, SumList) :- 
    length(Lst, X),
    ( X =:= 0
    ->  SumList = 0
    ;   [Car|Cdr] = Lst,
        sum_list(Cdr, SumList0),
        SumList is Car + SumList0
    ).

%% sum_list(0, Lst, 0).
%% sum_list(X, [Car|Cdr], SumList) :-
%%     sum_list(Cdr, SumList0),
%%     SumList is Car + SumList0.

%% sum_list([1,2,3], X), write(X), nl.

:- if(current_prolog_flag(dialect, sicstus)).
:- use_module(library(random)).
%% Provides random(-Uniform)
:- endif.

throw :-
    random(X),
    random(Y),
    Sqrt is sqrt((X * X) + (Y * Y)),
    1.0 =< Sqrt.

inc(X0, X) :-
    X is X0 + 1.

dec(X0, X) :-
    X is X0 - 1.

pi_monte(N0, In0, PiMonte) :-
    ( N0 =:= 0
    ->  PiMonte = In0
    ;   ( throw, !,
            dec(N0, N),
            pi_monte(N, In0, PiMonte)
        ;   dec(N0, N),
            inc(In0, In),
            pi_monte(N, In, PiMonte)
        )
    ).
%% pi_monte(0, In, In).
%% pi_monte(N0, In, PiMonte) :-
%%     throw, !,
%%     dec(N0, N),
%%     pi_monte(N, In, PiMonte).
%% pi_monte(N0, In0, PiMonte) :-
%%     dec(N0, N),
%%     inc(In0, In),
%%     pi_monte(N, In, PiMonte).

%% pi_monte(100000,0,PiMonte), X is 4 * PiMonte, write(X), nl.

% This will be called when the application starts:
user:runtime_entry(start) :-
    sum_list([1,2,3], SumList), write(SumList), nl,
    pi_monte(100000,0,PiMonte), X is 4 * PiMonte, write(X), nl.

/* 
sicstus -i -f --goal "compile(pi_monte),save_program('pi_monte.sav'),halt." \
&& spld --output=pi_monte.exe --static pi_monte.sav
*/
%% % ./pi_monte.exe
%% 6
%% 313788

%% Local Variables:
%% prolog-indent-width: 4
%% End:
