;; --------------------------------------------------
;; Contract: auto-split
;; Purpose: Automatically split incoming STX among recipients
;; Author: [Your Name]
;; License: MIT
;; --------------------------------------------------

;; === Constants ===
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_TOTAL_SHARE (err u101))
(define-constant ERR_RECIPIENT_NOT_FOUND (err u102))
(define-constant ERR_NO_FUNDS (err u103))

;; === Admin Control ===
(define-data-var contract-owner principal tx-sender)

;; === Recipients and Shares (basis points: 10000 = 100%) ===
(define-map recipients
    {recipient: principal}    ;; recipient address
    {share: uint}            ;; share in basis points (e.g., 3000 = 30%)
)

(define-data-var total-share uint u0)

;; === Set recipients and their shares (admin only) ===
(define-public (set-recipients (recipients-list (list 10 {recipient: principal, share: uint})))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_UNAUTHORIZED)
        (let ((total u0))
            (map-delete recipients {recipient: tx-sender})
            
            ;; Set new recipients and calculate total share
            (fold add-recipient recipients-list total)
            
            ;; Verify total share is 100%
            (asserts! (is-eq total u10000) ERR_INVALID_TOTAL_SHARE)
            (var-set total-share total)
            (ok true))))

;; === Helper function to add recipient ===
(define-private (add-recipient (entry {recipient: principal, share: uint}) (current-total uint))
    (begin
        (map-set recipients {recipient: (get recipient entry)} {share: (get share entry)})
        (+ current-total (get share entry))))

;; === Deposit and split STX ===
(define-public (deposit-and-split (amount uint))
    (begin
        (asserts! (> amount u0) ERR_NO_FUNDS)
        
        ;; Transfer STX from sender
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        
        ;; Get all unique recipients and distribute
        (map-get? recipients {recipient: tx-sender})
        (ok true)))

;; === Helper function to distribute share ===
(define-private (distribute-share (recipient principal) (share uint) (amount uint))
    (let ((share-amount (/ (* amount share) u10000)))
        (try! (stx-transfer? share-amount (as-contract tx-sender) recipient))
        (ok true)))

;; === Read-only: Get share for a recipient ===
(define-read-only (get-recipient-share (recipient principal))
    (match (map-get? recipients {recipient: recipient})
        share (ok (get share share))
        (err ERR_RECIPIENT_NOT_FOUND)))