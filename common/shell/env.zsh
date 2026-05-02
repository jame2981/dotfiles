# ============================================================================
# env.zsh — Dotfiles 统一入口（由 make shell-setup 自动注入 ~/.zshrc）
# ============================================================================

# --- PATH 工具函数 ---
# 无条件 prepend：始终添加到最前面，由 path_dedup 兜底去重
# 这样可以正确处理"覆盖优先级"——后 prepend 的路径会排在更前面
path_prepend() {
    export PATH="$1:$PATH"
}

# 全局去重：保留首次出现的顺序，清除后续重复项
# 用于兜底清理第三方工具（gvm、nvm 等）无法控制的 PATH 污染
path_dedup() {
    typeset -A _seen
    local -a _result=()
    local _dir
    for _dir in ${(s/:/)PATH}; do
        if (( ! ${+_seen[$_dir]} )); then
            _seen[$_dir]=1
            _result+=("$_dir")
        fi
    done
    export PATH="${(j/:/)_result}"
}

# --- 路径优先级：~/.local/bin 最高 ---
path_prepend "$HOME/.local/bin"

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

# --- 最终 PATH 整理 ---
# 重新 prepend ~/.local/bin 确保它在所有第三方工具之前（最高优先级）
path_prepend "$HOME/.local/bin"
# 去重：保留首次出现（最前面的），清除后续重复项
path_dedup

