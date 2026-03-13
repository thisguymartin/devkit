# ⚡️ Terminal God Mode: The Cheatsheet

## 🟢 Daily Workflow
| Command | Description |
| :--- | :--- |
| **`zdev`** | **Launch God Mode** (Opens AI + Git + Workbench layout) |
| `lg` | Open LazyGit manually |
| `ai` | Run OpenCode agent manually |
| `cat <file>` | Uses `bat` to read file with syntax highlighting |

---

## 🪟 Zellij (Window Manager)
*The workspace is split into "Panes" and "Tabs".*

| Goal | Shortcut | Notes |
| :--- | :--- | :--- |
| **Move Focus** | `Alt + Arrow Keys` | Or `Alt + h/j/k/l` |
| **New Pane** | `Alt + n` | Splits current pane |
| **Close Pane** | `Ctrl + d` | Or type `exit` |
| **New Tab** | `Alt + t` | Like a new browser tab |
| **Switch Tab** | `Alt + Left/Right` | Cycle through tabs |
| **Resize** | `Alt + [ ]` or `Alt + = -` | Increase/Decrease size |
| **Scroll Mode** | `Ctrl + s` | Then use arrows/PgUp/PgDn |
| **Detach** | `Ctrl + o` then `d` | Leaves session running in background |
| **Unlock/Lock**| `Ctrl + g` | **Important:** If shortcuts stop working, press this. |

---

## 🐙 LazyGit (Version Control)
*Launch with `lg`. Use your mouse or keyboard.*

| Goal | Shortcut | Notes |
| :--- | :--- | :--- |
| **Navigate** | `Arrow Keys` | Move between Files, Local, Commits panels |
| **Stage File** | `Space` | Toggles staged/unstaged |
| **Stage All** | `a` | Stages all files |
| **Commit** | `c` | Opens commit message dialog |
| **Push** | `P` | (Shift + p) Pushes to remote |
| **Pull** | `p` | Pulls from remote |
| **Undo** | `Z` | Undoes the last commit (Soft reset) |
| **View Diff** | `Enter` | Zoom into the changes of a file |
| **Help** | `?` | Shows all commands |

---

## 📂 Yazi (File Manager)
*Launch with `yazi`. Faster than Finder.*

| Goal | Shortcut |
| :--- | :--- |
| **Enter Folder** | `Right Arrow` or `l` |
| **Go Back** | `Left Arrow` or `h` |
| **Open File** | `Enter` (Opens in default editor) |
| **Select** | `Space` (Multi-select) |
| **Rename** | `r` |
| **Copy/Paste** | `y` (yank) / `p` (paste) |
| **Delete** | `d` then `d` |
| **Quit** | `q` |

---

## 🔍 Ripgrep (Search)
*Replaces VS Code global search. Usage: `rg [pattern]`*

| Command | Action |
| :--- | :--- |
| `rg "user_id"` | Find text in all files recursively |
| `rg "user_id" -t py` | Find only inside Python files |
| `rg "user_id" -t js` | Find only inside JavaScript files |
| `rg "user_id" --hidden`| Search hidden files too |
| `rg -i "User_ID"` | Case-insensitive search |

---

## 🦇 Bat (Reading Files)
*Replaces `cat`. It's a read-only viewer.*
* **Read:** `bat filename.py`
* **Exit:** Press `q`

## 📈 Btop (System Monitor)
* **Launch:** `btop`
* **Kill Process:** Click process → `k` → "Kill"
* **Change View:** `m` (Mini), `p` (Preset)

---

## 🧭 Zoxide (Smart cd)
| Command | Action |
| :--- | :--- |
| `z projects` | Jump to most-visited dir matching "projects" |
| `z my app` | Fuzzy match multiple words |
| `zi` | Interactive selection with fzf |
| `z -` | Jump to previous directory |

---

## 🔎 FZF (Fuzzy Finder)
| Shortcut | Action |
| :--- | :--- |
| `Ctrl+T` | Find and insert file path |
| `Alt+C` | cd into a directory |
| `Ctrl+R` | Search command history |
| `**<Tab>` | Trigger fzf completion (e.g., `vim **<Tab>`) |

---

## 🗂 Zellij Layouts
| Command | Layout |
| :--- | :--- |
| `zdev` | God Mode (AI + Git + Workbench) |
| `zfull` | Full Dev (Editor + LazyGit + Terminal) |
| `zgrove` | Grove — full-stack: server, logs, tests, git, files (4 tabs) |
| `ztest` | Test Runner — stacked unit/integration/E2E + watch mode |
| `zmig` | Migrations — runner, DB console, queries, seed data |
| `zapi` | API Dev — server + request logs + test + schema |
| `zpipe` | Pipeline — build, deploy, rollback, health checks |
| `zdebug` | Debug — log stacking, btop, floating notes, fix tab |
| `zmon` | Monitor (btop + logs + Docker) |
| `zdb` | Database (PostgreSQL + Redis) |
| `znode` | Node.js — dev server, vitest, lint, Drizzle DB, Docker |
| `zgo` | Go — go run, test, vet, benchmarks, modules, Docker |

**Tip:** Inside any layout, stacked panes show tabs on the left edge. Press `Alt+Arrow` to switch focus, then use Zellij's pane controls to expand/collapse stacks.

---

## 🎨 Git Delta
* Diffs are syntax-highlighted automatically via `core.pager = delta`
* **`n`** / **`N`** — Jump to next/previous file in diff
* Side-by-side view enabled by default
* Works in LazyGit automatically