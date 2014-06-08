(require web-server/servlet
         web-server/dispatch
         json
         db
         (planet dmac/spin))

(include "db.rkt")
(include "models/province.rkt")
(include "models/province_connection.rkt")
(include "models/nation.rkt")
(include "models/user.rkt")
(include "models/army.rkt")

(define (list-group-by key-method lst)
  (foldl (lambda (p h)
           (let ([n (key-method p)])
             (hash-set h n (cons p (hash-ref h n '())))))
         #hash()
         lst))

(define (json-response-maker status headers body)
  (response status
            (status->message status)
            (current-seconds)
            #"application/json; charset=utf-8"
            headers
            (let ([jsexpr-body (case status
                                 [(404) (string->jsexpr "{\"error\": 404, \"message\": \"Not Found\"}")]
                                 [else body])])
              (lambda (op) (write-json (force jsexpr-body) op #:null sql-null)))))

(define (json-get path handler)
  (define-handler "GET" path handler json-response-maker))

(json-get
  "/api/game.json"
  (lambda (req)
    (define nations (nations-fetch))
    (define provinces (provinces-fetch))
    (define province-connections (province-connections-fetch))
    (define users (users-fetch))
    (define armies (armies-fetch))

    (let ([provinces-by-nation (list-group-by province-nation-id provinces)]
          [armies-by-nation (list-group-by army-nation-id armies)])
      (for ([n (in-list nations)])
        (let ([id (nation-id n)])
          (set-nation-provinces! n (hash-ref provinces-by-nation id '()))
          (set-nation-armies! n (hash-ref armies-by-nation id '())))))

    (let ([armies-by-province (list-group-by army-province-id armies)]
          [connections-by-province (list-group-by province-connection-province-id province-connections)]
          [armies-by-location (list-group-by army-location-id armies)] )
      (for ([p (in-list provinces)])
        (let ([id (province-id p)])
          (set-province-neighbors! p (hash-ref connections-by-province id '()))
          (set-province-occupying-armies! p (hash-ref armies-by-location id '()))
          (set-province-armies! p (hash-ref armies-by-province id '())))))

    (hash
      'armies (armies->jsexpr armies)
      'nations (nations->jsexpr nations)
      'provinces (provinces->jsexpr provinces)
      'users (users->jsexpr users))))

(run #:servlet-path ""
     #:port 8080
     #:launch-browser? #f
     #:response-maker json-response-maker)
