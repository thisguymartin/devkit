---
name: plane-sprint-run
description: Targets a milestone or multiple issues and works through them sequentially — plan, confirm, execute, commit, repeat — then opens PRs. Use when the user wants to batch-work a sprint or milestone from Plane.so.
argument-hint: "[milestone-name | ZEN-42 ZEN-43 ZEN-55 | project-name]"
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep, Agent, WebFetch, WebSearch, AskUserQuestion, mcp__plane__list_projects, mcp__plane__list_milestones, mcp__plane__retrieve_milestone, mcp__plane__list_milestone_work_items, mcp__plane__list_work_items, mcp__plane__retrieve_work_item, mcp__plane__retrieve_work_item_by_identifier, mcp__plane__list_states, mcp__plane__update_work_item, mcp__plane__list_labels, mcp__plane__list_cycles, mcp__plane__list_cycle_work_items, mcp__plane__list_modules, mcp__plane__list_module_work_items, mcp__plane__search_work_items, mcp__plane__create_work_item_comment, mcp__plane__create_work_item_link, mcp__plane__list_work_item_comments, mcp__plane__list_work_item_links, mcp__plane__list_work_item_relations, mcp__plane__get_me]
---

# Plane Sprint Run

Work through an entire milestone (or a set of selected issues) sequentially: plan, confirm, execute, commit, and move to the next. Open PRs at the end.

## Input

`$ARGUMENTS` may contain:
- A milestone name (e.g., `MVP Launch`) — fetches all actionable items in that milestone
- Multiple work item identifiers (e.g., `ZEN-42 ZEN-43 ZEN-55`) — uses those specific issues
- A project name alone — lists milestones and asks user to pick
- Empty — lists projects, then milestones, then asks user to pick

---

## Phase 1: Resolve the Work Queue

### Step 1: Detect input mode

Parse `$ARGUMENTS`:

- **Identifiers mode**: Contains one or more `[A-Z]+-\d+` patterns → extract all identifiers
- **Milestone mode**: Text that does NOT match an identifier pattern → treat as milestone or project name
- **Empty mode**: No arguments → interactive selection

### Step 2: Resolve the project

1. Call `mcp__plane__list_projects`
2. If `$ARGUMENTS` matches a project name (case-insensitive), select it
3. If identifiers provided, extract project prefix from the first identifier
4. If only one project, auto-select
5. If ambiguous, present list and use `AskUserQuestion` to pick

### Step 3: Fetch project metadata (run in parallel)

- `mcp__plane__list_states` — save IDs for: unstarted (Todo), started (In Progress), completed (Done), and any "In Review" state
- `mcp__plane__list_labels` — for display
- `mcp__plane__list_milestones` — for resolution

### Step 4: Resolve work items

**Identifiers mode:**
For each identifier, call `mcp__plane__retrieve_work_item_by_identifier` (parallelize up to 5). Validate all items are from the same project.

**Milestone mode:**
Match `$ARGUMENTS` to a milestone name (case-insensitive substring). If ambiguous, ask. Call `mcp__plane__list_milestone_work_items`. Filter to state_group `backlog` or `unstarted`.

**Empty mode:**
Present milestones:
```
## Select a milestone

1. MVP Launch (due Mar 30) — 8 items remaining
2. Polish (due Apr 15) — 5 items remaining
3. Public Beta (due May 1) — 12 items remaining
```
Use `AskUserQuestion` to pick. Then fetch and filter.

### Step 5: Enforce queue limit

If more than 10 actionable items:
- Show all items but recommend batches of 10 or fewer
- Ask: "This milestone has N items. Pick up to 10 for this run, or type `all`."
- Accept row numbers, identifier list, or `all`

### Step 6: Build dependency-sorted queue

For each item, call `mcp__plane__list_work_item_relations` (parallelize).

Sort the queue:
1. **Topological order** — If A is `blocked_by` B and both are in the queue, B comes first
2. **Within same tier**, sort by priority: urgent > high > medium > low > none
3. If a blocker is NOT in the queue and NOT completed, flag that item as potentially blocked

### Step 7: Present the work queue

