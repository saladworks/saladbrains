#!/usr/bin/env bash
# saladbrains.sh — scaffold a new AI code-agent project skeleton
# Usage:
#   PRJ_BASE=/path/to/project bash saladbrains.sh
#   curl -fsSL https://raw.githubusercontent.com/.../saladbrains.sh | bash
set -euo pipefail

PRJ_BASE="${PRJ_BASE:-$(pwd)}"

echo "Scaffolding project skeleton in: $PRJ_BASE"

# ---------------------------------------------------------------------------
# Directories
# ---------------------------------------------------------------------------
mkdir -p "$PRJ_BASE"
for TYPE in prov cpp rust java backend; do
    mkdir -p "$PRJ_BASE/brains/$TYPE"
done
mkdir -p "$PRJ_BASE/skills"
mkdir -p "$PRJ_BASE/staging"

# ---------------------------------------------------------------------------
# .gitignore
# ---------------------------------------------------------------------------
cat > "$PRJ_BASE/.gitignore" << 'TEMPLATE'
staging/
.DS_Store
*.log
*.tmp
TEMPLATE

# ---------------------------------------------------------------------------
# CLAUDE.md  (AI agent operating principles)
# ---------------------------------------------------------------------------
cat > "$PRJ_BASE/CLAUDE.md" << 'TEMPLATE'
# CLAUDE.md

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---
TEMPLATE

# Agent.md is identical to CLAUDE.md
cp "$PRJ_BASE/CLAUDE.md" "$PRJ_BASE/Agent.md"

# ---------------------------------------------------------------------------
# README.md
# ---------------------------------------------------------------------------
cat > "$PRJ_BASE/README.md" << 'TEMPLATE'
# Project Name

## Goal

<!-- Describe what this project does and why it exists. -->

## Principles

- Clarity over cleverness
- Minimum viable implementation
- Every decision traceable to a requirement

## Design & Architecture

<!-- High-level overview: key components, data flow, module boundaries. -->

## Key Technologies

| Technology | Role |
|------------|------|
|            |      |

## Build

```bash
# Install dependencies
# Build steps
```

## Installation

```bash
# How to install / deploy
```

## User Guide

<!-- How to use the project once it is running. -->
TEMPLATE

# ---------------------------------------------------------------------------
# brains/<type>/req.md
# ---------------------------------------------------------------------------
write_req() {
    local dir="$1"
    cat > "$dir/req.md" << 'TEMPLATE'
# Requirements

## Purpose

<!-- What does this project do? -->

## Scope

- [ ] Core functionality
- [ ] Interfaces / APIs
- [ ] Non-goals

## Inputs / Outputs

<!-- Data in, data out -->
TEMPLATE
}

# ---------------------------------------------------------------------------
# brains/<type>/plan.md
# ---------------------------------------------------------------------------
write_plan() {
    local dir="$1"
    cat > "$dir/plan.md" << 'TEMPLATE'
# Plan

## Steps

1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]

## Open Questions

-
TEMPLATE
}

# ---------------------------------------------------------------------------
# brains/<type>/verify.md
# ---------------------------------------------------------------------------
write_verify() {
    local dir="$1"
    cat > "$dir/verify.md" << 'TEMPLATE'
# Verification

## Checklist

- [ ] Build succeeds with no warnings
- [ ] All tests pass
- [ ] Manual smoke test passes

## How to Run

```bash
# build and test command
```
TEMPLATE
}

# ---------------------------------------------------------------------------
# brains/<type>/tool.md  (type-specific)
# ---------------------------------------------------------------------------
write_tools_prov() {
    cat > "$1/tool.md" << 'TEMPLATE'
# Prerequisite Tools

| Tool   | Version | Purpose            | Install |
|--------|---------|--------------------|---------|
| bash   | >= 4.0  | scripting          | system  |
| docker | latest  | container runtime  | https://docs.docker.com/get-docker/ |
TEMPLATE
}

write_tools_cpp() {
    cat > "$1/tool.md" << 'TEMPLATE'
# Prerequisite Tools

| Tool        | Version | Purpose         |
|-------------|---------|-----------------|
| gcc / clang | >= 11   | C/C++ compiler  |
| cmake       | >= 3.20 | build system    |
| make        | any     | build runner    |
TEMPLATE
}

write_tools_rust() {
    cat > "$1/tool.md" << 'TEMPLATE'
# Prerequisite Tools

| Tool   | Version | Purpose                   |
|--------|---------|---------------------------|
| rustup | latest  | toolchain manager         |
| cargo  | >= 1.70 | build & package manager   |
TEMPLATE
}

write_tools_java() {
    cat > "$1/tool.md" << 'TEMPLATE'
# Prerequisite Tools

| Tool           | Version | Purpose              |
|----------------|---------|----------------------|
| JDK            | >= 17   | Java compiler/runtime|
| maven / gradle | latest  | build tool           |
TEMPLATE
}

write_tools_backend() {
    cat > "$1/tool.md" << 'TEMPLATE'
# Prerequisite Tools

| Tool                      | Version          | Purpose          |
|---------------------------|------------------|------------------|
| runtime (node/python/go/..)| project-specific | server runtime   |
| docker                    | latest           | containerization |
| curl / httpie             | any              | API testing      |
TEMPLATE
}

# Provisioning brain (custom req.md)
PROV="$PRJ_BASE/brains/prov"
cat > "$PROV/req.md" << 'TEMPLATE'
# Requirements

## Purpose

<!-- What does this provisioning project do? -->

## Scope

- [ ] Target environment (Docker / VM / bare-metal)
- [ ] Target OS / distro
- [ ] Tools to install

## Inputs

<!-- Parameters the scripts accept -->

## Expected Outputs

<!-- What is created / installed when done -->
TEMPLATE
write_plan   "$PROV"
write_tools_prov "$PROV"
write_verify "$PROV"

# Remaining types
for TYPE in cpp rust java backend; do
    DIR="$PRJ_BASE/brains/$TYPE"
    write_req    "$DIR"
    write_plan   "$DIR"
    "write_tools_$TYPE" "$DIR"
    write_verify "$DIR"
done

# ---------------------------------------------------------------------------
echo "Done. Skeleton created in $PRJ_BASE"
echo ""
echo "Next steps:"
echo "  1. Edit README.md with your project goal"
echo "  2. Fill in brains/<type>/req.md with your requirements"
echo "  3. git init && git add . && git commit -m 'init: project skeleton'"
