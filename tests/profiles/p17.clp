;;; ============================================================================
;;; Profile p17 -- Language & literature
;;; Excellent foreign language with high artistic and social interest and very strong communication and creativity - a language-and-expression profile.
;;; Expected top-1: english-lang  |  acceptable top-3: english-lang; media; education
;;; ============================================================================
(deffacts profile-p17
   ;; --- Academic performance ---
   (attr (student p17) (name math) (value average))
   (attr (student p17) (name physics) (value weak))
   (attr (student p17) (name chemistry) (value weak))
   (attr (student p17) (name biology) (value weak))
   (attr (student p17) (name arabic) (value good))
   (attr (student p17) (name foreign-lang) (value excellent))
   (attr (student p17) (name social-studies) (value good))
   (attr (student p17) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p17) (name realistic) (value low))
   (attr (student p17) (name investigative) (value medium))
   (attr (student p17) (name artistic) (value high))
   (attr (student p17) (name social) (value high))
   (attr (student p17) (name enterprising) (value medium))
   (attr (student p17) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p17) (name analytical) (value medium))
   (attr (student p17) (name creativity) (value high))
   (attr (student p17) (name communication) (value high))
   (attr (student p17) (name technical) (value low))
   (attr (student p17) (name leadership) (value medium))
   (attr (student p17) (name detail) (value medium))
)
