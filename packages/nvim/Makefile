# packages/nvim/Makefile
PKG_NAME    := nvim
PKG_VERSION := 0.11.6

# Architecture-aware AppImage URL
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),aarch64)
  PKG_ARCH := arm64
else
  PKG_ARCH := x86_64
endif
PKG_URL := https://github.com/neovim/neovim/releases/download/v$(PKG_VERSION)/nvim-linux-$(PKG_ARCH).appimage

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

SHELL_D := $(LOCAL_SHARE)/dotfiles/shell.d

.PHONY: install configure clean uninstall

install: configure
ifeq ($(PKG_MGR),brew)
	@if [ -n "$(call needs_install,$(PKG_NAME),$(PKG_VERSION))" ]; then \
		echo "[install] Installing nvim $(PKG_VERSION) via brew..."; \
		brew install neovim; \
	else \
		echo "[skip] nvim $(PKG_VERSION) already installed"; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else
	$(call sys_install,libfuse2 build-essential)
	$(call appimage_install,$(PKG_NAME),$(PKG_URL),$(PKG_VERSION))
endif
	@if [ -f "$(HOME)/.nvm/nvm.sh" ] && ! command -v tree-sitter >/dev/null 2>&1; then \
		. $(HOME)/.nvm/nvm.sh && npm install -g tree-sitter-cli; \
	fi

configure:
	$(call xdg_link,$(PKG_NAME),config,$(XDG_CONFIG_HOME)/nvim)
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/nvim.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
ifeq ($(PKG_MGR),brew)
	@brew uninstall neovim 2>/dev/null || true
	$(call uninstall_pkg,$(PKG_NAME),)
else
	$(call uninstall_pkg,$(PKG_NAME),$(LOCAL_BIN)/$(PKG_NAME) $(LOCAL_BIN)/$(PKG_NAME).appimage)
endif
	@rm -f "$(XDG_CONFIG_HOME)/nvim"
	@rm -f "$(SHELL_D)/nvim.zsh"
	@echo "[uninstall] nvim config and shell links removed"

