#!/usr/bin/env bash
# validate_memory.sh — Post-Prune validation gate for /dream
#
# Usage: validate_memory.sh <memory-dir>
#
# Checks (in order):
#   1. MEMORY.md exists                            guards against missing index
#   2. Line count <= 200                           hard cap
#   3. Byte size <= 25600                          hard cap
#   4. Non-empty, non-header lines <= 150 chars    hard cap (reports first offender)
#   5. Index link targets exist (or in archived/)  guards dangling pointers
#   6. Topic *.md files have YAML frontmatter      schema enforcement
#
# Exit codes: 0 = all pass, 1 = check failed (stderr), 2 = bad invocation
# Does NOT auto-fix — that retry path is handled by the calling SKILL.md.
# Constants must match constants.md in this directory.
set -euo pipefail

MAX_LINES=200
MAX_BYTES=25600
MAX_LINE_CHARS=150

if [[ $# -lt 1 ]] || [[ ! -d "$1" ]]; then
    echo "Usage: validate_memory.sh <memory-dir>" >&2
    exit 2
fi

MEMORY_DIR="$1"
MEMORY_FILE="${MEMORY_DIR}/MEMORY.md"

# Check 1: MEMORY.md exists
if [[ ! -f "$MEMORY_FILE" ]]; then
    echo "FAIL: missing_memory_md: MEMORY.md not found in ${MEMORY_DIR}" >&2
    exit 1
fi

# Check 2: Line count
line_count=$(wc -l < "$MEMORY_FILE")
if [[ "$line_count" -gt "$MAX_LINES" ]]; then
    echo "FAIL: line_cap_exceeded: MEMORY.md has ${line_count} lines (max ${MAX_LINES})" >&2
    exit 1
fi

# Check 3: Byte size
byte_count=$(wc -c < "$MEMORY_FILE")
if [[ "$byte_count" -gt "$MAX_BYTES" ]]; then
    echo "FAIL: byte_cap_exceeded: MEMORY.md is ${byte_count} bytes (max ${MAX_BYTES})" >&2
    exit 1
fi

# Check 4: Per-line char limit (skip blank lines and # headers)
line_num=0
while IFS= read -r line; do
    line_num=$(( line_num + 1 ))
    [[ -z "$line" ]] && continue
    [[ "$line" == \#* ]] && continue
    char_count=${#line}
    if [[ "$char_count" -gt "$MAX_LINE_CHARS" ]]; then
        echo "FAIL: line_too_long: line ${line_num} is ${char_count} chars (max ${MAX_LINE_CHARS}): ${line:0:80}..." >&2
        exit 1
    fi
done < "$MEMORY_FILE"

# Check 5: Index link targets exist in memory-dir or archived/
# Matches: - [Title](file.md)
line_num=0
link_rx='\]\(([^)]+\.md)\)'
while IFS= read -r line; do
    line_num=$(( line_num + 1 ))
    if [[ "$line" =~ $link_rx ]]; then
        target="${BASH_REMATCH[1]}"
        basename_target="${target##*/}"
        if [[ ! -f "${MEMORY_DIR}/${basename_target}" ]] && \
           [[ ! -f "${MEMORY_DIR}/archived/${basename_target}" ]]; then
            echo "FAIL: dangling_link: line ${line_num} links to '${target}' — not found in ${MEMORY_DIR} or ${MEMORY_DIR}/archived/" >&2
            exit 1
        fi
    fi
done < "$MEMORY_FILE"

# Check 6: Each topic *.md (excluding MEMORY.md) has YAML frontmatter
while IFS= read -r -d '' topic_file; do
    [[ "$(basename "$topic_file")" == "MEMORY.md" ]] && continue
    first_line=$(head -n 1 "$topic_file" 2>/dev/null || true)
    if [[ "$first_line" != "---" ]]; then
        echo "FAIL: missing_frontmatter: $(basename "$topic_file") does not open with ---" >&2
        exit 1
    fi
    closing=$(tail -n +2 "$topic_file" | grep -m1 "^---$" || true)
    if [[ -z "$closing" ]]; then
        echo "FAIL: missing_frontmatter: $(basename "$topic_file") has no closing --- delimiter" >&2
        exit 1
    fi
done < <(find "$MEMORY_DIR" -maxdepth 1 -name "*.md" -print0)

echo "OK: all 6 checks passed for ${MEMORY_DIR}"
exit 0
