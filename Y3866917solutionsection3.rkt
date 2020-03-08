#lang racket

; Question 1 is in Prolog
; ------ Question 2

; In Scheme lists consist of a head plus a tail, so recursively sum
(define (sum lst)
  (if (null? lst)
      0   ; Base case: empty lists sum to zero
      (+ (car lst) (sum (cdr lst)))   ; Sum is the first item plus the sum of the rest of the list
      )
  )

; Test cases:
; > (sum '(1 2 3))
; 6
; > (sum '())
; 0
; > (sum '(1 -1))
; 0
; > (sum '(1 20 300 4000))
; 4321


; Question 3 is in Prolog
; ------ Question 4

; Each element must be at least as great as the one to its right
(define (desc? lst)
  (if (= (length lst) 1)
      #t
      (and
           (>= (car lst) (car (cdr lst)))
           (desc? (cdr lst)))
      )
  )

; Test cases:
; > (desc? '(3 2 1))
; #t
; > (desc? '(1 2 3))
; #f
; > (desc? '(89 78 65 45))
; #t
; > (desc? '(89 45 65 79))
; #f