(module common racket
  (provide list-group-by)

  (define (list-group-by key-method lst)
    (foldl (lambda (p h)
             (let ([n (key-method p)])
               (hash-set h n (cons p (hash-ref h n '())))))
           #hash()
           lst)))
