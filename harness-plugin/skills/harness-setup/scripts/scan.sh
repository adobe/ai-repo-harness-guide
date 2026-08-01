#!/usr/bin/env bash
# Copyright 2026 Adobe. All rights reserved.
# This file is licensed to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. You may obtain a copy
# of the License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.

# harness-setup: scan for existing harness artifacts
# Usage:  bash scripts/scan.sh [repo-root]
#         --help    print this message
# Stdout: TYPE<TAB>PATH for each artifact found (relative to repo root)
# Stderr: diagnostics and progress
# Exit 0: one or more artifacts found  →  use migrate path
# Exit 1: no artifacts found           →  use create path

set -uo pipefail

if [[ "${1:-}" == "--help" ]]; then
  sed -n '2,9p' "$0" | sed 's/^# //'
  exit 0
fi

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
declare -a RESULTS=()

found() { RESULTS+=("$1	$2"); }

# ── Core canonical files ──────────────────────────────────────────────────
if [[ -L "$ROOT/AGENTS.md" ]]; then
  target=$(readlink "$ROOT/AGENTS.md")
  if [[ "$(basename "$target")" == "CLAUDE.md" ]]; then
    found reversed-symlink AGENTS.md  # points at CLAUDE.md — backwards; AGENTS.md must hold the real content
  else
    found symlink AGENTS.md  # AGENTS.md must hold real content, not point elsewhere
  fi
elif [[ -f "$ROOT/AGENTS.md" ]]; then
  found canonical AGENTS.md
fi
[[ -f "$ROOT/INVARIANTS.md" ]] && found canonical    INVARIANTS.md

# CLAUDE.md — shim (only blank lines, comments, @-refs) vs real content
if [[ -f "$ROOT/CLAUDE.md" ]]; then
  real=$(grep -cEv '^\s*(#.*)?$|^@' "$ROOT/CLAUDE.md" 2>/dev/null) || real=0
  [[ "${real:-0}" -gt 0 ]] && found real-content CLAUDE.md \
                            || found shim         CLAUDE.md
fi

# ── Non-canonical agent-facing files ─────────────────────────────────────
# Add new tool-specific locations here as AI coding tools emerge.
[[ -f "$ROOT/.cursorrules" ]] && found non-canonical .cursorrules  # legacy; current is .cursor/rules/
[[ -f "$ROOT/.github/copilot-instructions.md" ]] \
  && found non-canonical .github/copilot-instructions.md

# .cursor/rules/ (current Cursor location) picked up by the .cursor directory scan below
for dir in .cursor .github/instructions ".claude"; do
  [[ -d "$ROOT/$dir" ]] || continue
  while IFS= read -r f; do
    rel="${f#"$ROOT/"}"
    [[ "$rel" == .claude/commands/* ]] && continue  # command shims are expected
    found non-canonical "$rel"
  done < <(find "$ROOT/$dir" \( -name "*.md" -o -name "*.mdc" \) 2>/dev/null)
done

# ── Misplaced skills (SKILL.md outside .agents/skills/) ──────────────────
while IFS= read -r f; do
  found misplaced-skill "${f#"$ROOT/"}"
done < <(find "$ROOT" -name "SKILL.md" \
           -not -path "$ROOT/.agents/skills/*" \
           -not -path "$ROOT/.git/*" 2>/dev/null)

# ── Existing canonical harness ────────────────────────────────────────────
while IFS= read -r f; do
  found canonical-skill "${f#"$ROOT/"}"
done < <(find "$ROOT/.agents/skills" -name "SKILL.md" 2>/dev/null)

# ── Docs and Makefile (inform which migrations are needed) ────────────────
[[ -d "$ROOT/docs" ]] && while IFS= read -r f; do
  found docs "${f#"$ROOT/"}"
done < <(find "$ROOT/docs" -name "*.md" 2>/dev/null)

[[ -f "$ROOT/Makefile" ]] && found makefile Makefile

# ── Output ────────────────────────────────────────────────────────────────
if [[ ${#RESULTS[@]} -eq 0 ]]; then
  printf 'No harness artifacts found.\n' >&2
  exit 1
fi

printf '%s\n' "${RESULTS[@]}"
exit 0
