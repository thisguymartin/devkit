---
name: plane-triage
description: Finds untriaged Plane.so issues (missing milestone, labels, or priority), suggests values based on content analysis, and batch-applies after confirmation. Use when the user wants to triage, organize, or clean up backlog items.
argument-hint: "[project-name or priority-only|labels-only|milestone-only]"
allowed-tools: [AskUserQuestion, mcp__plane__list_projects, mcp__plane__list_milestones, mcp__plane__list_labels, mcp__plane__list_states, mcp__plane__list_work_items, mcp__plane__retrieve_work_item, mcp__plane__update_work_item, mcp__plane__add_work_items_to_milestone]
---

# Plane Issue Triage

Find unorganized backlog issues, suggest appropriate metadata, and batch-apply after user confirmation.

## Input

`$ARGUMENTS` may contain:
- A project name — filters to that project
- `priority-only` — only triage items missing priority
- `labels-only` — only triage items missing labels
- `milestone-only` — only triage items missing milestone
- Empty — auto-detect project and triage all missing metadata

---

## Phase 1: Resolve Project and Fetch Metadata

### Step 1: Resolve the project

1. Call `mcp__plane__list_projects`
2. If `$ARGUMENTS` matches a project name (case-insensitive substring), select it
3. If only one project, auto-select
4. If ambiguous, present the list and use `AskUserQuestion` to pick

### Step 2: Fetch project metadata (run in parallel)

- `mcp__plane__list_states` — build state ID to name/group map
- `mcp__plane__list_milestones` — collect active milestones with names, descriptions, due dates
- `mcp__plane__list_labels` — collect all existing labels with names

---

## Phase 2: Identify Untriaged Items

### Step 1: Fetch candidate work items

Call `mcp__plane__list_work_items` with:
- `state_groups: ["backlog", "unstarted"]`
- `limit: 50`

If more than 50 items exist, note the total and inform the user only the first batch is being triaged.

### Step 2: Filter to untriaged items

An item is **untriaged** if it is missing ANY of:
- **Priority**: value is `"none"` or null
- **Labels**: empty labels list
- **Milestone**: not assigned to any milestone

Apply `$ARGUMENTS` filter if set:
- `priority-only` — only items where priority is none/null
- `labels-only` — only items where labels list is empty
- `milestone-only` — only items with no milestone

### Step 3: Retrieve full details

For each untriaged item (up to 30), call `mcp__plane__retrieve_work_item` with `expand: "labels,state"` to get the full description.

If zero untriaged items found:
```
## Triage Complete

All backlog/unstarted items in {project_name} have priority, labels, and milestone assignments.
```
Stop.

---

## Phase 3: Analyze and Suggest

### Step 1: Analyze each item

For each untriaged item, read its `name` and description. Apply these heuristics:

**Priority suggestion** (when priority is none):
- `urgent` — keywords: crash, security, data loss, broken, blocker, critical, production
- `high` — keywords: bug, fix, regression, failing, error, auth, login, payment
- `medium` — keywords: implement, feature, add, create, build, refactor, update (default for implementation work)
- `low` — keywords: docs, documentation, style, cosmetic, nice-to-have, cleanup, typo, minor

**Label suggestion** (when labels are empty):
- Match against existing project label names using keyword analysis of title and description
- Common mappings: bug/fix/error → bug labels, feature/implement → implementation labels, test → testing labels, docs → documentation labels, refactor/cleanup → quality labels
- Only suggest labels that already exist in the project
- Suggest 1-2 labels maximum per item

**Milestone suggestion** (when no milestone):
- Small urgent/high tasks → nearest-due active milestone
- Large features → later milestones
- Spikes, research, docs → earliest milestone
- If milestone descriptions exist, match content to themes
- If no good match, suggest "No suggestion" rather than forcing

---

## Phase 4: Present and Confirm

### Step 1: Display the triage table

```
## Triage Suggestions — {project_name}

Found {N} untriaged items out of {total} backlog/unstarted items.

| # | Issue | Current State | Suggested Priority | Suggested Labels | Suggested Milestone |
|---|-------|--------------|-------------------|-----------------|-------------------|
| 1 | {ID} — {title} | pri: none, labels: none, ms: none | high | bug, backend | MVP Launch |
| 2 | {ID} — {title} | pri: none, labels: none, ms: none | medium | implementation | MVP Launch |
| 3 | {ID} — {title} | pri: low, labels: none, ms: none | — | documentation | Polish |

Legend: "—" = no change needed for that field
```

### Step 2: Ask for confirmation

Use `AskUserQuestion`:

> "Review the suggestions. You can:"
> 1. Apply all — update all items as suggested
> 2. Select rows — enter row numbers (e.g., "1, 3, 4")
> 3. Modify — tell me which rows to change before applying
> 4. Cancel — make no changes

If "Modify", apply edits, re-display, and ask again.

---

## Phase 5: Apply Changes

### Step 1: Batch-apply confirmed suggestions

For each confirmed row:

**Priority and labels** — call `mcp__plane__update_work_item` with:
- `project_id`, `work_item_id`
- `priority` (if suggested)
- `labels` (merge with existing — append, do not replace)

**Milestone** — call `mcp__plane__add_work_items_to_milestone` with:
- `project_id`, `milestone_id`, and the work item ID

Run updates in parallel where possible.

### Step 2: Present summary

```
## Triage Applied

Updated {N} items in {project_name}:

| Issue | Priority | Labels | Milestone |
|-------|----------|--------|-----------|
| {ID} — {title} | none -> high | +bug, +backend | -> MVP Launch |
| {ID} — {title} | none -> medium | +implementation | -> MVP Launch |

{M} items skipped.
```

---

## Constraints

- **Always confirm before applying** — never auto-apply without explicit user approval
- **Never create new labels or milestones** — only use existing ones
- **Merge labels, don't replace** — append to existing labels, never overwrite
- **Limit to 30 items per run** — suggest running again if more exist
- **No state changes** — only set priority, labels, and milestone
- **Conservative suggestions** — suggest "No suggestion" rather than a bad fit
- **Show the full table before any writes** — user must see all proposed changes first
- If any Plane MCP call fails, skip that item and continue
- If zero untriaged items, report the project is well-organized and stop
