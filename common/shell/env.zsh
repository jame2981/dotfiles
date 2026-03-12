# ============================================================================
# env.zsh — Dotfiles 统一入口（由 make shell-setup 自动注入 ~/.zshrc）
# ============================================================================

# --- 路径优先级：~/.local/bin 最高 ---
export PATH="$HOME/.local/bin:$PATH"

# --- XDG 规范 ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --- 加载共享 Aliases ---
if [ -f "$HOME/.local/share/dotfiles/aliases.sh" ]; then
    source "$HOME/.local/share/dotfiles/aliases.sh"
fi

# --- 加载共享 Functions ---
if [ -f "$HOME/.local/share/dotfiles/functions.sh" ]; then
    source "$HOME/.local/share/dotfiles/functions.sh"
fi

# --- 加载包级别的 Shell 扩展 ---
for f in "$HOME/.local/share/dotfiles/shell.d"/*.zsh(N); do
    source "$f"
done

# --- 加载本地覆盖（机器专属，不入 git）---
[[ -f "$HOME/.dotfiles.local.zsh" ]] && source "$HOME/.dotfiles.local.zsh"

