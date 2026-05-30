;;; ============================================================================
;;; Profile p10 -- Pure mathematician
;;; Excellent math, high investigative and analytical with strong detail, modest in everything applied - drawn to mathematics for its own sake.
;;; Expected top-1: math-sci  |  acceptable top-3: math-sci; cs; physics-sci
;;; ============================================================================
(deffacts profile-p10
   ;; --- Academic performance ---
   (attr (student p10) (name math) (value excellent))
   (attr (student p10) (name physics) (value good))
   (attr (student p10) (name chemistry) (value average))
   (attr (student p10) (name biology) (value weak))
   (attr (student p10) (name arabic) (value average))
   (attr (student p10) (name foreign-lang) (value good))
   (attr (student p10) (name social-studies) (value average))
   (attr (student p10) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p10) (name realistic) (value low))
   (attr (student p10) (name investigative) (value high))
   (attr (student p10) (name artistic) (value low))
   (attr (student p10) (name social) (value low))
   (attr (student p10) (name enterprising) (value low))
   (attr (student p10) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p10) (name analytical) (value high))
   (attr (student p10) (name creativity) (value medium))
   (attr (student p10) (name communication) (value low))
   (attr (student p10) (name technical) (value medium))
   (attr (student p10) (name leadership) (value low))
   (attr (student p10) (name detail) (value high))
)
