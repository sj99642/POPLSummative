
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
adjacent("WA", "PA").
adjacent("PA", "OC").
adjacent("OC", "EM").
adjacent("EM", "EC").

% Central line
adjacent("NH", "LG").
adjacent("LG", "OC").
adjacent("OC", "TC").
adjacent("TC", "CL").
adjacent("CL", "LS").
adjacent("LS", "BG").

% Metropolitan line
adjacent("FR", "BS").
adjacent("BS", "KX").
adjacent("KX", "LS").
adjacent("LS", "AL").

% Northern line
adjacent("EU", "WS").
adjacent("WS", "TC").
adjacent("TC", "EM").
adjacent("EM", "KE").

% Victoria line
adjacent("FP", "KX").
adjacent("KX", "WS").
adjacent("WS", "OC").
adjacent("OC", "VI").
adjacent("VI", "BR").

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

% This first checks that NonInterStation is not an interchange an that InterchangeStation is. Then it checks to see if the two are adjacent 
% in either direction, using disjunction (;). 
adjacent2interchange(NonInterStation, InterchangeStation) :- not(is_interchange(NonInterStation)), (adjacent(NonInterStation, InterchangeStation);adjacent(InterchangeStation, NonInterStation)).

% Test cases:
% ?- adjacent2interchange("CL", InterchangeStation).
% InterchangeStation = "LS" ;
% InterchangeStation = "TC".
% 
% ?- adjacent2interchange("TC", InterchangeStation).
% false.

