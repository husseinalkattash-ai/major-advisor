;;; ============================================================================
;;; Profile p18 -- Aspiring lawyer
;;; Excellent Arabic and social studies, high enterprising+social, very strong communication, leadership, analytical and detail - argues and persuades, fits law.
;;; Expected top-1: law  |  acceptable top-3: law; sociology; economics
;;; ============================================================================
(deffacts profile-p18
   ;; --- Academic performance ---
   (attr (student p18) (name math) (value average))
   (attr (student p18) (name physics) (value weak))
   (attr (student p18) (name chemistry) (value weak))
   (attr (student p18) (name biology) (value weak))
   (attr (student p18) (name arabic) (value excellent))
   (attr (student p18) (name foreign-lang) (value good))
   (attr (student p18) (name social-studies) (value excellent))
   (attr (student p18) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p18) (name realistic) (value low))
   (attr (student p18) (name investigative) (value high))
   (attr (student p18) (name artistic) (value low))
   (attr (student p18) (name social) (value high))
   (attr (student p18) (name enterprising) (value high))
   (attr (student p18) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p18) (name analytical) (value high))
   (attr (student p18) (name creativity) (value medium))
   (attr (student p18) (name communication) (value high))
   (attr (student p18) (name technical) (value low))
   (attr (student p18) (name leadership) (value high))
   (attr (student p18) (name detail) (value high))
)
