(struct province-connection (id province-id neighbor-id created-at updated-at))

(define (province-connection->jsexpr province-connection)
  (hash 'provinceId (province-connection-province-id province-connection)
        'neighborId (province-connection-neighbor-id province-connection)))

(define (province-connections->jsexpr province-connections)
  (map province-connection->jsexpr province-connections))

(define (province-connections-fetch)
  (map
    (lambda (row) (apply province-connection (vector->list row)))
    (fetch-records "province_connections")))
