# LinkedIn document platform notes

These are implementation-time notes, not permanent guarantees. Recheck the
linked official LinkedIn Help pages before each implementation that depends on
platform limits, and record the retrieval date in the carousel brief or QA
receipt.

## Verified on 2026-09-25

LinkedIn's official guidance states that document uploads support PDF, PPT,
PPTX, DOC, and DOCX formats; the file size cannot exceed 100 MB and the page
limit is 300 pages. It also recommends converting to PDF when possible,
flattening or merging multi-layer PDFs, keeping pages the same size, and using
secure hyperlinks.

Sources:

- [Upload and share documents on LinkedIn](https://www.linkedin.com/help/linkedin/answer/a518909)
- [Media file types supported on LinkedIn](https://www.linkedin.com/help/linkedin/answer/a792945)

## Implications for this skill

- Five-page and seven-page documents are editorial choices, not platform
  requirements.
- Prefer a PDF deliverable when the user requests a LinkedIn document unless a
  different approved deliverable is needed.
- Check page count, file size, page dimensions, flattening, hyperlinks, and file
  type before reporting local QA.
- Do not claim upload success, rendering behavior, or mobile acceptance from
  these notes; only the user or an approved external workflow can verify that.
- If official guidance changes, update this reference and the QA checklist
  rather than silently applying stale limits.
