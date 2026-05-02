# ============================================================================
# env.zsh — Dotfiles 统一入口（由 make shell-setup 自动注入 ~/.zshrc）
# ============================================================================

# --- PATH 工具函数 ---
# 强制插入：清除 PATH 中所有同名条目，再插到最前面（唯一且第一）
path_insert() {
    local -a _result=()
    local _dir
    for _dir in ${(s/:/)PATH}; do
        [[ "$_dir" != "$1" ]] && _result+=("$_dir")
    done
    export PATH="$1:${(j/:/)_result}"
}

# 全局去重 + 撤销 path_helper 重排
# 1. 识别 macOS path_helper 管理的系统路径（/etc/paths + /etc/paths.d）
# 2. 将自定义路径归到系统路径前面（撤销 path_helper 的强制提前）
# 3. 保留末次出现，删除前面的冗余副本（第三方工具重复注入的路径）
path_dedup() {
    # --- 撤销 path_helper 重排 ---
    if [[ -x /usr/libexec/path_helper ]]; then
        local _sys_raw
        _sys_raw=$(PATH="" /usr/libexec/path_helper -s 2>/dev/null)
        if [[ -n "$_sys_raw" ]]; then
            local _sys_path="${_sys_raw#PATH=\"}"
            _sys_path="${_sys_path%%\";*}"
            typeset -A _sys_set=()
            local _d
            for _d in ${(s/:/)_sys_path}; do _sys_set[$_d]=1; done
            local -a _custom=() _system=()
            for _d in ${(s/:/)PATH}; do
                if (( ${+_sys_set[$_d]} )); then
                    _system+=("$_d")
                else
                    _custom+=("$_d")
                fi
            done
            PATH="${(j/:/)_custom}:${(j/:/)_system}"
        fi
    fi

    # --- 去重：保留末次出现 ---
    local -a _parts=(${(s/:/)PATH})
    typeset -A _last=()
    local _i
    for (( _i = 1; _i <= ${#_parts}; _i++ )); do
        _last[${_parts[$_i]}]=$_i
    done
    local -a _result=()
    for (( _i = 1; _i <= ${#_parts}; _i++ )); do
        (( _last[${_parts[$_i]}] == _i )) && _result+=("${_parts[$_i]}")
    done
    export PATH="${(j/:/)_result}"
}

# --- 路径优先级：~/.local/bin 最高 ---
path_insert "$HOME/.local/bin"

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
# 去重：保留末次出现，清除被 path_helper 等二次注入的前置副本
path_dedup
# 强制确保 ~/.local/bin 在最前面（唯一且第一）
path_insert "$HOME/.local/bin"