```
## Sprint Run Queue

Milestone: MVP Launch (due Mar 30)
Branch: sprint/mvp-launch
Items: 6 actionable

### Execution Order
 #  | ID      | Priority | Title                          | Blocked By
 1  | ZEN-10  | urgent   | Set up database schema         | —
 2  | ZEN-12  | urgent   | Set up authentication flow     | —
 3  | ZEN-15  | high     | Implement task CRUD operations | ZEN-10 (in queue)
 4  | ZEN-18  | high     | Add keyboard shortcuts         | —
 5  | ZEN-20  | medium   | Implement dashboard widgets    | ZEN-15 (in queue)
 6  | ZEN-22  | medium   | Animate sidebar transitions    | —

### Warnings
- ZEN-25 skipped: blocked by ZEN-99 (not in queue, state: In Progress)
```

Use `AskUserQuestion` with options:
1. Confirm queue as-is
2. Reorder (provide new order)
3. Exclude items (list identifiers to skip)
4. Choose PR strategy: single PR (default) or one per issue

Save the PR strategy choice for Phase 4.

---

## Phase 2: Set Up the Sprint Branch

### Step 1: Check git status

Run `git status`. If uncommitted changes exist, warn and ask:
- Stash changes (`git stash`)
- Commit them first
- Abort

### Step 2: Create the sprint branch

**Single PR mode:**
```bash
git checkout -b sprint/<milestone-kebab-name>
```

If the branch already exists, ask: continue on it, or create `sprint/<name>-2`?

**Per-issue PR mode:**
Stay on `main` for now. Individual branches created per issue in Phase 3.

### Step 3: Post sprint start comments

For each issue in the queue, call `mcp__plane__create_work_item_comment`:
> "Sprint run started. Queued as item #N of M."

---

## Phase 3: Sequential Issue Processing Loop

**For each issue `i` of `N` in the queue:**

### Step 3.1: Announce current issue

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Issue [i/N]: ZEN-42 — Implement task CRUD operations
 Priority: high | Labels: implementation, backend
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 3.2: Load full issue details

1. Call `mcp__plane__retrieve_work_item` with `expand: "assignees,labels,state"` (if not already loaded)
2. In parallel: `list_work_item_comments`, `list_work_item_links`, `list_work_item_relations`

### Step 3.3: Check for blockers

If any `blocked_by` relation points to an issue NOT in `completed` state AND not already completed earlier in this sprint run:

```
ZEN-42 is blocked by ZEN-99 (state: In Progress, not in this sprint run).
```

Use `AskUserQuestion`: skip / work anyway / pause sprint

If skipped, mark as skipped, log reason, move to next issue.

### Step 3.4: Per-issue branch (per-issue PR mode only)

If PR strategy is `per-issue`:
```bash
git checkout main
git checkout -b type/ZEN-42-short-description
```

### Step 3.5: Generate lightweight implementation plan

Shorter than plane-work's full plan since the user already approved the queue:

1. Launch up to 2 Explore agents to find relevant files and study patterns
2. Present a compact plan:
   ```
   ### Plan: ZEN-42
   Approach: [1-2 sentences]
   Files: [list of files to create/modify]
   Steps: [numbered list, 3-6 steps]
   ```
3. Ask ONE confirming question if anything is ambiguous. Otherwise: "Proceed with this plan? [yes/skip/pause]"
4. If `skip`, mark as skipped and move to next
5. If `pause`, go to Phase 4 with whatever is done so far

### Step 3.6: Update Plane issue status

Call `mcp__plane__update_work_item` to set state to "In Progress".

### Step 3.7: Execute the work

Implement autonomously:

1. **Follow project conventions** — `CLAUDE.md`, `.prettierrc`, existing code patterns
2. **Small logical commits**:
   ```
   type(scope): description

   Refs: ZEN-42
   ```
3. **Never add dependencies** without asking
4. **If you hit a blocker** — STOP and ask. Do not guess.
5. **Write tests** if test patterns exist in the project

### Step 3.8: Run quality checks

After completing the issue's work (NOT after every file):
```bash
pnpm lint
pnpm format
```
Fix any issues and commit fixes.

### Step 3.9: Self-review

1. Diff against the last issue's end commit (or main for the first issue)
2. Check each acceptance criterion — verify it's met
3. Check `git status` — no unintended files
4. Remove debug code, console.logs, hardcoded values

### Step 3.10: Mark issue complete in Plane

