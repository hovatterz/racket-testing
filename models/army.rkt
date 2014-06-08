(struct army (id name current-manpower max-manpower province-id nation-id created-at updatde-at location-id dead disbanded) #:mutable)

(define (army->jsexpr a)
  (hash 'id (army-id a)
        'name (army-name a)
        'currentManpower (army-current-manpower a)
        'maxManpower (army-max-manpower a)
        'provinceId (army-province-id a)
        'nationId (army-nation-id a)
        'locationId (army-location-id a)
        'dead (army-dead a)
        'disbanded (army-disbanded a)))

(define (armies->jsexpr as)
  (map army->jsexpr as))

(define (armies-fetch)
  (map
    (lambda (row) (apply army (vector->list row)))
    (fetch-records "armies")))

(define (armies-with-nation-id nid as)
  (filter (lambda (p) (equal? (army-nation-id p) nid)) as))
