;;; ============================================================================
;;; run-tests.clp
;;; Gold-standard test runner (spec section 9.2). Loads the expert system, then
;;; for every profile in tests/profiles/ it (re)initialises working memory, runs
;;; the engine, captures the top-1 and top-3 majors, and compares them to
;;; tests/expected-results.csv. Finally it prints Top-1 accuracy, Top-3 hit
;;; rate, an "acceptable@3" rate, and a faculty-level confusion matrix.
;;;
;;; Run from the PROJECT ROOT:
;;;     clips -f2 tests/run-tests.clp
;;; or inside a CLIPS prompt:  (batch* "tests/run-tests.clp")
;;; ============================================================================

;;; --- Load the system (silently, with load*). Consultation is not needed for
;;;     batch testing, so it is not loaded. ---
(load* "src/templates.clp")
(load* "src/majors.clp")
(load* "src/requirements.clp")
(load* "src/scoring.clp")
(load* "src/ranking.clp")

;;; The interactive auto-report rule would print a full 5-major report for every
;;; profile. Remove it for batch testing; we capture the ranking ourselves with
;;; the rec-worse/sort helpers that remain from ranking.clp.
(undefrule print-report)

;;; ----------------------------------------------------------------------------
;;; Split a string by a single-character delimiter into a multifield of strings.
;;; ----------------------------------------------------------------------------
(deffunction split-str (?s ?d)
   (bind ?out (create$))
   (while (> (str-length ?s) 0) do
      (bind ?i (str-index ?d ?s))
      (if (integerp ?i)
         then (bind ?out (create$ ?out (sub-string 1 (- ?i 1) ?s)))
              (bind ?s (sub-string (+ ?i 1) (str-length ?s) ?s))
         else (bind ?out (create$ ?out ?s))
              (bind ?s "")))
   ?out)

;;; ----------------------------------------------------------------------------
;;; Map a major id to one of the six spec faculty groups (3-letter code) used by
;;; the confusion matrix.
;;; ----------------------------------------------------------------------------
(deffunction fac-group (?mid)
   (bind ?f "")
   (do-for-fact ((?m major)) (eq ?m:id ?mid) (bind ?f ?m:faculty))
   (if (eq ?f "Faculty of Engineering")                  then (return Eng))
   (if (eq ?f "Faculty of Medicine & Health Sciences")   then (return Med))
   (if (eq ?f "Faculty of Science")                      then (return Sci))
   (if (eq ?f "Faculty of Business Administration")      then (return Bus))
   (if (eq ?f "Faculty of Arts & Humanities")            then (return Art))
   (return Oth))

;;; ----------------------------------------------------------------------------
;;; Run one profile end-to-end and return its top-3 major ids as a multifield.
;;; Loads the profile's deffacts, (reset)s working memory (which re-asserts the
;;; knowledge base plus this profile), runs the engine, ranks the
;;; recommendations, then undeffacts the profile so it does not leak into the
;;; next test.
;;; ----------------------------------------------------------------------------
(deffunction run-profile (?pid)
   (load* (str-cat "tests/profiles/" ?pid ".clp"))
   (reset)
   (run)
   (bind ?recs (sort rec-worse (find-all-facts ((?r recommendation)) TRUE)))
   (bind ?top (create$ (fact-slot-value (nth$ 1 ?recs) major)
                       (fact-slot-value (nth$ 2 ?recs) major)
                       (fact-slot-value (nth$ 3 ?recs) major)))
   (undeffacts (sym-cat "profile-" ?pid))
   (return ?top))

;;; ----------------------------------------------------------------------------
;;; Count expected->predicted faculty-group pairs in the collected list.
;;; ----------------------------------------------------------------------------
(deffunction count-pair (?pairs ?e ?s)
   (bind ?key (str-cat ?e ">" ?s))
   (bind ?c 0)
   (progn$ (?p ?pairs) (if (eq ?p ?key) then (bind ?c (+ ?c 1))))
   (return ?c))

(deffunction pct (?num ?den)
   (if (= ?den 0) then (return 0))
   (return (round (/ (* ?num 100.0) ?den))))

