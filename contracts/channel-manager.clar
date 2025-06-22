;; Channel Manager Verification Contract
;; Validates and manages omnichannel managers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_EXISTS (err u101))
(define-constant ERR_NOT_FOUND (err u102))

;; Data maps
(define-map channel-managers principal bool)
(define-map manager-details principal {
    name: (string-ascii 50),
    channels: (list 10 (string-ascii 20)),
    verified-at: uint,
    active: bool
})

;; Public functions
(define-public (register-manager (manager principal) (name (string-ascii 50)) (channels (list 10 (string-ascii 20))))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-none (map-get? channel-managers manager)) ERR_ALREADY_EXISTS)
        (map-set channel-managers manager true)
        (map-set manager-details manager {
            name: name,
            channels: channels,
            verified-at: block-height,
            active: true
        })
        (ok true)
    )
)

(define-public (deactivate-manager (manager principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
        (asserts! (is-some (map-get? channel-managers manager)) ERR_NOT_FOUND)
        (map-set channel-managers manager false)
        (ok true)
    )
)

;; Read-only functions
(define-read-only (is-verified-manager (manager principal))
    (default-to false (map-get? channel-managers manager))
)

(define-read-only (get-manager-details (manager principal))
    (map-get? manager-details manager)
)
