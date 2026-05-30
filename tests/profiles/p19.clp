;;; ============================================================================
;;; Profile p19 -- Architect
;;; Good math/physics with high realistic AND high artistic interest, very high creativity plus strong technical and detail - the design-meets-build profile of architecture.
;;; Expected top-1: architecture  |  acceptable top-3: architecture; civil-eng; graphic-design
;;; ============================================================================
(deffacts profile-p19
   ;; --- Academic performance ---
   (attr (student p19) (name math) (value good))
   (attr (student p19) (name physics) (value good))
   (attr (student p19) (name chemistry) (value average))
   (attr (student p19) (name biology) (value weak))
   (attr (student p19) (name arabic) (value average))
   (attr (student p19) (name foreign-lang) (value good))
   (attr (student p19) (name social-studies) (value average))
   (attr (student p19) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p19) (name realistic) (value high))
   (attr (student p19) (name investigative) (value medium))
   (attr (student p19) (name artistic) (value high))
   (attr (student p19) (name social) (value medium))
   (attr (student p19) (name enterprising) (value medium))
   (attr (student p19) (name conventional) (value low))
   ;; --- Skills / aptitudes ---
   (attr (student p19) (name analytical) (value high))
   (attr (student p19) (name creativity) (value high))
   (attr (student p19) (name communication) (value medium))
   (attr (student p19) (name technical) (value high))
   (attr (student p19) (name leadership) (value medium))
   (attr (student p19) (name detail) (value high))
)
