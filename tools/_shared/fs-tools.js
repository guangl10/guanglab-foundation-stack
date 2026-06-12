(function () {
  "use strict";

  var wrap = document.getElementById("fs-hr-calculator");
  if (!wrap) return;

  var ageEl = document.getElementById("fs-age");
  var pctEl = document.getElementById("fs-pct");
  var ageOut = document.getElementById("fs-age-out");
  var pctOut = document.getElementById("fs-pct-out");
  var hrmaxEl = document.getElementById("fs-hrmax");
  var bpmEl = document.getElementById("fs-bpm");
  var overlapEl = document.getElementById("fs-overlap");
  var svg = document.getElementById("fs-band-chart");
  var formulaInputs = document.querySelectorAll('input[name="fs-formula"]');

  var data = null;
  var chartPad = { top: 28, right: 88, bottom: 36, left: 200 };

  function hrmax220(age) {
    return 220 - age;
  }

  function hrmax208(age) {
    return 208 - 0.7 * age;
  }

  function selectedFormula() {
    var checked = document.querySelector('input[name="fs-formula"]:checked');
    return checked ? checked.value : "220-age";
  }

  function computeHrmax(age) {
    return selectedFormula() === "208-0.7age" ? hrmax208(age) : hrmax220(age);
  }

  function overlaps(band, pct) {
    return pct >= band.xmin && pct <= band.xmax;
  }

  function xScale(pct, width, xmin, xmax) {
    var inner = width - chartPad.left - chartPad.right;
    return chartPad.left + ((pct - xmin) / (xmax - xmin)) * inner;
  }

  function renderChart(pct) {
    if (!data || !svg) return;

    var xmin = data.xmin;
    var xmax = data.xmax;
    var bands = data.bands;
    var clusters = data.clusters;
    var rowH = 32;
    var height = chartPad.top + chartPad.bottom + bands.length * rowH;
    var width = Math.min(720, wrap.clientWidth || 720);

    svg.setAttribute("width", width);
    svg.setAttribute("height", height);
    svg.setAttribute("viewBox", "0 0 " + width + " " + height);
    svg.innerHTML = "";

    var ns = "http://www.w3.org/2000/svg";

    function el(name, attrs) {
      var node = document.createElementNS(ns, name);
      Object.keys(attrs).forEach(function (k) {
        node.setAttribute(k, attrs[k]);
      });
      return node;
    }

    for (var t = xmin; t <= xmax; t += 5) {
      var tx = xScale(t, width, xmin, xmax);
      svg.appendChild(
        el("line", {
          x1: tx,
          y1: chartPad.top,
          x2: tx,
          y2: height - chartPad.bottom,
          stroke: "#e9ecef",
          "stroke-width": 1
        })
      );
      var tick = el("text", {
        x: tx,
        y: height - 12,
        "text-anchor": "middle",
        fill: "#495057",
        "font-size": "11"
      });
      tick.textContent = t;
      svg.appendChild(tick);
    }

    var axisLabel = el("text", {
      x: (width + chartPad.left - chartPad.right) / 2,
      y: height - 2,
      "text-anchor": "middle",
      fill: "#212529",
      "font-size": "12",
      "font-weight": "600"
    });
    axisLabel.textContent = "% age-predicted HRmax";
    svg.appendChild(axisLabel);

    bands.forEach(function (band, i) {
      var y = chartPad.top + i * rowH + rowH / 2;
      var color = clusters[band.cluster].color;
      var x1 = xScale(band.xmin, width, xmin, xmax);
      var x2 = xScale(band.xmax, width, xmin, xmax);

      svg.appendChild(
        el("rect", {
          x: x1,
          y: y - 10,
          width: Math.max(x2 - x1, 2),
          height: 20,
          fill: color,
          stroke: "#495057",
          "stroke-width": 0.4,
          rx: 2
        })
      );

      if (band.marker) {
        var mx = xScale(band.marker, width, xmin, xmax);
        svg.appendChild(
          el("line", {
            x1: mx,
            y1: y - 12,
            x2: mx,
            y2: y + 12,
            stroke: "#8b4513",
            "stroke-width": 1.2,
            "stroke-dasharray": "4 3"
          })
        );
      }

      var label = el("text", {
        x: chartPad.left - 8,
        y: y + 4,
        "text-anchor": "end",
        fill: "#212529",
        "font-size": "11"
      });
      label.textContent = band.label;
      svg.appendChild(label);
    });

    var px = xScale(pct, width, xmin, xmax);
    svg.appendChild(
      el("line", {
        x1: px,
        y1: chartPad.top - 4,
        x2: px,
        y2: height - chartPad.bottom,
        stroke: "#c92a2a",
        "stroke-width": 2.5
      })
    );
    var sel = el("text", {
      x: px,
      y: 16,
      "text-anchor": "middle",
      fill: "#c92a2a",
      "font-size": "12",
      "font-weight": "700"
    });
    sel.textContent = "You: " + pct + "%";
    svg.appendChild(sel);
  }

  function update() {
    var age = Number(ageEl.value);
    var pct = Number(pctEl.value);
    var hrmax = computeHrmax(age);
    var bpm = Math.round((pct / 100) * hrmax);

    ageOut.textContent = String(age);
    pctOut.textContent = pct + "%";
    hrmaxEl.textContent = Math.round(hrmax) + " bpm";
    bpmEl.textContent = bpm + " bpm";

    if (data) {
      var hits = data.bands.filter(function (b) {
        return overlaps(b, pct);
      });
      overlapEl.textContent =
        hits.length === 0
          ? "None of the five mapped bands"
          : hits.map(function (b) {
              return b.label.split(" (")[0];
            }).join("; ");
      renderChart(pct);
    }
  }

  function bind() {
    ageEl.addEventListener("input", update);
    pctEl.addEventListener("input", update);
    formulaInputs.forEach(function (inp) {
      inp.addEventListener("change", update);
    });
    window.addEventListener("resize", function () {
      update();
    });
  }

  fetch("../_shared/hrmax-bands.json")
    .then(function (r) {
      if (!r.ok) throw new Error("bands json");
      return r.json();
    })
    .then(function (json) {
      data = json;
      bind();
      update();
    })
    .catch(function () {
      overlapEl.textContent = "Chart data unavailable";
      bind();
      update();
    });
})();
