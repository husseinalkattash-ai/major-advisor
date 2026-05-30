;;; ============================================================================
;;; majors.clp
;;; `major` facts for every major in the knowledge base (spec section 8),
;;; one deffacts block per faculty.
;;; ============================================================================

;;; --- Faculty of Engineering ---
(deffacts majors-engineering
   (major (id comp-eng) (name "Computer Engineering") (faculty "Faculty of Engineering"))
   (major (id elec-eng) (name "Electrical Engineering") (faculty "Faculty of Engineering"))
   (major (id civil-eng) (name "Civil Engineering") (faculty "Faculty of Engineering"))
   (major (id mech-eng) (name "Mechanical Engineering") (faculty "Faculty of Engineering"))
)

;;; --- Faculty of Medicine & Health Sciences ---
(deffacts majors-medicine-health-sciences
   (major (id medicine) (name "Medicine") (faculty "Faculty of Medicine & Health Sciences"))
   (major (id pharmacy) (name "Pharmacy") (faculty "Faculty of Medicine & Health Sciences"))
   (major (id nursing) (name "Nursing") (faculty "Faculty of Medicine & Health Sciences"))
   (major (id med-lab) (name "Medical Laboratory Sciences") (faculty "Faculty of Medicine & Health Sciences"))
)

;;; --- Faculty of Science ---
(deffacts majors-science
   (major (id cs) (name "Computer Science") (faculty "Faculty of Science"))
   (major (id math-sci) (name "Mathematics") (faculty "Faculty of Science"))
   (major (id physics-sci) (name "Physics") (faculty "Faculty of Science"))
   (major (id chem-sci) (name "Chemistry") (faculty "Faculty of Science"))
   (major (id bio-sci) (name "Biology") (faculty "Faculty of Science"))
)

;;; --- Faculty of Business Administration ---
(deffacts majors-business-administration
   (major (id accounting) (name "Accounting") (faculty "Faculty of Business Administration"))
   (major (id management) (name "Management") (faculty "Faculty of Business Administration"))
   (major (id marketing) (name "Marketing") (faculty "Faculty of Business Administration"))
   (major (id economics) (name "Economics") (faculty "Faculty of Business Administration"))
   (major (id mis) (name "Management Information Systems") (faculty "Faculty of Business Administration"))
)

;;; --- Faculty of Arts & Humanities ---
(deffacts majors-arts-humanities
   (major (id arabic-lang) (name "Arabic Language") (faculty "Faculty of Arts & Humanities"))
   (major (id english-lang) (name "English Language") (faculty "Faculty of Arts & Humanities"))
   (major (id history) (name "History") (faculty "Faculty of Arts & Humanities"))
   (major (id psychology) (name "Psychology") (faculty "Faculty of Arts & Humanities"))
   (major (id sociology) (name "Sociology") (faculty "Faculty of Arts & Humanities"))
)

;;; --- Faculty of Law ---
(deffacts majors-law
   (major (id law) (name "Law") (faculty "Faculty of Law"))
)

;;; --- Faculty of Education ---
(deffacts majors-education
   (major (id education) (name "Education") (faculty "Faculty of Education"))
)

;;; --- Faculty of Mass Communication ---
(deffacts majors-mass-communication
   (major (id media) (name "Media") (faculty "Faculty of Mass Communication"))
)

;;; --- Faculty of Architecture ---
(deffacts majors-architecture
   (major (id architecture) (name "Architecture") (faculty "Faculty of Architecture"))
)

;;; --- Faculty of Fine Arts & Design ---
(deffacts majors-fine-arts-design
   (major (id graphic-design) (name "Graphic Design") (faculty "Faculty of Fine Arts & Design"))
)

