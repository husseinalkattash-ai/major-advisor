/* Major Advisor — screens. Exports to window. */
(function () {
  const { Icon, AttributeRow, Progress, SectionNav, ResultCard, MatchViz, Justification, justText } = window;
  const e = React.createElement;
  const { useState, useEffect } = React;

  /* ===== Welcome ========================================================= */
  function Welcome({ lang, onStart, c }) {
    const feats = [
      ["route", c.w_feat1_t, c.w_feat1_d],
      ["quote", c.w_feat2_t, c.w_feat2_d],
      ["compass", c.w_feat3_t, c.w_feat3_d],
    ];
    return e("div", { className: "welcome screen-anim" },
      e("div", { className: "w-left" },
        e("span", { className: "hero-badge" }, e(Icon, { name: "clock", size: 15 }), c.w_badge),
        e("h1", { className: "h1" }, c.w_title),
        e("p", { className: "lead" }, c.w_lead),
        e("div", { className: "feature-list" },
          feats.map(([ic, t, d]) =>
            e("div", { className: "feat", key: t },
              e("div", { className: "fi" }, e(Icon, { name: ic, size: 19 })),
              e("div", null,
                e("div", { className: "ft" }, t),
                e("div", { className: "fd" }, d)
              )
            )
          )
        )
      ),
      e("div", { className: "hero-art", role: "img", "aria-label": "" },
        e("div", { className: "glyphs" },
          e("div", null, e(Icon, { name: "grad", size: 26 })),
          e("div", null, e(Icon, { name: "compass", size: 26 })),
          e("div", null, e(Icon, { name: "bulb", size: 26 }))
        )
      )
    );
  }

  /* ===== Questionnaire (sections A / B / C) ============================== */
  function Questionnaire({ section, lang, answers, setAnswer, ratingStyle }) {
    const c = window.MA_COPY[lang];
    return e("div", { className: "q-canvas screen-anim", key: section.id },
      e(SectionNav, { current: section.id, lang }),
      e("div", { style: { marginBottom: 6 } },
        e("h2", { className: "q-prompt" }, lang === "ar" ? section.ar : section.en),
        e("p", { className: "q-help" }, lang === "ar" ? section.subAr : section.subEn)
      ),
      e("div", { style: { marginTop: 8 } },
        section.items.map((attr) => {
          const full = window.MA.attrIndex[attr.key];
          return e(AttributeRow, {
            key: attr.key, attr: full, lang,
            value: answers[attr.key],
            onChange: (v) => setAnswer(attr.key, v),
            ratingStyle,
          });
        })
      )
    );
  }

  /* ===== Review ========================================================== */
  function Review({ lang, answers, onEdit, c }) {
    const groups = window.MA.sections;
    const pips = (raw, steps) =>
      e("span", { className: "pips" },
        Array.from({ length: steps }).map((_, i) =>
          e("i", { key: i, className: raw !== undefined && i <= raw ? "on" : "" })
        )
      );
    return e("div", { className: "screen-anim" },
      e("div", { style: { marginBottom: 18 } },
        e("h2", { className: "h2" }, c.rev_title),
        e("p", { className: "lead", style: { fontSize: 14, marginTop: 6 } }, c.rev_lead)
      ),
      groups.map((g) =>
        e("div", { className: "review-group", key: g.id },
          e("div", { className: "rg-head" },
            e(Icon, { name: window.ICON_FOR[g.id], size: 19, className: "ic", style: { color: "var(--primary)" } }),
            e("h3", null, lang === "ar" ? g.ar : g.en),
            e("button", { className: "edit", onClick: () => onEdit(g.id) },
              e(Icon, { name: "edit", size: 13, style: { verticalAlign: -2, marginInlineEnd: 4 } }), c.rev_edit)
          ),
          g.items.map((attr) => {
            const raw = answers[attr.key];
            const labels = g.scale.labels[lang];
            return e("button", { className: "review-row", key: attr.key, onClick: () => onEdit(g.id) },
              e("span", { className: "rr-name" }, lang === "ar" ? attr.ar : attr.en),
              e("span", { className: "rr-val", style: raw === undefined ? { color: "var(--ink-mute)", fontWeight: 600 } : {} },
                raw === undefined ? c.rev_unanswered : labels[raw],
                pips(raw, g.scale.steps)
              )
            );
          })
        )
      )
    );
  }

  /* ===== Processing ====================================================== */
  function Processing({ lang, c, onDone }) {
    const [step, setStep] = useState(0);
    useEffect(() => {
      const t1 = setTimeout(() => setStep(1), 700);
      const t2 = setTimeout(() => setStep(2), 1500);
      const t3 = setTimeout(() => setStep(3), 2300);
      const t4 = setTimeout(() => onDone(), 3050);
      return () => [t1, t2, t3, t4].forEach(clearTimeout);
    }, []);
    const steps = [c.proc_s1, c.proc_s2, c.proc_s3];
    return e("div", { className: "processing fade-anim" },
      e("div", { className: "proc-orbit" },
        e("div", { className: "ringline" }),
        e("div", { className: "ringline two" }),
        e("div", { className: "core" }, e(Icon, { name: "spark", size: 26 }))
      ),
      e("div", null,
        e("h2", { className: "h2" }, c.proc_title),
        e("p", { className: "lead", style: { fontSize: 14, marginTop: 6 } }, c.proc_sub)
      ),
      e("div", { className: "proc-steps" },
        steps.map((s, i) =>
          e("div", { className: "proc-step" + (step > i ? " on" : ""), key: i },
            e("span", { className: "pcheck" }, e(Icon, { name: "check", size: 11 })),
            e("span", null, s)
          )
        )
      )
    );
  }

  /* ===== Results overview ================================================ */
  function Results({ lang, ranked, onOpen, isDesktop, viz }) {
    const c = window.MA_COPY[lang];
    const top5 = ranked.slice(0, 5);
    const list = e("div", { className: "results-list" },
      top5.map((entry, i) =>
        e(ResultCard, { key: entry.major.key, entry, rank: i, lang, isTop: i === 0, onOpen: () => onOpen(i), viz })
      )
    );
    const header = e("div", { style: { marginBottom: 18 } },
      e("span", { className: "eyebrow" }, c.res_eyebrow),
      e("h2", { className: "h1", style: { fontSize: 25 } }, c.res_title),
      e("p", { className: "lead", style: { fontSize: 14.5 } }, c.res_lead)
    );
    if (isDesktop) {
      return e("div", { className: "screen-anim" },
        header,
        e("div", { className: "results-grid" },
          list,
          e("div", { className: "card", style: { padding: 18, position: "sticky", top: 0 } },
            e("div", { style: { fontSize: 12, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".04em", color: "var(--ink-mute)", marginBottom: 12 } },
              lang === "ar" ? "ملخص ملفك" : "Your profile at a glance"),
            e(ProfileSummary, { lang })
          )
        )
      );
    }
    return e("div", { className: "screen-anim" }, header, list);
  }

  function ProfileSummary({ lang }) {
    // top interests + skills snapshot from current answers
    const A = window.__maAnswers || {};
    const pick = (list, sec) => list
      .map((a) => ({ a, v: A[a.key] }))
      .filter((x) => x.v !== undefined)
      .sort((x, y) => y.v - x.v).slice(0, 3);
    const interests = pick(window.MA.interests);
    const skills = pick(window.MA.skills);
    const row = (title, arr, scaleLabels) =>
      e("div", { style: { marginBottom: 14 } },
        e("div", { style: { fontSize: 12.5, fontWeight: 700, color: "var(--ink-soft)", marginBottom: 8 } }, title),
        e("div", { className: "tag-row" },
          arr.length ? arr.map(({ a, v }) =>
            e("span", { className: "just-chip", key: a.key },
              a.hue && e("span", { style: { width: 8, height: 8, borderRadius: 3, background: `var(--c-${a.hue})` } }),
              (lang === "ar" ? a.ar : a.en)
            )
          ) : e("span", { className: "muted", style: { fontSize: 13 } }, lang === "ar" ? "—" : "—")
        )
      );
    return e("div", null,
      row(lang === "ar" ? "أقوى اهتماماتك" : "Your strongest interests", interests),
      row(lang === "ar" ? "أبرز مهاراتك" : "Your top skills", skills)
    );
  }

  /* ===== Result detail =================================================== */
  function Detail({ lang, entry, next, onCompare, isDesktop, viz }) {
    const c = window.MA_COPY[lang];
    const m = entry.major;
    const fac = window.MA.faculties[m.faculty];
    const facHue = `var(--c-${fac.hue})`;
    const careers = lang === "ar" ? m.careersAr : m.careersEn;
    const relatedNames = (m.related || []).map((k) => window.MA.majors.find((x) => x.key === k)).filter(Boolean);

    const whyBlock = e("div", { className: "detail-section" },
      e("h3", null, c.det_why),
      e("p", { className: "lead", style: { fontSize: 13.5, marginTop: -4, marginBottom: 12 } }, c.det_whySub),
      entry.justifications.map((j, i) =>
        e("div", { className: "just-card", key: i },
          e("div", { className: "jc-ic" + (j.section === "B" ? " from" : "") },
            e(Icon, { name: j.section === "A" ? "grad" : j.section === "B" ? "compass" : "wrench", size: 16 })),
          e("div", { className: "jc-body" }, justText(j, lang))
        )
      ),
      entry.gap && e("div", { style: { marginTop: 14 } },
        e("h3", null, c.det_grow),
        e("div", { className: "just-card", style: { borderColor: "var(--primary-line)", background: "var(--primary-soft)" } },
          e("div", { className: "jc-ic", style: { background: "var(--warn)" } }, e(Icon, { name: "bulb", size: 16 })),
          e("div", { className: "jc-body" }, justText(entry.gap, lang))
        )
      )
    );

    const sideBlock = e("div", null,
      e("div", { className: "detail-section" },
        e("h3", null, c.det_careers),
        e("div", { className: "tag-row" },
          careers.map((ca) => e("span", { className: "tag", key: ca }, e(Icon, { name: "briefcase", size: 13, style: { verticalAlign: -2, marginInlineEnd: 6, color: "var(--ink-mute)" } }), ca)))
      ),
      next && e("div", { className: "detail-section" },
        e("h3", null, c.det_compare),
        e("button", { className: "compare-card", onClick: onCompare, style: { width: "100%", textAlign: "start", cursor: "pointer" } },
          e("div", { className: "cc-head" }, `${lang === "ar" ? m.ar : m.en} ${c.det_compareVs} ${lang === "ar" ? next.major.ar : next.major.en}`),
          e("div", { style: { display: "flex", alignItems: "center", gap: 14, justifyContent: "space-between" } },
            e("div", { style: { display: "flex", alignItems: "center", gap: 8 } },
              e(MatchViz, { pct: entry.pct, size: "md", color: facHue, viz }),
              e("span", { style: { fontSize: 13, fontWeight: 700 } }, lang === "ar" ? m.ar : m.en)
            ),
            e(Icon, { name: "arrow", size: 18, className: "arrow", style: { color: "var(--primary)" } }),
            e("div", { style: { display: "flex", alignItems: "center", gap: 8 } },
              e(MatchViz, { pct: next.pct, size: "md", color: `var(--c-${window.MA.faculties[next.major.faculty].hue})`, viz }),
              e("span", { style: { fontSize: 13, fontWeight: 700 } }, lang === "ar" ? next.major.ar : next.major.en)
            )
          )
        )
      ),
      relatedNames.length && e("div", { className: "detail-section" },
        e("h3", null, c.det_related),
        e("div", { className: "tag-row" },
          relatedNames.map((rm) => e("span", { className: "tag", key: rm.key }, lang === "ar" ? rm.ar : rm.en)))
      )
    );

    return e("div", { className: "screen-anim" },
      e("div", { className: "detail-hero" },
        e(MatchViz, { pct: entry.pct, size: "lg", color: facHue, viz }),
        e("div", { className: "dh-info" },
          e("h2", { className: "h2" }, lang === "ar" ? m.ar : m.en),
          e("div", { className: "r-fac", style: { marginTop: 5 } },
            e("span", { className: "fdot", style: { background: facHue } }),
            lang === "ar" ? fac.ar : fac.en),
          e("div", { style: { fontSize: 12.5, color: "var(--ink-mute)", marginTop: 8, fontWeight: 600 } }, c.det_match + " · " + entry.pct + "%")
        )
      ),
      isDesktop
        ? e("div", { className: "detail-2col" }, whyBlock, sideBlock)
        : e("div", null, whyBlock, sideBlock)
    );
  }

  /* ===== Empty / no-match ================================================ */
  function Empty({ lang, onRetake, c }) {
    return e("div", { className: "empty fade-anim" },
      e("div", { className: "e-ic" }, e(Icon, { name: "compass", size: 34 })),
      e("div", null,
        e("h2", { className: "h2" }, c.empty_title),
        e("p", { className: "lead", style: { maxWidth: 340, marginInline: "auto" } }, c.empty_lead)
      ),
      e("div", { style: { display: "flex", flexDirection: "column", gap: 10, width: "100%", maxWidth: 300 } },
        e("button", { className: "btn btn-primary", onClick: onRetake, style: { flex: "none" } },
          e(Icon, { name: "refresh", size: 18 }), c.empty_retake),
        e("button", { className: "btn btn-ghost" }, e(Icon, { name: "chat", size: 18 }), c.empty_advisor)
      )
    );
  }

  Object.assign(window, { Welcome, Questionnaire, Review, Processing, Results, Detail, Empty });
})();
