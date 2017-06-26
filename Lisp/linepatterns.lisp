;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Line Patterns Progetto E3P
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Gruppo di lavoro:
;;;Gabriele_Bisogno_810106
;;;Alessandro_Dossi_771041
;;;Jacopo_Bazzaro_ 807342
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;Definizione Punto e estrazioni coordinate;;;;;;;;;;;;;;;;;;;;

;;definzione punto

(defun make-point (x y)
  (cons x y))

;;estrazione x e y dal punto

(defun x (r)
    (car r))


(defun y (r)
    (cdr r))


;;;;;;;;;;;;;;;;;;;;;;Definisco Funzioni Geometriche;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Funzione area2

(defun area2 (a b c)
  (-
   (* (- (x b) (x a))
      (- (y c) (y a)))
   (* (- (y b) (y a))
      (- (x c) (x a)))))


;;; funzioni di svolta

;;restituisce true se la funzione area2 è positiva,ed ha quindi
;; un angolo "svolta a sinistra"

(defun left (a b c)
  (if
      (> (area2 a b c) 0
       t
       nil)))

;;restituisce true se l'area è negativa, ed ha quindi un angolo
;;"svolta a destra"

(defun left-on (a b c)
  (if
      (< (area2 a b c) 0
       t
       nil)))


;;restituisce true se l'area è uguale a zero, e quindi i punti sono collineari
(defun collinear (a b c)
  (if
      (= (area2 a b c) 0)
   t
   nil))


;;; Funzione Angolo in Gradi

(defun angle2dGradi (a b)
  (*    (atan a b)
        (/ 180 PI)))

;; Funzione Angolo in Radianti

(defun angle2d (a b)
  (atan a b))


;;;;;;;;;;;;;;;;;;;;;;;;;;;Passi Algoritmo Finale;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Punto 1

;;;; Ordinamento/Sorting Y di una lista di punti

