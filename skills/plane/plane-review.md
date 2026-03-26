---
name: plane-review
description: Reviews a PR against its linked Plane.so issue's acceptance criteria. Fetches the Plane issue, reads the PR diff, evaluates each criterion, and optionally posts a structured review comment. Use when the user wants to review a PR against Plane acceptance criteria.
argument-hint: "[PR number, URL, or blank for current branch]"
allowed-tools: [Bash, Read, Glob, Grep, AskUserQuestion, mcp__plane__retrieve_work_item_by_identifier, mcp__plane__retrieve_work_item, mcp__plane__list_work_item_comments, mcp__plane__list_work_item_links, mcp__plane__list_work_item_relations, mcp__plane__list_states, mcp__plane__list_projects, mcp__plane__create_work_item_comment]
---

# Plane PR Review

Review a pull request against the acceptance criteria defined in its linked Plane.so issue.

## Input

`$ARGUMENTS` may contain:
- A PR number (e.g., `42`)
- A PR URL (e.g., `https://github.com/org/repo/pull/42`)
- `--issue ZEN-42` — override to skip auto-detection of Plane identifier
- Empty — auto-detect the PR for the current branch

---

## Phase 1: Identify the PR

### Step 1: Resolve the PR

If `$ARGUMENTS` contains a number or URL, use it directly. Otherwise, detect from the current branch:

```bash
gh pr view $(git branch --show-current) --json number,title,body,url,state,headRefName
```

If no PR exists for the current branch, report the error and stop.

### Step 2: Fetch the full PR details

```bash
gh pr view <number> --json number,title,body,url,state,headRefName,additions,deletions,files
```

Store the PR number, title, body, URL, and branch name.

### Step 3: Validate PR state

If the PR is `MERGED` or `CLOSED`, warn: "This PR is already <state>. Review anyway?"
Use `AskUserQuestion` to confirm. If declined, stop.

---

## Phase 2: Extract and Fetch the Plane Issue

### Step 1: Extract the Plane identifier

Search for a pattern matching `[A-Z]+-\d+` in this order:
1. PR title (e.g., `feat(tasks): implement CRUD [ZEN-42]`)
2. PR body (look for `Plane Issue:`, `Issue:`, `Refs:`, or bare identifiers)
3. Branch name (e.g., `feat/ZEN-42-implement-task-crud`)

If `$ARGUMENTS` contains `--issue <IDENTIFIER>`, use that and skip auto-detection.

If no identifier is found, use `AskUserQuestion`:
> "No Plane issue identifier found in the PR. Please provide the identifier (e.g., ZEN-42), or type 'skip' to review without Plane criteria."

If the user types `skip`, proceed to Phase 3 with a general diff-only review (no acceptance criteria).

### Step 2: Fetch the Plane issue

1. Parse the identifier into `project_identifier` (letters) and `issue_identifier` (number)
2. Call `mcp__plane__retrieve_work_item_by_identifier` with `expand: "assignees,labels,state"`

### Step 3: Fetch supplementary context (run in parallel)

- `mcp__plane__list_work_item_comments` — team discussion and clarifications
- `mcp__plane__list_work_item_links` — external specs, designs, references
- `mcp__plane__list_work_item_relations` — blockers and dependencies

### Step 4: Extract acceptance criteria

Parse `description_html` or `description_stripped` for acceptance criteria. Look for:
- An "Acceptance Criteria" heading followed by a list
- Checkbox items under an AC heading
- Any bullet list describing expected behavior

If no criteria found, use `AskUserQuestion`:
> "No acceptance criteria found in the Plane issue. Provide criteria manually, or proceed with a general diff review?"

---

## Phase 3: Analyze the PR Diff

### Step 1: Fetch the diff

```bash
gh pr diff <number>
```

If the diff is over 2000 lines, also fetch the file list:

```bash
gh pr diff <number> --name-only
```

### Step 2: Evaluate each criterion

For each acceptance criterion, scan the diff to determine:
1. Is there code that directly addresses this criterion? Identify specific files and changes.
2. Is the implementation complete? Check for partial implementations, TODOs, or missing edge cases.
3. Are there issues? Look for bugs, missing error handling, style violations.

### Step 3: Check project conventions (if relevant)

If changes involve the Conveyor IPC system, verify:
- Schema in `lib/conveyor/schemas/`, API in `lib/conveyor/api/`, Handler in `lib/conveyor/handlers/`
- Registered in `schemas/index.ts`, `api/index.ts`, `lib/main/app.ts`

If changes involve a Zustand store, verify it follows patterns in `app/store/`.
If changes involve a feature module, verify self-contained structure in `app/features/<name>/`.

---

## Phase 4: Present the Review

### Step 1: Build the structured review

```
## PR Review: #<number> — <title>

Branch: <branch> | Files changed: <count> | +<additions> -<deletions>
Plane Issue: <IDENTIFIER> — <issue title>

### Acceptance Criteria Evaluation

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | [criterion text] | PASS / FAIL / PARTIAL | [file:line or summary] |
| 2 | [criterion text] | PASS / FAIL / PARTIAL | [file:line or summary] |

### Summary

- Criteria met: X/Y
- Criteria partially met: X/Y
- Criteria not met: X/Y

### Findings

#### Issues (must fix)
- [Critical problems that block approval]

#### Suggestions (nice to have)
- [Non-blocking improvements]

### Verdict

[APPROVE / REQUEST_CHANGES / COMMENT] — [1-2 sentence rationale]
```

### Step 2: Ask the user what to do

Use `AskUserQuestion`:

> "Review complete. What would you like to do?"
> 1. Post as a PR review (approve/request-changes/comment)
> 2. Post as a regular PR comment
> 3. Post a summary comment on the Plane issue
> 4. Just view — don't post anything

---

## Phase 5: Post the Review

### Option 1: PR review

```bash
gh pr review <number> --event APPROVE --body "$(cat <<'EOF'
## Acceptance Criteria Review — <IDENTIFIER>

| # | Criterion | Status |
|---|-----------|--------|
| 1 | [text] | :white_check_mark: PASS |
| 2 | [text] | :x: FAIL |

**Summary**: X/Y criteria met.

### Issues
- [List if any]

---
*Reviewed against <IDENTIFIER> acceptance criteria*
EOF
)"
```

Use `--event REQUEST_CHANGES` or `--event COMMENT` depending on verdict.

### Option 2: PR comment

```bash
gh pr comment <number> --body "$(cat <<'EOF'
...same body...
EOF
)"
```

### Option 3: Plane issue comment

Call `mcp__plane__create_work_item_comment` with a summary including verdict, criteria met count, and PR link.

### Step 3: Confirm completion

Report what was posted and where.

---

## Constraints

- **Never approve or merge PRs automatically** — always present the review first and get explicit confirmation
- **Never post comments without asking** — always use `AskUserQuestion` before posting to GitHub or Plane
- **If no Plane identifier found**, ask the user — never guess or fabricate
- **If no acceptance criteria exist**, fall back to a general diff review
- **Never modify the PR** (edit title, close, merge) — only read and post review comments
- **Never modify the Plane issue state** — only post comments
- **If `gh` CLI is unavailable**, report the error and provide the manual command
- **If any Plane MCP call fails**, report the error and continue with GitHub-only review
