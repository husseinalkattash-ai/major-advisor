/* =========================================================================
   Major Advisor — data model, bilingual copy, sample majors + scoring
   Exposes window.MA = { i18n, sections, attributes, scales, majors, score, t }
   Attribute keys map 1:1 to Brief §8 so output reconciles with the engine.
   ========================================================================= */
(function () {
  // ---- value scales -------------------------------------------------------
  // Academic: 4-point ordinal. Interests + Skills: 3-point ordinal.
  const scale4 = { steps: 4, labels: { ar: ["ضعيف", "متوسط", "جيد", "ممتاز"], en: ["Weak", "Average", "Good", "Excellent"] } };
  const scale3 = { steps: 3, labels: { ar: ["منخفض", "متوسط", "مرتفع"], en: ["Low", "Medium", "High"] } };

  // ---- attributes (Brief §8) ----------------------------------------------
  // key, label(ar/en), help(ar/en) where useful, section
  const academic = [
    { key: "math",      ar: "الرياضيات",        en: "Mathematics" },
    { key: "physics",   ar: "الفيزياء",         en: "Physics" },
    { key: "chem",      ar: "الكيمياء",         en: "Chemistry" },
    { key: "bio",       ar: "الأحياء",          en: "Biology" },
    { key: "arabic",    ar: "اللغة العربية",    en: "Arabic" },
    { key: "foreign",   ar: "اللغة الأجنبية",   en: "Foreign language" },
    { key: "social",    ar: "الدراسات الاجتماعية", en: "Social studies" },
    { key: "computing", ar: "الحاسوب",          en: "Computing" },
  ];

  const interests = [
    { key: "realistic",     ar: "العملي (الواقعي)", en: "Realistic",     hue: "realistic",
      helpAr: "تحب العمل اليدوي والأدوات والآلات والأنشطة الملموسة في الهواء الطلق.",
      helpEn: "You enjoy hands-on work — tools, machines, building, the outdoors." },
    { key: "investigative", ar: "البحثي",           en: "Investigative", hue: "investigative",
      helpAr: "تستمتع بالتحليل والبحث وفهم كيف تعمل الأشياء وحل الألغاز.",
      helpEn: "You like analysing, researching, and figuring out how things work." },
    { key: "artistic",      ar: "الفني",            en: "Artistic",      hue: "artistic",
      helpAr: "تنجذب إلى التعبير والإبداع والتصميم والأفكار غير التقليدية.",
      helpEn: "You're drawn to self-expression, creativity, design and original ideas." },
    { key: "social_i",      ar: "الاجتماعي",        en: "Social",        hue: "social",
      helpAr: "تجد معنى في مساعدة الناس وتعليمهم والعمل ضمن فريق.",
      helpEn: "You find meaning in helping, teaching, and working with people." },
    { key: "enterprising",  ar: "المبادر (القيادي)", en: "Enterprising",  hue: "enterprising",
      helpAr: "تحب الإقناع والقيادة وإدارة المشاريع واتخاذ المبادرة.",
      helpEn: "You like persuading, leading, running projects and taking initiative." },
    { key: "conventional",  ar: "التنظيمي",         en: "Conventional",  hue: "conventional",
      helpAr: "تفضّل النظام والدقة والعمل مع البيانات والإجراءات الواضحة.",
      helpEn: "You prefer order, precision, and working with data and clear procedures." },
  ];

  const skills = [
    { key: "analytical",    ar: "التحليل",          en: "Analytical" },
    { key: "creativity",    ar: "الإبداع",          en: "Creativity" },
    { key: "communication", ar: "التواصل",          en: "Communication" },
    { key: "technical",     ar: "المهارة التقنية",  en: "Technical" },
    { key: "leadership",    ar: "القيادة",          en: "Leadership" },
    { key: "detail",        ar: "الدقة والانتباه للتفاصيل", en: "Attention to detail" },
  ];

  const sections = [
    { id: "A", scaleKey: "scale4", scale: scale4, items: academic,
      ar: "الأداء الأكاديمي", en: "Academic performance",
      subAr: "قيّم مستواك في كل مادة. لا توجد إجابات صحيحة أو خاطئة.",
      subEn: "Rate your level in each subject. There are no right or wrong answers." },
    { id: "B", scaleKey: "scale3", scale: scale3, items: interests,
      ar: "الاهتمامات", en: "Interests",
      subAr: "إلى أي مدى ينطبق عليك كل نوع من الاهتمامات؟",
      subEn: "How much does each type of interest sound like you?" },
    { id: "C", scaleKey: "scale3", scale: scale3, items: skills,
      ar: "المهارات والقدرات", en: "Skills & aptitudes",
      subAr: "قيّم مهاراتك بصدق — هذا يساعدنا على فهمك أكثر.",
      subEn: "Rate your skills honestly — it helps us understand you better." },
  ];

  // ---- faculties (accent palette, Brief §9) -------------------------------
  const faculties = {
    computing:   { ar: "كلية الحاسبات وتقنية المعلومات", en: "Computing & IT",    hue: "investigative" },
    engineering: { ar: "كلية الهندسة",                   en: "Engineering",       hue: "realistic" },
    medicine:    { ar: "كلية الطب والعلوم الصحية",       en: "Medicine & Health", hue: "conventional" },
    science:     { ar: "كلية العلوم",                    en: "Sciences",          hue: "investigative" },
    business:    { ar: "كلية إدارة الأعمال",             en: "Business",          hue: "enterprising" },
    law:         { ar: "كلية الحقوق",                    en: "Law",               hue: "enterprising" },
    arts:        { ar: "كلية الفنون والتصميم",           en: "Arts & Design",     hue: "artistic" },
    humanities:  { ar: "كلية الآداب والعلوم الإنسانية",  en: "Humanities",        hue: "social" },
  };

  // ---- majors with weighted attribute profiles ----------------------------
  // weights are 1–3 (importance to this major). Match = weighted avg of the
  // student's normalised answers over the weighted attributes.
  const majors = [
    { key: "cs", faculty: "computing", ar: "علوم الحاسب", en: "Computer Science",
      w: { math: 3, computing: 3, physics: 1, investigative: 3, conventional: 1, analytical: 3, technical: 3, detail: 2 },
      careersAr: ["مهندس برمجيات", "عالم بيانات", "مهندس ذكاء اصطناعي", "أخصائي أمن سيبراني"],
      careersEn: ["Software engineer", "Data scientist", "AI/ML engineer", "Cybersecurity analyst"],
      related: ["se", "ee", "data"] },
    { key: "se", faculty: "computing", ar: "هندسة البرمجيات", en: "Software Engineering",
      w: { math: 2, computing: 3, investigative: 2, conventional: 2, enterprising: 1, analytical: 3, technical: 3, detail: 3, communication: 2 },
      careersAr: ["مطوّر تطبيقات", "مهندس أنظمة", "قائد فريق تقني", "مهندس جودة"],
      careersEn: ["Application developer", "Systems engineer", "Tech lead", "QA engineer"],
      related: ["cs", "data"] },
    { key: "data", faculty: "computing", ar: "علم البيانات", en: "Data Science",
      w: { math: 3, computing: 2, investigative: 3, conventional: 2, analytical: 3, technical: 2, detail: 3 },
      careersAr: ["محلل بيانات", "مهندس تعلم آلي", "أخصائي إحصاء", "محلل أعمال"],
      careersEn: ["Data analyst", "ML engineer", "Statistician", "Business analyst"],
      related: ["cs", "math_major"] },
    { key: "medicine", faculty: "medicine", ar: "الطب البشري", en: "Medicine",
      w: { bio: 3, chem: 3, physics: 1, social_i: 2, investigative: 2, communication: 2, detail: 3, analytical: 2 },
      careersAr: ["طبيب", "جرّاح", "باحث طبي", "أخصائي صحة عامة"],
      careersEn: ["Physician", "Surgeon", "Medical researcher", "Public-health specialist"],
      related: ["pharmacy", "bio_major"] },
    { key: "pharmacy", faculty: "medicine", ar: "الصيدلة", en: "Pharmacy",
      w: { chem: 3, bio: 3, math: 1, investigative: 2, conventional: 2, detail: 3, analytical: 2 },
      careersAr: ["صيدلي", "باحث دوائي", "أخصائي رقابة دوائية", "صيدلي سريري"],
      careersEn: ["Pharmacist", "Drug researcher", "Regulatory specialist", "Clinical pharmacist"],
      related: ["medicine", "bio_major"] },
    { key: "civil", faculty: "engineering", ar: "الهندسة المدنية", en: "Civil Engineering",
      w: { math: 3, physics: 3, chem: 1, realistic: 3, conventional: 2, analytical: 2, technical: 2, detail: 2, leadership: 1 },
      careersAr: ["مهندس إنشائي", "مدير مشاريع", "مهندس بنية تحتية", "مهندس موقع"],
      careersEn: ["Structural engineer", "Project manager", "Infrastructure engineer", "Site engineer"],
      related: ["mech", "arch"] },
    { key: "mech", faculty: "engineering", ar: "الهندسة الميكانيكية", en: "Mechanical Engineering",
      w: { math: 3, physics: 3, realistic: 3, investigative: 1, analytical: 2, technical: 3, detail: 2 },
      careersAr: ["مهندس ميكانيكي", "مهندس تصميم", "مهندس صيانة", "مهندس طاقة"],
      careersEn: ["Mechanical engineer", "Design engineer", "Maintenance engineer", "Energy engineer"],
      related: ["civil", "ee"] },
    { key: "ee", faculty: "engineering", ar: "الهندسة الكهربائية", en: "Electrical Engineering",
      w: { math: 3, physics: 3, computing: 2, realistic: 2, investigative: 2, analytical: 3, technical: 3 },
      careersAr: ["مهندس كهرباء", "مهندس إلكترونيات", "مهندس اتصالات", "مهندس أنظمة تحكم"],
      careersEn: ["Electrical engineer", "Electronics engineer", "Telecom engineer", "Control-systems engineer"],
      related: ["mech", "cs"] },
    { key: "arch", faculty: "engineering", ar: "الهندسة المعمارية", en: "Architecture",
      w: { math: 2, physics: 1, artistic: 3, realistic: 2, creativity: 3, technical: 2, detail: 2, communication: 1 },
      careersAr: ["مهندس معماري", "مصمم حضري", "مصمم داخلي", "مخطط مدن"],
      careersEn: ["Architect", "Urban designer", "Interior designer", "Urban planner"],
      related: ["civil", "design"] },
    { key: "business", faculty: "business", ar: "إدارة الأعمال", en: "Business Administration",
      w: { math: 1, social: 1, foreign: 1, enterprising: 3, social_i: 1, leadership: 3, communication: 3, analytical: 1 },
      careersAr: ["مدير أعمال", "ريادي أعمال", "مدير تسويق", "محلل أعمال"],
      careersEn: ["Business manager", "Entrepreneur", "Marketing manager", "Business analyst"],
      related: ["accounting", "law"] },
    { key: "accounting", faculty: "business", ar: "المحاسبة", en: "Accounting & Finance",
      w: { math: 2, conventional: 3, enterprising: 1, analytical: 2, detail: 3, communication: 1 },
      careersAr: ["محاسب قانوني", "مدقق مالي", "محلل مالي", "مدير مالي"],
      careersEn: ["Accountant", "Auditor", "Financial analyst", "Finance manager"],
      related: ["business"] },
    { key: "law", faculty: "law", ar: "القانون", en: "Law",
      w: { arabic: 3, social: 2, foreign: 1, enterprising: 2, social_i: 1, communication: 3, analytical: 2, detail: 2 },
      careersAr: ["محامٍ", "مستشار قانوني", "قاضٍ", "أخصائي امتثال"],
      careersEn: ["Lawyer", "Legal advisor", "Judge", "Compliance specialist"],
      related: ["business", "humanities_major"] },
    { key: "design", faculty: "arts", ar: "التصميم الجرافيكي", en: "Graphic Design",
      w: { artistic: 3, computing: 1, creativity: 3, technical: 2, communication: 2, detail: 2 },
      careersAr: ["مصمم جرافيك", "مصمم واجهات UX/UI", "مدير فني", "رسّام رقمي"],
      careersEn: ["Graphic designer", "UX/UI designer", "Art director", "Digital illustrator"],
      related: ["arch", "media"] },
    { key: "psych", faculty: "humanities", ar: "علم النفس", en: "Psychology",
      w: { bio: 1, social: 2, arabic: 1, social_i: 3, investigative: 2, communication: 3, analytical: 2 },
      careersAr: ["أخصائي نفسي", "مرشد تربوي", "باحث سلوكي", "أخصائي موارد بشرية"],
      careersEn: ["Psychologist", "Counsellor", "Behavioural researcher", "HR specialist"],
      related: ["medicine", "humanities_major"] },
  ];

  // lookup helpers
  const attrIndex = {};
  [["A", academic], ["B", interests], ["C", skills]].forEach(([sec, list]) =>
    list.forEach((a) => (attrIndex[a.key] = { ...a, section: sec, scale: sec === "A" ? scale4 : scale3 })));

  // ---- scoring -------------------------------------------------------------
  // answers: { key: index } where index is 0-based ordinal step (or undefined)
  // returns ranked array of { major, pct, justifications:[{kind, attr, valLabel, ...}], gap }
  function score(answers, lang) {
    const norm = (key) => {
      const v = answers[key];
      if (v === undefined) return null;
      const steps = attrIndex[key].scale.steps;
      return v / (steps - 1); // 0..1
    };

    const ranked = majors.map((m) => {
      let wsum = 0, acc = 0;
      const contribs = [];
      Object.entries(m.w).forEach(([key, weight]) => {
        const n = norm(key);
        const used = n === null ? 0.5 : n; // neutral if unanswered
        wsum += weight;
        acc += weight * used;
        if (n !== null) contribs.push({ key, weight, n, raw: answers[key] });
      });
      const ratio = wsum ? acc / wsum : 0;
      // map 0..1 → realistic 38..98 band so ties/lows read sensibly
      const pct = Math.round(38 + ratio * 60);
      return { major: m, pct, ratio, contribs };
    });

    ranked.sort((a, b) => b.pct - a.pct || b.ratio - a.ratio);

    // build justifications drawn from the student's own answers
    ranked.forEach((r) => {
      const strong = r.contribs
        .filter((c) => c.n >= 0.66 && c.weight >= 2)
        .sort((a, b) => b.weight * b.n - a.weight * a.n);
      const interestsStrong = strong.filter((c) => attrIndex[c.key].section === "B");
      const academicStrong = strong.filter((c) => attrIndex[c.key].section === "A");
      const skillStrong = strong.filter((c) => attrIndex[c.key].section === "C");

      const js = [];
      const mk = (c, kind) => {
        const a = attrIndex[c.key];
        const valLabel = a.scale.labels[lang][c.raw];
        return { kind, key: c.key, attrAr: a.ar, attrEn: a.en, section: a.section, valLabel, raw: c.raw };
      };
      // interleave: academic, interest, skill for a rounded explanation
      [academicStrong[0], interestsStrong[0], skillStrong[0], academicStrong[1], interestsStrong[1], skillStrong[1]]
        .filter(Boolean).forEach((c) => js.push(mk(c, "strength")));

      // a gap: high-weight attribute the student rated low (shown gently in detail)
      const gapC = r.contribs
        .filter((c) => c.n <= 0.34 && c.weight >= 3)
        .sort((a, b) => b.weight - a.weight)[0];
      const gap = gapC ? mk(gapC, "gap") : null;

      r.justifications = js;
      r.gap = gap;
    });

    return ranked;
  }

  // count answered
  function progressOf(answers) {
    const total = academic.length + interests.length + skills.length;
    const done = Object.values(answers).filter((v) => v !== undefined).length;
    return { done, total };
  }

  window.MA = {
    scale4, scale3, sections, faculties, majors, attrIndex,
    academic, interests, skills, score, progressOf,
  };
})();