;; Ordinare in ordine crescente le y di ogni punto/cons
;;(SortingY '( (1 . 70) (2 . 4) (4 . 8) ))

(defun SortingY (ListPunti)
    (sort (copy-seq listPunti) #'< :key #'cdr))


;;; Punto 2

;;;sommare ad ogni altro altro punto della lista le coordinate di P0
;;;(ListaPunti[i]), (ad ogni X dei punti, la X di P0,
;;;ad ogni Y dei punti la Y di P0

(defun sommaX (point0 x)
  (+ (x point0) x))

(defun sommaY (point0 y)
  (+ (y point0) y))


;;
(defun sottrX (point0 x)
  (- (x point0) x))
;;
(defun sottrY (point0 y)
  (- (y point0) y))


;;; Funzione Normalizzante Piano

;;il primo elemento della lista considerato come origine,
;;non viene tenuto considerato
;;nella lista risultante

(defun NormGrafico (firstList restList)
  (cond
   ((and
      (or
       (< (x firstList) 0)
       (= (x firstList)))
      (or
       (= (y firstList))
       (< (y firstList) 0)))
    (mapcar
     (lambda (e)
      (cons
        (+ (- (x firstList)) (x e))
        (+ (- (y firstList)) (y e)))) restList))

   ((and
     (or
       (> (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (> (y firstList) 0)))
    (mapcar
     (lambda (e)
      (cons
        (+ (- (x firstList)) (x e))
        (+ (- (y firstList)) (y e)))) restList))

   ((and
     (or
       (< (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (> (y firstList) 0)))
    (mapcar
     (lambda (e)
      (cons
        (+ (- (x firstList)) (x e))
        (+ (- (y firstList)) (y e)))) restList))

   ((and
     (or
       (> (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (< (y firstList) 0)))
    (mapcar
      (lambda (e)
       (cons
         (+ (- (x firstList)) (x e))
         (+ (- (y firstList)) (y e)))) restList))))

;;; Punto 3

;;;; Calcoli atan per tutti i punti e crei una lista di slopes

(defun AllAtan (ListNorm)
  (mapcar
    (lambda (e)
      (slope (atan (x e) (y e)) e)) ListNorm))


;;; Punto 4

;;;; Ordini per gli angoli di Slopes

;;definisco slope

(defun slope (angle point)
  (cons angle point))


;;(SortingSlope
;; '( (12 . (make-point x y)) (2 . (make-point x y)) (4 . (make-point x y)))

(defun SortingSlope (ListSlope)
    (sort (copy-seq listSlope) #'< :key #'car))


;;; Punto 5

;;;; Funzione aggiuntiva a foundLines

(defun optpoint (ListSlopeOrd)

 (if (null (second ListSlopeOrd)) (list (cdr (first ListSlopeOrd)))
  (if
    (= (car (first ListSlopeOrd)) (car (second ListSlopeOrd)))
    (append
      (list (cdr (first ListSlopeOrd)))
      (optPoint (rest ListSlopeOrd)))
   (list (cdr (first ListSlopeOrd))))))


;;;; Trova le linee

(defun foundLines (ListSlopeOrd)
  (cond
    ((null (third ListSlopeOrd)) '())
    ((and (collinear
           (cdr (first ListSlopeOrd))
           (cdr (second ListSlopeOrd))
           (cdr (third ListSlopeOrd)))
          (=
            (car (first ListSlopeOrd))
            (car (second ListSlopeOrd))
            (car (third ListSlopeOrd))))
     (append
      (list (optPoint ListSlopeOrd))
      (foundLines (rest ListSlopeOrd))))
   (t (foundLines (rest ListSlopeOrd)))))


;;;; Punto 5.5

;;;; Eliminazione sotto-segmenti

(defun remove-duplicate-list (list)
  (remove-duplicates list :test #'two-similar-p :from-end t))

;;;;

(defun two-similar-p (l1 l2)
  (consp (cdr (intersection l1 l2 :test #'equal))))


;;;; Punto  6

;;;; Funzioni aggiuntive N.B per la correttezza della rappresentazione Finale

;;(addInitialpoint '(1 . 1) '( ((2 . 2)) ((3 . 3)) ((4 . 4)) ))
;;aggiunge il punto considerato come origine a ogni lineaa
(defun addInitialpoint (p0 list)

    (mapcar
      (lambda (e) (append (list p0) e)) list))


;;restituisce i valori "De-Normalizzati di ogni punto di ogni linea"
(defun DenNormGrafico (firstList restList)
  (cond

   ((null restList) '())
   ((and
     (or
       (< (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (< (y firstList) 0)))
    (mapcar
     (lambda (e)
      (mapcar
        (lambda (e1)
         (cons
          (+ (x firstList) (x e1))
          (+ (y firstList) (y e1)))) e)) restList))

   ((and
     (or
       (> (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (> (y firstList) 0)))
    (mapcar
     (lambda (e)
      (mapcar
        (lambda (e1)
          (cons
           (+ (x firstList) (x e1))
           (+ (y firstList) (y e1)))) e)) restList))

   ((and
     (or
       (< (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (> (y firstList) 0)))
    (mapcar
     (lambda (e)
      (mapcar
        (lambda (e1)
         (cons
          (+ (x firstList) (x e1))
          (+ (y firstList) (y e1)))) e)) restList))

   ((and
     (or
       (> (x firstList) 0)
       (= (x firstList)))
     (or
       (= (y firstList))
       (< (y firstList) 0)))
    (mapcar
      (lambda (e)
       (mapcar
         (lambda (e1)
          (cons
           (+ (x firstList) (x e1))
           (+ (y firstList) (y e1)))) e)) restList))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Line-Patterns;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Algoritmo Finale, implementazione


(defun Main (ListPoints)
  (cond
    ((null ListPoints) '())
    ((atom ListPoints) '())
    ((not (null ListPoints))
     (append
       (addInitialpoint
        (first (SortingY ListPoints))
        (DenNormGrafico (first (SortingY ListPoints))
         (foundLines
          (SortingSlope
           (AllAtan
            (NormGrafico
             (first (SortingY ListPoints))
             (rest (SortingY ListPoints))))))))
       (Main (rest (sortingy ListPoints)))))
    (t (Main (rest (sortingy ListPoints))))))


(defun Line-Patterns (ListPoints)
 (remove-duplicate-list (Main ListPoints)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;Input/Output;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Funzioni utili per I/O

;;; funzione specifica


(defun consAll (list)
 (mapcar (lambda (e) (cons (first e) (second e)))list))



;;; Funzione Rimuovi Punti Duplicati

(defun remove-duplicate-points (ListPoints)
  (remove-duplicates ListPoints :test #'equal))


;;Appiattire una lista

(defun flatten (x)
  (cond ((null x) x)
        ((atom x) (list x))
        (T (append (flatten (first x))
                   (flatten (rest x))))))


;;Prende la lista flatten, creando delle cons per ogni punto
;;es (1 2 3 4)-->((1 2) (3 4))

(defun smallList (l n)
   (when l
      (cons (subseq l 0 (min n (length l)))
            (smalllist (nthcdr n l) n))))


;;;; Implementazione I/O

;;;; Funzione readpoints
;;legge punti da file, eliminado i punti duplicati


(defun readpoints (x)
  (with-open-file (in x)
          :direction
          :input
          :if-does-not-exist :error
      (read-list-from in)))


(defun read-list-from (input-stream)
  (let ((e (read input-stream nil 'eof)))
    (unless (eq e 'eof)
        (consAll
         (remove-duplicate-points
           (smallList
             (flatten
               (cons e (read-list-from input-stream))) 2))))))



;;;; Scrive una lista list sull file sul percorso/path x
;;Es.(writepoints "path" '( (1 . 2) (1 . 1) (3 . 3) ))
;;Es.(writepoints "path" (list (make-point 1 2) (make-point 2 1)))


(defun writepoints (x list)
  (cond ((null list) "la lista è nulla")
        ((equal x "") "La path inserita è vuota")
        ((atom list) "La lista inserita è un atomo")
        ((null x) "Il path inserito è nullo")
        (t (with-open-file (out x
                               :direction :output
                               :if-exists :supersede
                               :if-does-not-exist :create)
              (mapcar
                (lambda (e)
                  (format out "~D" (x e))
                  (format out "~C" #\Tab)
                  (format out "~D~%" (y e))) list)))))


;;;; Scrive un segmento per linea

(defun write-segments (x list)
  (cond ((null list) "la lista è nulla")
        ((equal x "") "La path inserita è vuota")
        ((atom list) "La lista inserita è un atomo")
        ((null x) "Il path inserito è nullo")
        (t (with-open-file (out x
                               :direction :output
                               :if-exists :supersede
                               :if-does-not-exist :create)
              (mapcar
                (lambda (e)
                  (mapcar
                   (lambda (e1)
                    (format out "~D" (x e1))
                    (format out "~C" #\Tab)
                    (format out "~D" (y e1))
                    (format out "~C" #\Tab)) e)
                 (format out "~%")) list)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
