/* Major Advisor — app shell: state machine, chrome, language/direction, tweaks */
(function () {
  const { Icon } = window;
  const e = React.createElement;
  const { useState, useEffect, useRef } = React;
  const { useTweaks, TweaksPanel, TweakSection, TweakColor, TweakRadio } = window;

  const PALETTES = {
    "Royal blue": "#2A5BD7",
    "Teal": "#0E7C66",
    "Violet": "#5B3FD9",
    "Ink": "#1F2A44",
  };

  const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
    "primary": "#2A5BD7",
    "ratingStyle": "segmented",
    "matchViz": "ring",
    "direction": "a",
  }/*EDITMODE-END*/;

  // step machine: welcome → A → B → C → review → processing → results → detail/empty
  const FLOW = ["welcome", "A", "B", "C", "review", "processing", "results"];

  function App() {
    const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
    const lang = "ar";       // Arabic-only build
    const view = "desktop";  // desktop-only build
    const [step, setStep] = useState("welcome");
    const [answers, setAnswers] = useState({});
    const [ranked, setRanked] = useState([]);
    const [detailIdx, setDetailIdx] = useState(0);
    const [returnTo, setReturnTo] = useState(null); // editing from review
    const [procDone, setProcDone] = useState(false); // processing animation finished
    const bodyRef = useRef(null);

    const c = window.MA_COPY[lang];
    const isDesktop = view === "desktop";

    // expose tweaks + answers for components that read globals
    window.__maTweaks = t;
    window.__maAnswers = answers;

    // apply primary + direction to the document scope
    useEffect(() => {
      const root = document.getElementById("ma-root");
      if (root) {
        root.style.setProperty("--primary", t.primary);
        root.setAttribute("data-direction", t.direction);
      }
    }, [t.primary, t.direction]);

    useEffect(() => {
      document.documentElement.setAttribute("dir", c.dir);
      document.documentElement.setAttribute("lang", lang);
    }, [lang]);

    // scroll to top on step change
    useEffect(() => { if (bodyRef.current) bodyRef.current.scrollTop = 0; }, [step, view]);

    // leave the processing screen only once BOTH the animation has finished and
    // the CLIPS result has arrived, so results are never empty / mis-routed
    useEffect(() => {
      if (step === "processing" && procDone && ranked.length) {
        setStep(ranked[0].pct >= 50 ? "results" : "empty");
        setProcDone(false);
      }
    }, [step, procDone, ranked]);

    const setAnswer = (key, v) => setAnswers((a) => ({ ...a, [key]: a[key] === v ? undefined : v }));

    const sectionFor = (id) => window.MA.sections.find((s) => s.id === id);
    const prog = window.MA.progressOf(answers);

    const goNext = () => {
      if (returnTo && ["A", "B", "C"].includes(step)) { setStep("review"); setReturnTo(null); return; }
      const i = FLOW.indexOf(step);
      const nextStep = FLOW[i + 1];
      if (nextStep === "processing") {
        // run the REAL CLIPS engine while the processing animation plays;
        // fall back to the local heuristic if the backend is unreachable
        setRanked([]);
        setProcDone(false);
        setStep("processing");
        window.MA.scoreAsync(answers, lang)
          .then(setRanked)
          .catch(() => setRanked(window.MA.score(answers, lang)));
      } else setStep(nextStep);
    };
    const goBack = () => {
      const i = FLOW.indexOf(step);
      if (step === "detail") { setStep("results"); return; }
      if (i > 0) setStep(FLOW[i - 1]);
    };
    const editSection = (id) => { setReturnTo("review"); setStep(id); };
    const retake = () => { setAnswers({}); setStep("welcome"); };

    const sectionAnsweredAll = (id) => sectionFor(id).items.every((a) => answers[a.key] !== undefined);

    // === header chrome (outside device) ===
    const chrome = e("div", { className: "chrome" },
      e("div", { className: "brand" },
        e("div", { className: "dot" }, e(Icon, { name: "grad", size: 15 })),
        e("div", null, c.brand, e("small", null, c.brandSub))
      )
    );

    // === the app content per step ===
    let content, footer = null, appbar = null;

    if (step === "welcome") {
      content = e(window.Welcome, { lang, c });
      footer = e("div", { className: "footer" },
        e("button", { className: "btn btn-primary", onClick: goNext },
          c.w_start, e(Icon, { name: "arrow", size: 18, className: "arrow" })),
      );
    } else if (["A", "B", "C"].includes(step)) {
      const sec = sectionFor(step);
      appbar = e("div", { className: "appbar" },
        e("button", { className: "iconbtn back", onClick: goBack, "aria-label": c.back }, e(Icon, { name: "back", size: 18 })),
        e("span", { className: "sectiontag" }, `${c.section} ${step}`),
        e("span", { className: "spacer" }),
        e("span", { className: "stepcount" }, `${prog.done}/${prog.total}`)
      );
      content = e("div", null,
        e("div", { style: { marginBottom: 16 } }, e(window.Progress, { done: prog.done, total: prog.total, c })),
        e(window.Questionnaire, { section: sec, lang, answers, setAnswer, ratingStyle: t.ratingStyle })
      );
      const allAnswered = sectionAnsweredAll(step);
      footer = e("div", { className: "footer", style: { flexDirection: "column", alignItems: "stretch", gap: 8 } },
        !allAnswered && e("div", { style: { fontSize: 12, color: "var(--ink-mute)", textAlign: "center" } }, c.skipNote),
        e("button", { className: "btn btn-primary", onClick: goNext },
          returnTo ? c.rev_edit : c.next, e(Icon, { name: "arrow", size: 18, className: "arrow" }))
      );
    } else if (step === "review") {
      const unanswered = prog.total - prog.done;
      appbar = e("div", { className: "appbar" },
        e("button", { className: "iconbtn back", onClick: () => setStep("C"), "aria-label": c.back }, e(Icon, { name: "back", size: 18 })),
        e("span", { className: "sectiontag" }, c.rev_title),
      );
      content = e("div", null,
        unanswered > 0 && e("div", { className: "inline-error", style: { color: "var(--warn)", background: "color-mix(in oklch, var(--warn) 12%, white)", borderColor: "color-mix(in oklch, var(--warn) 30%, white)" } },
          e(Icon, { name: "alert", size: 18 }), c.rev_warn.replace("{n}", unanswered)),
        e(window.Review, { lang, answers, onEdit: editSection, c })
      );
      footer = e("div", { className: "footer" },
        e("button", { className: "btn btn-primary", onClick: goNext },
          e(Icon, { name: "spark", size: 18 }), c.rev_generate)
      );
    } else if (step === "processing") {
      content = e(window.Processing, { lang, c, onDone: () => setProcDone(true) });
    } else if (step === "results") {
      appbar = e("div", { className: "appbar" },
        e("span", { className: "sectiontag" }, e(Icon, { name: "spark", size: 14, style: { verticalAlign: -2, marginInlineEnd: 6, color: "var(--primary)" } }), c.res_title),
        e("span", { className: "spacer" }),
        e("button", { className: "iconbtn", onClick: () => setStep("review"), title: c.res_adjust }, e(Icon, { name: "edit", size: 17 }))
      );
      content = e(window.Results, { lang, ranked, isDesktop, viz: t.matchViz, onOpen: (i) => { setDetailIdx(i); setStep("detail"); } });
      footer = e("div", { className: "footer" },
        e("button", { className: "btn btn-ghost", onClick: () => setStep("review"), style: { flex: 1 } },
          e(Icon, { name: "edit", size: 17 }), c.res_adjust),
        e("button", { className: "btn btn-ghost", onClick: retake, style: { flex: 1 } },
          e(Icon, { name: "refresh", size: 17 }), c.res_retake)
      );
    } else if (step === "detail") {
      const entry = ranked[detailIdx];
      const next = ranked[detailIdx + 1];
      appbar = e("div", { className: "appbar" },
        e("button", { className: "iconbtn back", onClick: () => setStep("results"), "aria-label": c.det_back }, e(Icon, { name: "back", size: 18 })),
        e("span", { className: "sectiontag" }, c.det_back)
      );
      content = e(window.Detail, { lang, entry, next, isDesktop, viz: t.matchViz,
        onCompare: () => { setDetailIdx(detailIdx + 1); if (bodyRef.current) bodyRef.current.scrollTop = 0; } });
    } else if (step === "empty") {
      content = e(window.Empty, { lang, c, onRetake: () => setStep("review") });
    }

    const app = e("div", { className: "app" },
      appbar,
      e("div", { className: "body", ref: bodyRef }, content),
      footer
    );

    // desktop-only build
    const device = e("div", { className: "desktop" },
      e("div", { className: "screen" }, app)
    );

    return e(React.Fragment, null,
      chrome,
      e("div", { className: "device-wrap" }, device),
      e(TweaksPanel, null,
        e(TweakSection, { label: lang === "ar" ? "الاتجاه التصميمي" : "Design direction" }),
        e(TweakRadio, {
          label: lang === "ar" ? "الأسلوب" : "Style",
          value: t.direction,
          options: [{ value: "a", label: lang === "ar" ? "ناعم" : "Soft" }, { value: "b", label: lang === "ar" ? "حاد" : "Crisp" }],
          onChange: (v) => setTweak("direction", v),
        }),
        e(TweakSection, { label: lang === "ar" ? "اللون الأساسي" : "Accent palette" }),
        e(TweakColor, {
          label: lang === "ar" ? "اللون" : "Primary",
          value: t.primary, options: Object.values(PALETTES),
          onChange: (v) => setTweak("primary", v),
        }),
        e(TweakSection, { label: lang === "ar" ? "أدوات التقييم" : "Controls" }),
        e(TweakRadio, {
          label: lang === "ar" ? "أداة التقييم" : "Rating control",
          value: t.ratingStyle,
          options: [{ value: "segmented", label: lang === "ar" ? "مجزّأ" : "Segmented" }, { value: "slider", label: lang === "ar" ? "شريط" : "Slider" }],
          onChange: (v) => setTweak("ratingStyle", v),
        }),
        e(TweakRadio, {
          label: lang === "ar" ? "عرض التطابق" : "Match score",
          value: t.matchViz,
          options: [{ value: "ring", label: lang === "ar" ? "حلقة" : "Ring" }, { value: "bar", label: lang === "ar" ? "شريط" : "Bar" }],
          onChange: (v) => setTweak("matchViz", v),
        })
      )
    );
  }

  window.MAApp = App;
})();
