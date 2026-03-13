# devkit - Shell Enhancements
# Source this in your .zshrc: source ~/devkit/.config/shell/enhancements.zsh

# --- Zoxide (smart cd) ---
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# --- FZF + fd integration ---
if command -v fzf &> /dev/null; then
    # Use fd for file search (fast, respects .gitignore)
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
    fi

    # Ctrl+T preview with bat
    if command -v bat &> /dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    fi

    # Alt+C preview with eza tree
    if command -v eza &> /dev/null; then
        export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
    fi

    # Catppuccin Mocha color scheme for fzf
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --border --height=40%"
fi

# --- eza aliases ---
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias tree='eza --tree --icons --level=3'
fi

# --- Quick navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Zellij layout aliases ---
alias zmon='zellij --layout ~/devkit/zellij/layouts/monitor.kdl'
alias zdb='zellij --layout ~/devkit/zellij/layouts/database.kdl'
alias ztest='zellij --layout ~/devkit/zellij/layouts/testrunner.kdl'
alias zmig='zellij --layout ~/devkit/zellij/layouts/migrations.kdl'
alias zpipe='zellij --layout ~/devkit/zellij/layouts/pipeline.kdl'
alias zapi='zellij --layout ~/devkit/zellij/layouts/api.kdl'
alias zdebug='zellij --layout ~/devkit/zellij/layouts/debug.kdl'
alias znode='zellij --layout ~/devkit/zellij/layouts/node.kdl'
alias zgo='zellij --layout ~/devkit/zellij/layouts/golang.kdl'
