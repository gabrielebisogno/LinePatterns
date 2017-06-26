Prog E3P Line-Patterns

Gruppo di lavoro:
- Gabriele Bisogno 810106
- Jacopo Bazzaro 807342
- Alessandro Dossi 771041

--------------------------------------------------
Spiegazione del comportamento dell'algoritmo:
--------------------------------------------------
Come suggeritoci dal testo, abbiamo incentrato l'algoritmo sul predicato atan\2;
il cuore dell'esercizio è stato capire come sfruttare quel predicato per
calcolare correttamente l'angolo tra 2 punti; la soluzione che abbiamo adottato
è la seguente:

1) Presa una lista di punti L, li abbiamo ordinati secondo la loro coordinata y,
in questo modo possiamo immaginarci che tutti i punti della lista vengano
processati dal "basso verso l'alto".

2) Una volta ordinati, ricorsivamente, andremo a prendere il primo punto (P0) e,
a seconda di dove P0 si trovi eseguiremo le seguenti operazioni:
    
    2.1) Se P0, si trova nel primo quadrante, eseguiremo una traslazione di
    tutti i punti rimanenti verso l'origine degli assi, ovvero faremo diventare
    P0 l'origine degli assi e sottrarremo a tutti gli altri punti le coordinate 
    di P0.
    2.2) Se P0, si trova nel secondo quadrante, eseguiremo una traslazione di
    tutti i punti rimanenti verso l'origine degli assi, ovvero faremo diventare
    P0 l'origine degli assi e sottrarremo a tutti gli altri punti le coordinate
    Y di P0, mentre sommiamo le coordinate X di P0
    2.3) Se P0, si trova nel terzo quadrante, eseguiremo una traslazione di
    tutti i punti rimanenti verso l'origine degli assi, ovvero faremo diventare
    P0 l'origine degli assi e sommeremo a tutti gli altri punti le coordinate 
    di P0.
    2.4) Se P0, si trova nel primo quadrante, eseguiremo una traslazione di
    tutti i punti rimanenti verso l'origine degli assi, ovvero faremo diventare
    P0 l'origine degli assi e sommeremo a tutti gli altri punti le coordinate Y 
    di P0, mentre sottrarremo le coordinaten X di P0.

3) Una volta "normalizzati" i punti, andiamo a creare gli slopes e
successivamente gli ordiniamo, in questo modo gli slope che formeranno un
segmento, saranno tutti vicini e ridurremo le tempistiche per trovare (e creare)
i segmenti (che saranno formati da almeno 4 punti).

4) A questo punto basta trovare almeno 3 slope con lo stesso angolo e avremo
duenque trovato un segmento.
--------------------------------------------------
Predicati definiti in linepatterns.pl:
--------------------------------------------------

- area2(A, B, C, Area):
Il predicato area2/4 calcola l'area di un triangolo
composto dai punti A, B, C utilizzando la formula:
Area is (((X2 - X1) * (Y3 - Y1)) - ((Y2 - Y1) * (X3 - X1))).
In base al valore di Area, gli altri predicati diranno se il triangolo è
orientato a sinistra, destra oppure se i punti che lo formano sono collineari.

Esempio:
?- area2(point(1, 2), point(3, 4), point(5, 6), R).
R = 0.

--------------------------------------------------
- left(A, B, C):

Dati 3 punti A, B, C nella forma point(X, Y), il predicato left/3 restituisce
true se i 3 punti formano un angolo orientato a sinistra, quindi se la
computazione di area2/4 restituisce un valore positivo.

Esempio:
?- left(point(2, 2), point(3, 2), point(5, 5)).
true.

--------------------------------------------------
- left_on(A, B, C):

Dati 3 punti A, B, C nella forma point(X, Y), il predicato left_on/3
restituisce true se i 3 punti formano un angolo orientato a destra,
quindi se la computazione di area2/4 restituisce un valore negativo.

Esempio:
?- left_on(point(1, 2), point(-1, 2), point(5, 5)).
true.

--------------------------------------------------
- collinear(A, B, C):

Dati 3 punti A, B, C nella forma point(X, Y), il predicato left_on/3
restituisce true se i 3 punti sono collineari, quindi se la computazione di
area2/4 restituisce 0.

Esempio:
?- collinear(point(1, 2), point(3, 4), point(5, 6)).
true.

--------------------------------------------------
- angle2d(A, B, R):

