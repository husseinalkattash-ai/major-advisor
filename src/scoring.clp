;;; ============================================================================
;;; scoring.clp
;;; Scoring rules (spec section 4). For one student loaded in working memory,
;;; compare each major's requirements against the student's attributes and
;;; accumulate points (raw) and justifications (reasons) into that major's
;;; recommendation fact. Finally normalise raw into a percentage.
;;;
;;; Knowledge source: the graded-match policy in spec section 4 (full / half /
;;; zero credit by ordinal distance). The rules are fully generic -- they never
;;; mention a specific major or attribute, only the data in the requirement,
;;; attr, and rank facts.
;;;
;;; Recommendation facts (one per major, raw=0, max=sum of weights) are created
;;; by the `init-recommendations` deffacts in requirements.clp, so these rules
;;; only have to add to raw and reasons.
;;;
;;; NO DOUBLE COUNTING: each (student, major, attribute) requirement may be
;;; scored at most once. After a requirement is scored we assert a control fact
;;;     (scored <student> <major> <attribute>)
;;; and every scoring rule carries (not (scored ...)) so it cannot fire again.
;;; This is essential because `modify` on the recommendation creates a new fact,
;;; which would otherwise re-activate the rule with the same requirement and
;;; double-count it (an infinite loop). See docs/rules-reference.md.
;;; ============================================================================

;;; ----------------------------------------------------------------------------
;;; FULL MATCH: student rank >= required rank  ->  award the full weight and
;;; record the justification.
;;; ----------------------------------------------------------------------------
(defrule score-full-match
   (requirement (major ?m) (attribute ?a) (level ?rl) (weight ?w) (reason ?r))
   (attr (student ?s) (name ?a) (value ?sv))
   (rank ?sv ?srank)
   (rank ?rl ?rrank)
   (test (>= ?srank ?rrank))
   (not (scored ?s ?m ?a))
   ?rec <- (recommendation (major ?m) (raw ?raw) (reasons $?rs))
   =>
   (modify ?rec (raw (+ ?raw ?w)) (reasons (create$ ?rs ?r)))
   (assert (scored ?s ?m ?a)))

;;; ----------------------------------------------------------------------------
;;; PARTIAL MATCH: student rank is exactly one level below the requirement ->
;;; award half the weight, but do NOT record a justification (it is a near miss,
;;; not something we would cite as a reason).
;;; ----------------------------------------------------------------------------
(defrule score-partial-match
   (requirement (major ?m) (attribute ?a) (level ?rl) (weight ?w))
   (attr (student ?s) (name ?a) (value ?sv))
   (rank ?sv ?srank)
   (rank ?rl ?rrank)
   (test (= ?srank (- ?rrank 1)))
   (not (scored ?s ?m ?a))
   ?rec <- (recommendation (major ?m) (raw ?raw))
   =>
   (modify ?rec (raw (+ ?raw (/ ?w 2))))
   (assert (scored ?s ?m ?a)))

;;; ----------------------------------------------------------------------------
;;; PERCENTAGE: once all scoring has stabilised (lower salience guarantees this
;;; runs after every full/partial match), compute percent = round(raw/max*100)
;;; for each recommendation. The (not (percent-done ?m)) guard makes this fire
;;; exactly once per major -- without it, modifying the fact would re-activate
;;; the rule (and a raw of 0 would loop forever).
;;; ----------------------------------------------------------------------------
(defrule compute-percent
   (declare (salience -10))
   ?rec <- (recommendation (major ?m) (raw ?raw) (max ?mx))
   (test (> ?mx 0))
   (not (percent-done ?m))
   =>
   (modify ?rec (percent (round (/ (* ?raw 100.0) ?mx))))
   (assert (percent-done ?m)))
