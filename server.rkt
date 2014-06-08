(require (planet dmac/spin))

(include "common.rkt")

(require "database.rkt")
(require "models/main.rkt")
(require "api/main.rkt")

(run #:servlet-path ""
     #:port 8080
     #:launch-browser? #f
     #:response-maker json-response-maker)
