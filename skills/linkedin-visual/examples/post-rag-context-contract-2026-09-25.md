# Sample LinkedIn carousel: RAG is a context contract

> Historical fixture: the visual-generation handoff below predates the current
> local editable design system. Do not reuse its older palette or identity
> placement as a current brand rule.

- Status: `APPROVED-UNPUBLISHED` sample
- Post no.: `SAMPLE-001`
- Research date: `2026-09-25`
- Topic: RAG and context engineering
- Primary angle: mechanism
- Core takeaway: Treat context selection as a first-class contract before
  choosing a vector store.
- Audience: AI engineers building retrieval-augmented applications
- Objective: teach a practical mental model for evaluating RAG systems
- Format: multi-page LinkedIn document; orientation and dimensions selected in
  the approved brief
- Brand: Ahsan LinkedIn identity in
  [brand-and-layout-guidelines.md](../references/brand-and-layout-guidelines.md)

## Final post text

RAG is not just a vector database.

It is a context selection problem.

The model can only reason over the context it receives. That makes the
retrieval boundary part of the product:

- what was retrieved;
- what was filtered out;
- what was reranked;
- what was assembled into the prompt;
- and which sources support the answer.

Before choosing an embedding model or database, define the context contract.

Then evaluate the pipeline in parts:

1. retrieval relevance;
2. context sufficiency and noise;
3. answer faithfulness;
4. citation coverage.

The practical shift is simple: debug the context before blaming the model.

Sources are in the final slide.

## Source and claim notes

- The framing and recommendations are editorial analysis, not a reported
  personal result.
- The original RAG paper describes combining parametric and non-parametric
  memory for knowledge-intensive tasks.
- The pipeline language is a practical decomposition for this sample, not a
  claim that every RAG system must use the same components.

## Visual-generation handoff

- Visual status: `created`
- Chosen page count: `5` for this argument
- Color scheme: `Lime Signal` (persisted for rerenders)
- Layout archetypes: `cover`, `chat`, `diagram`, `closing`
- Identity anchors: top left `M. Ahsan Izhar`; top right `ahsanizhar.com`;
  bottom right `Senior Software Engineer`
- Output: `post-rag-context-contract-2026-09-25.pdf`
- QA receipt: recorded after PDF rendering and inspection

## Sources

- Lewis et al., “Retrieval-Augmented Generation for Knowledge-Intensive NLP
  Tasks,” 2020: [paper](https://arxiv.org/abs/2005.11401)
