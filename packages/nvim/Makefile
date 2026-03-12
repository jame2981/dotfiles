# packages/nvim/Makefile
PKG_NAME    := nvim
PKG_VERSION := 0.11.6
PKG_URL     := https://github.com/neovim/neovim/releases/download/v$(PKG_VERSION)/nvim-linux-x86_64.appimage

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
ifeq ($(PKG_MGR),brew)
	@if [ -n "$(call needs_install,$(PKG_NAME),$(PKG_VERSION))" ]; then \
		echo "[install] Installing nvim $(PKG_VERSION) via brew..."; \
		brew install neovim; \
		echo "$(PKG_VERSION)" > "$(STATE_DIR)/$(PKG_NAME)"; \
		echo "[state] $(PKG_NAME)=$(PKG_VERSION) marked installed"; \
	else \
		echo "[skip] nvim $(PKG_VERSION) already installed"; \
	fi
else
	$(call sys_install,libfuse2)
	$(call appimage_install,$(PKG_NAME),$(PKG_URL),$(PKG_VERSION))
endif
	@if [ -f "$(HOME)/.nvm/nvm.sh" ]; then \
		. $(HOME)/.nvm/nvm.sh && npm install -g tree-sitter-cli; \
	else \
		echo "[warn] nvm not found; install nodejs package first, then re-run nvim install"; \
	fi

configure:
	$(call xdg_link,$(PKG_NAME),config,$(XDG_CONFIG_HOME)/nvim)

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
	@echo "[uninstall] nvim config link removed"

