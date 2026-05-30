;;; ============================================================================
;;; Profile p09 -- Lab-bench scientist
;;; Good chemistry/biology, high investigative+conventional, strong technical and detail but low social - happiest at the bench, fits medical lab sciences.
;;; Expected top-1: med-lab  |  acceptable top-3: med-lab; bio-sci; pharmacy
;;; ============================================================================
(deffacts profile-p09
   ;; --- Academic performance ---
   (attr (student p09) (name math) (value average))
   (attr (student p09) (name physics) (value average))
   (attr (student p09) (name chemistry) (value good))
   (attr (student p09) (name biology) (value good))
   (attr (student p09) (name arabic) (value average))
   (attr (student p09) (name foreign-lang) (value average))
   (attr (student p09) (name social-studies) (value average))
   (attr (student p09) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p09) (name realistic) (value medium))
   (attr (student p09) (name investigative) (value high))
   (attr (student p09) (name artistic) (value low))
   (attr (student p09) (name social) (value low))
   (attr (student p09) (name enterprising) (value low))
   (attr (student p09) (name conventional) (value high))
   ;; --- Skills / aptitudes ---
   (attr (student p09) (name analytical) (value high))
   (attr (student p09) (name creativity) (value low))
   (attr (student p09) (name communication) (value low))
   (attr (student p09) (name technical) (value high))
   (attr (student p09) (name leadership) (value low))
   (attr (student p09) (name detail) (value high))
)
