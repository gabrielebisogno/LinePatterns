% Prog E3P Line-Patterns

% Gruppo di lavoro:
% Gabriele Bisogno 810106
% Alessandro Dossi 771041
% Jacopo Bazzaro 807342

% Calcolo dell'area di un triangolo
area2(point(X1, Y1), point(X2, Y2), point(X3, Y3), Area) :-
    Area is (((X2 - X1) * (Y3 - Y1)) - ((Y2 - Y1) * (X3 - X1))), !.

% svolta a sinistra
left(A, B, C) :-
  area2(A, B, C, Area),
  Area > 0.

% svolta a destra
left_on(A, B, C) :-
  area2(A, B, C, Area),
  Area < 0.

% punti collineari
collinear(A, B, C) :- area2(A, B, C, 0).

% angolo tra due punti
angle2d(A, B, R) :- atan2(A, B, R).
  % debug: conversione in gradi
  %atan2(A, B, Radiants),
  %R is (Radiants * 180 / pi).

%%% Creazione degli slopes: %%%
% slope(Angle, Point) è una coppia <Angolo, Punto>
make_slope(Point, Slope) :-
	Point = point(X, Y),
	angle2d(X, Y, Angle),
	Slope = slope(Angle, Point).

% ordinamento di point(X, Y) in base alla Y
sort_points_by_y(List, Sorted) :-
	sort(2, @<, List, Sorted).

% creazione della lista degli slopes
make_slopes_list([], []).
make_slopes_list([L | Ls], [S | Sl]) :-
		make_slope(L, S),
		make_slopes_list(Ls, Sl), !.

% ordinamento della lista in base all'angolo
% (senza eliminazione degli angoli uguali...)
sort_by_angle(List, Sorted) :-
	sort(0, @=<, List, Sorted).

%%%%%%%%%%%%%%%%%%%%%%% Algoritmo Line Patterns %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%predicato che dati due slope mi indica se essi hanno lo stesso angolo
sameAngle(slope(A, _P1), slope(A, _P2)).

%predicato per l'eliminazione di liste vuote
deleteEmptyList(X, R):-
	deleteEmptyList([], X, R).
deleteEmptyList(_X, [], []).
deleteEmptyList(X, [X | Xs], Y) :-
	deleteEmptyList(X, Xs, Y).
deleteEmptyList(X, [T | Xs], Y) :-
	deleteEmptyList(X, Xs, Y2), append([T], Y2, Y).

%punti insufficenti per un segmento
line_patterns([], []) :- !.
line_patterns([_P1], []) :- !.
line_patterns([_P1, _P2], []) :- !.
line_patterns([_P1, _P2, _P3], []) :- !.

%1 QUADRANTE
line_patterns([point(X, Y) | Ps], R) :-
	X >= 0,
	Y >= 0,
	segment1(Ps, point(X, Y), R1),
	line_patterns(Ps, R2),
	append(R1, R2, Rpar),
	deleteEmptyList(Rpar, R), !.

%2 QUADRANTE
line_patterns([point(X, Y) | Ps], R) :-
	X =< 0,
	Y >= 0,
	segment2(Ps, point(X, Y), R1),
	line_patterns(Ps, R2),
	append(R1, R2, Rpar),
	deleteEmptyList(Rpar, R), !.

%3 QUADRANTE
line_patterns([point(X, Y) | Ps], R) :-
	X =< 0,
	Y =< 0,
	segment3(Ps, point(X, Y), R1),
	line_patterns(Ps, R2),
	append(R1, R2, Rpar),
	deleteEmptyList(Rpar, R), !.

%4 QUADRANTE
line_patterns([point(X, Y) | Ps], R):-
	X >= 0,
	Y =< 0,
	segment4(Ps, point(X, Y), R1),
	line_patterns(Ps, R2),
	append(R1, R2, Rpar),
	deleteEmptyList(Rpar, R), !.

%Segment mi trova tutti i segmenti che hanno in comune P0
segment1(Ps, P0, R) :-
	standard1(P0, Ps, Standardized),
	make_slopes_list(Standardized, Slopes),
	sort_by_angle(Slopes, SortedSlopes),
	collinear1(SortedSlopes, P0, Rpar),
	deleteEmptyList(Rpar, R).

segment2(Ps, P0, R):-
	standard2(P0, Ps, Standardized),
	make_slopes_list(Standardized, Slopes),
	sort_by_angle(Slopes, SortedSlopes),
	collinear2(SortedSlopes, P0, R).

