#!/usr/bin/env bash
# Checkpoint Skill — Validation Test Suite
# Runs on Linux, macOS, and Windows (Git Bash / GitHub Actions)
# Exit on first failure
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
ERRORS=()

# --- Helpers ---

pass() {
  PASS=$((PASS + 1))
  printf "  \033[32m✓\033[0m %s\n" "$1"
}

fail() {
  FAIL=$((FAIL + 1))
  ERRORS+=("$1")
  printf "  \033[31m✗\033[0m %s\n" "$1"
}

section() {
  printf "\n\033[1m%s\033[0m\n" "$1"
}

assert_file_exists() {
  local file="$1"
  local label="${2:-$file}"
  if [[ -f "$REPO_ROOT/$file" ]]; then
    pass "$label exists"
  else
    fail "$label missing: $file"
  fi
}

assert_dir_exists() {
  local dir="$1"
  local label="${2:-$dir}"
  if [[ -d "$REPO_ROOT/$dir" ]]; then
    pass "$label exists"
  else
    fail "$label missing: $dir"
  fi
}

assert_file_contains() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if grep -qE "$pattern" "$REPO_ROOT/$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label — pattern not found in $file"
  fi
}

assert_frontmatter() {
  local file="$1"
  local label="${2:-$file}"
  local content
  content="$(head -5 "$REPO_ROOT/$file")"
  if echo "$content" | head -1 | grep -q '^---$'; then
    if echo "$content" | grep -q '^description:'; then
      pass "$label has valid frontmatter"
    else
      fail "$label frontmatter missing 'description' field"
    fi
  else
    fail "$label missing YAML frontmatter (must start with ---)"
  fi
}

assert_valid_json() {
  local file="$1"
  local label="${2:-$file}"
  local full_path="$REPO_ROOT/$file"
  if command -v node &>/dev/null; then
    if node -e "JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))" "$full_path" 2>/dev/null; then
      pass "$label is valid JSON"
    else
      fail "$label is invalid JSON"
    fi
  elif command -v python3 &>/dev/null; then
    if python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$full_path" 2>/dev/null; then
      pass "$label is valid JSON"
    else
      fail "$label is invalid JSON"
    fi
  elif command -v python &>/dev/null; then
    if python -c "import json,sys; json.load(open(sys.argv[1]))" "$full_path" 2>/dev/null; then
      pass "$label is valid JSON"
    else
      fail "$label is invalid JSON"
    fi
  else
    pass "$label JSON validation skipped (no python/node)"
  fi
}

# --- Tests ---

section "1. Required Files"
assert_file_exists "README.md" "README"
assert_file_exists "README.zh-TW.md" "README (zh-TW)"
assert_file_exists "LICENSE" "LICENSE"
assert_file_exists ".gitignore" ".gitignore"
assert_file_exists "skills/checkpoint/SKILL.md" "Core SKILL.md"
assert_file_exists "commands/checkpoint.md" "Main command"
assert_file_exists "commands/checkpoint/consolidate.md" "Consolidate sub-command"
assert_file_exists "docs/screenshot.jpg" "Screenshot"

section "2. Platform Variants"
assert_file_exists "cursor/rules/checkpoint.mdc" "Cursor rule"
assert_file_exists "vscode/instructions/checkpoint.md" "VSCode instructions"
assert_file_exists "vscode/prompts/checkpoint.prompt.md" "VSCode prompt"
assert_file_exists "codex/checkpoint/SKILL.md" "Codex CLI skill"

section "3. Plugin Manifests"
assert_file_exists ".claude-plugin/plugin.json" "Plugin manifest"
assert_file_exists ".claude-plugin/marketplace.json" "Marketplace manifest"
assert_valid_json ".claude-plugin/plugin.json" "plugin.json"
assert_valid_json ".claude-plugin/marketplace.json" "marketplace.json"

section "4. References"
assert_file_exists "skills/checkpoint/references/anti-amnesia-protocol.md" "Anti-Amnesia Protocol"
assert_file_exists "skills/checkpoint/references/memory-types.md" "Memory Types guide"
assert_file_exists "skills/checkpoint/references/consolidation.md" "Consolidation algorithm"

section "5. CI/CD"
assert_file_exists ".github/workflows/release.yml" "Release workflow"
assert_file_exists ".github/workflows/ci.yml" "CI workflow"

section "6. YAML Frontmatter Validation"
assert_frontmatter "skills/checkpoint/SKILL.md" "Core SKILL.md"
assert_frontmatter "commands/checkpoint.md" "Main command"
assert_frontmatter "commands/checkpoint/consolidate.md" "Consolidate sub-command"
assert_frontmatter "cursor/rules/checkpoint.mdc" "Cursor rule"

section "7. Content Integrity — Core SKILL.md"
SKILL="skills/checkpoint/SKILL.md"
assert_file_contains "$SKILL" "user.*feedback.*project.*reference|type.*user|memory types" "Mentions all 4 memory types"
assert_file_contains "$SKILL" "frontmatter|---" "References frontmatter format"
assert_file_contains "$SKILL" "MEMORY\.md|index" "References MEMORY.md index"
assert_file_contains "$SKILL" "SCAN|scan|Step 1" "Has SCAN step"
assert_file_contains "$SKILL" "CHECK|check.*existing|Step 2" "Has CHECK step"
assert_file_contains "$SKILL" "SAVE|save.*discover|Step [34]" "Has SAVE step"
assert_file_contains "$SKILL" "VERIFY|verify|Step [56]" "Has VERIFY step"

