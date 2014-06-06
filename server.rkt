(require web-server/servlet)
(require web-server/dispatch)
(require json)
(require db)

(include "db.rkt")
(include "models/province.rkt")
(include "models/province_connection.rkt")
(include "models/nation.rkt")
(include "models/user.rkt")

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
    [("nations") list-nations]
    [("provinces") list-provinces]
    [("game") list-game-data]))

(define (list-provinces request)
  (json-response
    (provinces->jsexpr (provinces-fetch))))

(define (list-nations request)
  (json-response
    (nations->jsexpr (nations-fetch))))

(define (list-game-data request)
  (json-response
    (hash
      'nations (nations->jsexpr (nations-fetch))
      'provinces (provinces->jsexpr (provinces-fetch))
      'provinceConnections (province-connections->jsexpr (province-connections-fetch))
      'users (users->jsexpr (users-fetch)))))

(define (start request)
  (api-dispatch request))

(require web-server/servlet-env)
(serve/servlet
  start
  #:servlet-path ""
  #:port 8080
  #:servlet-regexp #rx""
  #:launch-browser? #f)