segment3(Ps, P0, R):-
	standard3(P0, Ps, Standardized),
	make_slopes_list(Standardized, Slopes),
	sort_by_angle(Slopes, SortedSlopes),
	collinear3(SortedSlopes, P0, R).

segment4(Ps, P0, R):-
	standard4(P0, Ps, Standardized),
	make_slopes_list(Standardized, Slopes),
	sort_by_angle(Slopes, SortedSlopes),
	collinear4(SortedSlopes, P0, R).

%standard si occupa di standardizzare tutti i punti a seconda del punto P0 di
%riferimento
standard1(_P0, [], []) :- !.

standard1(point(X, Y), [point(A, B) | Ps], [point(XS, YS) | Rs]) :-
	XS is (A - X),
	YS is (B - Y),
	standard1(point(X, Y), Ps, Rs), !.

standard2(_P0, [], []) :- !.

standard2(point(X, Y), [point(A, B) | Ps], [point(XS, YS) | Rs]):-
	XS is (A +  abs(X)),
	YS is (B - Y),
	standard1(point(X, Y), Ps, Rs), !.

standard3(_P0, [], []) :- !.

standard3(point(X, Y), [point(A, B) | Ps], [point(XS, YS) | Rs]):-
	XS is (A + abs(X)),
	YS is (B + abs(Y)),
	standard1(point(X, Y), Ps, Rs), !.

standard4(_P0, [], []) :- !.

standard4(point(X, Y), [point(A, B) | Ps], [point(XS, YS) | Rs]) :-
	XS is (A - X),
	YS is (B + abs(Y)),
	standard1(point(X, Y), Ps, Rs), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Primo Quadrante %%%%%%%%%%%%%%%%%%%%%%%%%%%%

collinear1([], _P0, []) :- !.
collinear1([_P], _P0, []) :- !.
collinear1([_P1, _P2], _P0, []) :- !.

collinear1([P1 | Ps], P0, [R | Rs]) :-
	collinear1(Ps, P1, P0, Rpar),
	flatten(Rpar, R),
	collinear1(Ps, P0, Rs), !.

collinear1([P2 | Ps], P1, P0, R) :-
	sameAngle(P2, P1),
	collinear1(Ps, P2, P1, P0, R), !.

collinear1(_P, _P1, _P0, []) :- !.

collinear1([P3 | Ps], P2, P1, P0, [R | Rs]) :-
	sameAngle(P3, P2),
	buildSegment1(P3, P2, P1, P0, R),
	collinearPlus1(Ps, P3, P0, Rs), !.

collinear1(_P, _P2, _P1, _P0, []) :-!.

%%%%%%%%%%%%

collinearPlus1([], _P3, _P0, []):-!.
collinearPlus1(
    [slope(A, point(X, Y)) | Ps],
    slope(A, B),
    point(X0, Y0),
    [point(XF, YF) | Rs]) :-
    XF is (X + X0),
    YF is (Y + Y0),
    collinearPlus1(Ps, slope(A, B), point(X0, Y0), Rs), !.

collinearPlus1(_P, _P3, _P0, []) :- !.

%%%%%%%%%%%%

