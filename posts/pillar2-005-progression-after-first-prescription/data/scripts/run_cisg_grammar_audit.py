#!/usr/bin/env python3
"""Standalone CISG grammar audit (pillar2-005 supplement).

Requires: pip install pypdf
PDFs: Amsterdam [PMID 37316210], Berlin [PMID 28446457] — obtain from publisher.

Usage:
  python run_cisg_grammar_audit.py \\
    --amsterdam /path/to/amsterdam.pdf \\
    --berlin /path/to/berlin.pdf \\
    --out-dir ../
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from datetime import date
from pathlib import Path
from typing import Any

try:
    from pypdf import PdfReader
except ImportError:
    print("Install pypdf: pip install pypdf", file=sys.stderr)
    raise SystemExit(1)


@dataclass(frozen=True)
class GrammarRow:
    document: str
    pmid: str
    table_label: str
    track: str
    steps: int
    explicit_24h_floor: bool
    time_rule_location: str
    progression_gate: str
    verification: dict[str, bool]


def load_pdf_text(path: Path) -> str:
    reader = PdfReader(str(path))
    return "\n".join(page.extract_text() or "" for page in reader.pages)


def _norm(text: str) -> str:
    return re.sub(r"\s+", " ", text)


def _slice_after(text: str, marker: str, length: int = 2500) -> str:
    idx = text.find(marker)
    return text[idx : idx + length] if idx >= 0 else ""


def audit_amsterdam(text: str) -> tuple[list[GrammarRow], dict[str, str]]:
    snippets: dict[str, str] = {}
    rts_title = "Return-to-sport (RTS) strategy—each step typically takes a minimum of 24 hours"
    rtl_footer = (
        "Progression through the strategy for students should be slowed when there is "
        "more than a mild and brief symptom exacerbation"
    )
    t2_block = _slice_after(text, "Table 2", 4000)
    t1_block = _slice_after(text, "Table 1", 3500)
    checks = {
        "rts_title_24h": rts_title.replace("\u2011", "-") in _norm(text).replace("\u2011", "-")
        or "minimum of 24 hours" in _norm(t2_block),
        "rtl_no_title_24h": "minimum of 24 hours" not in _norm(t1_block).split("Table 2")[0],
        "rtl_slow_on_exacerbation": rtl_footer.replace("\u2011", "-") in _norm(text).replace("\u2011", "-"),
    }
    if checks["rts_title_24h"]:
        snippets["amsterdam_rts_title"] = rts_title
    if checks["rtl_slow_on_exacerbation"]:
        snippets["amsterdam_rtl_footer"] = rtl_footer
    return [
        GrammarRow(
            "Amsterdam 2022", "37316210", "Table 1 (RTL)", "RTL", 4, False,
            "Absent from title and footer",
            "Symptom only — slow if >mild/brief exacerbation",
            {"no_24h_in_rtl_table_block": checks["rtl_no_title_24h"], "rtl_footer_present": checks["rtl_slow_on_exacerbation"]},
        ),
        GrammarRow(
            "Amsterdam 2022", "37316210", "Table 2 (RTS)", "RTS", 6, True,
            "Table title + footnote", "≥24 h/step + ≤2/10 for <1 h",
            {"rts_24h_in_title_or_table2": checks["rts_title_24h"]},
        ),
    ], snippets


def audit_berlin(text: str) -> tuple[list[GrammarRow], dict[str, str]]:
    snippets: dict[str, str] = {}
    rts_note = "There should be at least 24 hours (or longer) for each step of the progression"
    rts_block = _slice_after(text, "Graduated return-to-sport", 5000) or _slice_after(text, "Table 1", 3500)
    rtl_block = _slice_after(text, "Graduated return-to-school strategy", 3500) or _slice_after(text, "return-to-school strategy", 3500)
    checks = {
        "rts_at_least_24h": "at least 24" in _norm(rts_block) and "each step" in _norm(rts_block),
        "rtl_no_24h_floor": not re.search(r"at least 24\s*hours.*each step", _norm(rtl_block), re.I),
    }
    if checks["rts_at_least_24h"]:
        snippets["berlin_rts_note"] = rts_note
    return [
        GrammarRow(
            "Berlin 2017", "28446457", "Table 2 (return-to-school)", "RTL", 4, False,
            "Stage text only", "Symptom recurrence at stage",
            {"no_24h_each_step_in_rtl_block": checks["rtl_no_24h_floor"]},
        ),
        GrammarRow(
            "Berlin 2017", "28446457", "Table 1 (RTS)", "RTS", 6, True,
            "NOTE below table", "≥24 h/step; step back if symptoms worsen",
            {"rts_at_least_24h_note": checks["rts_at_least_24h"]},
        ),
    ], snippets


def run_audit(amsterdam: Path, berlin: Path) -> dict[str, Any]:
    rows = audit_amsterdam(load_pdf_text(amsterdam))[0] + audit_berlin(load_pdf_text(berlin))[0]
    checks: dict[str, bool] = {}
    for row in rows:
        checks.update({f"{row.pmid}_{row.track}_{k}": v for k, v in row.verification.items()})
    return {
        "audit_version": "1.0",
        "audit_date": date.today().isoformat(),
        "installment": "pillar2-005",
        "source_pdfs": {"amsterdam_pmid": "37316210", "berlin_pmid": "28446457"},
        "grammar_rows": [asdict(r) for r in rows],
        "rule_derived_minimum": {
            "rtl_days_ideal": 4,
            "rts_days_ideal": 6,
            "grammar_rts_rtl_ratio": 1.5,
        },
        "pattern_checks_passed": all(checks.values()),
        "pattern_checks": checks,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--amsterdam", type=Path, required=True)
    parser.add_argument("--berlin", type=Path, required=True)
    parser.add_argument("--out-dir", type=Path, default=Path("../"))
    args = parser.parse_args()
    payload = run_audit(args.amsterdam, args.berlin)
    args.out_dir.mkdir(parents=True, exist_ok=True)
    out = args.out_dir / "cisg-grammar-audit.json"
    out.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print(f"Wrote {out} (pattern_checks_passed={payload['pattern_checks_passed']})")
    return 0 if payload["pattern_checks_passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
