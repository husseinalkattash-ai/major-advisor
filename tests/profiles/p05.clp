;;; ============================================================================
;;; Profile p05 -- Electrical Engineer
;;; Excellent math and physics, high investigative+realistic, strong technical and analytical, low social - a systems/electronics engineer profile.
;;; Expected top-1: elec-eng  |  acceptable top-3: elec-eng; comp-eng; mech-eng
;;; ============================================================================
(deffacts profile-p05
   ;; --- Academic performance ---
   (attr (student p05) (name math) (value excellent))
   (attr (student p05) (name physics) (value excellent))
   (attr (student p05) (name chemistry) (value good))
   (attr (student p05) (name biology) (value weak))
   (attr (student p05) (name arabic) (value average))
   (attr (student p05) (name foreign-lang) (value good))
   (attr (student p05) (name social-studies) (value average))
   (attr (student p05) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p05) (name realistic) (value high))
   (attr (student p05) (name investigative) (value high))
   (attr (student p05) (name artistic) (value low))
   (attr (student p05) (name social) (value low))
   (attr (student p05) (name enterprising) (value low))
   (attr (student p05) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p05) (name analytical) (value high))
   (attr (student p05) (name creativity) (value medium))
   (attr (student p05) (name communication) (value low))
   (attr (student p05) (name technical) (value high))
   (attr (student p05) (name leadership) (value low))
   (attr (student p05) (name detail) (value high))
)
