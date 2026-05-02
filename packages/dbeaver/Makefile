# packages/dbeaver/Makefile
PKG_NAME    := dbeaver
PKG_VERSION := latest

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
ifeq ($(PKG_MGR),brew)
	@echo "[install] $(PKG_NAME): installing via brew cask..."
	@brew install --cask dbeaver-community 2>/dev/null || true
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else ifeq ($(PKG_MGR),apt)
	@echo "[install] $(PKG_NAME): installing via snap..."
	@if command -v snap >/dev/null 2>&1; then \
		sudo snap install dbeaver-ce; \
	else \
		echo "[error] snap not found. Install snapd first: sudo apt install snapd"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else ifeq ($(PKG_MGR),dnf)
	@echo "[install] $(PKG_NAME): installing via flatpak..."
	@if command -v flatpak >/dev/null 2>&1; then \
		flatpak install -y flathub io.dbeaver.DBeaverCommunity; \
	else \
		echo "[error] flatpak not found. Install it first: sudo dnf install flatpak"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else ifeq ($(PKG_MGR),zypper)
	@echo "[install] $(PKG_NAME): installing via flatpak..."
	@if command -v flatpak >/dev/null 2>&1; then \
		flatpak install -y flathub io.dbeaver.DBeaverCommunity; \
	else \
		echo "[error] flatpak not found. Install it first: sudo zypper install flatpak"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))
else
	@echo "[error] $(PKG_NAME): unsupported package manager $(PKG_MGR)"
	@exit 1
endif

configure:
	@echo "[configure] $(PKG_NAME): nothing to configure"

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
ifeq ($(PKG_MGR),brew)
	@brew uninstall --cask dbeaver-community 2>/dev/null || true
else ifeq ($(PKG_MGR),apt)
	@sudo snap remove dbeaver-ce 2>/dev/null || true
else ifeq ($(PKG_MGR),dnf)
	@flatpak uninstall -y io.dbeaver.DBeaverCommunity 2>/dev/null || true
else ifeq ($(PKG_MGR),zypper)
	@flatpak uninstall -y io.dbeaver.DBeaverCommunity 2>/dev/null || true
endif
	$(call uninstall_pkg,$(PKG_NAME),)
