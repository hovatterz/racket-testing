(struct nation (id name user-id created-at updated-at color capital-id money provinces armies) #:mutable)

(define (nation->jsexpr n)
  (hash 'id (nation-id n)
        'name (nation-name n)
        'playerId (nation-user-id n)
        'color (nation-color n)
        'capitalId (nation-capital-id n)
        'money (exact->inexact (nation-money n))
        'provinces (map province-id (nation-provinces n))
        'armies (map army-id (nation-armies n))))

(define (nations->jsexpr ns)
  (map nation->jsexpr ns))

(define (nations-fetch)
  (map
    (lambda (row) (apply nation (append (vector->list row) '(#f #f))))
    (fetch-records "nations")))
