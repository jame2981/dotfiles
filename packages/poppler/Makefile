# packages/poppler/Makefile
PKG_NAME := poppler

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
ifneq ($(call check_installed,$(PKG_NAME),installed),yes)
	$(call sys_install,$(PKG_NAME))
	$(call mark_installed,$(PKG_NAME),installed)
else
	@echo "[skip] $(PKG_NAME) already installed"
endif

configure:
	@echo "[configure] $(PKG_NAME): nothing to configure"

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	$(call uninstall_pkg,$(PKG_NAME),)
