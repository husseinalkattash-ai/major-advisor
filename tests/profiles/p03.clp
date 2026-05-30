;;; ============================================================================
;;; Profile p03 -- Future physician
;;; Excellent biology and chemistry, high investigative and high social with strong communication and detail - a caring, science-strong medicine candidate.
;;; Expected top-1: medicine  |  acceptable top-3: medicine; pharmacy; bio-sci
;;; ============================================================================
(deffacts profile-p03
   ;; --- Academic performance ---
   (attr (student p03) (name math) (value good))
   (attr (student p03) (name physics) (value good))
   (attr (student p03) (name chemistry) (value excellent))
   (attr (student p03) (name biology) (value excellent))
   (attr (student p03) (name arabic) (value good))
   (attr (student p03) (name foreign-lang) (value good))
   (attr (student p03) (name social-studies) (value good))
   (attr (student p03) (name computing) (value average))
   ;; --- Interests (RIASEC) ---
   (attr (student p03) (name realistic) (value medium))
   (attr (student p03) (name investigative) (value high))
   (attr (student p03) (name artistic) (value low))
   (attr (student p03) (name social) (value high))
   (attr (student p03) (name enterprising) (value medium))
   (attr (student p03) (name conventional) (value medium))
   ;; --- Skills / aptitudes ---
   (attr (student p03) (name analytical) (value high))
   (attr (student p03) (name creativity) (value medium))
   (attr (student p03) (name communication) (value high))
   (attr (student p03) (name technical) (value medium))
   (attr (student p03) (name leadership) (value medium))
   (attr (student p03) (name detail) (value high))
)
