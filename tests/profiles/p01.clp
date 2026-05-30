;;; ============================================================================
;;; Profile p01 -- Computer Engineering archetype
;;; Excellent math and computing with high investigative+realistic interest and strong technical/analytical skills - classic computer engineering profile.
;;; Expected top-1: comp-eng  |  acceptable top-3: comp-eng; cs; elec-eng
;;; ============================================================================
(deffacts profile-p01
   ;; --- Academic performance ---
   (attr (student p01) (name math) (value excellent))
   (attr (student p01) (name physics) (value excellent))
   (attr (student p01) (name chemistry) (value good))
   (attr (student p01) (name biology) (value average))
   (attr (student p01) (name arabic) (value average))
   (attr (student p01) (name foreign-lang) (value good))
   (attr (student p01) (name social-studies) (value average))
   (attr (student p01) (name computing) (value excellent))
   ;; --- Interests (RIASEC) ---
   (attr (student p01) (name realistic) (value high))
   (attr (student p01) (name investigative) (value high))
   (attr (student p01) (name artistic) (value low))
   (attr (student p01) (name social) (value low))
   (attr (student p01) (name enterprising) (value medium))
   (attr (student p01) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p01) (name analytical) (value high))
   (attr (student p01) (name creativity) (value medium))
   (attr (student p01) (name communication) (value medium))
   (attr (student p01) (name technical) (value high))
   (attr (student p01) (name leadership) (value low))
   (attr (student p01) (name detail) (value high))
)
