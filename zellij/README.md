# Zellij LazyAI Layouts

Zellij layouts for a "God Mode" development environment with git interface and AI coding assistant.

## Quick Start

### Using the Launcher Script

The launcher script defaults to `opencode` but allows you to choose any editor:

```bash
# Default (uses opencode)
./zellij/launch-lazyai.sh

# Use Claude instead
./zellij/launch-lazyai.sh claude

# Use opencode explicitly
./zellij/launch-lazyai.sh opencode

# Use different layout variant
./zellij/launch-lazyai.sh opencode lazyai-b.kdl
./zellij/launch-lazyai.sh claude lazyai-b.kdl
```

### Direct Zellij Launch

You can also launch directly with zellij by setting the `AI_EDITOR` environment variable:

```bash
# Default (uses opencode)
AI_EDITOR=opencode zellij -l zellij/layouts/lazyai.kdl

# Use Claude
AI_EDITOR=claude zellij -l zellij/layouts/lazyai.kdl
```

## Shell Aliases (Optional)

Add these to your `~/.zshrc` or `~/.bashrc` for quick access:

```bash
# LazyAI with opencode (default)
alias lazyai='AI_EDITOR=opencode zellij -l ~/personal-workspace/devkit/zellij/layouts/lazyai.kdl'

# LazyAI with claude
alias lazyai-claude='AI_EDITOR=claude zellij -l ~/personal-workspace/devkit/zellij/layouts/lazyai.kdl'

# LazyAI-B variant with opencode
alias lazyaib='AI_EDITOR=opencode zellij -l ~/personal-workspace/devkit/zellij/layouts/lazyai-b.kdl'
```

## Layouts

### `lazyai.kdl`
Simple 2-pane layout:
- **Left (30%)**: LazyGit
- **Right (70%)**: AI Editor (opencode/claude)

### `lazyai-b.kdl`
3-pane layout with workbench:
- **Top Left (30%)**: LazyGit
- **Top Right (70%)**: AI Editor (opencode/claude)
- **Bottom**: Terminal workbench (for btop, npm run dev, etc.)

## Environment Variables

- `AI_EDITOR`: The command to launch for the AI editor pane
  - Default: `opencode`
  - Options: `opencode`, `claude`, `cursor`, or any CLI command

## Customization

To add more editor options or customize the layouts:

1. Edit the layout files in `zellij/layouts/`
2. Use `$AI_EDITOR` variable for the editor command
3. Adjust pane sizes, splits, or add new panes as needed

## Tips

- The AI Editor pane starts with focus by default
- Press `Ctrl+p` in zellij to switch between panes
- Press `Ctrl+t` to create new tabs
- Use `btop` in the workbench pane to monitor system resources
