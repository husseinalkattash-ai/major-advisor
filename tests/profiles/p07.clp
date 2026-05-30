;;; ============================================================================
;;; Profile p07 -- Pharmacy / chemistry detail
;;; Excellent chemistry, good biology, high conventional and very high detail with strong analytical - methodical, precise pharmacy candidate.
;;; Expected top-1: pharmacy  |  acceptable top-3: pharmacy; chem-sci; med-lab
;;; ============================================================================
(deffacts profile-p07
   ;; --- Academic performance ---
   (attr (student p07) (name math) (value good))
   (attr (student p07) (name physics) (value average))
   (attr (student p07) (name chemistry) (value excellent))
   (attr (student p07) (name biology) (value good))
   (attr (student p07) (name arabic) (value average))
   (attr (student p07) (name foreign-lang) (value good))
   (attr (student p07) (name social-studies) (value average))
   (attr (student p07) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p07) (name realistic) (value low))
   (attr (student p07) (name investigative) (value high))
   (attr (student p07) (name artistic) (value low))
   (attr (student p07) (name social) (value medium))
   (attr (student p07) (name enterprising) (value medium))
   (attr (student p07) (name conventional) (value high))
   ;; --- Skills / aptitudes ---
   (attr (student p07) (name analytical) (value high))
   (attr (student p07) (name creativity) (value low))
   (attr (student p07) (name communication) (value medium))
   (attr (student p07) (name technical) (value medium))
   (attr (student p07) (name leadership) (value low))
   (attr (student p07) (name detail) (value high))
)
