(module database racket
  (require db)

  (provide db-conn
           fetch-records
           fetch-records-hash)

  (define db-conn
    (virtual-connection
      (connection-pool
        (lambda () (postgresql-connect
                     #:user "postgres"
                     #:password "postgres"
                     #:database "Risque_development")))))

  (define (fetch-records table-name)
    (query-rows db-conn (string-append "select * from " table-name)))

  (define (fetch-records-hash table-name)
    (define results (query db-conn (string-append "select * from " table-name)))
    (rows->dict
      results
      #:key "id"
      #:value (list->vector
                (map
                  (lambda (h) (cdr (list-ref h 0)))
                  (rows-result-headers results)
                  ))
      #:value-mode (list 'list 'preserve-null))))
