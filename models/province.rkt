(struct province (id name map-color created-at updated-at nation-id current-manpower max-manpower is-colony max-population current-population center-x center-y neighbors) #:mutable)

(define (province->jsexpr p)
  (hash 'id (province-id p)
        'name (province-name p)
        'mapColor (province-map-color p)
        'nationId (province-nation-id p)
        'currentManpower (province-current-manpower p)
        'maxManpower (province-max-manpower p)
        'isColony (province-is-colony p)
        'maxPopulation (province-max-population p)
        'currentPopulation (province-current-population p)
        'centerX (province-center-x p)
        'centerY (province-center-y p)
        'neighbors (map province-connection-neighbor-id (province-neighbors p))))

(define (provinces->jsexpr ps)
  (map province->jsexpr ps))

(define (provinces-fetch)
  (map
    (lambda (row) (apply province (append (vector->list row) '(#f))))
    (fetch-records "provinces")))

(define (provinces-with-nation-id nid ps)
  (filter (lambda (p) (equal? (province-nation-id p) nid)) ps))
