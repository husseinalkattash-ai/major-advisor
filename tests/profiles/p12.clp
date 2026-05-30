;;; ============================================================================
;;; Profile p12 -- Life scientist
;;; Excellent biology, good chemistry, high investigative with strong analytical and detail but only medium social - research biology over clinical medicine.
;;; Expected top-1: bio-sci  |  acceptable top-3: bio-sci; medicine; med-lab
;;; ============================================================================
(deffacts profile-p12
   ;; --- Academic performance ---
   (attr (student p12) (name math) (value average))
   (attr (student p12) (name physics) (value average))
   (attr (student p12) (name chemistry) (value good))
   (attr (student p12) (name biology) (value excellent))
   (attr (student p12) (name arabic) (value good))
   (attr (student p12) (name foreign-lang) (value good))
   (attr (student p12) (name social-studies) (value good))
   (attr (student p12) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p12) (name realistic) (value medium))
   (attr (student p12) (name investigative) (value high))
   (attr (student p12) (name artistic) (value low))
   (attr (student p12) (name social) (value medium))
   (attr (student p12) (name enterprising) (value low))
   (attr (student p12) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p12) (name analytical) (value high))
   (attr (student p12) (name creativity) (value medium))
   (attr (student p12) (name communication) (value medium))
   (attr (student p12) (name technical) (value medium))
   (attr (student p12) (name leadership) (value low))
   (attr (student p12) (name detail) (value high))
)
