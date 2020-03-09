% ------ Question 1

% Base case: If the list has just one item, the sum is the value of that item.
% Using this instead of sum([], Sum) :- Sum is 0. because the question specifies
% the first argument must be a non-empty list.  
sum([H], H).

% Find the sum of the tail, then the total sum is the head plus this inner sum. 
sum([H1,H2|T], Sum) :- sum([H2|T], InnerSum), Sum is InnerSum+H1.

% Test cases:
% ?- sum([1, 2, 3], Length).
% Length = 6 . 
%
% ?- sum([1, 2, 3, 4], 10).
% true . 


% Question 2 is in Scheme
% ------ Question 3

% If the list has just one item (i.e. the tail is empty) then it is in descending order
desc([H|T]) :- T=[].

% If there are at least 2 elements, the first must be at least as big as the second,
% and the list from the second onward must be descending. 
desc([H1,H2|T]) :- H1>=H2, desc([H2|T]).

% Test cases:
% ?- desc([100]).
% true .
% 
% ?- desc([4, 3]).
% true .
% 
% ?- desc([3, 4]).
% false.

% ?- desc([10, 5, 1]).
% true .
% 
% ?- desc([3, 2, 1, 3]).
% false.

% Question 4 is in Scheme