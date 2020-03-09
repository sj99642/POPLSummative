
% ------ Question 1

% Just state the facts according to the diagram
station("AL", [metropolitan]).
station("BG", [central]).
station("BR", [victoria]).
station("BS", [metropolitan]).
station("CL", [central]).
station("EC", [bakerloo]).
station("EM", [bakerloo, northern]).
station("EU", [northern]).
station("FP", [victoria]).
station("FR", [metropolitan]).
station("KE", [northern]).
station("KX", [metropolitan, victoria]).
station("LG", [central]).
station("LS", [central, metropolitan]).
station("NH", [central]).
station("OC", [bakerloo, central, victoria]).
station("PA", [bakerloo]).
station("TC", [central, northern]).
station("VI", [victoria]).
station("WA", [bakerloo]).
station("WS", [northern, victoria]).

% ------ Question 2

% Asks if there is any fact assigning Station to a particular list of lines
station_exists(Station) :- station(Station, _).

% Test cases
% ?- station_exists("KE")
% true.
%
% ?- station_exists("KEE")
% false.
% 
% ?- station_exists(central)
% false.




% ------ Question 3

% List the facts according to the diagram

% Bakerloo line
adj("WA", "PA").
adj("PA", "OC").
adj("OC", "EM").
adj("EM", "EC").

% Central line
adj("NH", "LG").
adj("LG", "OC").
adj("OC", "TC").
adj("TC", "CL").
adj("CL", "LS").
adj("LS", "BG").

% Metropolitan line
adj("FR", "BS").
adj("BS", "KX").
adj("KX", "LS").
adj("LS", "AL").

% Northern line
adj("EU", "WS").
adj("WS", "TC").
adj("TC", "EM").
adj("EM", "KE").

% Victoria line
adj("FP", "KX").
adj("KX", "WS").
adj("WS", "OC").
adj("OC", "VI").
adj("VI", "BR").

% Provide a rule to see if two stations are adjacent in either direction
adjacent(Station1, Station2) :- adj(Station1, Station2).
adjacent(Station1, Station2) :- adj(Station2, Station1).

% ------ Question 4

% A station is on a line if there is some list of Lines which is both assigned to Station in a fact (from Q1)
% and Line is in that list of lines. This is useful in seeing if two stations are on the same line.
station_on_line(Station, Line) :- station(Station, Lines), member(Line, Lines).

% Two stations are on the same line if station_on_line is true for both of them, for the same line.
sameline(Station1, Station2, Line) :- station_on_line(Station1, Line), station_on_line(Station2, Line).

% Test cases:
% ?- sameline("WA", "EC", Line).
% Line = bakerloo.
%
% ?- sameline("FP", "KE", Line).
% false. 
% 
% ?- sameline("WS", "OC", victoria).
% true.
% 
% ?- sameline("WS", Station, Line).
% Station = "EM",
% Line = northern ;
% Station = "EU",
% Line = northern ;
% Station = "KE",
% Line = northern ;
% Station = "TC",
% Line = northern ;
% Station = "WS",
% Line = northern ;
% false.

% ------ Question 5

% The `setof` function collects all X for which station_on_line(X, Line) (that is, all
% the stations on the line Line), and puts them in ListOfStations.
line(Line, ListOfStations) :- setof(X, station_on_line(X, Line), ListOfStations).

% Test cases:
% ?- line(metropolitan, ListOfStations).
% ListOfStations = ["AL", "BS", "FR", "KX", "LS"].
% 
% ?- line(northern, ListOfStations).
% ListOfStations = ["EM", "EU", "KE", "TC", "WS"].
% 
% ?- line(victoria, ["BR", "VI", "OC", "WS", "KX"]).
% false. 
%
% ?- line(Line, ["EC", "EM", "OC", "PA", "WA"]).
% Line = bakerloo.

% ------ Question 6

% Get the list of Lines matching Station, and then output its length to NumberOfLines. 
station_numlines(Station, NumberOfLines) :- station(Station, Lines), length(Lines, NumberOfLines).

