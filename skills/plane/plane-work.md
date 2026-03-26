---
name: plane-work
description: Pulls issues from Plane.so organized by milestone, lets the user pick one, generates an implementation plan, creates a branch, works autonomously, then opens a draft PR. Use when the user wants to work on a Plane.so issue.
argument-hint: "[IDENTIFIER or project-name or filter]"
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep, Agent, WebFetch, WebSearch, AskUserQuestion, mcp__plane__list_projects, mcp__plane__list_milestones, mcp__plane__list_milestone_work_items, mcp__plane__list_work_items, mcp__plane__retrieve_work_item, mcp__plane__retrieve_work_item_by_identifier, mcp__plane__list_states, mcp__plane__update_work_item, mcp__plane__list_labels, mcp__plane__list_cycles, mcp__plane__list_cycle_work_items, mcp__plane__list_modules, mcp__plane__list_module_work_items, mcp__plane__search_work_items, mcp__plane__create_work_item_comment, mcp__plane__create_work_item_link, mcp__plane__list_work_item_comments, mcp__plane__list_work_item_links, mcp__plane__list_work_item_relations, mcp__plane__get_me]
---

# Plane Work Picker

Pick up a Plane.so issue, plan the implementation, execute it, and open a draft PR.

## Input

`$ARGUMENTS` may contain:
- A work item identifier (e.g., `ZEN-42`) — skips straight to Phase 2
- A project name — filters to that project
- Priority filter: `urgent`, `high`, `medium`, `low`
- A milestone or cycle name to scope the list
- Empty — lists all actionable items from the workspace

---

## Phase 1: Discover and Select Issue

### Step 1: Check for direct identifier

If `$ARGUMENTS` matches the pattern `[A-Z]+-\d+` (e.g., `ZEN-42`):
1. Extract the project identifier (letters before the dash) and sequence number (digits after)
2. Call `mcp__plane__retrieve_work_item_by_identifier` with `project_identifier` and `issue_identifier`
3. Skip directly to **Phase 2**

### Step 2: Resolve the project

1. Call `mcp__plane__list_projects` to list all workspace projects
2. If `$ARGUMENTS` contains text that matches a project name (case-insensitive substring), select that project
3. If only one project exists, auto-select it
4. If multiple projects and no match, present the list and ask the user to pick one

### Step 3: Fetch project metadata (run in parallel)

- `mcp__plane__list_states` with the project_id — capture all states, especially:
  - The state with group `started` (this is "In Progress") — save its ID for Phase 4
  - The state named "In Review" — save its ID for Phase 5
  - The state with group `completed` — save for reference
- `mcp__plane__list_labels` with the project_id — for display
- `mcp__plane__list_milestones` with the project_id — for grouping

### Step 4: Fetch actionable work items

Try these strategies in order:

**If milestones exist:**
- For each milestone that is active (not past due or explicitly completed), call `mcp__plane__list_milestone_work_items`
- Filter results to items in state_group `backlog` or `unstarted` only

**If no milestones, try cycles:**
- Call `mcp__plane__list_cycles` and find the current/active cycle
- Fetch work items for that cycle

**Flat list fallback:**
- Call `mcp__plane__list_work_items` with `state_groups: ["backlog", "unstarted"]`

Apply any priority filters from `$ARGUMENTS`.

### Step 5: Present the selection

Display issues grouped by milestone (or cycle, or ungrouped) like this:

```
## Pick an issue to work on

### Milestone: MVP Launch (due Mar 30)
 1. ZEN-12  [urgent]  Set up authentication flow          #infrastructure
 2. ZEN-15  [high]    Implement task CRUD operations       #implementation
 3. ZEN-18  [medium]  Add keyboard shortcuts               #implementation

### Milestone: Polish (due Apr 15)
 4. ZEN-22  [medium]  Animate sidebar transitions          #quality
 5. ZEN-25  [low]     Write API documentation              #documentation

### Backlog (no milestone)
 6. ZEN-30  [none]    Investigate Electron memory leak     #spike
```

Rules:
- Show: row number, identifier, priority in brackets, title, first label as hashtag
- Sort within each group by priority (urgent > high > medium > low > none)
- Limit to 25 items max; if more exist, tell the user and suggest filtering
- Use `AskUserQuestion` to let the user pick. Accept either the row number or the identifier.

