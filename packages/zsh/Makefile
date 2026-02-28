# packages/zsh/Makefile
PKG_NAME    := zsh
PKG_VERSION := 1.0

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

OMZ_URL := https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

.PHONY: install configure clean uninstall

install: configure
	@if [ ! -d "$(HOME)/.oh-my-zsh" ]; then \
		echo "[install] Installing oh-my-zsh..."; \
		RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$$(curl -fsSL $(OMZ_URL))"; \
	else \
		echo "[skip] oh-my-zsh already installed"; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))

configure:
	$(call xdg_link,$(PKG_NAME),config/zshrc,$(ZSHRC))
	$(call xdg_link,$(PKG_NAME),config/shell.d/zsh.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/zsh.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -f "$(ZSHRC)"
	@rm -f "$(LOCAL_SHARE)/dotfiles/shell.d/zsh.zsh"
	@rm -f "$(STATE_DIR)/$(PKG_NAME)"
	@echo "[uninstall] $(PKG_NAME) removed"

