# Terminal — only set TERM as fallback, don't override terminal emulators
if [[ "$TERM" == "dumb" || -z "$TERM" ]]; then
    export TERM=xterm-256color
fi

# Format claude --stream-json output as readable conversation
claude-view-stream() {
    jq --unbuffered -r '
    select(.type == "assistant" or .type == "user") |
    if .type == "assistant" then
        "assistant: " + (.message.content[] | select(.type == "text") | .text // "")
    elif .type == "user" then
        "user: " + (.message.content[] | select(.type == "text") | .text // "")
    else empty end
    ' | sed -u '/^$/d'
}

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
    auggie -p "用 git-commit-generator skill 直接提交暂存区代码，禁止执行任何 reset/restore/checkout/revert/stash 操作。请直接执行 commit 命令，跳过所有交互式确认，实现全自动提交" -m haiku4.5
}

cc-git-commit() {
    if [ -z "$(git diff --cached --name-only 2>/dev/null)" ]; then
        echo "暂存区为空，请先使用 git add 添加文件后再提交。"
        return 1
    fi
    claude -p "用 git-commit-generator skill 直接提交暂存区代码，禁止执行任何 reset/restore/checkout/revert/stash 操作。请直接执行 commit 命令，跳过所有交互式确认，实现全自动提交" --model sonnet
}



# auggie — tmux-aware AI tool wrapper
auggie() {
    local name=$(basename "$PWD")
    [ -n "$TMUX" ] && tmux rename-window "auggie-$name"
    if command -v timeout &>/dev/null; then
        timeout --foreground -k 1s 24h sh -c "command auggie \"\$@\"" -- "$@"
    else
        command auggie "$@"
    fi
    [ -n "$TMUX" ] && tmux set-window-option automatic-rename on
}

#claude() {
#    local ip=$(curl -s https://ipinfo.io  | jq .ip | tr -d '"')
#
#    if [[ "$ip" != "$CLAUDE_RUN_IP" ]]; then
#        echo "请先确认访问claude的IP地址当前IP ${ip}, 期望IP${CLAUDE_RUN_IP}"
#        return 1
#    fi
#
#    command claude "$@"
#}
