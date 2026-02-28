# packages/tmux/Makefile
PKG_NAME := tmux

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
	@echo "[install] $(PKG_NAME): config-only package"

configure:
	$(call xdg_link,$(PKG_NAME),config,$(XDG_CONFIG_HOME)/$(PKG_NAME))

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -f "$(XDG_CONFIG_HOME)/$(PKG_NAME)"
	@rm -f "$(STATE_DIR)/$(PKG_NAME)"
	@echo "[uninstall] $(PKG_NAME) removed"

