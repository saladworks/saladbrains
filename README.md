# saladbrains

## Goal

`saladbrains` is a scaffolding tool that generates a ready-to-use project skeleton optimised for AI code-agent workflows. Run one command and get a directory structure that both a human developer and an AI coding assistant (e.g. Claude Code) can navigate and extend immediately.

## Principles

- **Human + AI co-authorship** — every directory and file has a clear owner and purpose, legible to both agents and humans.
- **Minimum skeleton** — only what is universally needed; nothing project-specific is pre-filled.
- **Opinionated structure, flexible content** — the layout is fixed; the markdown files inside are yours to edit.
- **Curl-pipeable** — the single script is self-contained; no runtime dependencies beyond `bash`.

## Design & Architecture

```
saladbrains.sh          self-contained scaffold script (delivered to end users)

skeleton/               reference copy of every template file
  CLAUDE.md             AI agent operating principles
  Agent.md              identical copy of CLAUDE.md (agent-facing alias)
  .gitignore            excludes staging/ and noise files
  README.md             project README template
  brains/
    prov/               provisioning projects (Docker, VM, install scripts)
    cpp/                C / C++ projects
    rust/               Rust projects
    java/               Java projects
    backend/            Backend server projects
      req.md            requirements (human + agent editable)
      plan.md           implementation plan (agent-generated)
      tool.md           prerequisite tools
      verify.md         acceptance checklist
  skills/               domain-specific knowledge snippets
  staging/              ephemeral artefacts (images, VMs) — git-ignored
```

`saladbrains.sh` embeds all template content as heredocs and writes the full tree to `$PRJ_BASE`. No network access or external files are needed at run time.

## Key Technologies

| Technology | Role |
|------------|------|
| bash       | single-file scaffold script |
| Markdown   | all human/agent-readable content |

## Build

Nothing to build. The script is plain bash.

```bash
chmod +x saladbrains.sh
```

## Installation

**Option A — npm (recommended for local use)**

```bash
npm install -g saladbrains
saladbrains
```

**Option B — pipe from GitHub**

```bash
curl -fsSL https://raw.githubusercontent.com/saladworks/saladbrains/main/saladbrains.sh | bash
```

**Option C — clone and run locally**

```bash
git clone https://github.com/saladworks/saladbrains.git
cd saladbrains
bash saladbrains.sh
```

By default the skeleton is written to the current directory. Set `PRJ_BASE` to target a different path:

```bash
PRJ_BASE=~/projects/myapp bash saladbrains.sh
```

## User Guide

After running the script your project root will contain:

```
CLAUDE.md        read by the AI agent on every session
Agent.md         same content — a secondary entrypoint for agent tooling
README.md        fill in your project goal, architecture, and guides
.gitignore       staging/ and common noise files excluded
brains/          choose the subdirectory matching your project type
  prov | cpp | rust | java | backend
    req.md       write requirements here first
    plan.md      agent fills this in during planning
    tool.md      list prerequisite tools your project needs
    verify.md    define done — how to confirm the work is correct
skills/          add domain-specific markdown snippets here
staging/         drop large artefacts here; never committed to git
```

**Typical workflow:**

1. Edit `brains/<type>/req.md` — describe what you want to build.
2. Open the project in Claude Code (or your AI agent of choice).
3. The agent reads `CLAUDE.md` for operating principles and `brains/<type>/req.md` for goals.
4. The agent writes its plan to `brains/<type>/plan.md` and implements from there.
5. Use `brains/<type>/verify.md` to confirm the result before closing the task.
