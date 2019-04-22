(define (accumulate combiner start n term)
  (if (= 0 n) start
      (combiner (term n) (accumulate combiner start (- n 1) term)))
)

(define (accumulate-tail combiner start n term)
  (if (= n 0) start
      (accumulate-tail combiner (combiner start (term n)) (- n 1) term))
)

(define (rle s)
  (begin (define (helper current length stream) (cond ((null? stream) (list-to-stream (list (list current length))))
						      ((= current (car stream)) (helper current (+ length 1) (cdr-stream stream)))
						      (else (cons-stream (list current length) (helper (car stream) 1 (cdr-stream stream))))))
	 (if (null? s) nil
	     (helper (car s) 0 s)))
)
