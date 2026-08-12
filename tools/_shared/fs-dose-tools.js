(function () {
  "use strict";

  var wrap = document.getElementById("fs-dose-calculator");
  if (!wrap) return;

  var minEl = document.getElementById("fs-dose-min");
  var freqEl = document.getElementById("fs-dose-freq");
  var minOut = document.getElementById("fs-dose-min-out");
  var freqOut = document.getElementById("fs-dose-freq-out");
  var totalEl = document.getElementById("fs-dose-total");
  var vs100El = document.getElementById("fs-dose-vs100");
  var vs160El = document.getElementById("fs-dose-vs160");
  var svg = document.getElementById("fs-dose-chart");

  var data = null;
  var chartPad = { top: 28, right: 24, bottom: 36, left: 24 };

  function xScale(v, width, xmin, xmax) {
    var inner = width - chartPad.left - chartPad.right;
    return chartPad.left + ((v - xmin) / (xmax - xmin)) * inner;
  }

  function versusLine(total, target, label) {
    var diff = total - target;
    if (diff === 0) return "Exactly " + target + " min/wk";
    if (diff > 0) return diff + " min over " + target + " min/wk";
    return Math.abs(diff) + " min under " + target + " min/wk";
  }

  function renderChart(total) {
    if (!data || !svg) return;

    var xmin = data.xmin;
    var xmax = data.xmax;
    var height = 110;
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

    var axisY = height - chartPad.bottom;

    svg.appendChild(
      el("line", {
        x1: chartPad.left,
        y1: axisY,
        x2: width - chartPad.right,
        y2: axisY,
        stroke: "#adb5bd",
        "stroke-width": 1
      })
    );

    for (var t = 0; t <= xmax; t += 20) {
      var tx = xScale(t, width, xmin, xmax);
      var tick = el("text", {
        x: tx,
        y: axisY + 16,
        "text-anchor": "middle",
        fill: "#495057",
        "font-size": "10"
      });
      tick.textContent = t;
      svg.appendChild(tick);
    }

    data.lines.forEach(function (line) {
      var lx = xScale(line.value, width, xmin, xmax);
      svg.appendChild(
        el("line", {
          x1: lx,
          y1: chartPad.top,
          x2: lx,
          y2: axisY,
          stroke: line.color,
          "stroke-width": 1.5,
          "stroke-dasharray": line.dashed ? "4 3" : "none"
        })
      );
      var lbl = el("text", {
        x: lx,
        y: chartPad.top - 8,
        "text-anchor": "middle",
        fill: line.color,
        "font-size": "9"
      });
      lbl.textContent = line.value;
      svg.appendChild(lbl);
    });

    var px = xScale(Math.min(total, xmax), width, xmin, xmax);
    svg.appendChild(
      el("circle", {
        cx: px,
        cy: axisY,
        r: 7,
        fill: "#1d4ed8",
        stroke: "#0b2c8a",
        "stroke-width": 1.5
      })
    );
    var sel = el("text", {
      x: px,
      y: axisY - 14,
      "text-anchor": "middle",
      fill: "#1d4ed8",
      "font-size": "11",
      "font-weight": "700"
    });
    sel.textContent = "You: " + total;
    svg.appendChild(sel);
  }

  function update() {
    var perSession = Number(minEl.value);
    var perWeek = Number(freqEl.value);
    var total = perSession * perWeek;

    minOut.textContent = String(perSession);
    freqOut.textContent = String(perWeek);
    totalEl.textContent = total + " min/wk";
    vs100El.textContent = versusLine(total, 100);
    vs160El.textContent = versusLine(total, 160);

    renderChart(total);
  }

  function bind() {
    minEl.addEventListener("input", update);
    freqEl.addEventListener("input", update);
    window.addEventListener("resize", function () {
      update();
    });
  }

  fetch("../_shared/dose-thresholds.json")
    .then(function (r) {
      if (!r.ok) throw new Error("dose thresholds json");
      return r.json();
    })
    .then(function (json) {
      data = json;
      bind();
      update();
    })
    .catch(function () {
      bind();
      update();
    });
})();
