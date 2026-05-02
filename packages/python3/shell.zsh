# uv + python3 initialization
# ~/.local/bin is already in PATH via env.zsh

# uv shell completion
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion zsh 2>/dev/null)"
    eval "$(uvx --generate-shell-completion zsh 2>/dev/null)"
fi
