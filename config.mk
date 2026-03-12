# ============================================================================
# config.mk — 全局静态配置 & 系统探测
# ============================================================================

# Dotfiles 根目录（绝对路径）
DOTFILES_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# --- XDG 规范路径 ---
XDG_CONFIG_HOME := $(HOME)/.config
XDG_DATA_HOME   := $(HOME)/.local/share
XDG_STATE_HOME  := $(HOME)/.local/state

# --- 产物路径 ---
LOCAL_BIN   := $(HOME)/.local/bin
LOCAL_SHARE := $(XDG_DATA_HOME)

# --- 状态管理 ---
STATE_DIR := $(XDG_STATE_HOME)/dotfiles

# --- 系统探测 ---
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
  OS_ID       := macos
  PKG_MGR     := brew
  PKG_INSTALL := brew install
  PKG_UPDATE  := brew update
else
  OS_ID := $(shell . /etc/os-release 2>/dev/null && echo $$ID)
  ifeq ($(OS_ID),$(filter $(OS_ID),ubuntu debian))
    PKG_MGR     := apt
    PKG_INSTALL := sudo apt-get install -y
    PKG_UPDATE  := sudo apt-get update -qq
  else ifeq ($(OS_ID),$(filter $(OS_ID),fedora rhel centos))
    PKG_MGR     := dnf
    PKG_INSTALL := sudo dnf install -y
    PKG_UPDATE  := true
  else
    $(warning Unsupported OS: $(OS_ID). Supported: ubuntu/debian, fedora/rhel/centos, macOS.)
    PKG_MGR     := unknown
    PKG_INSTALL := false
    PKG_UPDATE  := false
  endif
endif

# --- Shell 配置 ---
SHELL_TYPE := zsh
ZSHRC      := $(HOME)/.zshrc
ENV_ENTRY  := $(HOME)/.local/env.zsh

# --- 工具版本（可被包 Makefile 覆盖） ---
# 示例: TMUX_VERSION := 3.4

# --- 确保关键目录存在 ---
$(shell mkdir -p $(LOCAL_BIN) $(STATE_DIR) $(XDG_CONFIG_HOME))

