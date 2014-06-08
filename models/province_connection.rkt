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
