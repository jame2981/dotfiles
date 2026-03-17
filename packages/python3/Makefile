# packages/python3/Makefile
PKG_NAME    := python3
PKG_VERSION := 3.13
UV_VERSION  := 0.10.7
UV_URL      := https://astral.sh/uv/install.sh

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "[install] Installing uv $(UV_VERSION)..."; \
		curl -LsSf $(UV_URL) | sh; \
	else \
		echo "[skip] uv already installed"; \
	fi
	@export PATH="$(HOME)/.local/bin:$$PATH" && \
		uv python install $(PKG_VERSION) && \
		echo "[install] Python $(PKG_VERSION) installed via uv"
	@# Create pip/pip3 symlinks pointing to uv-managed Python's pip
	@UV_PY_DIR="$$(ls -d $(HOME)/.local/share/uv/python/cpython-$(PKG_VERSION)*-linux-*-gnu 2>/dev/null | sort -V | tail -1)"; \
	if [ -n "$$UV_PY_DIR" ] && [ -x "$$UV_PY_DIR/bin/pip3" ]; then \
		ln -sfn "$$UV_PY_DIR/bin/pip3" "$(LOCAL_BIN)/pip3"; \
		ln -sfn "$$UV_PY_DIR/bin/pip3" "$(LOCAL_BIN)/pip"; \
		echo "[link] pip/pip3 -> $$UV_PY_DIR/bin/pip3"; \
	else \
		echo "[warn] pip not found in uv python, installing via ensurepip..."; \
		"$(LOCAL_BIN)/python3" -m ensurepip --upgrade 2>/dev/null || true; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION)+uv$(UV_VERSION))

configure:
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh)
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/config/pip.conf,$(XDG_CONFIG_HOME)/pip/pip.conf)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@export PATH="$(HOME)/.local/bin:$$PATH" && \
		uv python uninstall $(PKG_VERSION) 2>/dev/null || true
	@rm -f "$(LOCAL_BIN)/pip" "$(LOCAL_BIN)/pip3"
	@rm -f "$(XDG_CONFIG_HOME)/pip/pip.conf"
	@rm -f "$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh"
	$(call uninstall_pkg,$(PKG_NAME),)
