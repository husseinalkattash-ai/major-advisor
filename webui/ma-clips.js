/* =========================================================================
   ma-clips.js — wires the design to the real CLIPS expert system.

   The design ships a client-side scoring heuristic (MA.score). This file adds
   MA.scoreAsync, which keeps the design's answer-derived justifications, careers
   and bilingual names, but replaces each major's match PERCENTAGE with the value
   computed by the pure-CLIPS engine (served at /api/recommend), then re-ranks.

   If the backend is unreachable, it transparently falls back to MA.score so the
   prototype still works offline.
   ========================================================================= */
(function () {
  // design major key -> CLIPS major id (src/majors.clp)
  const MAJOR_TO_CLIPS = {
    cs: "cs", se: "comp-eng", data: "math-sci",
    medicine: "medicine", pharmacy: "pharmacy",
    civil: "civil-eng", mech: "mech-eng", ee: "elec-eng", arch: "architecture",
    business: "management", accounting: "accounting", law: "law",
    design: "graphic-design", psych: "psychology",
  };

  async function scoreAsync(answers, lang) {
    // 1) design heuristic gives us justifications, gap, careers, names, fallback pct
    const ranked = window.MA.score(answers, lang);
    try {
      const res = await fetch("/api/recommend", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ answers }),
      });
      if (!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();          // { percents: { clipsId: pct } }
      const pcts = data.percents || {};
      // 2) override each major's pct with the CLIPS result
      ranked.forEach((entry) => {
        const cid = MAJOR_TO_CLIPS[entry.major.key];
        if (cid && pcts[cid] !== undefined) {
          entry.pct = pcts[cid];
          entry.engine = "clips";
        }
      });
      // 3) re-rank by the real percentage (tie-break on the heuristic ratio)
      ranked.sort((a, b) => b.pct - a.pct || b.ratio - a.ratio);
    } catch (err) {
      console.warn("CLIPS backend unavailable, using local heuristic:", err);
    }
    return ranked;
  }

  window.MA.scoreAsync = scoreAsync;
})();
