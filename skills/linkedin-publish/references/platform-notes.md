# LinkedIn publishing platform notes

Implementation-time notes only. Recheck official LinkedIn Help before depending
on a current limit or supported feature.

Checked against official LinkedIn Help on 2026-09-28:

- Personal posts expose a scheduling control in the post composer.
- LinkedIn document posts support PDF, PPT/PPTX, DOC/DOCX; LinkedIn recommends
  PDF where possible and requires same-sized pages for multi-page documents.
- Document upload can use a local file or Google Drive/Dropbox from the LinkedIn
  upload flow when available.
- The public help page currently states a 100 MB / 300-page document ceiling.
- The current post-text limit is 3,000 characters.
- Scheduling is currently unavailable for Events, Jobs, and Services, and the
  scheduling window/interface should be rechecked at execution time.

Official references:

- [Schedule posts](https://www.linkedin.com/help/linkedin/answer/a1347212)
- [Upload and share documents](https://www.linkedin.com/help/linkedin/answer/a518909)
- [Document uploads FAQ](https://www.linkedin.com/help/linkedin/answer/a523054)
- [Post and share updates](https://www.linkedin.com/help/linkedin/answer/a528176)
