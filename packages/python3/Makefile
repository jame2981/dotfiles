# packages/python3/Makefile
PKG_NAME    := python3
PKG_VERSION := 3.13
UV_VERSION  := 0.10.7
UV_URL      := https://astral.sh/uv/$(UV_VERSION)/install.sh

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall reinstall

PKG_STATE := $(PKG_VERSION)+uv$(UV_VERSION)
STATE_FILE := $(STATE_DIR)/$(PKG_NAME)

install: configure
	$(call sys_install,curl)
	@if [ -f "$(STATE_FILE)" ] && [ "$$(cat $(STATE_FILE))" = "$(PKG_STATE)" ]; then \
		echo "[skip] $(PKG_NAME) $(PKG_STATE) already installed"; \
	else \
		if ! command -v uv >/dev/null 2>&1; then \
			echo "[install] Installing uv $(UV_VERSION)..."; \
			curl -LsSf $(UV_URL) | sh; \
		else \
			echo "[skip] uv already installed"; \
		fi && \
		export PATH="$(HOME)/.local/bin:$$PATH" && \
		uv python install $(PKG_VERSION) --default --preview-features python-install-default && \
		echo "[install] Python $(PKG_VERSION) installed via uv" && \
		if [ -x "$(LOCAL_BIN)/python3" ]; then \
			printf '#!/bin/sh\nexec "$(LOCAL_BIN)/python3" -m pip "$$@"\n' > "$(LOCAL_BIN)/pip3" && chmod +x "$(LOCAL_BIN)/pip3"; \
			ln -sfn "$(LOCAL_BIN)/pip3" "$(LOCAL_BIN)/pip"; \
			echo "[link] pip/pip3 -> python3 -m pip wrapper"; \
		else \
			echo "[warn] python3 not found in $(LOCAL_BIN) after install"; \
		fi && \
		echo "$(PKG_STATE)" > "$(STATE_FILE)" && \
		echo "[state] $(PKG_NAME)=$(PKG_STATE) marked installed"; \
	fi

configure:
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh)
	$(call xdg_link,$(PKG_NAME),config/pip.conf,$(XDG_CONFIG_HOME)/pip/pip.conf)
	$(call xdg_link,$(PKG_NAME),config/pythonstartup.py,$(XDG_CONFIG_HOME)/python/pythonstartup.py)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@export PATH="$(HOME)/.local/bin:$$PATH" && \
		uv python uninstall $(PKG_VERSION) 2>/dev/null || true
	@rm -f "$(LOCAL_BIN)/pip" "$(LOCAL_BIN)/pip3" "$(LOCAL_BIN)/python" "$(LOCAL_BIN)/python3"
	@rm -f "$(XDG_CONFIG_HOME)/pip/pip.conf"
	@rm -f "$(XDG_CONFIG_HOME)/python/pythonstartup.py"
	@rm -f "$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh"
	$(call uninstall_pkg,$(PKG_NAME),)

reinstall: uninstall install
