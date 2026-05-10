# Fixture: drifted-medium

**What this exercises:** Primary positive case — 3 planted drift cases of distinct types, each expecting exactly one UPDATE op. Confirms that dream's drift detection fires on project-status drift, reference-path drift, and feedback-preference reversal; and that it does NOT fire DELETE (contradicted-by-newer-signal alone is not grounds for deletion per the verification rule).

**Planted cases:**

1. **Project-status drift** (`project_analyzer_pipeline.md`, type: project) — Topic file says "Phase 2 in flight." The daily note from 2026-05-07 and the session entry from 2026-05-09 both state "Phase 2 closed and archived." Dream must UPDATE the status line; must NOT DELETE the file.

2. **Reference-path drift** (`reference_deploy_symlink.md`, type: reference) — Topic file claims a symlink exists at `~/tools/active → ~/projects/analyzer-pipeline`. The session entry notes this symlink was removed during a 2026-05-08 cleanup; `~/tools/active` no longer exists. Dream must UPDATE the symlink claim; the canonical-source claim (the underlying path) is still valid and should be preserved.

3. **Feedback-preference reversal** (`feedback_eval_scoring.md`, type: feedback) — Topic file says "scenario success rate is the signal; weighted score plateaus invisibly — drop it." The session entry from 2026-05-09 contains an explicit quote from G: "I want both metrics. Weighted score gives us trend lines, scenario rate gives us pass/fail. Don't drop either." Dream must UPDATE the body preserving the original guidance with a datestamp and adding the new direction. Must NOT DELETE. (This drift case is anonymized from a real tools-manager memory pattern: `feedback_eval_methodology.md` — which originally dismissed weighted scores before G reversed the preference.)

**Reviewer verification:** open `inputs/memory/` and check the three files above. Each contains a stale fact. Open `inputs/journals/sessions/2026-05-09-session-1.md` and `inputs/journals/daily-notes/2026-05-07.md` to confirm the contradicting signals are present and grounded.
