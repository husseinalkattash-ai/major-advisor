;;; ============================================================================
;;; templates.clp
;;; All deftemplate definitions and the ordinal rank scale.
;;; Knowledge representation per spec sections 3.1, 3.2, 3.3.
;;; ============================================================================

;;; ----------------------------------------------------------------------------
;;; Student profile attribute (working memory / system input).
;;; One uniform fact per attribute so that scoring can be fully generic:
;;; the same rule compares any student attribute against any requirement.
;;;   student : student id (e.g. p03)
;;;   name    : attribute name (e.g. math, investigative, analytical)
;;;   value   : ordinal value (weak..excellent  or  low..high)
;;; ----------------------------------------------------------------------------
(deftemplate attr
   (slot student)
   (slot name)
   (slot value))

;;; ----------------------------------------------------------------------------
;;; Major identity (knowledge base).
;;;   id      : symbolic key referenced by requirements/recommendations
;;;   name    : human-readable display name
;;;   faculty : owning faculty
;;; ----------------------------------------------------------------------------
(deftemplate major
   (slot id)
   (slot name)
   (slot faculty))

;;; ----------------------------------------------------------------------------
;;; A single requirement of a major's ideal profile (the core knowledge base).
;;;   major     : major id this requirement belongs to
;;;   attribute : attribute name compared against the student's attr
;;;   level     : required ordinal level on the same scale as the student value
;;;   weight    : importance of this attribute for this major (1..3)
;;;   reason    : justification shown to the student when the requirement is met
;;; ----------------------------------------------------------------------------
(deftemplate requirement
   (slot major)
   (slot attribute)
   (slot level)
   (slot weight)
   (slot reason))

;;; ----------------------------------------------------------------------------
;;; Recommendation accumulator (one per major; grows during inference).
;;;   raw     : sum of points awarded from met requirements
;;;   max     : sum of weights of all the major's requirements (the ceiling)
;;;   percent : raw / max * 100, computed once scoring stabilises
;;;   reasons : accumulated justification strings
;;; raw/max/percent default to 0 so a recommendation is always well-formed.
;;; ----------------------------------------------------------------------------
(deftemplate recommendation
   (slot major)
   (slot raw (default 0))
   (slot max (default 0))
   (slot percent (default 0))
   (multislot reasons))

;;; ----------------------------------------------------------------------------
;;; Ordinal scale: maps each symbolic value to a number so requirements can be
;;; compared by rank (>=, one-below, etc.). Academic and interest/skill scales
;;; share the same fact shape; they are only ever compared like-with-like.
;;; ----------------------------------------------------------------------------
(deffacts ordinal-scale
   (rank weak 1) (rank average 2) (rank good 3) (rank excellent 4)
   (rank low 1)  (rank medium 2)  (rank high 3))