1. Call `mcp__plane__update_work_item` to set state to "Done" (or "In Review" if that state exists)
2. Call `mcp__plane__create_work_item_comment`:
   ```
   Completed in sprint run. Commits: <count>.
   Branch: <branch-name>
   Changes: <1-2 line summary>
   ```

### Step 3.11: Checkpoint

1. Verify `git status` is clean
2. Display progress:
   ```
   Completed [i/N]: ZEN-42
   Remaining: ZEN-18, ZEN-20, ZEN-22
   Continue to next issue? [yes/pause]
   ```
3. Use `AskUserQuestion`. If `pause`, proceed to Phase 4.

**Per-issue PR mode:** Push branch and create PR now (Phase 4 Step 2 for this single issue), then `git checkout main` before looping.

---

## Phase 4: Finalize and Open PRs

### Step 1: Final quality pass

```bash
pnpm lint
pnpm format
```
Commit any final fixes.

### Step 2: Push and create PRs

**Single PR mode:**

```bash
git push -u origin sprint/<milestone-name>
```

Collect all completed issue identifiers. Create draft PR:

```bash
gh pr create --title "sprint(<scope>): <milestone-name> [ZEN-10 ZEN-12 ZEN-15 ...]" --body "$(cat <<'EOF'
## Sprint Run: <Milestone Name>

### Issues Completed
| ID | Title | Status |
|----|-------|--------|
| ZEN-10 | Set up database schema | Done |
| ZEN-12 | Set up authentication flow | Done |
| ZEN-22 | Animate sidebar transitions | Skipped (blocked) |

### Changes
- [Plain language summary per issue — NO code snippets]

### Files Modified
| File | Change | Related Issue |
|------|--------|---------------|
| `path/to/file.ts` | Added | ZEN-10 |

### Testing
- [ ] Lint passes (`pnpm lint`)
- [ ] Format passes (`pnpm format`)
- [ ] [Specific test items from acceptance criteria]
EOF
)" --base main --draft
```

**Per-issue PR mode:**
If any remain unpushed (paused sprint), push and create them now. Each PR follows the plane-work Phase 5 format.

### Step 3: Link PRs to Plane issues

For each completed issue:
1. `mcp__plane__create_work_item_link` with PR URL and title "Pull Request #NUMBER"
2. `mcp__plane__create_work_item_comment` with PR URL

### Step 4: Present sprint summary

```
## Sprint Run Complete

Milestone: MVP Launch
Branch: sprint/mvp-launch
PR: #<number> — <url>

### Results
| # | ID     | Title                          | Status  | Commits |
|---|--------|--------------------------------|---------|---------|
| 1 | ZEN-10 | Set up database schema         | Done    | 3       |
| 2 | ZEN-12 | Set up authentication flow     | Done    | 4       |
| 3 | ZEN-15 | Implement task CRUD operations | Done    | 5       |
| 4 | ZEN-20 | Implement dashboard widgets    | Skipped | —       |

### Summary
- Issues completed: X/N
- Issues skipped: Y (with reasons)
- Total commits: Z
- Total files changed: W
- PRs created: P

### Skipped Issues
- ZEN-20: Blocked by ZEN-99 (In Progress). Revisit when resolved.

### Follow-up
- [Manual testing needed]
- [Review notes for PR reviewer]
- [Remaining items for next sprint run]

All Plane issues updated with PR links and status.
```

---

## Constraints

- **Queue confirmation is mandatory** — never start executing without user approval
- **Ask before skipping** — if an issue is blocked or fails, always ask
- **Never force push**
- **Never create or delete Plane work items** — only read and update
- **Never add dependencies** without asking
- **Clean git state between issues** — verify `git status` is clean before each issue
- **Reorder for blockers** — if a blocker is in the queue but scheduled later, move it earlier automatically
- **Maximum 10 issues per run** — suggest splitting if more
- **Lint and format between issues**, not after every file
- **Pause is always an option** — user can stop between any two issues
- **Commit messages** always include `Refs: IDENTIFIER` in the body
- **Per-issue branches** use: `type/IDENTIFIER-short-description`
- **Sprint branches** use: `sprint/<milestone-kebab-name>`
- **If `gh` CLI unavailable**, report error and provide manual command
- **If any Plane MCP call fails**, report error and continue with next issue
