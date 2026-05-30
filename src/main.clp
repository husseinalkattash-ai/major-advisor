;;; ============================================================================
;;; main.clp
;;; Entry point. Loads all modules in the correct dependency order.
;;;
;;; Run from the PROJECT ROOT (the directory that contains src/ and tests/):
;;;     clips -f2 src/main.clp
;;; or, inside a CLIPS prompt started in the project root:
;;;     (load "src/main.clp")
;;;
;;; Load order matters: templates first (deftemplates + rank scale), then the
;;; knowledge base (majors, requirements), then the engine (scoring, ranking),
;;; then the consultation front-end.
;;; ============================================================================

(load "src/templates.clp")
(load "src/majors.clp")
(load "src/requirements.clp")
(load "src/scoring.clp")
(load "src/ranking.clp")
(load "src/consultation.clp")
