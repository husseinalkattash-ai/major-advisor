;;; ============================================================================
;;; Profile p20 -- Visual designer
;;; High artistic interest with very high creativity, strong technical and good computing but low analytical - a visual-maker profile fitting graphic design.
;;; Expected top-1: graphic-design  |  acceptable top-3: graphic-design; media; architecture
;;; ============================================================================
(deffacts profile-p20
   ;; --- Academic performance ---
   (attr (student p20) (name math) (value average))
   (attr (student p20) (name physics) (value weak))
   (attr (student p20) (name chemistry) (value weak))
   (attr (student p20) (name biology) (value weak))
   (attr (student p20) (name arabic) (value good))
   (attr (student p20) (name foreign-lang) (value good))
   (attr (student p20) (name social-studies) (value average))
   (attr (student p20) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p20) (name realistic) (value medium))
   (attr (student p20) (name investigative) (value low))
   (attr (student p20) (name artistic) (value high))
   (attr (student p20) (name social) (value medium))
   (attr (student p20) (name enterprising) (value medium))
   (attr (student p20) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p20) (name analytical) (value low))
   (attr (student p20) (name creativity) (value high))
   (attr (student p20) (name communication) (value medium))
   (attr (student p20) (name technical) (value high))
   (attr (student p20) (name leadership) (value low))
   (attr (student p20) (name detail) (value high))
)
