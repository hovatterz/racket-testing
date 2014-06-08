(module api racket
  (require db
           json
           web-server/servlet
           (planet dmac/spin)
           "../models/main.rkt"
           "../common.rkt")

  (provide json-response-maker
           json-get)

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

  (include "game.rkt")

  (provide (all-defined-out)))
