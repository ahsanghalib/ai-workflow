# Google Drive layout

Use one root folder:

```text
LinkedIn Client Acquisition/
├── LinkedIn Client Acquisition            # native Google Sheet workbook
├── Content/
│   ├── Posts/                              # Markdown source artifacts
│   ├── Research/                           # research/evidence files
│   ├── Visuals/
│   │   ├── Images/
│   │   └── Carousels/
│   └── Archive/
└── Exports/
```

Rules:

- Preserve original Markdown filenames during the first migration.
- Do not convert every post to a Google Doc unless the user explicitly asks.
- Store the exact approved post body in the Sheet as a publishing snapshot so a
  browser workflow does not need local filesystem access.
- Visual files live in Drive; the Sheet stores their Drive links and QA state.
- Do not duplicate the same asset into several folders merely because it is
  referenced by several tabs.
