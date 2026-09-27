# LinkedIn post topics

This is the editorial topic map for `linkedin-post`. It guides topic selection
and query expansion; it is not evidence, a trend report, or permission to claim
personal experience. Verify changing facts in the research run.

## Topic clusters

### 1. AI integration and custom models

- Subtopics: AI feature integration, model selection, custom models,
  fine-tuning, adapters, structured outputs, model routing, evaluation, small
  language models, latency, cost, and reliability.
- Query terms: `AI integration`, `custom model`, `model adaptation`,
  `fine-tuning`, `structured output`, `model evaluation`, `model routing`,
  `small language model`, `inference cost`, and `production reliability`.
- Useful angles: when integration is enough; what a custom model changes;
  evaluation before adaptation; routing by task; small-model tradeoffs; and
  the operational boundary between a model and a product feature.
- Research mode: release notes, official model documentation, evaluation
  papers, benchmarks with methodology, and implementation evidence.
- Avoid: unsupported claims that a model is universally best, cheaper, safer,
  or more accurate without a defined task and evidence.

### 2. Agentic systems and MCP

- Subtopics: agent loops, tool use, planning, orchestration, Model Context
  Protocol, MCP servers and clients, permissions, human-in-the-loop review,
  state, retries, and failure recovery.
- Query terms: `agentic system`, `AI agent`, `tool use`, `agent workflow`,
  `Model Context Protocol`, `MCP server`, `MCP client`, `agent evaluation`,
  `human in the loop`, and `tool authorization`.
- Useful angles: where an agent adds value; tool boundaries; approval gates;
  state versus prompt text; MCP interoperability; observability; and graceful
  failure instead of autonomous theater.
- Research mode: official specifications and documentation, implementation
  repositories, security guidance, research papers, and reproducible examples.
- Avoid: implying autonomy, safety, interoperability, or production readiness
  from a demo or a single vendor announcement.

### 3. RAG and context engineering

- Subtopics: retrieval-augmented generation, chunking, indexing, embeddings,
  reranking, query rewriting, citations, grounding, context windows,
  context selection, memory, and retrieval evaluation.
- Query terms: `RAG`, `retrieval augmented generation`, `context engineering`,
  `retrieval quality`, `chunking`, `reranking`, `grounding`, `citation`,
  `context window`, and `retrieval evaluation`.
- Useful angles: retrieval quality before model choice; context selection;
  citation fidelity; when RAG is not the answer; evaluation of retrieval and
  generation separately; and the cost of passing irrelevant context.
- Research mode: original papers, official product documentation, benchmark
  methodology, and documented system evaluations.
- Avoid: treating a larger context window as automatic grounding or a citation
  as proof that the generated answer is correct.

### 4. AI-engineering tooling and harnesses

- Subtopics: coding agents, agent harnesses, evaluations, observability,
  prompt tooling, workflow automation, sandboxes, tracing, regression tests,
  structured outputs, and developer experience.
- Query terms: `AI engineering tools`, `coding agent`, `agent harness`,
  `LLM evaluation`, `agent observability`, `prompt tooling`, `workflow
  automation`, `sandbox`, `tracing`, and `regression evaluation`.
- Useful angles: the harness as a control plane; deterministic checks around
  probabilistic output; local-first workflows; capability routing; test seams;
  and the difference between a tool demo and a repeatable engineering system.
- Research mode: official documentation, source repositories, release notes,
  papers, and transparent technical write-ups.
- Avoid: unsupported productivity multipliers, benchmark comparisons without
  matching tasks, or treating tool popularity as technical evidence.

### 5. Full-stack TypeScript, Node.js, and Python

- Subtopics: full-stack TypeScript, Node.js services, Python services, APIs,
  web applications, frontend/backend boundaries, queues, databases, testing,
  deployment, and AI application development.
- Query terms: `full-stack TypeScript`, `Node.js`, `Python`, `web API`,
  `backend engineering`, `frontend engineering`, `web application`, `AI
  application`, `type safety`, and `integration testing`.
- Useful angles: boundary design; typed contracts; choosing runtime by seam;
  incremental AI integration; testable workflows; and practical tradeoffs
  between TypeScript and Python without ecosystem tribalism.
- Research mode: official runtime/framework documentation, standards, release
  notes, source code, and reproducible technical measurements.
- Avoid: universal stack rankings, framework claims detached from a use case,
  and presenting a planned architecture as a shipped result.

## Angle selection

For each post, select one primary angle and one reader takeaway. Useful angle
families include:

- mechanism: explain why a system behaves a certain way;
- decision: compare options for a defined context;
- build lesson: document a supplied, real implementation experience;
- failure mode: show what breaks and how to detect it;
- evidence update: explain a new release, paper, standard, or measured result;
- counterpoint: challenge a common assumption with bounded evidence; and
- operating practice: show a repeatable workflow, check, or approval boundary.

Do not combine several angle families into one post unless the research file
explains why they form one coherent argument.

## Trend discipline

Treat one headline, social post, vendor claim, or isolated demo as a signal or
observation. Call something a trend only when multiple relevant, independent
signals support the claim or a primary source documents a meaningful change.
Use recent evidence for fast-moving facts and stable primary sources for
concepts whose origin or definition matters.

## Client-acquisition relevance

Topic choice should help the right professional audience recognize useful
engineering judgment. Prefer concrete production problems, tradeoffs, failure
modes, and implementation decisions over generic trend summaries. This does not
mean every post should sell a service or include a lead-generation CTA.