---

## Phase 2: Load Issue Details

### Step 1: Retrieve full work item

If you don't already have the full details, call `mcp__plane__retrieve_work_item` (or `retrieve_work_item_by_identifier`) with `expand: "assignees,labels,state"`.

### Step 2: Fetch supplementary context (run in parallel)

- `mcp__plane__list_work_item_comments` — additional context from team
- `mcp__plane__list_work_item_links` — external references (design docs, Figma, specs)
- `mcp__plane__list_work_item_relations` — blockers and dependencies

### Step 3: Display issue summary

Present clearly to the user:

```
## Issue: ZEN-42 — Implement task CRUD operations

Priority: high | State: Todo | Labels: implementation, backend
Milestone: MVP Launch

### Description
[Plain-text rendering of description_html]

### Acceptance Criteria
[Extracted from description if present]

### Links
- [Link title](url)

### Related Issues
- Blocked by: ZEN-10 (Set up database schema) — Status: Done ✓
- Related to: ZEN-15 (Task list UI) — Status: In Progress

### Comments
- @user: "Make sure to follow the Conveyor pattern..."
```

### Step 4: Check for warnings

- **Blocked**: If any `blocked_by` relation points to an issue NOT in state_group `completed`, warn: "This issue is blocked by ZEN-XX which is not yet done. Continue anyway?"
- **Already in progress**: If the issue state_group is `started`, warn: "This issue is already marked In Progress. Continue anyway?"
- **No description**: If description is empty or very short, warn: "This issue has no detailed description. You may want to add context before proceeding."

Wait for user acknowledgment before continuing.

---

## Phase 3: Generate Implementation Plan

### Step 1: Explore the codebase

Based on the issue description, launch up to 3 Explore agents in parallel to:

1. **Find relevant files** — Search for component names, module names, function names, and keywords from the issue using Glob and Grep
2. **Study existing patterns** — Read similar features to understand conventions. If the issue involves a new Conveyor channel, read an existing schema + api + handler triplet. If it's a new UI feature, read a similar feature folder.
3. **Map dependencies** — Identify which files will need changes and what imports/depends on them

### Step 2: Draft the implementation plan

Present a structured plan:

```
## Implementation Plan for ZEN-42

### Approach
[1-2 paragraph technical summary]

### Files to Create
- `path/to/new-file.ts` — purpose

### Files to Modify
- `path/to/existing-file.ts` — what changes and why

### Implementation Steps
1. [Step with rationale]
2. [Step with rationale]
...

### Patterns to Follow
- "Follow the pattern in `focus-schema.ts` for schema definition"
- "Match the handler registration in `app.ts:45`"

### Risks and Open Questions
- [Anything unclear from the issue]
- [Assumptions that need validation]
```

### Step 3: Ask clarifying questions (MANDATORY)

You MUST ask the user at least one question before proceeding. Consider:

- Gaps in the issue description or acceptance criteria
- Ambiguous requirements that could go multiple ways
- Architecture decisions that aren't obvious
- Whether the planned scope matches their expectations
- Any assumptions you're making

Use `AskUserQuestion` for this. **Never assume an approach when the issue is ambiguous.**

### Step 4: Propose branch name

Suggest a branch name in this format:

```
type/IDENTIFIER-short-kebab-description
```

Examples:
- `feat/ZEN-42-implement-task-crud`
- `fix/ZEN-55-sidebar-overflow-bug`
- `refactor/ZEN-60-extract-shared-utils`
- `chore/ZEN-80-update-dependencies`

Type is derived from issue labels or content:
- `feat` — new functionality (default if ambiguous)
- `fix` — bug fix
- `refactor` — code restructuring
- `docs` — documentation only
- `chore` — maintenance, dependencies
- `test` — test additions
- `perf` — performance improvement

Ask the user to confirm the branch name and overall plan before proceeding.

---

## Phase 4: Execute Work

### Step 1: Set up the branch

```bash
git checkout -b <branch-name>
```

If the branch already exists, ask the user for an alternative name.

If `git status` shows uncommitted changes, warn the user and ask whether to:
- Stash changes (`git stash`)
- Commit them first
- Abort

### Step 2: Update Plane issue status

