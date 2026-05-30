;;; ============================================================================
;;; Profile p15 -- Economist
;;; Good math and excellent social studies, high investigative+enterprising with strong analytical and communication - quantitative social scientist fitting economics.
;;; Expected top-1: economics  |  acceptable top-3: economics; management; accounting
;;; ============================================================================
(deffacts profile-p15
   ;; --- Academic performance ---
   (attr (student p15) (name math) (value good))
   (attr (student p15) (name physics) (value average))
   (attr (student p15) (name chemistry) (value weak))
   (attr (student p15) (name biology) (value weak))
   (attr (student p15) (name arabic) (value good))
   (attr (student p15) (name foreign-lang) (value good))
   (attr (student p15) (name social-studies) (value excellent))
   (attr (student p15) (name computing) (value good))
   ;; --- Interests (RIASEC) ---
   (attr (student p15) (name realistic) (value low))
   (attr (student p15) (name investigative) (value high))
   (attr (student p15) (name artistic) (value low))
   (attr (student p15) (name social) (value medium))
   (attr (student p15) (name enterprising) (value high))
   (attr (student p15) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p15) (name analytical) (value high))
   (attr (student p15) (name creativity) (value medium))
   (attr (student p15) (name communication) (value high))
   (attr (student p15) (name technical) (value low))
   (attr (student p15) (name leadership) (value medium))
   (attr (student p15) (name detail) (value medium))
)
