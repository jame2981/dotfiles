# packages/golang/Makefile
PKG_NAME    := golang
PKG_VERSION := go1.24.3
GVM_VERSION := master
GVM_URL     := https://raw.githubusercontent.com/moovweb/gvm/$(GVM_VERSION)/binscripts/gvm-installer
PKG_DEPS    := bison curl git

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

# gvm 脚本需要 bash，必须显式声明
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: install configure clean uninstall

install: configure
	@command -v bison >/dev/null 2>&1 && echo "[skip] system deps already installed" || \
		{ $(PKG_UPDATE) && $(PKG_INSTALL) bison curl git; }
	@if [ ! -f "$(HOME)/.gvm/scripts/gvm" ]; then \
		echo "[install] Installing gvm..."; \
		curl -fsSL $(GVM_URL) | PROFILE=/dev/null bash; \
	else \
		echo "[skip] gvm already installed"; \
	fi
	@set +u; source $(HOME)/.gvm/scripts/gvm && \
		gvm install $(PKG_VERSION) -B && \
		gvm use $(PKG_VERSION) --default && \
		echo "[install] $(PKG_VERSION) set as default"
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))

configure:
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/golang.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@if [ -f "$(HOME)/.gvm/scripts/gvm" ]; then \
		set +u; source $(HOME)/.gvm/scripts/gvm && \
		gvm uninstall $(PKG_VERSION) 2>/dev/null || true; \
	fi
	@rm -rf $(HOME)/.gvm
	@rm -f $(LOCAL_SHARE)/dotfiles/shell.d/golang.zsh
	$(call uninstall_pkg,$(PKG_NAME),)

