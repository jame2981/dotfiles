# packages/homebrew/Makefile
PKG_NAME := homebrew

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

BREWFILE := $(ROOT)/packages/$(PKG_NAME)/Brewfile
SHELL_D  := $(LOCAL_SHARE)/dotfiles/shell.d

.PHONY: install configure clean uninstall

install: configure
ifneq ($(PKG_MGR),brew)
	@echo "[skip] $(PKG_NAME): not on macOS, skipping"
else
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "[install] $(PKG_NAME): installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "[install] $(PKG_NAME): running brew bundle..."
	@brew bundle --file="$(BREWFILE)"
	$(call mark_installed,$(PKG_NAME),$$(date +%Y-%m-%d))
endif

configure:
ifeq ($(PKG_MGR),brew)
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/00-homebrew.zsh)
else
	@echo "[configure] $(PKG_NAME): not on macOS, skipping"
endif

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -f "$(SHELL_D)/00-homebrew.zsh"
	$(call uninstall_pkg,$(PKG_NAME),)
