# uv + python3 initialization
# Ensure uv-managed Python takes priority over system Python
export PATH="$HOME/.local/bin:$PATH"

# uv shell completion
eval "$(uv generate-shell-completion zsh 2>/dev/null)"
eval "$(uvx --generate-shell-completion zsh 2>/dev/null)"
