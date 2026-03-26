---
name: plane-standup
description: Generates a daily standup summary from Plane.so showing completed items, in-progress work, blockers, and up-next queue. Use when the user wants a standup report or daily status update.
argument-hint: "[project-name or 'all']"
allowed-tools: [AskUserQuestion, mcp__plane__list_projects, mcp__plane__get_me, mcp__plane__list_states, mcp__plane__list_labels, mcp__plane__list_work_items, mcp__plane__retrieve_work_item, mcp__plane__list_work_item_relations, mcp__plane__list_work_item_links, mcp__plane__list_work_item_activities]
---

# Plane Daily Standup

Generate a formatted daily standup summary from current Plane.so project state.

## Input

`$ARGUMENTS` may contain:
- A project name — filters to that project
- `all` — include items across all projects
- Empty — auto-detect project (use sole project, or ask if multiple)

---

## Phase 1: Resolve Context

### Step 1: Identify the current user

Call `mcp__plane__get_me` to get the current user's ID and display name. Save both for filtering and display.

### Step 2: Resolve the project

1. Call `mcp__plane__list_projects`
2. If `$ARGUMENTS` matches a project name (case-insensitive substring), select it
3. If `$ARGUMENTS` is `all`, collect all project IDs
4. If only one project, auto-select
5. If ambiguous, present the list and use `AskUserQuestion` to pick

### Step 3: Fetch project metadata (run in parallel)

- `mcp__plane__list_states` — build state ID to name/group map
- `mcp__plane__list_labels` — for display

---

## Phase 2: Gather Work Items by Category

### Step 1: Fetch completed items (Done recently)

Call `mcp__plane__list_work_items` with:
- `assignee_ids: [current_user_id]`
- `state_groups: ["completed"]`
- `limit: 10`

For each item, call `mcp__plane__list_work_item_links` to find associated PR links (show PR number if available).

Filter to items completed within the last 48 hours if activity data is available. Otherwise show the most recent 10.

### Step 2: Fetch in-progress items

Call `mcp__plane__list_work_items` with:
- `assignee_ids: [current_user_id]`
- `state_groups: ["started"]`

For each item, call `mcp__plane__list_work_item_links` to find branch or PR links.

### Step 3: Identify blocked items

For each in-progress item AND each backlog/unstarted item assigned to the user, call `mcp__plane__list_work_item_relations`.

An item is **blocked** if it has `blocked_by` entries where the blocking item's state_group is NOT `completed`. Note the blocking issue identifier and name.

An item appears in only one section — Blocked takes precedence over In Progress or Up Next.

### Step 4: Fetch up-next items

From backlog/unstarted items assigned to the user (call `mcp__plane__list_work_items` with `assignee_ids` and `state_groups: ["backlog", "unstarted"]`), filter out blocked items. Sort by priority (urgent > high > medium > low > none). Cap at 5.

---

## Phase 3: Format and Present

### Step 1: Build the standup report

```
## Daily Standup — {current_date}

**{user_display_name}** | Project: {project_name}

### Done (since yesterday)
- {IDENTIFIER} — {title} [PR #N]
- {IDENTIFIER} — {title}
{or "None" if empty}

### In Progress
- {IDENTIFIER} — {title} (branch: branch-name)
{or "None" if empty}

### Blocked
- {IDENTIFIER} — {title} (blocked by {BLOCKER_ID}: {blocker_title})
{or "None" if empty}

### Up Next
- {IDENTIFIER} [{priority}] — {title}
- {IDENTIFIER} [{priority}] — {title}
{or "None" if empty}
```

### Step 2: Offer follow-up actions

Use `AskUserQuestion`:

> "Standup ready. Would you like to:"
> 1. Copy to clipboard
> 2. Done — no further action

If copy, use `pbcopy` (macOS) to copy the markdown.

---

## Constraints

- **Read-only** — never create, update, or delete any Plane data
- **Current user only** — only show items assigned to the authenticated user
- **Show all sections** — if a category has no items, display "None" rather than omitting
- **Cap output** — Done: max 10, In Progress: all, Blocked: all, Up Next: max 5
- **No duplicates** — an item appears in only one section (Blocked > In Progress > Up Next)
- **Date awareness** — use today's date in the header, prefer recently completed items for "Done"
- If any Plane MCP call fails, report the error and suggest checking workspace connection