Date le coordinate X ed Y di un punto, il predicato calcola l'angolo R
in radianti tra il punto point(A, B) e l'origine degli assi.

Esempio:
?- angle2d(3, 3, R).
R = 0.7853981633974483.

--------------------------------------------------
- make_slope(Point, Slope):

Il predicato, preso un punto (Point) nella forma point(X, Y) crea il relativo
Slope, cioè calcola l'angolo in radianti (Angle) tra X ed Y e lo associa
al punto nella forma Slope(Angle, Point).

Esempio:
?- make_slope(point(3, 3), Slope).
Slope = slope(0.7853981633974483, point(3, 3)).

--------------------------------------------------
- make_slopes_list(List, Slopes):

Il predicato invoca ricorsivamente make_slope/2 su una lista di punti e crea
una lista Slopes formata dagli stessi punti di List con associati i relativi
angoli. Slopes sarà quindi formata da elementi di tipo slope(Angle, Point).

Esempio:
?- make_slopes_list([point(42, 0.4), point(-42, 2)], Slope).
Slope = [slope(1.5612728052012839, point(42, 0.4)),
        slope(-1.5232132235179132, point(-42, 2))].

--------------------------------------------------
- sort_points_by_y(List, Sorted):

Presa in ingresso una lista (List) composta da punti nella forma point(X, Y)
il predicato restituisce una lista degli stessi punti ordinati in base alla Y
in modo crescente (con eliminazione dei duplicati).

Esempio:
?- sort_points_by_y([point(0.1, 2), point(3, 4), point(42, -10.03)], Sorted).
Sorted = [point(42, -10.03), point(0.1, 2), point(3, 4)].

--------------------------------------------------
- somma(StartPoint, List, Summed):

Il predicato prende in ingresso un punto di partenza StartPoint precedentemente
determinato come il punto in List con il più piccolo valore per le ordinate e
ne somma i valori delle coordinate in valore assoluto con tutti i valori delle
coordinate in List. Summed sarà una lista valorizzata con i valori di queste
somme.

Esempio:
?- somma(point(1, -10), [point(1, 1), point(-2, -3)], Summed).
Summed = [point(2, 11), point(-1, 7)].

--------------------------------------------------
- sort_by_angle(List, Sorted):

Predicato che ordina (ovviamente, senza eliminazione di duplicati) gli angoli
dei punti specificati in List, che è per l'appunto, una lista di slopes.

Esempio:
?- make_slopes_list([point(42, 0.4), point(-42, 2)], Slope),
   sort_by_angle(Slope, Sorted).
Slope = [slope(1.5612728052012839, point(42, 0.4)),
        slope(-1.5232132235179132, point(-42, 2))],
Sorted = [slope(-1.5232132235179132, point(-42, 2)),
        slope(1.5612728052012839, point(42, 0.4))].

--------------------------------------------------
- collinear;

Predicati che si occupano di confrontare diversi punti in base al loro angolo:

--------------------------------------------------
- sameAngle(slope(Angle, _P2), slope(Angle, _P1)):

Questo predicato ritorna true se semplicemente due slopes condividono
lo stesso angolo.
Esempio:
?- checkSegment(slope(0.785398,point(X1,Y1)), slope(0.785398, point(X2,Y2))).
true.

--------------------------------------------------
- collinearPlus(SlopeList, Point, OtherPoint, Out).

Il predicato si occupa di ricercare ulteriori punti che condividono lo stesso
angolo nella lista di slopes.

--------------------------------------------------
- processa(Points, Processed):

Cuore dell'algoritmo: richiama i predicati somma/3, make_slopes_list/2,
sort_by_angle/2 ed allinea/3 per creare una lista di segmenti allineati.
Il predicato prende il primo punto, lo somma agli altri per farlo diventare
l'origine degli assi (somma/3), crea gli slopes (make_slopes_list/2),
ordina gli slopes per l'angolo (sort_by_angle/2) e chiama allinea/3
che trova i segmenti allineati con P0.
In seguito, prima dell'applicazione di un nuovo passo ricorsivo, viene ripulita
la lista in output con flatten/2, che permette di avere in output una lista
semplice.

--------------------------------------------------
- deleteEmptyList(Element, List, NewList):

Il predicato si occupa di eliminare le occorrenze di Element in List e di
restituire il risultato in NewList.
L'utilizzo nell'algoitmo è puramente rivolto all'eliminazione delle liste
vuote generate nel processo di ricerca dei punti collineari.
