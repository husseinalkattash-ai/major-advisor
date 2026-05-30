;;; ============================================================================
;;; consultation.clp
;;; Consultation front-end (spec section 6). Gathers a student profile in one of
;;; two modes and then runs the (unchanged) scoring engine:
;;;
;;;   (consult)              -> INTERACTIVE: ask academics -> interests -> skills,
;;;                             validate each answer, assert attr facts, then run.
;;;   (consult-batch <id>)   -> BATCH: load a ready-made profile from
;;;                             tests/profiles/<id>.clp, then run.
;;;   (consult-file <path>)  -> BATCH: load any profile file by path, then run.
;;;
;;; DESIGN: the module is built from deffunctions, not defrules, so it shares no
;;; rules with the scoring engine and cannot perturb the Rete agenda. Both modes
;;; just assert `attr` facts and call (run); the scoring rules are untouched
;;; (spec section 6: "keep the consultation module separate from the engine").
;;; Validated re-prompting is naturally a loop, which deffunctions express
;;; cleanly (a defrule fires once and cannot easily re-ask).
;;; ============================================================================

;;; The attribute groups, asked in this order (spec section 6).
(deffunction academic-attrs ()
   (create$ math physics chemistry biology arabic foreign-lang social-studies computing))
(deffunction interest-attrs ()
   (create$ realistic investigative artistic social enterprising conventional))
(deffunction skill-attrs ()
   (create$ analytical creativity communication technical leadership detail))

;;; Allowed value sets per scale.
(deffunction academic-values () (create$ weak average good excellent))
(deffunction rating-values   () (create$ low medium high))

;;; ----------------------------------------------------------------------------
;;; Ask for one attribute, validating against ?allowed. Re-prompts on any invalid
;;; entry. Accepts answers in any case (normalised to lower case). Typing 'quit'
;;; aborts; end-of-input (EOF) also aborts safely. Returns the asserted value, or
;;; the symbol quit if the user aborted.
;;; ----------------------------------------------------------------------------
(deffunction ask-attr (?student ?attr ?allowed)
   (while TRUE do
      (printout t "   " ?attr " (" (implode$ ?allowed) ") > ")
      (bind ?in (read))
      (if (eq ?in EOF) then
         (printout t crlf "   Input ended; consultation aborted." crlf)
         (return quit))
      (if (lexemep ?in) then (bind ?in (lowcase ?in)))
      (if (eq ?in quit) then
         (printout t "   Consultation cancelled." crlf)
         (return quit))
      (if (member$ ?in ?allowed) then
         (assert (attr (student ?student) (name ?attr) (value ?in)))
         (return ?in)
       else
         (printout t "   '" ?in "' is not allowed. Please type one of: "
                   (implode$ ?allowed) crlf))))

;;; Ask every attribute in a group. Returns quit if the user aborted.
(deffunction ask-group (?student ?attrs ?allowed ?title)
   (printout t crlf "--- " ?title " ---" crlf)
   (progn$ (?a ?attrs)
      (if (eq (ask-attr ?student ?a ?allowed) quit) then (return quit)))
   (return done))

;;; ----------------------------------------------------------------------------
;;; INTERACTIVE MODE entry point.
;;; ----------------------------------------------------------------------------
(deffunction consult ()
   (reset)
   (printout t crlf)
   (printout t "=======================================================" crlf)
   (printout t "   UNIVERSITY MAJOR ADVISOR - Interactive Consultation"  crlf)
   (printout t "=======================================================" crlf)
   (printout t "Rate yourself on each item, then press Enter." crlf)
   (printout t "  Academic subjects: weak | average | good | excellent" crlf)
   (printout t "  Interests & skills: low | medium | high" crlf)
   (printout t "  (Answers are case-insensitive. Type 'quit' to cancel.)" crlf)
   (if (eq (ask-group you (academic-attrs) (academic-values) "Academic performance") quit)
      then (return))
   (if (eq (ask-group you (interest-attrs) (rating-values) "Interests (RIASEC)") quit)
      then (return))
   (if (eq (ask-group you (skill-attrs) (rating-values) "Skills and aptitudes") quit)
      then (return))
   (printout t crlf "Thank you. Analysing your profile..." crlf)
   (run))

;;; ----------------------------------------------------------------------------
;;; BATCH MODE entry points.
;;; ----------------------------------------------------------------------------
(deffunction consult-batch (?pid)
   (bind ?file (str-cat "tests/profiles/" ?pid ".clp"))
   (printout t "Loading profile '" ?pid "' from " ?file " ..." crlf)
   (load* ?file)
   (reset)
   (run)
   (undeffacts (sym-cat "profile-" ?pid)))

(deffunction consult-file (?path)
   (printout t "Loading profile file " ?path " ..." crlf)
   (load* ?path)
   (reset)
   (run))
