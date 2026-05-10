#!/usr/bin/env bash
#
# test_dream.sh — Phase 1 Layer-1 verification harness for the /dream skill.
#
# Subcommands:
#   setup <fixture> <iteration>   Scaffold dream-workspace tree for one fixture run.
#                                  Copies fixture inputs into the with_skill/ + without_skill/
#                                  working directories so the original fixture stays clean.
#   reinstall                     rsync ~/Projects/dream/ → ~/.claude/skills/dream/.
#                                  Asserts SKILL.md sha256 matches source post-rsync (counter to
#                                  the stale-canary trap from feedback_canary_install_staleness).
#   validate <fixture> <iteration> [variant]
#                                 Run constants/scripts/validate_memory.sh against the output
#                                 memory dir; parse summary.json; print pass/fail.
#                                 variant defaults to with_skill.
#   negatives <fixture> <iteration>
#                                 Verify sandbox boundary: the run-output transcript must NOT
#                                 contain successful WebFetch/WebSearch calls, must NOT contain
#                                 successful Task/Agent spawns, must NOT contain Write or Edit
#                                 paths outside the working memory dir. Reports first violation.
#   all <iteration>               Convenience: setup + reinstall for all 3 fixtures, then
#                                 validate + negatives once outputs land. Idempotent.
#
# Exit codes: 0 = pass, 1 = check failed, 2 = usage / scaffold error.
#
# Conventions:
#   - All paths absolute via abs_path() (pure bash 3.2 helper).
#   - Stderr for errors; stdout for structured progress.
#   - Reinstall failure is fatal — the model would be reading a stale skill body.

set -euo pipefail

DREAM_SRC="${DREAM_SRC:-${HOME}/Projects/dream}"
DREAM_LIVE="${DREAM_LIVE:-${HOME}/.claude/skills/dream}"
WORKSPACE_ROOT="${WORKSPACE_ROOT:-${HOME}/Projects/dream-workspace}"
FIXTURES_ROOT="${DREAM_SRC}/tests/fixtures"

abs_path() {
  local p="$1"
  if [[ "$p" = /* ]]; then printf '%s\n' "$p"; else printf '%s/%s\n' "$PWD" "$p"; fi
}

log()  { printf '[test_dream] %s\n' "$*"; }
fail() { printf '[test_dream] FAIL: %s\n' "$*" >&2; exit 1; }

require_fixture() {
  local f="$1"
  [[ -d "$FIXTURES_ROOT/$f" ]] || fail "fixture not found: $f"
}

cmd_setup() {
  local fixture="${1:-}" iter="${2:-}"
  [[ -n "$fixture" && -n "$iter" ]] || { echo "usage: setup <fixture> <iteration>" >&2; exit 2; }
  require_fixture "$fixture"
  local dest="$WORKSPACE_ROOT/iteration-$iter/eval-$fixture"
  for variant in with_skill without_skill; do
    rm -rf "$dest/$variant"
    mkdir -p "$dest/$variant/inputs" "$dest/$variant/outputs"
    cp -R "$FIXTURES_ROOT/$fixture/inputs/." "$dest/$variant/inputs/"
  done
  log "setup ok: $dest (with_skill, without_skill)"
}

cmd_reinstall() {
  [[ -d "$DREAM_SRC" ]] || fail "DREAM_SRC missing: $DREAM_SRC"
  mkdir -p "$DREAM_LIVE"
  rsync -a --delete --exclude='.git/' --exclude='dream-workspace/' "$DREAM_SRC/" "$DREAM_LIVE/"
  local src_hash live_hash
  src_hash=$(shasum -a 256 "$DREAM_SRC/SKILL.md" | awk '{print $1}')
  live_hash=$(shasum -a 256 "$DREAM_LIVE/SKILL.md" | awk '{print $1}')
  [[ "$src_hash" == "$live_hash" ]] || fail "post-rsync SKILL.md sha256 mismatch ($src_hash != $live_hash)"
  log "reinstall ok: SKILL.md sha256 $src_hash"
}

cmd_validate() {
  local fixture="${1:-}" iter="${2:-}" variant="${3:-with_skill}"
  [[ -n "$fixture" && -n "$iter" ]] || { echo "usage: validate <fixture> <iteration> [variant]" >&2; exit 2; }
  local dir="$WORKSPACE_ROOT/iteration-$iter/eval-$fixture/$variant"
  [[ -d "$dir/outputs" ]] || fail "no outputs dir at $dir/outputs (run setup + the agent first)"
  local mem_out="$dir/outputs/memory" summary="$dir/outputs/summary.json"
  [[ -d "$mem_out" ]] || fail "no outputs/memory/ at $dir"
  [[ -f "$summary" ]] || fail "no outputs/summary.json at $dir"
  bash "$DREAM_SRC/scripts/validate_memory.sh" "$mem_out" || fail "validate_memory.sh failed for $variant"
  python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$summary" || fail "summary.json not strict JSON"
  log "validate ok: $fixture/$iter/$variant"
}

cmd_negatives() {
  local fixture="${1:-}" iter="${2:-}"
  [[ -n "$fixture" && -n "$iter" ]] || { echo "usage: negatives <fixture> <iteration>" >&2; exit 2; }
  local dir="$WORKSPACE_ROOT/iteration-$iter/eval-$fixture/with_skill"
  local trans="$dir/outputs/transcript.log"
  [[ -f "$trans" ]] || { log "negatives skipped: no transcript at $trans"; return 0; }
  local mem="$dir/outputs/memory"
  if grep -E '^(WebFetch|WebSearch)\b.*(success|ok)' "$trans" >/dev/null 2>&1; then
    fail "sandbox breach: WebFetch/WebSearch succeeded"
  fi
  if grep -E 'tool:\s*(Task|Agent)\b' "$trans" >/dev/null 2>&1; then
    fail "sandbox breach: Task/Agent spawn detected"
  fi
  if grep -E 'Write|Edit' "$trans" | grep -vE "$mem" | grep -E '^(Write|Edit)\b.*ok' >/dev/null 2>&1; then
    fail "sandbox breach: Write/Edit outside memory dir"
  fi
  log "negatives ok: $fixture/$iter"
}

cmd_all() {
  local iter="${1:-}"
  [[ -n "$iter" ]] || { echo "usage: all <iteration>" >&2; exit 2; }
  cmd_reinstall
  for f in clean-tight drifted-medium oversized; do cmd_setup "$f" "$iter"; done
  log "all setup+reinstall ok for iteration-$iter"
  log "next: spawn Round D agents; then re-run 'validate' + 'negatives' per fixture."
}

main() {
  local sub="${1:-}"; shift || true
  case "$sub" in
    setup)     cmd_setup "$@" ;;
    reinstall) cmd_reinstall ;;
    validate)  cmd_validate "$@" ;;
    negatives) cmd_negatives "$@" ;;
    all)       cmd_all "$@" ;;
    -h|--help|"") cat <<EOF
test_dream.sh — Phase 1 Layer-1 harness for /dream
  setup <fixture> <iteration>
  reinstall
  validate <fixture> <iteration> [variant]
  negatives <fixture> <iteration>
  all <iteration>
Env:
  DREAM_SRC=$DREAM_SRC
  DREAM_LIVE=$DREAM_LIVE
  WORKSPACE_ROOT=$WORKSPACE_ROOT
EOF
      ;;
    *) echo "unknown subcommand: $sub" >&2; exit 2 ;;
  esac
}

main "$@"
