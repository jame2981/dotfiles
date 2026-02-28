# ============================================================================
# functions.sh — 全局共享函数（POSIX 兼容）
# ============================================================================

# 生成随机字符串
randomstr() {
    local length=${1:-16}
    tr -dc 'a-zA-Z0-9' </dev/urandom | head -c "$length"
    echo
}

# 创建目录并进入
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 快速查找文件
ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}

# 快速查找目录
fd() {
    find . -type d -iname "*$1*" 2>/dev/null
}

# 解压万能命令
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

