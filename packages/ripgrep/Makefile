# packages/ripgrep/Makefile
PKG_NAME    := ripgrep
PKG_VERSION := 15.1.0

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

SHELL_D := $(LOCAL_SHARE)/dotfiles/shell.d

ifeq ($(PKG_MGR),apt)
PKG_REMOVE := sudo apt-get remove -y
else ifeq ($(PKG_MGR),dnf)
PKG_REMOVE := sudo dnf remove -y
else ifeq ($(PKG_MGR),zypper)
PKG_REMOVE := sudo zypper remove -y
else ifeq ($(PKG_MGR),brew)
PKG_REMOVE := brew uninstall
else
PKG_REMOVE := false
endif

.PHONY: install configure clean uninstall

install: configure
	@if command -v rg >/dev/null 2>&1 && [ -f "$(STATE_DIR)/$(PKG_NAME)" ]; then \
		echo "[skip] $(PKG_NAME) already installed ($$(cat $(STATE_DIR)/$(PKG_NAME)))"; \
	else \
		$(MAKE) _do_rg_install; \
	fi

_do_rg_install:
	$(call sys_install,$(PKG_NAME))
	@if command -v rg >/dev/null 2>&1; then \
		installed_version="$$(rg --version | awk 'NR==1 { print $$2 }')"; \
		echo "$$installed_version" > "$(STATE_DIR)/$(PKG_NAME)"; \
		echo "[state] $(PKG_NAME)=$$installed_version marked installed"; \
	else \
		echo "[error] ripgrep installation failed: rg not found in PATH"; \
		exit 1; \
	fi

configure:
	$(call xdg_link,$(PKG_NAME),config/ripgreprc,$(XDG_CONFIG_HOME)/ripgrep/ripgreprc)
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/ripgrep.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@$(PKG_REMOVE) $(call pkg_name,$(PKG_NAME)) || true
	@rm -f "$(XDG_CONFIG_HOME)/ripgrep/ripgreprc"
	@rm -f "$(SHELL_D)/ripgrep.zsh"
	$(call uninstall_pkg,$(PKG_NAME),)