;;; ============================================================================
;;; Profile p06 -- Mechanical Engineer
;;; Excellent math/physics with very high realistic interest, strong technical skill and good creativity for design - mechanical engineering archetype.
;;; Expected top-1: mech-eng  |  acceptable top-3: mech-eng; civil-eng; elec-eng
;;; ============================================================================
(deffacts profile-p06
   ;; --- Academic performance ---
   (attr (student p06) (name math) (value excellent))
   (attr (student p06) (name physics) (value excellent))
   (attr (student p06) (name chemistry) (value good))
   (attr (student p06) (name biology) (value average))
   (attr (student p06) (name arabic) (value average))
   (attr (student p06) (name foreign-lang) (value average))
   (attr (student p06) (name social-studies) (value average))
   (attr (student p06) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p06) (name realistic) (value high))
   (attr (student p06) (name investigative) (value high))
   (attr (student p06) (name artistic) (value medium))
   (attr (student p06) (name social) (value low))
   (attr (student p06) (name enterprising) (value medium))
   (attr (student p06) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p06) (name analytical) (value high))
   (attr (student p06) (name creativity) (value high))
   (attr (student p06) (name communication) (value low))
   (attr (student p06) (name technical) (value high))
   (attr (student p06) (name leadership) (value medium))
   (attr (student p06) (name detail) (value medium))
)
