;;; ============================================================================
;;; requirements.clp
;;; `requirement` facts -- the core knowledge base. One deffacts block per
;;; major giving its ideal profile (attribute, required level, weight, reason).
;;; Transcribed from the decision table in docs/knowledge-acquisition.md.
;;;
;;; The file ends with `init-recommendations`, a deffacts that creates one
;;; recommendation per major with raw=0 and max = sum of that major's weights
;;; (spec section 4.1 initialization). max is created here, alongside the
;;; weights it is derived from, so the scoring engine (Task 3) only has to
;;; accumulate raw and reasons -- keeping knowledge (here) separate from
;;; logic (scoring rules).
;;; ============================================================================

;;; ===== Faculty of Engineering =====
;;; Computer Engineering (comp-eng) -- RIASEC IR; 7 requirements; max weight 14
(deffacts req-comp-eng
   (requirement (major comp-eng) (attribute math) (level excellent) (weight 3)
                (reason "Computer engineering rests on a very strong mathematics foundation, from calculus to discrete math and logic."))
   (requirement (major comp-eng) (attribute investigative) (level high) (weight 3)
                (reason "Your strong investigative drive matches the problem-solving heart of engineering."))
   (requirement (major comp-eng) (attribute computing) (level good) (weight 2)
                (reason "A solid computing background gives you a real head start in programming and digital systems."))
   (requirement (major comp-eng) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking is essential for designing and debugging complex systems."))
   (requirement (major comp-eng) (attribute technical) (level high) (weight 2)
                (reason "Hands-on technical aptitude helps you build, wire, and test real hardware and software."))
   (requirement (major comp-eng) (attribute physics) (level good) (weight 1)
                (reason "Physics underpins the electronics and circuits that computer engineering depends on."))
   (requirement (major comp-eng) (attribute realistic) (level medium) (weight 1)
                (reason "An interest in building tangible systems supports a hands-on engineering path."))
)

;;; Electrical Engineering (elec-eng) -- RIASEC IR; 6 requirements; max weight 13
(deffacts req-elec-eng
   (requirement (major elec-eng) (attribute math) (level excellent) (weight 3)
                (reason "Electrical engineering demands excellent mathematics for signals, fields, and control."))
   (requirement (major elec-eng) (attribute physics) (level excellent) (weight 3)
                (reason "A deep grasp of physics, especially electromagnetism, is the core of electrical engineering."))
   (requirement (major elec-eng) (attribute analytical) (level high) (weight 2)
                (reason "Analytical reasoning drives circuit analysis and system modelling."))
   (requirement (major elec-eng) (attribute technical) (level high) (weight 2)
                (reason "Strong technical aptitude is needed to design and test electrical hardware."))
   (requirement (major elec-eng) (attribute investigative) (level high) (weight 2)
                (reason "Your investigative interest fits diagnosing and optimising electrical systems."))
   (requirement (major elec-eng) (attribute realistic) (level high) (weight 1)
                (reason "A realistic, hands-on orientation suits working with physical equipment."))
)

;;; Civil Engineering (civil-eng) -- RIASEC RI; 7 requirements; max weight 15
(deffacts req-civil-eng
   (requirement (major civil-eng) (attribute math) (level excellent) (weight 3)
                (reason "Structural and hydraulic calculations require excellent mathematics."))
   (requirement (major civil-eng) (attribute physics) (level excellent) (weight 3)
                (reason "Civil engineering applies physics, especially mechanics, to structures that must stand safely."))
   (requirement (major civil-eng) (attribute realistic) (level high) (weight 3)
                (reason "A strong realistic, hands-on interest fits designing and overseeing physical construction."))
   (requirement (major civil-eng) (attribute technical) (level high) (weight 2)
                (reason "Technical aptitude supports surveying, materials, and structural detailing."))
   (requirement (major civil-eng) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking ensures structures are safe and efficient."))
   (requirement (major civil-eng) (attribute investigative) (level high) (weight 1)
                (reason "An investigative streak helps in site and materials problem-solving."))
   (requirement (major civil-eng) (attribute detail) (level high) (weight 1)
                (reason "Attention to detail is critical where small errors can risk safety."))
)

;;; Mechanical Engineering (mech-eng) -- RIASEC RI; 7 requirements; max weight 16
(deffacts req-mech-eng
   (requirement (major mech-eng) (attribute math) (level excellent) (weight 3)
                (reason "Mechanical engineering relies on excellent mathematics for dynamics and thermodynamics."))
   (requirement (major mech-eng) (attribute physics) (level excellent) (weight 3)
                (reason "Physics, especially mechanics and energy, is the foundation of mechanical engineering."))
   (requirement (major mech-eng) (attribute realistic) (level high) (weight 3)
                (reason "A strong hands-on, realistic interest fits designing and building machines."))
   (requirement (major mech-eng) (attribute technical) (level high) (weight 2)
                (reason "Technical skill is essential for prototyping and testing mechanical systems."))
   (requirement (major mech-eng) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking underlies modelling forces, motion, and heat."))
   (requirement (major mech-eng) (attribute investigative) (level high) (weight 2)
                (reason "An investigative drive supports diagnosing and improving mechanical designs."))
   (requirement (major mech-eng) (attribute creativity) (level medium) (weight 1)
                (reason "Design creativity helps in inventing better mechanisms."))
)

;;; ===== Faculty of Medicine & Health Sciences =====
;;; Medicine (medicine) -- RIASEC IS; 7 requirements; max weight 16
(deffacts req-medicine
   (requirement (major medicine) (attribute biology) (level excellent) (weight 3)
                (reason "Medicine is grounded in an excellent command of biology and the human body."))
   (requirement (major medicine) (attribute chemistry) (level excellent) (weight 3)
                (reason "Biochemistry and pharmacology make excellent chemistry essential."))
   (requirement (major medicine) (attribute investigative) (level high) (weight 3)
                (reason "Diagnosis is detective work; a high investigative drive is vital."))
   (requirement (major medicine) (attribute social) (level high) (weight 2)
                (reason "Caring for patients requires genuine, high social motivation."))
   (requirement (major medicine) (attribute analytical) (level high) (weight 2)
                (reason "Clinical reasoning depends on strong analytical thinking."))
   (requirement (major medicine) (attribute detail) (level high) (weight 2)
                (reason "Meticulous attention to detail protects patient safety."))
   (requirement (major medicine) (attribute communication) (level high) (weight 1)
                (reason "Clear communication with patients and teams is part of good care."))
)

;;; Pharmacy (pharmacy) -- RIASEC IC; 6 requirements; max weight 13
(deffacts req-pharmacy
   (requirement (major pharmacy) (attribute chemistry) (level excellent) (weight 3)
                (reason "Pharmacy centres on an excellent understanding of chemistry and drug action."))
   (requirement (major pharmacy) (attribute detail) (level high) (weight 3)
                (reason "Precise attention to detail is essential when dosing and dispensing medicines."))
   (requirement (major pharmacy) (attribute biology) (level good) (weight 2)
                (reason "A good biology base is needed to understand how drugs affect the body."))
   (requirement (major pharmacy) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking supports formulation and interaction checking."))
   (requirement (major pharmacy) (attribute conventional) (level high) (weight 2)
                (reason "A methodical, procedure-following disposition suits regulated pharmacy practice."))
   (requirement (major pharmacy) (attribute investigative) (level high) (weight 1)
                (reason "An investigative interest helps in pharmaceutical research and review."))
)

;;; Nursing (nursing) -- RIASEC SC; 5 requirements; max weight 12
(deffacts req-nursing
   (requirement (major nursing) (attribute social) (level high) (weight 3)
                (reason "Nursing is a deeply caring profession demanding high social motivation."))
   (requirement (major nursing) (attribute communication) (level high) (weight 3)
                (reason "Constant communication with patients and families is central to nursing."))
   (requirement (major nursing) (attribute biology) (level good) (weight 3)
                (reason "A good grasp of biology underpins safe clinical care."))
   (requirement (major nursing) (attribute detail) (level high) (weight 2)
                (reason "Attention to detail prevents medication and care errors."))
   (requirement (major nursing) (attribute conventional) (level medium) (weight 1)
                (reason "Following clinical procedures reliably keeps patients safe."))
)

;;; Medical Laboratory Sciences (med-lab) -- RIASEC CI; 7 requirements; max weight 15
(deffacts req-med-lab
   (requirement (major med-lab) (attribute chemistry) (level good) (weight 3)
                (reason "Laboratory analysis relies on a good command of chemistry."))
   (requirement (major med-lab) (attribute biology) (level good) (weight 3)
                (reason "Understanding biology is essential for interpreting clinical samples."))
   (requirement (major med-lab) (attribute detail) (level high) (weight 3)
                (reason "Exact, detail-focused work is the essence of laboratory accuracy."))
   (requirement (major med-lab) (attribute technical) (level high) (weight 2)
                (reason "Technical aptitude is needed to operate laboratory instruments."))
   (requirement (major med-lab) (attribute conventional) (level high) (weight 2)
                (reason "A procedure-driven, conventional style fits standardised lab protocols."))
   (requirement (major med-lab) (attribute analytical) (level high) (weight 1)
                (reason "Analytical thinking helps interpret and flag abnormal results."))
   (requirement (major med-lab) (attribute investigative) (level medium) (weight 1)
                (reason "A measured investigative interest supports diagnostic testing."))
)

;;; ===== Faculty of Science =====
;;; Computer Science (cs) -- RIASEC IR; 5 requirements; max weight 13
(deffacts req-cs
   (requirement (major cs) (attribute math) (level excellent) (weight 3)
                (reason "Computer science is founded on excellent mathematics and formal reasoning."))
   (requirement (major cs) (attribute computing) (level excellent) (weight 3)
                (reason "A strong computing background is the natural launchpad for computer science."))
   (requirement (major cs) (attribute investigative) (level high) (weight 3)
                (reason "High investigative interest fits exploring algorithms and computation."))
   (requirement (major cs) (attribute analytical) (level high) (weight 3)
                (reason "Analytical thinking is the core skill of algorithmic problem-solving."))
   (requirement (major cs) (attribute detail) (level high) (weight 1)
                (reason "Attention to detail matters when a single character can break a program."))
)

;;; Mathematics (math-sci) -- RIASEC IC; 5 requirements; max weight 11
(deffacts req-math-sci
   (requirement (major math-sci) (attribute math) (level excellent) (weight 3)
                (reason "A mathematics major obviously demands excellent mathematics."))
   (requirement (major math-sci) (attribute investigative) (level high) (weight 3)
                (reason "Abstract, investigative curiosity drives mathematical discovery."))
   (requirement (major math-sci) (attribute analytical) (level high) (weight 3)
                (reason "Rigorous analytical reasoning is the heart of mathematics."))
   (requirement (major math-sci) (attribute physics) (level good) (weight 1)
                (reason "Physics offers a natural field to apply mathematical tools."))
   (requirement (major math-sci) (attribute detail) (level high) (weight 1)
                (reason "Careful, detailed proof-writing is essential in mathematics."))
)

;;; Physics (physics-sci) -- RIASEC IR; 4 requirements; max weight 11
(deffacts req-physics-sci
   (requirement (major physics-sci) (attribute physics) (level excellent) (weight 3)
                (reason "A physics major requires an excellent command of physics."))
   (requirement (major physics-sci) (attribute math) (level excellent) (weight 3)
                (reason "Advanced mathematics is the language of physics."))
   (requirement (major physics-sci) (attribute investigative) (level high) (weight 3)
                (reason "Deep investigative curiosity about how nature works defines a physicist."))
   (requirement (major physics-sci) (attribute analytical) (level high) (weight 2)
                (reason "Analytical reasoning links theory to experiment."))
)

;;; Chemistry (chem-sci) -- RIASEC IC; 6 requirements; max weight 13
(deffacts req-chem-sci
   (requirement (major chem-sci) (attribute chemistry) (level excellent) (weight 3)
                (reason "A chemistry major naturally requires excellent chemistry."))
   (requirement (major chem-sci) (attribute investigative) (level high) (weight 3)
                (reason "Investigative curiosity drives chemical experimentation and discovery."))
   (requirement (major chem-sci) (attribute math) (level good) (weight 2)
                (reason "A good mathematics base supports physical and analytical chemistry."))
   (requirement (major chem-sci) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking is central to interpreting chemical data."))
   (requirement (major chem-sci) (attribute detail) (level high) (weight 2)
                (reason "Careful, detailed technique keeps laboratory chemistry accurate and safe."))
   (requirement (major chem-sci) (attribute biology) (level good) (weight 1)
                (reason "A good biology background helps in biochemistry and life-science links."))
)

;;; Biology (bio-sci) -- RIASEC IS; 5 requirements; max weight 11
(deffacts req-bio-sci
   (requirement (major bio-sci) (attribute biology) (level excellent) (weight 3)
                (reason "A biology major requires an excellent command of the life sciences."))
   (requirement (major bio-sci) (attribute investigative) (level high) (weight 3)
                (reason "Investigative curiosity about living systems drives biological research."))
   (requirement (major bio-sci) (attribute chemistry) (level good) (weight 2)
                (reason "A good chemistry base is needed for biochemistry and molecular biology."))
   (requirement (major bio-sci) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking supports interpreting biological experiments."))
   (requirement (major bio-sci) (attribute detail) (level high) (weight 1)
                (reason "Detailed observation is key in biology, from labs to fieldwork."))
)

;;; ===== Faculty of Business Administration =====
;;; Accounting (accounting) -- RIASEC CE; 5 requirements; max weight 12
(deffacts req-accounting
   (requirement (major accounting) (attribute conventional) (level high) (weight 3)
                (reason "Accounting rewards a highly organised, procedure-following disposition."))
   (requirement (major accounting) (attribute detail) (level high) (weight 3)
                (reason "Meticulous attention to detail is essential for accurate accounts."))
   (requirement (major accounting) (attribute math) (level good) (weight 3)
                (reason "A good command of mathematics underlies all financial computation."))
   (requirement (major accounting) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking helps interpret financial statements."))
   (requirement (major accounting) (attribute computing) (level average) (weight 1)
                (reason "Basic computing competence supports modern accounting software."))
)

;;; Management (management) -- RIASEC EC; 5 requirements; max weight 11
(deffacts req-management
   (requirement (major management) (attribute enterprising) (level high) (weight 3)
                (reason "Management is an enterprising role centred on driving organisations forward."))
   (requirement (major management) (attribute leadership) (level high) (weight 3)
                (reason "Leading and motivating people is the core of management."))
   (requirement (major management) (attribute communication) (level high) (weight 2)
                (reason "Clear communication is vital for coordinating teams."))
   (requirement (major management) (attribute social) (level high) (weight 2)
                (reason "Working effectively with people requires a strong social orientation."))
   (requirement (major management) (attribute conventional) (level medium) (weight 1)
                (reason "Some appetite for structure and process helps run operations."))
)

;;; Marketing (marketing) -- RIASEC EA; 5 requirements; max weight 12
(deffacts req-marketing
   (requirement (major marketing) (attribute enterprising) (level high) (weight 3)
                (reason "Marketing is an enterprising field about persuading and creating demand."))
   (requirement (major marketing) (attribute communication) (level high) (weight 3)
                (reason "Persuasive communication is the everyday work of marketing."))
   (requirement (major marketing) (attribute creativity) (level high) (weight 3)
                (reason "Creative ideas make campaigns stand out."))
   (requirement (major marketing) (attribute social) (level high) (weight 2)
                (reason "Understanding people and audiences requires social insight."))
   (requirement (major marketing) (attribute artistic) (level medium) (weight 1)
                (reason "An artistic sensibility helps in design and messaging."))
)

;;; Economics (economics) -- RIASEC IE; 6 requirements; max weight 12
(deffacts req-economics
   (requirement (major economics) (attribute math) (level good) (weight 3)
                (reason "Economics increasingly relies on a good command of mathematics."))
   (requirement (major economics) (attribute analytical) (level high) (weight 3)
                (reason "Analytical reasoning is central to economic modelling."))
   (requirement (major economics) (attribute investigative) (level high) (weight 2)
                (reason "Investigative curiosity drives understanding of markets and behaviour."))
   (requirement (major economics) (attribute social-studies) (level good) (weight 2)
                (reason "A good social-studies grounding frames economic and policy context."))
   (requirement (major economics) (attribute enterprising) (level medium) (weight 1)
                (reason "An enterprising outlook helps connect economics to real markets."))
   (requirement (major economics) (attribute communication) (level high) (weight 1)
                (reason "Communicating economic findings clearly adds real value."))
)

;;; Management Information Systems (mis) -- RIASEC CE; 6 requirements; max weight 12
(deffacts req-mis
   (requirement (major mis) (attribute computing) (level good) (weight 3)
                (reason "MIS sits at the meeting point of business and a good computing skill set."))
   (requirement (major mis) (attribute conventional) (level high) (weight 2)
                (reason "Organised, procedure-aware thinking suits managing information systems."))
   (requirement (major mis) (attribute math) (level good) (weight 2)
                (reason "A good mathematics base supports data and systems analysis."))
   (requirement (major mis) (attribute analytical) (level high) (weight 2)
                (reason "Analytical thinking bridges technical systems and business needs."))
   (requirement (major mis) (attribute enterprising) (level medium) (weight 2)
                (reason "A business-minded, enterprising streak helps align IT with strategy."))
   (requirement (major mis) (attribute communication) (level medium) (weight 1)
                (reason "Communicating between technical and business teams is key in MIS."))
)

;;; ===== Faculty of Arts & Humanities =====
;;; Arabic Language (arabic-lang) -- RIASEC AS; 5 requirements; max weight 9
(deffacts req-arabic-lang
   (requirement (major arabic-lang) (attribute arabic) (level excellent) (weight 3)
                (reason "An Arabic-language major naturally requires excellent Arabic."))
   (requirement (major arabic-lang) (attribute communication) (level high) (weight 2)
                (reason "Strong communication skills bring language study to life."))
   (requirement (major arabic-lang) (attribute artistic) (level high) (weight 2)
                (reason "An artistic, expressive sensibility suits literature and rhetoric."))
   (requirement (major arabic-lang) (attribute creativity) (level high) (weight 1)
                (reason "Creativity enriches writing and literary interpretation."))
   (requirement (major arabic-lang) (attribute social-studies) (level good) (weight 1)
                (reason "A good social-studies background frames literary and cultural context."))
)

;;; English Language (english-lang) -- RIASEC AS; 5 requirements; max weight 9
(deffacts req-english-lang
   (requirement (major english-lang) (attribute foreign-lang) (level excellent) (weight 3)
                (reason "An English-language major requires excellent command of the foreign language."))
   (requirement (major english-lang) (attribute communication) (level high) (weight 3)
                (reason "Communication is the core competency of language study."))
   (requirement (major english-lang) (attribute artistic) (level medium) (weight 1)
                (reason "An artistic sensibility deepens engagement with literature."))
   (requirement (major english-lang) (attribute social) (level medium) (weight 1)
                (reason "A sociable orientation suits language use and teaching."))
   (requirement (major english-lang) (attribute social-studies) (level average) (weight 1)
                (reason "Some social-studies grounding supports cultural and historical context."))
)

;;; History (history) -- RIASEC IA; 4 requirements; max weight 7
(deffacts req-history
   (requirement (major history) (attribute social-studies) (level excellent) (weight 3)
                (reason "History sits at the centre of excellent social-studies knowledge."))
   (requirement (major history) (attribute investigative) (level high) (weight 2)
                (reason "Investigative curiosity drives historical research and interpretation."))
   (requirement (major history) (attribute communication) (level medium) (weight 1)
                (reason "Communicating arguments clearly is part of historical writing."))
   (requirement (major history) (attribute arabic) (level good) (weight 1)
                (reason "A good command of Arabic aids reading and writing historical texts."))
)

;;; Psychology (psychology) -- RIASEC IS; 5 requirements; max weight 10
(deffacts req-psychology
   (requirement (major psychology) (attribute social) (level high) (weight 3)
                (reason "Psychology is a people-centred field needing high social interest."))
   (requirement (major psychology) (attribute investigative) (level high) (weight 2)
                (reason "Investigative curiosity about the mind drives psychological research."))
   (requirement (major psychology) (attribute biology) (level good) (weight 2)
                (reason "A good biology base supports understanding the brain and behaviour."))
   (requirement (major psychology) (attribute communication) (level high) (weight 2)
                (reason "Communication skills are vital for interviewing and counselling."))
   (requirement (major psychology) (attribute analytical) (level high) (weight 1)
                (reason "Analytical thinking helps interpret behavioural data."))
)

;;; Sociology (sociology) -- RIASEC SE; 5 requirements; max weight 10
(deffacts req-sociology
   (requirement (major sociology) (attribute social) (level high) (weight 3)
                (reason "Sociology studies people in groups and needs a strong social orientation."))
   (requirement (major sociology) (attribute social-studies) (level good) (weight 3)
                (reason "A good social-studies foundation grounds sociological analysis."))
   (requirement (major sociology) (attribute communication) (level high) (weight 2)
                (reason "Communicating social findings clearly is central to the field."))
   (requirement (major sociology) (attribute investigative) (level medium) (weight 1)
                (reason "An investigative interest supports social research."))
   (requirement (major sociology) (attribute enterprising) (level medium) (weight 1)
                (reason "Some enterprising drive helps in applied, community-facing work."))
)

;;; ===== Faculty of Law =====
;;; Law (law) -- RIASEC ES; 7 requirements; max weight 14
(deffacts req-law
   (requirement (major law) (attribute social-studies) (level excellent) (weight 3)
                (reason "Law builds on excellent knowledge of society, civics, and institutions."))
   (requirement (major law) (attribute enterprising) (level high) (weight 3)
                (reason "Advocacy and negotiation make law a strongly enterprising field."))
   (requirement (major law) (attribute communication) (level high) (weight 3)
                (reason "Persuasive, precise communication is the lawyer's main tool."))
   (requirement (major law) (attribute leadership) (level high) (weight 2)
                (reason "Leadership and confidence support courtroom and advisory roles."))
   (requirement (major law) (attribute detail) (level high) (weight 1)
                (reason "Careful attention to detail matters when wording carries legal weight."))
   (requirement (major law) (attribute analytical) (level high) (weight 1)
                (reason "Analytical reasoning underlies legal argument."))
   (requirement (major law) (attribute arabic) (level good) (weight 1)
                (reason "A good command of Arabic supports drafting and pleading."))
)

;;; ===== Faculty of Education =====
;;; Education (education) -- RIASEC SC; 5 requirements; max weight 10
(deffacts req-education
   (requirement (major education) (attribute social) (level high) (weight 3)
                (reason "Teaching is a caring, people-centred profession needing high social interest."))
   (requirement (major education) (attribute communication) (level high) (weight 3)
                (reason "Clear communication is the essence of effective teaching."))
   (requirement (major education) (attribute social-studies) (level good) (weight 2)
                (reason "A good general-knowledge and social-studies base supports teaching breadth."))
   (requirement (major education) (attribute leadership) (level medium) (weight 1)
                (reason "Classroom leadership helps guide and motivate learners."))
   (requirement (major education) (attribute conventional) (level medium) (weight 1)
                (reason "Following curricula and structure keeps teaching organised."))
)

;;; ===== Faculty of Mass Communication =====
;;; Media (media) -- RIASEC AE; 5 requirements; max weight 10
(deffacts req-media
   (requirement (major media) (attribute communication) (level high) (weight 3)
                (reason "Media work is built on outstanding communication."))
   (requirement (major media) (attribute artistic) (level high) (weight 2)
                (reason "An artistic eye shapes compelling stories and visuals."))
   (requirement (major media) (attribute enterprising) (level high) (weight 2)
                (reason "An enterprising drive suits the fast, competitive media world."))
   (requirement (major media) (attribute creativity) (level high) (weight 2)
                (reason "Creativity powers original content and storytelling."))
   (requirement (major media) (attribute social) (level medium) (weight 1)
                (reason "A sociable orientation helps in interviewing and audience work."))
)

;;; ===== Faculty of Architecture =====
;;; Architecture (architecture) -- RIASEC AR; 7 requirements; max weight 13
(deffacts req-architecture
   (requirement (major architecture) (attribute artistic) (level high) (weight 3)
                (reason "Architecture fuses art and engineering; a strong artistic sense is essential."))
   (requirement (major architecture) (attribute creativity) (level high) (weight 3)
                (reason "Creative design vision is at the core of architecture."))
   (requirement (major architecture) (attribute math) (level good) (weight 2)
                (reason "A good command of mathematics supports structural and spatial calculation."))
   (requirement (major architecture) (attribute technical) (level high) (weight 2)
                (reason "Technical aptitude turns design ideas into buildable plans."))
   (requirement (major architecture) (attribute realistic) (level medium) (weight 1)
                (reason "A hands-on, realistic interest connects design to real construction."))
   (requirement (major architecture) (attribute analytical) (level high) (weight 1)
                (reason "Analytical thinking balances aesthetics with function and cost."))
   (requirement (major architecture) (attribute detail) (level high) (weight 1)
                (reason "Attention to detail ensures drawings translate accurately to structures."))
)

;;; ===== Faculty of Fine Arts & Design =====
;;; Graphic Design (graphic-design) -- RIASEC AR; 6 requirements; max weight 11
(deffacts req-graphic-design
   (requirement (major graphic-design) (attribute artistic) (level high) (weight 3)
                (reason "Graphic design is fundamentally an artistic, visual discipline."))
   (requirement (major graphic-design) (attribute creativity) (level high) (weight 3)
                (reason "Original creative ideas define strong design work."))
   (requirement (major graphic-design) (attribute technical) (level high) (weight 2)
                (reason "Technical skill with design tools turns ideas into finished work."))
   (requirement (major graphic-design) (attribute computing) (level good) (weight 1)
                (reason "A good computing base supports digital design software."))
   (requirement (major graphic-design) (attribute social) (level medium) (weight 1)
                (reason "Understanding audiences helps a design communicate effectively."))
   (requirement (major graphic-design) (attribute detail) (level high) (weight 1)
                (reason "Attention to detail gives designs polish and precision."))
)

;;; ----------------------------------------------------------------------------
;;; Recommendation initialization (spec 4.1): one per major, max = sum weights.
;;; ----------------------------------------------------------------------------
(deffacts init-recommendations
   (recommendation (major comp-eng) (raw 0) (max 14))
   (recommendation (major elec-eng) (raw 0) (max 13))
   (recommendation (major civil-eng) (raw 0) (max 15))
   (recommendation (major mech-eng) (raw 0) (max 16))
   (recommendation (major medicine) (raw 0) (max 16))
   (recommendation (major pharmacy) (raw 0) (max 13))
   (recommendation (major nursing) (raw 0) (max 12))
   (recommendation (major med-lab) (raw 0) (max 15))
   (recommendation (major cs) (raw 0) (max 13))
   (recommendation (major math-sci) (raw 0) (max 11))
   (recommendation (major physics-sci) (raw 0) (max 11))
   (recommendation (major chem-sci) (raw 0) (max 13))
   (recommendation (major bio-sci) (raw 0) (max 11))
   (recommendation (major accounting) (raw 0) (max 12))
   (recommendation (major management) (raw 0) (max 11))
   (recommendation (major marketing) (raw 0) (max 12))
   (recommendation (major economics) (raw 0) (max 12))
   (recommendation (major mis) (raw 0) (max 12))
   (recommendation (major arabic-lang) (raw 0) (max 9))
   (recommendation (major english-lang) (raw 0) (max 9))
   (recommendation (major history) (raw 0) (max 7))
   (recommendation (major psychology) (raw 0) (max 10))
   (recommendation (major sociology) (raw 0) (max 10))
   (recommendation (major law) (raw 0) (max 14))
   (recommendation (major education) (raw 0) (max 10))
   (recommendation (major media) (raw 0) (max 10))
   (recommendation (major architecture) (raw 0) (max 13))
   (recommendation (major graphic-design) (raw 0) (max 11))
)
