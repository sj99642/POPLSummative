
% ------ Question 1
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

station_on_line(Station, Line) :- station(Station, Lines), member(Line, Lines).
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