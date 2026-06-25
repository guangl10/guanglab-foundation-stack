# pillar2-005 data supplements

## `run_cisg_grammar_audit.py`

Re-runs the CISG RTL/RTS grammar audit against publisher PDFs.

```bash
pip install pypdf
python run_cisg_grammar_audit.py \
  --amsterdam /path/to/amsterdam37316210.pdf \
  --berlin /path/to/berlin28446457.pdf \
  --out-dir ..
```

Output: `../cisg-grammar-audit.json` with `pattern_checks_passed`.

Source PDFs: Patricios et al. 2023 [PMID 37316210]; McCrory et al. 2017 [PMID 28446457].
