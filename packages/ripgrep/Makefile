# packages/ripgrep/Makefile
PKG_NAME    := ripgrep
PKG_VERSION := 15.1.0

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

ifeq ($(PKG_MGR),apt)
PKG_REMOVE := sudo apt-get remove -y
else ifeq ($(PKG_MGR),dnf)
PKG_REMOVE := sudo dnf remove -y
else ifeq ($(PKG_MGR),brew)
PKG_REMOVE := brew uninstall
else
PKG_REMOVE := false
endif

.PHONY: install configure clean uninstall

install: configure
	$(call sys_install,$(PKG_NAME))
	@installed_version="$$(rg --version | awk 'NR==1 { print $$2 }')"; \
		if [ "$$installed_version" != "$(PKG_VERSION)" ]; then \
			echo "[warn] $(PKG_MGR) provided ripgrep $$installed_version (upstream verified: $(PKG_VERSION))"; \
		fi; \
		echo "$$installed_version" > "$(STATE_DIR)/$(PKG_NAME)"; \
		echo "[state] $(PKG_NAME)=$$installed_version marked installed"

configure:
	@echo "[configure] $(PKG_NAME): nothing to configure"

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@$(PKG_REMOVE) $(call pkg_name,$(PKG_NAME)) || true
	$(call uninstall_pkg,$(PKG_NAME),)