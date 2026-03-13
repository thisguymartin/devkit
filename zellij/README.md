# Zellij Layouts

Purpose-built Zellij layouts for different development workflows.

For AI-powered worktree workspaces (AI agent + LazyGit + multi-branch), see [Grove](https://github.com/thisguymartin/grove).

## Available Layouts

| Layout | File | What It's For |
| :--- | :--- | :--- |
| Test Runner | `testrunner.kdl` | Stacked test suites (unit/integration/E2E) + watch mode |
| Migrations | `migrations.kdl` | Migration runner, DB console, queries, seed data |
| API Dev | `api.kdl` | Server + request logs + test + schema |
| Pipeline | `pipeline.kdl` | Build, deploy, rollback, container logs, health checks |
| Debug | `debug.kdl` | Log stacking, process inspector, floating notes |
| Monitor | `monitor.kdl` | btop + logs + Docker |
| Database | `database.kdl` | PostgreSQL + Redis consoles |
| Node.js | `node.kdl` | Dev server, vitest, lint, Drizzle migrations/studio, Docker |
| Go | `golang.kdl` | go run, go test, vet, benchmarks, modules, Docker |

## Usage

```bash
# Via shell aliases (after sourcing enhancements.zsh)
ztest
zapi
zdebug

# Or directly
zellij --layout ~/devkit/zellij/layouts/testrunner.kdl
```

## Tips

- Stacked panes show tabs on the left edge — use `Alt+Arrow` to switch focus
- Press `Ctrl+p` to switch between panes
- Press `Ctrl+t` to create new tabs
- Language-specific layouts start suspended — press ENTER to run commands
