;;; ============================================================================
;;; ranking.clp
;;; Ranking and output (spec section 5). After scoring stabilises, rank the
;;; recommendations by percentage (descending), break ties by raw score, and
;;; print the top 5 majors with name, faculty, match percentage, and the list
;;; of accumulated justifications.
;;; ============================================================================

;;; ----------------------------------------------------------------------------
;;; Ordering predicate used by `sort`. CLIPS sort places ?a AFTER ?b when this
;;; returns TRUE, so returning TRUE for the "worse" recommendation yields a
;;; best-first (descending) order. Worse = lower percent, or equal percent with
;;; lower raw (the spec's tie-break: favour the higher raw).
;;; ----------------------------------------------------------------------------
(deffunction rec-worse (?a ?b)
   (bind ?pa (fact-slot-value ?a percent))
   (bind ?pb (fact-slot-value ?b percent))
   (if (< ?pa ?pb) then (return TRUE))
   (if (> ?pa ?pb) then (return FALSE))
   (< (fact-slot-value ?a raw) (fact-slot-value ?b raw)))

;;; ----------------------------------------------------------------------------
;;; Print the top ?n recommendations. Looks up each major's display name and
;;; faculty from its `major` fact, and lists the justifications collected during
;;; scoring. Majors with no matching factors are still well-formed (0%).
;;; ----------------------------------------------------------------------------
(deffunction print-recommendations (?n)
   (bind ?recs (sort rec-worse (find-all-facts ((?r recommendation)) TRUE)))
   (bind ?count (min ?n (length$ ?recs)))
   (printout t crlf)
   (printout t "====================================================================" crlf)
   (printout t "   TOP " ?count " MAJOR RECOMMENDATIONS FOR YOU" crlf)
   (printout t "====================================================================" crlf)
   (loop-for-count (?i 1 ?count) do
      (bind ?rec (nth$ ?i ?recs))
      (bind ?mid (fact-slot-value ?rec major))
      (bind ?pct (fact-slot-value ?rec percent))
      (bind ?raw (fact-slot-value ?rec raw))
      (bind ?mx  (fact-slot-value ?rec max))
      (bind ?nm ?mid)
      (bind ?fac "")
      (do-for-fact ((?mj major)) (eq ?mj:id ?mid)
         (bind ?nm ?mj:name)
         (bind ?fac ?mj:faculty))
      (printout t crlf "#" ?i "   " ?nm "   --   " ?pct "% match" crlf)
      (printout t "     Faculty: " ?fac crlf)
      (printout t "     Match score: " ?raw " / " ?mx crlf)
      (bind ?reasons (fact-slot-value ?rec reasons))
      (if (> (length$ ?reasons) 0) then
         (printout t "     Why this fits you:" crlf)
         (progn$ (?why ?reasons)
            (printout t "        - " ?why crlf))
       else
         (printout t "     (No strongly matching factors for this major.)" crlf))
      (printout t "--------------------------------------------------------------------" crlf))
   (printout t crlf))

;;; ----------------------------------------------------------------------------
;;; Auto-print the report once, after scoring AND percentage computation have
;;; finished. Salience -100 (below compute-percent's -10) guarantees this runs
;;; last; the (not (reported)) guard makes it fire exactly once.
;;; ----------------------------------------------------------------------------
(defrule print-report
   (declare (salience -100))
   (not (reported))
   =>
   (assert (reported))
   (print-recommendations 5))
