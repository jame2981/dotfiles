# ============================================================================
# aliases.sh — 全局共享别名（POSIX 兼容）
# ============================================================================

# --- 基础增强 ---
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# --- 安全操作 ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- 导航 ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Git 快捷 ---
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph -20'
alias gd='git diff'


# --- Dotfiles 快捷 ---
alias dot='cd $HOME/code/github/dotfiles'
alias dotup='cd $HOME/code/github/dotfiles && make all'

