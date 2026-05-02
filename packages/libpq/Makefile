# packages/libpq/Makefile
PKG_NAME := libpq

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

SHELL_D := $(LOCAL_SHARE)/dotfiles/shell.d

.PHONY: install configure clean uninstall

install: configure
ifneq ($(call check_installed,$(PKG_NAME),installed),yes)
	$(call sys_install,$(PKG_NAME))
	$(call mark_installed,$(PKG_NAME),installed)
else
	@echo "[skip] $(PKG_NAME) already installed"
endif

configure:
ifeq ($(PKG_MGR),brew)
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/$(PKG_NAME).zsh)
else
	@echo "[configure] $(PKG_NAME): no shell integration needed on Linux"
endif

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -f "$(SHELL_D)/$(PKG_NAME).zsh"
	$(call uninstall_pkg,$(PKG_NAME),)
