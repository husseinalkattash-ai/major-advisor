;;; ============================================================================
;;; Profile p08 -- Caring Nurse
;;; Good biology with very high social and communication and strong detail - a people-centred health-care profile fitting nursing.
;;; Expected top-1: nursing  |  acceptable top-3: nursing; med-lab; psychology
;;; ============================================================================
(deffacts profile-p08
   ;; --- Academic performance ---
   (attr (student p08) (name math) (value average))
   (attr (student p08) (name physics) (value average))
   (attr (student p08) (name chemistry) (value good))
   (attr (student p08) (name biology) (value good))
   (attr (student p08) (name arabic) (value good))
   (attr (student p08) (name foreign-lang) (value average))
   (attr (student p08) (name social-studies) (value good))
   (attr (student p08) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p08) (name realistic) (value medium))
   (attr (student p08) (name investigative) (value medium))
   (attr (student p08) (name artistic) (value low))
   (attr (student p08) (name social) (value high))
   (attr (student p08) (name enterprising) (value medium))
   (attr (student p08) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p08) (name analytical) (value medium))
   (attr (student p08) (name creativity) (value low))
   (attr (student p08) (name communication) (value high))
   (attr (student p08) (name technical) (value medium))
   (attr (student p08) (name leadership) (value medium))
   (attr (student p08) (name detail) (value high))
)
