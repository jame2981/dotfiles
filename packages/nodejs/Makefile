# packages/nodejs/Makefile
PKG_NAME    := nodejs
PKG_VERSION := 22
NVM_VERSION := v0.40.4
NVM_URL     := https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh
NPM_PACKAGES := tree-sitter-cli @bufbuild/buf opencode-ai @augmentcode/auggie

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
	@if [ ! -f "$(HOME)/.nvm/nvm.sh" ]; then \
		echo "[install] Installing nvm $(NVM_VERSION)..."; \
		curl -o- $(NVM_URL) | PROFILE=/dev/null bash; \
	else \
		echo "[skip] nvm already installed"; \
	fi
	@. $(HOME)/.nvm/nvm.sh && \
		nvm install $(PKG_VERSION) && \
		nvm alias default $(PKG_VERSION) && \
		npm install -g $(NPM_PACKAGES)
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))

configure:
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/nodejs.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -rf $(HOME)/.nvm
	@rm -f $(LOCAL_SHARE)/dotfiles/shell.d/nodejs.zsh
	$(call uninstall_pkg,$(PKG_NAME),)

