(struct nation (id name user-id created-at updated-at color capital-id money))

(define (nation->jsexpr nation)
  (hash 'id (nation-id nation)
        'name (nation-name nation)
        'playerId (nation-user-id nation)
        'color (nation-color nation)
        'capitalId (nation-capital-id nation)
        'money (exact->inexact (nation-money nation))))

(define (nations->jsexpr nations)
  (map nation->jsexpr nations))

(define (nations-fetch)
  (map
    (lambda (row) (apply nation (vector->list row)))
    (fetch-records "nations")))