% Test cases:
% ?- station_numlines("AL", NumberOfLines).
% NumberOfLines = 1.
% 
% ?- station_numlines("EM", NumberOfLines).
% NumberOfLines = 2.
% 
% ?- station_numlines("OC", NumberOfLines).
% NumberOfLines = 3.
% 
% ?- station_numlines(Station, 2).
% Station = "EM" ;
% Station = "KX" ;
% Station = "LS" ;
% Station = "TC" ;
% Station = "WS".


% ------ Question 7

% Gets the number of lines at the station, and if there are more than one, then this is an interchange.
is_interchange(Station) :- station_numlines(Station, NumberOfLines), NumberOfLines > 1.

% This first checks that NonInterStation is not an interchange an that InterchangeStation is. Then it checks to see if the two are adjacent. 
adjacent2interchange(NonInterStation, InterchangeStation) :- not(is_interchange(NonInterStation)), is_interchange(InterchangeStation), adjacent(NonInterStation, InterchangeStation).

% Test cases:
% ?- adjacent2interchange("CL", InterchangeStation).
% InterchangeStation = "LS" ;
% InterchangeStation = "TC".
% 
% ?- adjacent2interchange("TC", InterchangeStation).
% false.


% ------ Question 8

% Count occurrences of an item in a list
% count([], Item, 0). % None of the item in an empty list
% count([Item|T], Item, Count) :- count(T, Item, Z), Count is 1+Z. % If the head is the item then add 1 and recurse
% count([NotItem|T], Item, Count) :- NotItem\=Item, count(T, Item, Count). % If the head is not the item then just recurse

% % Base case: two adjacent stations already form a route
% route(From, To, Route) :- adjacent(From, To), Route=[From, To].
% route(From, To, Route) :- adjacent(From, X), count(Route, X, XCount), XCount=<1, route(X, To, R), Route=[From|R].

% We need 2 rules, one to actually use (route) and one internally, to keep track of visited
% nodes and prevent cycles (which would cause infinite regress).

% This is effectively the user interface. It runs `scan`, which produced RRoute, the route from To
% back to From (due to how `scan` works), so this then reverses that.
route(From, To, Route) :- scan(From, To, [From], RRoute), reverse(RRoute, Route).

% This says that a path from From to To has been found if they are adjacent
scan(From, To, Path, [To|Path]) :- adjacent(From, To). 
% This says we have a path from From to To if From is connected to some node X, not equal to To and
% which has not yet been scanned, and we have a path from X to To.
scan(From, To, Scanned, Path) :- adjacent(From, X), X\==To, \+member(X, Scanned), scan(X, To, [X|Scanned], Path).

% Test cases:
% ?- route("TC", "CL", Route).
% Route = ["TC", "CL"] ;
% Route = ["TC", "EM", "OC", "WS", "KX", "LS", "CL"] ;
% Route = ["TC", "OC", "WS", "KX", "LS", "CL"] ;
% Route = ["TC", "WS", "KX", "LS", "CL"] ;
% false.
% 
% ?- route("FR", "FR", Route).
% Route = ["FR", "BS", "FR"] ;
% false.
% 
% ?- route("NH", "LG", Route).
% Route = ["NH", "LG"] ;
% false.
% 
% ?- route("BR", "FP", Route).
% Route = ["BR", "VI", "OC", "EM", "TC", "CL", "LS", "KX", "FP"] ;
% Route = ["BR", "VI", "OC", "EM", "TC", "WS", "KX", "FP"] ;
% Route = ["BR", "VI", "OC", "TC", "CL", "LS", "KX", "FP"] ;
% Route = ["BR", "VI", "OC", "TC", "WS", "KX", "FP"] ;
% Route = ["BR", "VI", "OC", "WS", "TC", "CL", "LS", "KX", "FP"] ;
% Route = ["BR", "VI", "OC", "WS", "KX", "FP"] ;
% false.