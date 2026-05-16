# packages/nodejs/Makefile
PKG_NAME    := nodejs
PKG_VERSION := --lts
NVM_VERSION := v0.40.4
NVM_DIR     := $(HOME)/.config/nvm
NVM_URL     := https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh
NPM_PACKAGES := tree-sitter-cli @bufbuild/buf opencode-ai @augmentcode/auggie

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
ifneq ($(call check_installed,$(PKG_NAME),$(PKG_VERSION)),yes)
	$(call sys_install,curl)
	@mkdir -p $(NVM_DIR)
	@if [ ! -f "$(NVM_DIR)/nvm.sh" ]; then \
		echo "[install] Installing nvm $(NVM_VERSION)..."; \
		curl -o- $(NVM_URL) | PROFILE=/dev/null NVM_DIR=$(NVM_DIR) bash; \
	else \
		echo "[skip] nvm already installed"; \
	fi
	@. $(NVM_DIR)/nvm.sh && \
		nvm install $(PKG_VERSION) && \
		nvm alias default node && \
		npm install -g $(NPM_PACKAGES)
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else
	@echo "[skip] $(PKG_NAME) $(PKG_VERSION) already installed"
endif

configure:
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/nodejs.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -rf $(NVM_DIR)
	@rm -f $(LOCAL_SHARE)/dotfiles/shell.d/nodejs.zsh
	$(call uninstall_pkg,$(PKG_NAME),)
