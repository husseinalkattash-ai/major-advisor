;;; ============================================================================
;;; Profile p13 -- Accountant
;;; Good math, very high conventional and detail with strong analytical and good computing - precise, numbers-and-records profile fitting accounting.
;;; Expected top-1: accounting  |  acceptable top-3: accounting; mis; economics
;;; ============================================================================
(deffacts profile-p13
   ;; --- Academic performance ---
   (attr (student p13) (name math) (value good))
   (attr (student p13) (name physics) (value average))
   (attr (student p13) (name chemistry) (value weak))
   (attr (student p13) (name biology) (value weak))
   (attr (student p13) (name arabic) (value good))
   (attr (student p13) (name foreign-lang) (value average))
   (attr (student p13) (name social-studies) (value good))
   (attr (student p13) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p13) (name realistic) (value low))
   (attr (student p13) (name investigative) (value medium))
   (attr (student p13) (name artistic) (value low))
   (attr (student p13) (name social) (value medium))
   (attr (student p13) (name enterprising) (value medium))
   (attr (student p13) (name conventional) (value high))
   ;; --- Skills / aptitudes ---
   (attr (student p13) (name analytical) (value high))
   (attr (student p13) (name creativity) (value low))
   (attr (student p13) (name communication) (value medium))
   (attr (student p13) (name technical) (value low))
   (attr (student p13) (name leadership) (value low))
   (attr (student p13) (name detail) (value high))
)
