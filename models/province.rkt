(struct province (id name map-color created-at updated-at nation-id current-manpower max-manpower is-colony max-population current-population center-x center-y))

(define (province->jsexpr province)
  (hash 'id (province-id province)
        'name (province-name province)
        'mapColor (province-map-color province)
        'nationId (province-nation-id province)
        'currentManpower (province-current-manpower province)
        'maxManpower (province-max-manpower province)
        'isColony (province-is-colony province)
        'maxPopulation (province-max-population province)
        'currentPopulation (province-current-population province)
        'centerX (province-center-x province)
        'centerY (province-center-y province)))

(define (provinces->jsexpr provinces)
  (map province->jsexpr provinces))

(define (provinces-fetch)
  (map
    (lambda (row) (apply province (vector->list row)))
    (fetch-records "provinces")))
