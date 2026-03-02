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
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION)+uv$(UV_VERSION))

configure:
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@export PATH="$(HOME)/.local/bin:$$PATH" && \
		uv python uninstall $(PKG_VERSION) 2>/dev/null || true
	@rm -f "$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh"
	$(call uninstall_pkg,$(PKG_NAME),)

