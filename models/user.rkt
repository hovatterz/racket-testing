(struct user (id email-address display-name password-digest created-at updated-at access-token))

(define (user->jsexpr u)
  (hash 'id (user-id u)
        'displayName (user-display-name u)))

(define (users->jsexpr us)
  (map user->jsexpr us))

(define (users-fetch)
  (map
    (lambda (row) (apply user (vector->list row)))
    (fetch-records "users")))
