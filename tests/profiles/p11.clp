;;; ============================================================================
;;; Profile p11 -- Physicist
;;; Excellent math and physics, high investigative, strong analytical, low social and enterprising - a theory-leaning physical scientist.
;;; Expected top-1: physics-sci  |  acceptable top-3: physics-sci; math-sci; elec-eng
;;; ============================================================================
(deffacts profile-p11
   ;; --- Academic performance ---
   (attr (student p11) (name math) (value excellent))
   (attr (student p11) (name physics) (value excellent))
   (attr (student p11) (name chemistry) (value good))
   (attr (student p11) (name biology) (value average))
   (attr (student p11) (name arabic) (value average))
   (attr (student p11) (name foreign-lang) (value good))
   (attr (student p11) (name social-studies) (value average))
   (attr (student p11) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p11) (name realistic) (value medium))
   (attr (student p11) (name investigative) (value high))
   (attr (student p11) (name artistic) (value low))
   (attr (student p11) (name social) (value low))
   (attr (student p11) (name enterprising) (value low))
   (attr (student p11) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p11) (name analytical) (value high))
   (attr (student p11) (name creativity) (value medium))
   (attr (student p11) (name communication) (value low))
   (attr (student p11) (name technical) (value medium))
   (attr (student p11) (name leadership) (value low))
   (attr (student p11) (name detail) (value medium))
)