1. Call `mcp__plane__update_work_item` to set the state to the "In Progress" state ID (captured in Phase 1 Step 3)
2. Call `mcp__plane__create_work_item_comment` with: `"Work started on branch \`<branch-name>\`"`

### Step 3: Implement autonomously

Work through each step of the implementation plan. Follow these rules:

1. **Small logical commits** — After completing each logical unit (a new file, a feature slice), commit with:
   ```
   type(scope): description

   Refs: ZEN-42
   ```
2. **Follow project conventions** — Read and follow `CLAUDE.md` for project-specific patterns, `.prettierrc` for formatting, and existing code style
3. **Run linting after changes** — `pnpm lint` — fix any errors before moving on
4. **Run formatting** — `pnpm format` to match project style
5. **Never add new dependencies** without asking the user first
6. **If you hit an ambiguity or blocker** — STOP and ask the user. Do not guess.
7. **If tests exist** — Write tests following existing patterns. Run them.

### Step 4: Self-review

Before declaring work complete:

1. Run `pnpm lint` and `pnpm format` — fix any issues
2. Run `git diff main..HEAD` — review all changes
3. Go through each acceptance criterion from the issue — verify it's met
4. Check `git status` — ensure no unintended files were modified
5. Look for debug code, console.logs, hardcoded values, or secrets — remove them
6. If any acceptance criterion is NOT met, either implement it or note it explicitly

---

## Phase 5: Open Draft PR and Update Plane

### Step 1: Push the branch

```bash
git push -u origin <branch-name>
```

### Step 2: Create the draft PR

Use `gh pr create --draft` with a structured body.

**PR title format:**
```
type(scope): description [IDENTIFIER]
```
Example: `feat(tasks): implement CRUD operations [ZEN-42]`

**PR body structure:**

```markdown
## Overview

[2-3 sentence summary]

Plane Issue: IDENTIFIER

## Changes

- [Plain language bullet for each change — NO code snippets]

## Files Modified

| File | Change | Description |
|------|--------|-------------|
| `path/to/file.ts` | Added | New task schema definitions |
| `path/to/other.ts` | Modified | Registered new handler |

## Context

[Why this approach was taken, architectural decisions made]

## Testing

- [ ] Lint passes (`pnpm lint`)
- [ ] Format passes (`pnpm format`)
- [ ] [Specific test scenarios from acceptance criteria]

## Acceptance Criteria

- [ ] [Each criterion from the Plane issue, checked if completed]
```

If changes involve a new workflow, data pipeline, or API pattern, generate a flow diagram using `pr-flow-gen` and embed it under a **Flow** section.

Use a HEREDOC to pass the body:
```bash
gh pr create --title "type(scope): description [IDENTIFIER]" --body "$(cat <<'EOF'
...body content...
EOF
)" --base main --draft
```

### Step 3: Update the Plane issue

1. **Add PR link**: `mcp__plane__create_work_item_link` with the PR URL and title "Pull Request #NUMBER"
2. **Post comment**: `mcp__plane__create_work_item_comment` with:
   ```
   Draft PR opened: <PR URL>

   Changes include:
   - [summary of changes]
   ```
3. **Update state**: Call `mcp__plane__update_work_item` to set the state to "In Review".

### Step 4: Present final summary

```
## Work Complete

Issue: ZEN-42 — Implement task CRUD operations
Branch: feat/ZEN-42-implement-task-crud
PR: #<number> — <url>
Commits: <count>
Files changed: <count>

### What was done
- [Summary of completed work]

### Acceptance Criteria
- [x] Criterion 1
- [x] Criterion 2
- [ ] Criterion 3 (needs manual testing)

### Next steps
- [Manual testing needed]
- [Review notes for PR reviewer]
- [Follow-up items]

Plane issue updated with PR link and status.
```

---

## Constraints

- Never force push
- Never create or delete Plane work items — this skill only reads and updates
- Never add dependencies without asking
- Never assume an approach when the issue is ambiguous — always ask
- Always commit and push before creating the PR
- Always check for existing branches before creating new ones
- If `gh` CLI is unavailable, report the error and provide the manual command
- If any Plane MCP call fails, report the error and suggest checking workspace connection
- For large or vague issues, suggest breaking into sub-tasks before proceeding
