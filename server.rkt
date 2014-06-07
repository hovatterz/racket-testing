(require web-server/servlet
         web-server/dispatch
         json
         db)

(include "db.rkt")
(include "models/province.rkt")
(include "models/province_connection.rkt")
(include "models/nation.rkt")
(include "models/user.rkt")

(define (list-group-by key-method lst)
  (foldl (lambda (p h)
           (let ([n (key-method p)])
             (hash-set h n (cons p (hash-ref h n '())))))
         #hash()
         lst))

(define (json-response jsexpr)
  (response/full
    200 #"OK"
    (current-seconds)
    #"application/json; charset=utf-8"
    (list)
    (list (jsexpr->bytes jsexpr #:null sql-null))))

(define-values
  (api-dispatch api-url)
  (dispatch-rules
    [("api" "nations.json") list-nations]
    [("api" "provinces.json") list-provinces]
    [("api" "game.json") list-game-data]))

(define (list-provinces request)
  (json-response
    (provinces->jsexpr (provinces-fetch))))

(define (list-nations request)
  (json-response
    (nations->jsexpr (nations-fetch))))

(define (list-game-data request)
  (define nations (nations-fetch))
  (define provinces (provinces-fetch))
  (define province-connections (province-connections-fetch))
  (define users (users-fetch))

  (let ([nation-provinces (list-group-by province-nation-id provinces)])
    (for ([n (in-list nations)])
      (set-nation-provinces! n (hash-ref nation-provinces (nation-id n) '()))))

  (let ([province-neighbors (list-group-by province-connection-province-id province-connections)])
    (for ([p (in-list provinces)])
      (set-province-neighbors! p (hash-ref province-neighbors (province-id p) '()))))

  (json-response
    (hash
      'nations (nations->jsexpr nations)
      'provinces (provinces->jsexpr provinces)
      'provinceConnections (province-connections->jsexpr province-connections)
      'users (users->jsexpr users))))

(define (start request)
  (api-dispatch request))

(require web-server/servlet-env)
(serve/servlet
  start
  #:servlet-path ""
  #:port 8080
  #:servlet-regexp #rx""
  #:launch-browser? #f)
