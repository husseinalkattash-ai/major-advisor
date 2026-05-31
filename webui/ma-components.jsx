/* Major Advisor — reusable component set (Brief §7). Exports to window. */
(function () {
  const { Icon } = window;
  const e = React.createElement;

  /* ---- Ordinal rating: segmented ---------------------------------------- */
  function RatingSegmented({ labels, value, onChange, name }) {
    return e("div", { className: "rating-seg", role: "radiogroup", "aria-label": name },
      labels.map((lbl, i) =>
        e("button", {
          key: i, className: "opt", role: "radio",
          "aria-checked": value === i, "aria-label": lbl,
          onClick: () => onChange(i),
        },
          e("span", { className: "tick" }, e(Icon, { name: "check", size: 12 })),
          e("span", { className: "lbl" }, lbl)
        )
      )
    );
  }

  /* ---- Ordinal rating: labeled slider ----------------------------------- */
  function RatingSlider({ labels, value, onChange, name }) {
    const n = labels.length;
    const has = value !== undefined && value !== null;
    const pct = has ? (value / (n - 1)) * 100 : 0;
    return e("div", { className: "rating-slider", role: "radiogroup", "aria-label": name },
      e("div", { className: "rail" },
        e("div", { className: "line" }),
        e("div", { className: "linefill", style: { width: `${pct}%` } }),
        e("div", { className: "stops" },
          labels.map((lbl, i) =>
            e("button", {
              key: i, role: "radio", "aria-checked": value === i, "aria-label": lbl,
              className: "stop" + (value === i ? " thumb" : "") + (has && i < value ? " " : ""),
              "data-on": has && i <= value,
              onClick: () => onChange(i),
            })
          )
        )
      ),
      e("div", { className: "stoplabels" },
        labels.map((lbl, i) =>
          e("span", { key: i, className: value === i ? "cur" : "" }, lbl)
        )
      )
    );
  }

  function RatingControl(props) {
    const style = props.style || (window.__maTweaks && window.__maTweaks.ratingStyle) || "segmented";
    return style === "slider" ? e(RatingSlider, props) : e(RatingSegmented, props);
  }

  /* ---- Progress indicator ----------------------------------------------- */
  function Progress({ done, total, c }) {
    const pct = total ? Math.round((done / total) * 100) : 0;
    return e("div", { className: "progress" },
      e("div", { className: "track" }, e("div", { className: "fill", style: { width: `${pct}%` } })),
      e("div", { className: "meta" },
        e("span", null, c.overall),
        e("span", null, `${done} ${c.of} ${total}`)
      )
    );
  }

  /* ---- Attribute row (label + helper + rating) -------------------------- */
  function AttributeRow({ attr, lang, value, onChange, ratingStyle }) {
    const help = lang === "ar" ? attr.helpAr : attr.helpEn;
    const labels = attr.scale.labels[lang];
    return e("div", { className: "attr" },
      e("div", { className: "top" },
        attr.hue && e("span", { className: "swatch", style: { background: `var(--c-${attr.hue})` } }),
        e("div", null,
          e("div", { className: "name" }, lang === "ar" ? attr.ar : attr.en),
          help && e("div", { className: "help" }, help)
        )
      ),
      e(RatingControl, { labels, value, onChange, name: lang === "ar" ? attr.ar : attr.en, style: ratingStyle })
    );
  }

  /* ---- Match score visualization (ring / bar) --------------------------- */
  function MatchViz({ pct, size = "md", color, viz }) {
    const mode = viz || (window.__maTweaks && window.__maTweaks.matchViz) || "ring";
    if (mode === "bar") {
      return e("div", { className: "bar" + (size === "lg" ? " lg" : ""), role: "img", "aria-label": `${pct}%` },
        e("div", { className: "bar-num" }, pct, e("small", null, "%")),
        e("div", { className: "bar-track" },
          e("div", { className: "bar-fill", style: { width: `${pct}%`, "--barcolor": color } })
        )
      );
    }
    const r = size === "lg" ? 46 : 28;
    const C = 2 * Math.PI * r;
    const dim = size === "lg" ? 104 : 64;
    const off = C * (1 - pct / 100);
    return e("div", { className: "ring" + (size === "lg" ? " lg" : ""), style: { "--ringcolor": color }, role: "img", "aria-label": `${pct}%` },
      e("svg", { viewBox: `0 0 ${dim} ${dim}` },
        e("circle", { className: "bg", cx: dim / 2, cy: dim / 2, r, fill: "none", strokeWidth: size === "lg" ? 9 : 7 }),
        e("circle", { className: "val", cx: dim / 2, cy: dim / 2, r, fill: "none", strokeWidth: size === "lg" ? 9 : 7,
          strokeDasharray: C, strokeDashoffset: off })
      ),
      e("div", { className: "pct" }, pct, e("span", { style: { fontSize: "0.6em", marginInlineStart: 1 } }, "%"))
    );
  }

  /* ---- Justification item ----------------------------------------------- */
  function justText(j, lang) {
    const c = window.MA_COPY[lang];
    const a = lang === "ar" ? j.attrAr : j.attrEn;
    // derive the value label from the raw index in the CURRENT language so it
    // stays correct when the user toggles AR/EN after results are computed
    const scale = j.section === "A" ? window.MA.scale4 : window.MA.scale3;
    const valLabel = scale.labels[lang][j.raw];
    const fn = c.jt[(j.kind === "gap" ? "gap" : "strength") + j.section];
    return fn ? fn(a, valLabel) : "";
  }

  function Justification({ j, lang }) {
    const isGap = j.kind === "gap";
    return e("div", { className: "just" },
      e(Icon, { name: isGap ? "bulb" : "check", size: 18, className: "jic" + (isGap ? " q" : "") }),
      e("span", null, justText(j, lang))
    );
  }

  /* ---- Result card ------------------------------------------------------- */
  function ResultCard({ entry, rank, lang, onOpen, isTop, viz }) {
    const c = window.MA_COPY[lang];
    const m = entry.major;
    const fac = window.MA.faculties[m.faculty];
    const facHue = `var(--c-${fac.hue})`;
    const preview = entry.justifications.slice(0, isTop ? 3 : 2);
    return e("button", {
      className: "result screen-anim" + (isTop ? " top" : ""),
      style: { "--ringcolor": facHue, "--barcolor": facHue },
      onClick: onOpen,
    },
      e("span", { className: "rank" },
        isTop ? e(Icon, { name: "spark", size: 12 }) : null,
        isTop ? c.res_topBadge : `${c.rank} ${rank + 1}`
      ),
      e("div", { className: "r-head" },
        e("div", { className: "r-info" },
          e("h3", { className: "r-name" }, lang === "ar" ? m.ar : m.en),
          e("div", { className: "r-fac" },
            e("span", { className: "fdot", style: { background: facHue } }),
            lang === "ar" ? fac.ar : fac.en
          )
        ),
        e(window.MatchViz, { pct: entry.pct, size: isTop ? "lg" : "md", color: facHue, viz })
      ),
      e("div", { className: "r-reasons" },
        preview.map((j, i) => e(Justification, { key: i, j, lang }))
      ),
      e("div", { className: "r-more" },
        c.res_more, e(Icon, { name: "chevron", size: 15 })
      )
    );
  }

  /* ---- Section nav chips ------------------------------------------------- */
  function SectionNav({ current, lang }) {
    const c = window.MA_COPY[lang];
    const secs = [["A", c.sectionA], ["B", c.sectionB], ["C", c.sectionC]];
    const order = ["A", "B", "C"];
    const ci = order.indexOf(current);
    return e("div", { className: "sectionnav" },
      secs.map(([id, label], i) =>
        e("div", { key: id, className: "sc" + (id === current ? " active" : i < ci ? " done" : "") },
          e(Icon, { name: window.ICON_FOR[id], size: 17, className: "ic" }),
          e("span", null, label)
        )
      )
    );
  }

  Object.assign(window, {
    RatingControl, RatingSegmented, RatingSlider, Progress,
    AttributeRow, MatchViz, Justification, justText, ResultCard, SectionNav,
  });
})();
