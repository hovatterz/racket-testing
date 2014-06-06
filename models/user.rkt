(struct user (id email-address display-name password-digest created-at updated-at access-token))

(define (user->jsexpr user)
  (hash 'id (user-id user)
        'displayName (user-display-name user)))

(define (users->jsexpr users)
  (map user->jsexpr users))

(define (users-fetch)
  (map
    (lambda (row) (apply user (vector->list row)))
    (fetch-records "users")))
