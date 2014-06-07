(struct province-connection (id province-id neighbor-id created-at updated-at))

(define (province-connection->jsexpr pc)
  (hash 'provinceId (province-connection-province-id pc)
        'neighborId (province-connection-neighbor-id pc)))

(define (province-connections->jsexpr pc)
  (map province-connection->jsexpr pc))

(define (province-connections-fetch)
  (map
    (lambda (row) (apply province-connection (vector->list row)))
    (fetch-records "province_connections")))

(define (province-connections-with-province-id pid pcs)
  (filter (lambda (pc) (equal? (province-connection-province-id pc) pid)) pcs))

