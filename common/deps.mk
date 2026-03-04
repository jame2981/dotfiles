# ============================================================================
# deps.mk — 跨发行版依赖映射
# ============================================================================
# 用法: $(call pkg_name,<通用名>)
# 返回当前系统对应的包名。若无映射则返回通用名本身。
#
# 添加新映射: 同时设置 PKG_apt_<name> 和 PKG_dnf_<name>

# --- 编译工具链 ---
PKG_apt_build-essential := build-essential
PKG_dnf_build-essential := gcc gcc-c++ make

PKG_apt_bison := bison
PKG_dnf_bison := bison

PKG_apt_cmake := cmake
PKG_dnf_cmake := cmake

# --- 开发库 ---
PKG_apt_libncurses-dev := libncurses-dev
PKG_dnf_libncurses-dev := ncurses-devel

PKG_apt_libevent-dev := libevent-dev
PKG_dnf_libevent-dev := libevent-devel

PKG_apt_libssl-dev := libssl-dev
PKG_dnf_libssl-dev := openssl-devel

# --- 常用工具 ---
PKG_apt_git  := git
PKG_dnf_git  := git

PKG_apt_curl := curl
PKG_dnf_curl := curl

PKG_apt_wget := wget
PKG_dnf_wget := wget

PKG_apt_unzip := unzip
PKG_dnf_unzip := unzip

PKG_apt_ripgrep := ripgrep
PKG_dnf_ripgrep := ripgrep

PKG_apt_fd-find := fd-find
PKG_dnf_fd-find := fd-find

PKG_apt_jq := jq
PKG_dnf_jq := jq

# --- 映射函数 ---
# $(call pkg_name,通用名) → 当前发行版对应的包名
pkg_name = $(or $(PKG_$(PKG_MGR)_$(1)),$(1))

