# Repository Guidelines

## Project Structure

- This workspace is a static harm-reduction warning site built from a local source export and public links.
- `index.html` contains the page content, warning copy, and source references.
- `archive.html` is a generated readable transcript of the local source export with obvious private identifiers redacted.
- `styles.css` contains all styling.
- `assets/` contains redacted, publishable images derived from reviewed source media.
- `result.json`, `sources.txt`, `photos/`, `video_files/`, `voice_messages/`, and `stickers/` are source material, not public site assets.

## Build, Test, and Run Commands

- There is no package manager, framework, build step, or generated bundle.
- Open `index.html` directly in a browser for local review.
- Open `archive.html` directly to review message anchors such as `archive.html#m77`.
- Use `rg` for source checks, for example `rg "archiv zpráv" index.html styles.css`.

## Content and Source Rules

- Keep public copy direct but source-aware: use phrases such as "poškození popisují", "podle archivovaných zpráv", "veřejné zdroje uvádějí", and "screenshot pátrání uvádí".
- Do not state criminal or warrant facts without a visible source label or qualified wording.
- Treat local export messages as source claims unless corroborated by a public or official source.
- Do not use insulting group names or harassment language as site branding.
- Main-page source references should link to `archive.html` anchors instead of showing bare message IDs where practical.

## Privacy and Redaction

- Do not publish raw phone numbers, bank accounts, emails, home addresses, dates of birth, ID document numbers, passports, or third-party personal details.
- Do not embed original media from `photos/`, `video_files/`, `voice_messages/`, or `stickers/`.
- Use only reviewed and redacted files from `assets/` for public images.
- Original media containing documents, phone numbers, accounts, addresses, DOB, or family details must remain private source material.
- If regenerating `archive.html`, preserve redaction of phone numbers, emails, account-like values, long private numeric identifiers, and internal actor/user IDs.

## Validation Guidelines

- Check the static page in a browser at desktop and mobile widths.
- Verify external links or clearly mark unavailable/source-lead links.
- Search the final site files for obvious unmasked identifiers before handoff.
- Review copy for legal certainty; replace unsupported definitive claims with sourced or qualified wording.
