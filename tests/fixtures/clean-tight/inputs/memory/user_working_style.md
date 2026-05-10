---
name: G Working Style
description: Max parallelism, sequential phases, terse delegation, paste-as-instruction pattern.
type: user
---

G's operational style:

- **Parallelism:** always asks for parallel tool calls; never serial when independent.
- **Phases:** work must proceed sequentially phase-by-phase with sign-off gates between.
- **Delegation:** terse instructions. No hand-holding. Agents expected to fill in gaps from context.
- **Paste-as-instruction:** G pastes raw text or screenshots and expects the agent to extract the instruction without being asked to clarify.

**How to apply:** When given a task, figure out the max parallelism across sub-tasks before starting. Don't ask for permission to proceed within a phase — move and report.
