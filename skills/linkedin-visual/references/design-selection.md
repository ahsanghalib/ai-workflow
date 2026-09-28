# Design-system selection

Use this reference after deciding that a visual is useful and before opening
the option PNGs. Select one complete design system for the whole carousel.
Never switch systems from page to page.

## Decision order

Apply these rules in order:

1. **Explicit direction wins.** If the user names `evidence-ledger`,
   `dark-signal`, `modular-index`, or the baseline system, use that system.
2. **Random is opt-in.** Use random selection only when the user says
   `random`, `surprise me`, or asks for an exploratory random direction. Select
   one option, record the selected name, and label the receipt
   `selection-mode: random-exploration`. Do not describe that result as the
   content-optimal choice.
3. **Content fit is the default.** Classify the post's dominant reader job
   using the routing signals below and select the strongest matching option.
4. **Baseline is the ambiguity fallback.** If no option has a clear lead, use
   the baseline canonical templates and record why the alternate options were
   not a stronger fit.

If the active harness has no real random capability, do not pretend that a
model preference is random. Fall back to content fit and label the receipt
`selection-mode: content-fit`.

## Content-fit routing

Choose the option whose primary job matches the post's central argument:

- **Evidence Ledger** — the reader needs to inspect evidence, sources,
  caveats, retrieval grounding, evaluation criteria, contracts, or benchmark
  notes. Typical signals: `evidence`, `source`, `citation`, `grounded`,
  `retrieval`, `eval`, `benchmark`, `contract`, `caveat`.
- **Dark Signal** — the reader needs to understand failure, diagnosis,
  observability, traces, agent/tool paths, latency, or error recovery. Typical
  signals: `failure`, `debug`, `trace`, `observability`, `incident`, `error`,
  `latency`, `agent`, `tool call`, `retry`.
- **Modular Index** — the reader needs to see structure across components,
  stages, layers, choices, or metrics. Typical signals: `architecture`,
  `pipeline`, `stage`, `component`, `taxonomy`, `map`, `comparison`,
  `trade-off`, `metric`, `system design`.

Use the post's page sequence, not an isolated keyword, to resolve the choice.
For example, a RAG post with a failure-and-debugging sequence belongs to Dark
Signal even if it mentions retrieval and evaluation.

## Minimal scoring rule

For an auditable choice, score each alternate system:

- `2` for a dominant reader job match;
- `1` for a supporting signal;
- `0` when the system adds no explanatory advantage.

Select an alternate only when it scores at least `2` and leads the next option
by at least `1`. Otherwise use the baseline. If the user asked to see options,
show the leading candidate and name the runner-up rather than mixing them.

## Selection receipt

Record this before authoring:

```text
selection-mode: explicit | content-fit | random-exploration | baseline
selected-system: baseline | evidence-ledger | dark-signal | modular-index
dominant-reader-job: ...
content-signals: ...
runner-up: ...
reason: ...
```

Open every rendered PNG in the selected option's `slides/` directory before
authoring. Use its PDF and editable SVG only for source/export review; rebuild
the final content as native editable PPTX objects.