buildSegment1(
    slope(A, point(X3, Y3)),
    slope(A, point(X2, Y2)),
    slope(A, point(X1, Y1)),
    point(X0, Y0),
    [point(X0, Y0),
     point(X1F, Y1F),
     point(X2F, Y2F),
     point(X3F, Y3F)]) :-
    X1F is (X1 + X0),
    X2F is (X2 + X0),
    X3F is (X3 + X0),
    Y1F is (Y1 + Y0),
    Y2F is (Y2 + Y0),
    Y3F is (Y3 + Y0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Secondo Quadrante %%%%%%%%%%%%%%%%%%%%%%%%%%%%

collinear2([], _P0, []) :- !.
collinear2([_P], _P0, []) :- !.
collinear2([_P1, _P2], _P0, []) :- !.

collinear2([P1 | Ps], P0, [R | Rs]) :-
	collinear2(Ps, P1, P0, Rpar),
	flatten(Rpar, R),
	collinear2(Ps, P0, Rs), !.

collinear2([P2 | Ps], P1, P0, R) :-
	sameAngle(P2, P1),
	collinear2(Ps, P2, P1, P0, R), !.

collinear2(_P, _P1, _P0, []) :- !.

collinear2([P3 | Ps], P2, P1, P0, [R | Rs]) :-
	sameAngle(P3, P2),
	buildSegment2(P3, P2, P1, P0, R),
	collinearPlus2(Ps, P3, P0, Rs), !.

collinear2(_P, _P2, _P1, _P0, []) :- !.

%%%%%%%%%%%%

collinearPlus2([], _P3, _P0, []) :- !.
collinearPlus2(
    [slope(A, point(X, Y)) | Ps],
    slope(A, B),
    point(X0, Y0),
    [point(XF, YF) | Rs]) :-
    XF is (X - abs(X0)),
    YF is (Y + Y0),
    collinearPlus2(Ps, slope(A, B), point(X0, Y0), Rs), !.

collinearPlus2(_P, _P3, _P0, []) :- !.

%%%%%%%%%%%%

buildSegment2(
    slope(A, point(X3, Y3)),
    slope(A, point(X2, Y2)),
    slope(A, point(X1, Y1)),
    point(X0, Y0),
    [point(X0, Y0),
     point(X1F, Y1F),
     point(X2F, Y2F),
     point(X3F, Y3F)]) :-
    X1F is (X1 - abs(X0)),
    X2F is (X2 - abs(X0)),
    X3F is (X3 - abs(X0)),
    Y1F is (Y1 + Y0),
    Y2F is (Y2 + Y0),
    Y3F is (Y3 + Y0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Terzo Quadrante %%%%%%%%%%%%%%%%%%%%%%%%%%%%

collinear3([], _P0, []) :- !.
collinear3([_P], _P0, []) :- !.
collinear3([_P1, _P2], _P0, []) :- !.

collinear3([P1 | Ps], P0, [R | Rs]) :-
	collinear3(Ps, P1, P0, Rpar),
	flatten(Rpar, R),
	collinear3(Ps, P0, Rs), !.

collinear3([P2 | Ps], P1, P0, R) :-
	sameAngle(P2, P1),
	collinear3(Ps, P2, P1, P0, R), !.

collinear3(_P, _P1, _P0, []) :- !.

collinear3([P3 | Ps], P2, P1, P0, [R | Rs]) :-
	sameAngle(P3, P2),
	buildSegment3(P3, P2, P1, P0, R),
	collinearPlus3(Ps, P3, P0, Rs), !.

collinear3(_P, _P2, _P1, _P0, []) :- !.

%%%%%%%%%%%%

collinearPlus3([], _P3, _P0, []) :- !.

collinearPlus3(
    [slope(A, point(X, Y)) | Ps],
    slope(A, B),
    point(X0, Y0),
    [point(XF, YF) | Rs]) :-
    XF is (X - abs(X0)),
    YF is (Y - abs(Y0)),
    collinearPlus3(Ps, slope(A, B), point(X0, Y0), Rs), !.

collinearPlus3(_P, _P3, _P0, []) :- !.

%%%%%%%%%%%%

buildSegment3(
    slope(A, point(X3, Y3)),
    slope(A, point(X2, Y2)),
    slope(A, point(X1, Y1)),
    point(X0, Y0),
    [point(X0, Y0),
     point(X1F, Y1F),
     point(X2F, Y2F),
     point(X3F, Y3F)]) :-
    X1F is (X1 - abs(X0)),
    X2F is (X2 - abs(X0)),
    X3F is (X3 - abs(X0)),
    Y1F is (Y1 - abs(Y0)),
    Y2F is (Y2 - abs(Y0)),
    Y3F is (Y3 - abs(Y0)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Quarto Quadrante %%%%%%%%%%%%%%%%%%%%%%%%%%%%

collinear4([], _P0, []) :- !.
collinear4([_P], _P0, []) :- !.
collinear4([_P1, _P2], _P0, []) :- !.

collinear4([P1 | Ps], P0, [R | Rs]) :-
	collinear4(Ps, P1, P0, Rpar),
	flatten(Rpar, R),
	collinear4(Ps, P0, Rs), !.

collinear4([P2 | Ps], P1, P0, R) :-
	sameAngle(P2, P1),
	collinear4(Ps, P2, P1, P0, R), !.

collinear4(_P, _P1, _P0, []) :- !.

collinear4([P3 | Ps], P2, P1, P0, [R | Rs]) :-
	sameAngle(P3, P2),
	buildSegment4(P3, P2, P1, P0, R),
	collinearPlus4(Ps, P3, P0, Rs), !.

collinear4(_P, _P2, _P1, _P0, []) :- !.

%%%%%%%%%%%%

collinearPlus4([], _P3, _P0, []) :- !.
collinearPlus4(
    [slope(A, point(X, Y)) | Ps],
    slope(A, B),
    point(X0, Y0),
    [point(XF, YF) | Rs]) :-
    XF is (X + X0),
    YF is (Y - abs(Y0)),
    collinearPlus4(Ps, slope(A, B), point(X0, Y0), Rs), !.

collinearPlus4(_P, _P3, _P0, []) :- !.

%%%%%%%%%%%%

buildSegment4(
    slope(A, point(X3, Y3)),
    slope(A, point(X2, Y2)),
    slope(A, point(X1, Y1)),
    point(X0, Y0),
    [point(X0, Y0),
     point(X1F, Y1F),
     point(X2F, Y2F),
     point(X3F, Y3F)]) :-
    X1F is (X1 + X0),
    X2F is (X2 + X0),
    X3F is (X3 + X0),
    Y1F is (Y1 - abs(Y0)),
    Y2F is (Y2 - abs(Y0)),
    Y3F is (Y3 - abs(Y0)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I/O %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% lettura di punti %%%%%

% apre il file e legge tutto quello che contiene
open_file(Filename, Read) :-
  open(Filename, read, File),
  read_until_stop(File, Read),
  close(File).

read_until_stop(File, [L|Lines]) :-
    read_line_to_codes(File, Codes),
    Codes \= end_of_file,
    atom_codes(L, Codes),
    L \= stop,
    !, read_until_stop(File, Lines).

read_until_stop(_, []).

% estrae il primo elemento del file letto
x_first([X | _], X).

% controlla che X sia membro della lista
is_member(X, [X|_]) :- !.
is_member(X, [_|Xs]) :- is_member(X, Xs).

% controlla che ci sia un separatore tabulazione nel file
check_tab(Filename) :-
  open_file(Filename, Read),
  x_first(Read, First),
  string_chars(First, Chars),
  is_member('\t', Chars).

% controlla che ci sia un separatore spazio nel file
check_space(Filename) :-
  open_file(Filename, Read),
  x_first(Read, First),
  string_chars(First, Chars),
  is_member(' ', Chars).

% separatore: tabulazione -> 0'\t
readpoints(Filename, Points) :-
  check_tab(Filename),
  csv_read_file(
            Filename,
            Pts,
            [separator(0'\t), functor(point), convert(true)]),
            % utilizzo esclusivo per rimozione duplicati
            sort(Pts, Points), !.

% separatore: spazio -> 0'
readpoints(Filename, Points) :-
  check_space(Filename),
  csv_read_file(
            Filename,
            Pts,
            [separator(0' ), functor(point), convert(true)]),
            % utilizzo esclusivo per rimozione duplicati
            sort(Pts, Points), !.

%%%%% scrittura di punti %%%%%

% separatore: tabulazione -> 0'\t
writepoints(Filename, Points) :-
  csv_write_file(Filename, Points, [separator(0'\t)]), !.

%%%%% Scrittura di segmenti %%%%%

write_segments(Filename, Segments) :-
  make_segments(Segments, ToWrite),
  csv_write_file(Filename, ToWrite, [separator(0'\t)]), !.

% Prende in ingresso una lista di punti del tipo:
% [[point(1, 2), point(3, 4)], [point(5, 6), point(7, 8)]]
% e restituisce una lista di segmenti derivati di tipo:
% [segment(1, 2, 3, 4), segment(5, 6, 7, 8)]
make_segments([], []) :- !.
make_segments([Points | Ps], [Segment | Ss]) :-
  count(Points, N),
  % stampa solamente se tutti i segmenti sono formati
  % da almeno due punti
  N > 1,
  extract_XY(Points, Sgmt),
  make_sgmt(Sgmt, Segment),
  make_segments(Ps, Ss), !.

% Estrae le coordinate dei punti passati in ingresso e
% le accoda in una lista di coordinate
extract_XY([], []) :- !.
extract_XY([Point | Ps], [X, Y | Ls]) :-
  Point = point(X, Y),
  extract_XY(Ps, Ls), !.

% Traccia un segmento inserendo il funtore segment
% come primo elemento della lista. Successivamente
% utilizza =.. per comporre segment(P1, P2, ..., Pn)
make_sgmt(Sgmt, Segment) :-
  insert_foo_first(Sgmt, New),
  Segment =.. New.

% inserisce segment come primo elemento della lista passata
insert_foo_first([L | Ls], [segment, L | Ls]).

% utilizzato per contare quanti punti sono contenuti
% nella sottolista che dovrebbe rappresentare un segmento:
% se ci sono meno di due punti collegati, allora il predicato
% write_segments/2 tornerÃ  false
count([], 0).
count([_ | T], N) :- count(T, N1) , N is N1 + 1, !.