;;; ----------------------------------------------------------------------------
;;; Print metrics and the 6x6 faculty confusion matrix.
;;; ----------------------------------------------------------------------------
(deffunction print-metrics (?total ?t1 ?t3 ?a3 ?pairs)
   (printout t crlf "==================== METRICS ====================" crlf)
   (printout t "Profiles evaluated : " ?total crlf)
   (printout t "Top-1 accuracy     : " ?t1 "/" ?total " = " (pct ?t1 ?total) "%   (target >= 70%)" crlf)
   (printout t "Top-3 hit rate     : " ?t3 "/" ?total " = " (pct ?t3 ?total) "%   (target >= 90%)" crlf)
   (printout t "Acceptable@3 rate  : " ?a3 "/" ?total " = " (pct ?a3 ?total) "%" crlf)
   (printout t crlf "==== FACULTY CONFUSION MATRIX (row=expected, col=predicted) ====" crlf)
   (bind ?groups (create$ Eng Med Sci Bus Art Oth))
   (printout t (format nil "%-8s" "exp\\pred"))
   (progn$ (?g ?groups) (printout t (format nil "%5s" (str-cat ?g))))
   (printout t crlf)
   (progn$ (?ge ?groups)
      (printout t (format nil "%-8s" (str-cat ?ge)))
      (progn$ (?gs ?groups)
         (printout t (format nil "%5d" (count-pair ?pairs ?ge ?gs))))
      (printout t crlf))
   (printout t "=================================================" crlf))

;;; ----------------------------------------------------------------------------
;;; Main driver: read expected-results.csv, run every profile, tabulate.
;;; The first three CSV columns (profile_id, expected_top1, acceptable_top3)
;;; never contain commas, so splitting on ',' and using fields 1-3 is robust
;;; even though the 4th column (notes) is quoted and may contain commas.
;;; ----------------------------------------------------------------------------
(deffunction run-all-tests ()
   (open "tests/expected-results.csv" csv "r")
   (readline csv)   ; discard header
   (bind ?total 0) (bind ?t1 0) (bind ?t3 0) (bind ?a3 0) (bind ?pairs (create$))
   (printout t "PID   EXPECTED_TOP1   SYSTEM_TOP1     T1 T3 A3  SYSTEM_TOP3" crlf)
   (printout t "----------------------------------------------------------------------" crlf)
   (bind ?line (readline csv))
   (while (neq ?line EOF) do
      (if (> (str-length ?line) 0) then
         (bind ?f (split-str ?line ","))
         (bind ?pid (nth$ 1 ?f))
         (bind ?e1  (sym-cat (nth$ 2 ?f)))
         (bind ?accs (create$))
         (progn$ (?a (split-str (nth$ 3 ?f) ";")) (bind ?accs (create$ ?accs (sym-cat ?a))))
         (bind ?top (run-profile ?pid))
         (bind ?s1 (nth$ 1 ?top))
         (bind ?hit1 (eq ?s1 ?e1))
         (bind ?hit3 (if (member$ ?e1 ?top) then TRUE else FALSE))
         (bind ?hitA FALSE)
         (progn$ (?a ?accs) (if (member$ ?a ?top) then (bind ?hitA TRUE)))
         (bind ?total (+ ?total 1))
         (if ?hit1 then (bind ?t1 (+ ?t1 1)))
         (if ?hit3 then (bind ?t3 (+ ?t3 1)))
         (if ?hitA then (bind ?a3 (+ ?a3 1)))
         (bind ?pairs (create$ ?pairs (str-cat (fac-group ?e1) ">" (fac-group ?s1))))
         (printout t (format nil "%-5s %-15s %-15s  %s  %s  %s  %s"
                       ?pid (str-cat ?e1) (str-cat ?s1)
                       (if ?hit1 then "Y" else ".")
                       (if ?hit3 then "Y" else ".")
                       (if ?hitA then "Y" else ".")
                       (implode$ ?top)) crlf))
      (bind ?line (readline csv)))
   (close csv)
   (print-metrics ?total ?t1 ?t3 ?a3 ?pairs))

(run-all-tests)
