# Linux — The Next Step 🚀

A concise, practical guide to Linux for new users. This repository contains the source material (Markdown chapters and configuration) for the book "Linux — the next step" (Norwegian content).

**Purpose:** ⚙️

- Provide friendly, approachable explanations and examples for people moving beyond basic Linux usage.

**Audience:** 🎯

- New Linux users who want practical command-line skills, system tips, and reference material.

**What’s in this repo:** 📦

- **Chapters:** the `chapter/` directory contains individual Markdown files (one per chapter).
- **Build system:** the top-level `Makefile` defines targets to build EPUB, HTML, PDF, ODT, TeX and a single combined Markdown file.
- **Configuration and styles:** the `config/` and `styles/` directories hold pandoc defaults, Lua filters, and CSS/LaTeX styles.

- **Quick build & preview** 🛠️
- 
- Requirements: `pandoc`, `make`, `hunspell` (for spellcheck), and a TeX distribution for PDF output. On Linux, also `xdg-open` and `libreoffice` are used by preview targets.
- Build HTML: `make html`
- Build EPUB: `make epub`
- Build PDF: `make pdf` (may take longer)
- Build all formats: `make all`
- Preview outputs: `make preview` or use the individual `open-epub`, `open-html`, `open-pdf` targets.

- **Useful utilities** 🔧
- 
- Spellcheck all chapters: `make spellcheck`
- Spellcheck a single file: `make spellcheck-one file=chapter/05-omdirigering.md`

- **How to contribute** 🤝
- 
- Edit or add chapters in `chapter/` using Markdown.
- Keep chapters focused and small; the build concatenates them in the order present in the `chapter/` folder.
- Run `make html` locally to preview changes.
- Add uncommon words to `.hunspell_ignore` with `make add-word word=yourword` if spellcheck flags project-specific terms.