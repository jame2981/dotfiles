# ============================================================================
# deps.mk — 跨发行版依赖映射
# ============================================================================
# 用法: $(call pkg_name,<通用名>)
# 返回当前系统对应的包名。若无映射则返回通用名本身。
#
# 添加新映射: 同时设置 PKG_apt_<name>, PKG_dnf_<name>, PKG_brew_<name>

# --- 编译工具链 ---
# macOS: build-essential 对应 xcode-select，通常已预装，留空跳过
PKG_apt_build-essential  := build-essential
PKG_dnf_build-essential  := gcc gcc-c++ make
PKG_brew_build-essential :=

PKG_apt_bison  := bison
PKG_dnf_bison  := bison
PKG_brew_bison := bison

PKG_apt_cmake  := cmake
PKG_dnf_cmake  := cmake
PKG_brew_cmake := cmake

# --- 开发库 ---
PKG_apt_libncurses-dev  := libncurses-dev
PKG_dnf_libncurses-dev  := ncurses-devel
PKG_brew_libncurses-dev := ncurses

PKG_apt_libevent-dev  := libevent-dev
PKG_dnf_libevent-dev  := libevent-devel
PKG_brew_libevent-dev := libevent

PKG_apt_libssl-dev  := libssl-dev
PKG_dnf_libssl-dev  := openssl-devel
PKG_brew_libssl-dev := openssl

# macOS AppImage 需要 libfuse2，brew 上等价为 macfuse（需 cask）
PKG_apt_libfuse2  := libfuse2
PKG_dnf_libfuse2  := fuse
PKG_brew_libfuse2 :=

# --- 常用工具 ---
PKG_apt_git  := git
PKG_dnf_git  := git
PKG_brew_git := git

PKG_apt_curl  := curl
PKG_dnf_curl  := curl
PKG_brew_curl := curl

PKG_apt_wget  := wget
PKG_dnf_wget  := wget
PKG_brew_wget := wget

PKG_apt_unzip  := unzip
PKG_dnf_unzip  := unzip
PKG_brew_unzip := unzip

PKG_apt_ripgrep  := ripgrep
PKG_dnf_ripgrep  := ripgrep
PKG_brew_ripgrep := ripgrep

PKG_apt_fd-find  := fd-find
PKG_dnf_fd-find  := fd-find
PKG_brew_fd-find := fd

PKG_apt_jq  := jq
PKG_dnf_jq  := jq
PKG_brew_jq := jq

# --- 映射函数 ---
# $(call pkg_name,通用名) → 当前发行版对应的包名
pkg_name = $(or $(PKG_$(PKG_MGR)_$(1)),$(1))

