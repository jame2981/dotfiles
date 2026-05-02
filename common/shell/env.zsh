# ============================================================================
# env.zsh — Dotfiles 统一入口（由 make shell-setup 自动注入 ~/.zshrc）
# ============================================================================

# --- PATH 工具函数 ---
# 幂等 prepend：仅当目录不在 PATH 中时才添加到最前面
path_prepend() {
    case ":${PATH}:" in
        *:"$1":*) ;;
        *) export PATH="$1:$PATH" ;;
    esac
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

# --- 兜底去重：清理第三方工具（gvm、nvm 等）带来的 PATH 重复 ---
path_dedup

