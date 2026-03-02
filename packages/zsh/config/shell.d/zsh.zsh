# Terminal
export TERM=xterm-256color

# WSL clipboard
alias pbcopy='iconv -f UTF-8 -t GBK | /mnt/c/Windows/SysWOW64/clip.exe'
alias pbpaste='/mnt/c/Windows/SysWOW64/WindowsPowerShell/v1.0/powershell.exe -noprofile -command "Get-Clipboard"'

# Claude shortcuts
alias oclaude='claude --model=anthropic/claude-opus-4-5'
alias hclaude='claude --model=anthropic/claude-haiku-4-5'
alias aliclaude='claude --settings ~/.claude/aliyun-settings.json'
alias c88claude='claude --settings ~/.claude/code88-settings.json'
aug-git-commit() {
    if [ -z "$(git diff --cached --name-only 2>/dev/null)" ]; then
        echo "暂存区为空，请先使用 git add 添加文件后再提交。"
        return 1
    fi
    auggie -p "使用 git-commit-generator skill 直接提交修改" -m haiku4.5
}

# auggie — tmux-aware AI tool wrapper
auggie() {
    local name=$(basename "$PWD")
    [ -n "$TMUX" ] && tmux rename-window "auggie-$name"
    timeout --foreground -k 1s 24h sh -c "command auggie \"\$@\"" -- "$@"
    [ -n "$TMUX" ] && tmux set-window-option automatic-rename on
}

