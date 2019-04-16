(define (reverse lst)
  (if (null? lst)
      nil
      (append (reverse (cdr lst))
              (cons (car lst) nil))))

; helper function
; returns the values of lst that are bigger than x
; e.g., (larger-values 3 '(1 2 3 4 5 1 2 3 4 5)) --> (4 5 4 5)
(define (larger-values x lst)
  (cond
   ((null? lst)
    nil)
   ((> (car lst) x)
    (cons (car lst)
          (larger-values x (cdr lst))))
   (else
    (larger-values x (cdr lst)))))

(define ; the following skeleton is optional, remove if you like
 (longest-increasing-subsequence lst)
 (if (null? lst)
     nil
     (begin (define first (car lst))
            (define rest (cdr lst))
            (define large-values-rest
              (larger-values first rest))
            (define with-first
              (cons first (longest-increasing-subsequence large-values-rest)))
            (define without-first
              (longest-increasing-subsequence rest))
            (if (> (length with-first) (length without-first))
                with-first
                without-first))))

(define (cadr s)
  (car (cdr s)))

(define (caddr s)
  (cadr (cdr s)))

; derive returns the derivative of EXPR with respect to VAR
(define (derive expr var)
  (cond
   ((number? expr)
    0)
   ((variable? expr)
    (if (same-variable? expr var)
        1
        0))
   ((sum? expr)
    (derive-sum expr var))
   ((product? expr)
    (derive-product expr var))
   ((exp? expr)
    (derive-exp expr var))
   (else
    'Error)))

; Variables are represented as symbols
(define (variable? x)
  (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1)
       (variable? v2)
       (eq? v1 v2)))

; Numbers are compared with =
(define (=number? expr num)
  (and (number? expr)
       (= expr num)))

; Sums are represented as lists that start with +.
(define (make-sum a1 a2)
  (cond
   ((=number? a1 0)
    a2)
   ((=number? a2 0)
    a1)
   ((and (number? a1)
         (number? a2))
    (+ a1 a2))
   (else
    (list '+ a1 a2))))

(define (sum? x)
  (and (list? x)
       (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

; Products are represented as lists that start with *.
(define (make-product m1 m2)
  (cond
   ((or (=number? m1 0)
        (=number? m2 0))
    0)
   ((=number? m1 1)
    m2)
   ((=number? m2 1)
    m1)
   ((and (number? m1)
         (number? m2))
    (* m1 m2))
   (else
    (list '* m1 m2))))

(define (product? x)
  (and (list? x)
       (eq? (car x) '*)))

(define (multiplier p)
  (cadr p))

(define (multiplicand p)
  (caddr p))

(define (derive-sum expr var)
  (if (sum? expr)
      (begin (define ad (addend expr))
             (define au (augend expr))
             (make-sum (derive ad var) (derive au var)))))

(define (derive-product expr var)
  (if (product? expr)
      (begin (define mr (multiplier expr))
             (define md (multiplicand expr))
             (make-sum (make-product (derive mr var) md) (make-product (derive md var) mr)))))

; Exponentiations are represented as lists that start with ^.
(define (make-exp base exponent)
  (define (num-exp b e)
      (if (=number? e 0)
          1
          (* b (num-exp b (- e 1)))))
  (cond ((=number? base 0) 0)
        ((=number? base 1) 1)
        ((=number? exponent 0) 1)
        ((=number? exponent 1) base)
        ((and (number? base) (number? exponent)) (num-exp base exponent))
        (else (cons '^ (cons base (cons exponent nil))))))

(define (base exp)
  (cadr exp))

(define (exponent exp)
  (caddr exp))

(define (exp? exp)
  (cond ((number? exp) #f)
        ((symbol? exp) #f)
        ((and (= (length exp) 3) (eq? (car exp) '^)) #t)))

(define x^2 (make-exp 'x 2))

(define x^3 (make-exp 'x 3))

(define (derive-exp exp var)
  (if (exp? exp)
      (begin
          (define e (exponent exp))
          (define b (base exp))
          (cond ((eq? var b) (make-product (exponent exp) (make-exp b (- (exponent exp) 1))))))))
