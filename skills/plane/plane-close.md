---
name: plane-close
description: Post-merge cleanup. Updates the linked Plane.so issue to Done, posts a closing comment with merge SHA, and checks if blocked issues are now unblocked. Use when the user wants to close out a Plane issue after a PR is merged.
argument-hint: "[PR number, URL, or blank for current branch]"
allowed-tools: [Bash, Read, AskUserQuestion, mcp__plane__retrieve_work_item_by_identifier, mcp__plane__retrieve_work_item, mcp__plane__update_work_item, mcp__plane__create_work_item_comment, mcp__plane__list_work_item_relations, mcp__plane__list_states, mcp__plane__list_projects]
---

# Plane Post-Merge Close

After a PR is merged, update the linked Plane.so issue to Done, post a closing comment, and check if any blocked issues are now unblocked.

## Input

`$ARGUMENTS` may contain:
- A PR number (e.g., `42`)
- A PR URL (e.g., `https://github.com/org/repo/pull/42`)
- `--issue ZEN-42` — skip PR lookup, close the issue directly
- Empty — auto-detect the most recently merged PR for the current branch

---

## Phase 1: Identify the Merged PR

### Step 1: Resolve the PR

If `$ARGUMENTS` contains a number or URL, use it directly. Otherwise, detect from the current branch:

```bash
gh pr view $(git branch --show-current) --json number,title,body,url,state,mergeCommit,headRefName
```

If no PR found, try listing recent merged PRs:

```bash
gh pr list --state merged --limit 5 --json number,title,headRefName,mergedAt,url
```

Present the list and use `AskUserQuestion` to let the user pick one.

### Step 2: Verify the PR is merged

```bash
gh pr view <number> --json number,title,body,url,state,mergeCommit,headRefName,mergedAt
```

If `state` is NOT `MERGED`, **stop immediately**:
> "PR #<number> is not merged (state: <state>). This skill only processes merged PRs."

Extract and store: PR number, title, body, URL, merge SHA (short form), branch name, merged date.

---

## Phase 2: Extract and Fetch the Plane Issue

### Step 1: Extract the Plane identifier

Search for `[A-Z]+-\d+` in this order:
1. PR title
2. PR body (look for `Plane Issue:`, `Issue:`, `Refs:`)
3. Branch name

If `$ARGUMENTS` contains `--issue <IDENTIFIER>`, use that directly.

If no identifier found, use `AskUserQuestion`:
> "No Plane issue identifier found. Provide the identifier (e.g., ZEN-42), or type 'skip' to skip Plane updates."

If `skip`, report no Plane updates made and stop.

### Step 2: Fetch the Plane issue

1. Parse identifier into `project_identifier` and `issue_identifier`
2. Call `mcp__plane__retrieve_work_item_by_identifier` with `expand: "assignees,labels,state"`
3. Store `project_id`, `work_item_id`, current state, and state_group

### Step 3: Check if already done

If the issue's `state_group` is already `completed`:
- Report: "Issue <IDENTIFIER> is already Done. Skipping state update."
- Skip the state update in Phase 3 but continue with closing comment and blocker check

---

## Phase 3: Update the Plane Issue

### Step 1: Resolve the Done state

Call `mcp__plane__list_states` with the `project_id`.
Find the state with `group: "completed"` — prefer one named "Done" if multiple exist.

### Step 2: Confirm the state change

Present:

```
## Plane Issue Update

Issue: <IDENTIFIER> — <title>
Current state: <state name> (<state_group>)
New state: Done (completed)
Merge SHA: <short SHA>
PR: #<number> — <url>
```

Use `AskUserQuestion` to confirm. If declined, skip state update but offer to continue with comment and blocker check.

### Step 3: Update the state

Call `mcp__plane__update_work_item` with:
- `project_id`, `work_item_id`, `state`: Done state UUID

### Step 4: Post closing comment

Call `mcp__plane__create_work_item_comment` with `comment_html`:

```html
<p>Closed via <a href="<PR URL>">PR #<number></a> (merge SHA: <code><short SHA></code>)</p>
<p><strong>Branch</strong>: <code><branch name></code></p>
<p><strong>Merged</strong>: <merged date></p>
```

---

## Phase 4: Check Blocked Issues

### Step 1: Fetch relations

Call `mcp__plane__list_work_item_relations` with `project_id` and `work_item_id`.

Look at the `blocking` list — issues that THIS item was blocking. If empty, skip to Phase 5.

### Step 2: Check if blocked issues are fully unblocked

For each issue in the `blocking` list (run in parallel):

1. Call `mcp__plane__retrieve_work_item` with `expand: "state"`
2. Call `mcp__plane__list_work_item_relations` for the blocked issue
3. Check its `blocked_by` list — for each blocker, check if state_group is `completed`
4. If ALL blockers are now `completed`, this issue is **fully unblocked**

### Step 3: Collect results

For each fully unblocked issue, note: identifier, title, current state, priority.

---

## Phase 5: Present Summary

```
## Post-Merge Cleanup Complete

### PR
- PR: #<number> — <url>
- Merge SHA: <short SHA>
- Branch: <branch name>

### Plane Issue
- Issue: <IDENTIFIER> — <title>
- State: <previous state> -> Done
- Closing comment posted

### Unblocked Issues
- <IDENTIFIER> — <title> [<priority>] — now fully unblocked and ready to work on
- <IDENTIFIER> — <title> [<priority>] — still blocked by <other IDENTIFIER>

(If no blocked issues: "This issue was not blocking any other items.")
```

---

## Constraints

- **Never close an issue if the PR is not merged** — always verify `state: MERGED` before any Plane updates
- **Never change Plane state without confirmation** — always use `AskUserQuestion`
- **If the issue is already Done**, skip the state update — do not error, just report and continue
- **Never delete or create work items** — only update state and post comments
- **Never merge or close PRs** — only read PR data
- **Do not automatically update blocked issues** — only report which are unblocked
- **Always include merge SHA and PR link** in the closing comment for traceability
- **If `gh` CLI is unavailable**, report the error and provide the manual command
- **If any Plane MCP call fails**, report the error and continue with remaining steps