section "8. Content Integrity — Commands"
CMD="commands/checkpoint.md"
assert_file_contains "$CMD" '\$ARGUMENTS' "Main command accepts \$ARGUMENTS"
assert_file_contains "$CMD" "Step [12].*[Ss]can|scan.*conversation" "Scan step present"
assert_file_contains "$CMD" "Step.*[Cc]heck|existing memory" "Check step present"
assert_file_contains "$CMD" "MEMORY\.md" "References MEMORY.md"

CONSOL="commands/checkpoint/consolidate.md"
assert_file_contains "$CONSOL" "[Gg]host" "Consolidate detects ghosts"
assert_file_contains "$CONSOL" "[Oo]rphan" "Consolidate detects orphans"
assert_file_contains "$CONSOL" "[Dd]uplicate" "Consolidate detects duplicates"
assert_file_contains "$CONSOL" "[Mm]erge|MERGE" "Consolidate can merge"

section "9. Plugin Manifest Integrity"
PLUGIN=".claude-plugin/plugin.json"
assert_file_contains "$PLUGIN" '"checkpoint"' "Plugin name is checkpoint"
assert_file_contains "$PLUGIN" '"commands"' "Plugin declares commands"
assert_file_contains "$PLUGIN" '"skills"' "Plugin declares skills"
assert_file_contains "$PLUGIN" 'commands/checkpoint\.md' "Plugin points to main command"
assert_file_contains "$PLUGIN" 'skills/checkpoint/SKILL\.md' "Plugin points to core SKILL.md"

# Validate all paths referenced in plugin.json actually exist
section "10. Plugin Path Validation"
FULL_PLUGIN="$REPO_ROOT/$PLUGIN"
if command -v node &>/dev/null; then
  PATHS=$(node -e "
const d = JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'));
[...(d.skills||[]),...(d.commands||[])].forEach(x => x.path && console.log(x.path));
" "$FULL_PLUGIN" 2>/dev/null)
elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
  PY=$(command -v python3 || command -v python)
  PATHS=$($PY -c "
import json, sys
data = json.load(open(sys.argv[1]))
for s in data.get('skills', []):
    if 'path' in s: print(s['path'])
for c in data.get('commands', []):
    if 'path' in c: print(c['path'])
" "$FULL_PLUGIN" 2>/dev/null)
else
  PATHS=""
  pass "Plugin path validation skipped (no python/node)"
fi
while IFS= read -r p; do
  [[ -z "$p" ]] && continue
  if [[ -f "$REPO_ROOT/$p" ]]; then
    pass "Plugin path exists: $p"
  else
    fail "Plugin path missing: $p"
  fi
done <<< "$PATHS"

section "11. Markdown Link Validation (README)"
# Check that relative links in README point to existing files
while IFS= read -r link; do
  [[ -z "$link" ]] && continue
  # Skip URLs, anchors, badges
  [[ "$link" =~ ^https?:// ]] && continue
  [[ "$link" =~ ^# ]] && continue
  [[ "$link" =~ ^mailto: ]] && continue
  # Strip anchor from path
  clean="${link%%#*}"
  [[ -z "$clean" ]] && continue
  if [[ -f "$REPO_ROOT/$clean" ]] || [[ -d "$REPO_ROOT/$clean" ]]; then
    pass "README link valid: $clean"
  else
    fail "README link broken: $clean"
  fi
done < <(grep -oP '\]\(\K[^)]+' "$REPO_ROOT/README.md" 2>/dev/null || true)

section "12. No Platform-Specific Path Issues"
# Ensure no backslashes in any .md or .json files (Windows path leak)
BACKSLASH_FILES=$(grep -rlP '\\\\' "$REPO_ROOT"/*.md "$REPO_ROOT"/commands/ "$REPO_ROOT"/skills/ "$REPO_ROOT"/.claude-plugin/ 2>/dev/null || true)
if [[ -z "$BACKSLASH_FILES" ]]; then
  pass "No Windows backslash paths in content files"
else
  fail "Windows backslashes found in: $BACKSLASH_FILES"
fi

# Ensure no absolute paths
ABS_PATHS=$(grep -rnP '[A-Z]:\\|/home/|/Users/' "$REPO_ROOT"/*.md "$REPO_ROOT"/commands/ "$REPO_ROOT"/skills/ 2>/dev/null | grep -v 'example\|Example\|e\.g\.\|#' || true)
if [[ -z "$ABS_PATHS" ]]; then
  pass "No hardcoded absolute paths in content files"
else
  fail "Hardcoded absolute paths found: $ABS_PATHS"
fi

# --- Summary ---

printf "\n\033[1m━━━ Results ━━━\033[0m\n"
printf "  \033[32m%d passed\033[0m, \033[31m%d failed\033[0m\n" "$PASS" "$FAIL"

if [[ $FAIL -gt 0 ]]; then
  printf "\n\033[31mFailures:\033[0m\n"
  for err in "${ERRORS[@]}"; do
    printf "  • %s\n" "$err"
  done
  exit 1
fi

printf "\n\033[32mAll tests passed.\033[0m\n"
