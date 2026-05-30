;;; ============================================================================
;;; Profile p16 -- Psychologist
;;; Good biology, very high social and high investigative with strong communication and analytical - understands people scientifically, fits psychology.
;;; Expected top-1: psychology  |  acceptable top-3: psychology; sociology; nursing
;;; ============================================================================
(deffacts profile-p16
   ;; --- Academic performance ---
   (attr (student p16) (name math) (value average))
   (attr (student p16) (name physics) (value weak))
   (attr (student p16) (name chemistry) (value average))
   (attr (student p16) (name biology) (value good))
   (attr (student p16) (name arabic) (value good))
   (attr (student p16) (name foreign-lang) (value good))
   (attr (student p16) (name social-studies) (value good))
   (attr (student p16) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p16) (name realistic) (value low))
   (attr (student p16) (name investigative) (value high))
   (attr (student p16) (name artistic) (value medium))
   (attr (student p16) (name social) (value high))
   (attr (student p16) (name enterprising) (value medium))
   (attr (student p16) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p16) (name analytical) (value high))
   (attr (student p16) (name creativity) (value medium))
   (attr (student p16) (name communication) (value high))
   (attr (student p16) (name technical) (value low))
   (attr (student p16) (name leadership) (value medium))
   (attr (student p16) (name detail) (value medium))
)
