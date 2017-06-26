Prog E3P Line-Patterns

Gruppo di lavoro:
-Gabriele_Bisogno_810106
-Alessandro_Dossi_771041
-Jacopo_Bazzaro_ 807342
Libreria Lisp Readme:

Make-point : crea un punto/cons con valori delle coordinate x/car e y/cdr
ex. (make-point 2 1)

x  : estrae valore coordinata x/cdr dal punto/cons

y  : estrae valore coordinata y/cdr dal punto/cons

Area2 : calcolare area di tre punti dati come argomento
ex. (area 2 ‘(42 .42) ‘(2 . 2) ‘(4 . 4))

Left: restituisce true se la funzione area2 è positiva, ed ha quindi un angolo "svolta a sinistra"

Left-on: restituisce true se l'area è negativa, ed ha quindi un angolo "svolta a destra"

Collinear: restituisce true se l'area è uguale a zero, e quindi i punti sono collineari
ex. (Collinear ‘(-1 . -1) ‘(2 . 2) ‘(1 . 1))

angle2d: restituisce l’angolo tra un punto e l’origine in radianti
ex.(atan 2 2)

angle2dGradi: restituisce l’angolo tra un punto e l’origine in radianti

SortingY: Ordina in ordine crescente le y di ogni punto/cons
ex. SortingY '( (1 . 70) (2 . 4) (4 . 8) ))

NormGrafico: “Normalizza” un insieme di punti, ossia sposta tutti i punti(rest list) in base ai valori x e y del primo punto della lista(first list).
ex.(NormGrafico firstList restList )

DenNormGrafico:“De-normalizza” un insieme di punti, ossia li riporta al loro valore precedente all’applicazione della funzione normgrafico.
ex.(DenNormGrafico firstList restList )

AllAtan: utilizza la funzione atan per tutti i punti “normalizzati” di una lista e crea una lista di slopes
ex.(AllAtan listpointsNorm)

SortingSlope: Ordina una lista di slope in modo crescente in base all’angolo
ex.((foundLines ‘(  ‘(0.67 . (1 . 4)) (0.60  . (2 . 5)) (0.50 . (2 . 2)) (0.50 . (3 . 3)) (0.58 . (3 . 5)))))

Foundlines: Trova tutte le linee di lunghezza maggiore o uguale a 3 punti per un punto, in una lista di sole ordinati(considerato come l’origine).
ex.(foundLines ‘(  ‘(0.42 . (2 . 2)) (0.42 . (1 . 1)) (0.50 . (2 . 2)) (0.50 . (3 . 3)) (0.58 . (3 . 5))))

addInitialPoint: aggiunge il punto considerato come origine a ogni lineaa
ex.(addInitialpoint '(1 . 1) '( ((2 . 2)) ((3 . 3)) ((4 . 4)) ))

Line-patterns: Applica tutte le funzioni mostrare in precedenza e trova tutte le linee per tutti i punti di lunghezza maggiore o uguale a 4 punti.
ex.(linepatterns ‘( (1 . 1) (2 . 2) (3 . 3) (4 . 4) (2 . 3) (3 . 4) (4 . 5)))
IMPORTANTE:
line-patterns ritorna ogni linea come una sottolista(di primo livello), quindi avremmo in output una lista di sottoliste
ex. ( ( (1 . 1) (2 . 2) (3 . 3) (4 . 4) ) (1 . 1) (2 . 3) (3 . 4) (4 . 5) (2 . 6) (3 . 7) (4 . 8)) )


Readpoints: legge punti da un file.txt
ex.(readpoints “path file” )

Writepoints: scrive i punti su un file.txt, due per linea e separati da un carattere di tabulazione.
ex.(write-points  “path file”  ’( (1 . 1) (2 . 2) (3 . 3) (4 . 4) (2 . 3) (3 . 4) (4 . 5)) )

Writesegments: scrive dei segmenti su un file.txt, un segmento per linea(con numeri pari) e ogni numero è separato da un carattere di tabulazione
ex.(write-segments  “path file”  ’( ((1 . 1) (2 . 2) (3 . 3) (4 . 4)) ((2 . 3) (3 . 4) (4 . 5))) )
