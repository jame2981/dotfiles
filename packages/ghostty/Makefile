# packages/ghostty/Makefile
PKG_NAME := ghostty

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

SHELL_D := $(LOCAL_SHARE)/dotfiles/shell.d

install: configure
ifeq ($(PKG_MGR),brew)
	@echo "[install] $(PKG_NAME): installing via brew cask..."
	@brew install --cask ghostty 2>/dev/null || true
	$(call mark_installed,$(PKG_NAME),installed)
else ifeq ($(PKG_MGR),apt)
	@echo "[install] $(PKG_NAME): trying apt, then flatpak fallback..."
	@if sudo apt-get install -y ghostty 2>/dev/null; then \
		echo "[install] $(PKG_NAME): installed via apt"; \
	elif command -v flatpak >/dev/null 2>&1; then \
		flatpak install -y flathub app.ghostty.ghostty; \
		echo "[install] $(PKG_NAME): installed via flatpak"; \
	else \
		echo "[error] $(PKG_NAME): not in apt repos and flatpak not available"; \
		echo "[hint]  see https://ghostty.org/docs/install"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),installed)
else ifeq ($(PKG_MGR),dnf)
	@echo "[install] $(PKG_NAME): trying dnf, then flatpak fallback..."
	@if sudo dnf install -y ghostty 2>/dev/null; then \
		echo "[install] $(PKG_NAME): installed via dnf"; \
	elif command -v flatpak >/dev/null 2>&1; then \
		flatpak install -y flathub app.ghostty.ghostty; \
		echo "[install] $(PKG_NAME): installed via flatpak"; \
	else \
		echo "[error] $(PKG_NAME): not in dnf repos and flatpak not available"; \
		echo "[hint]  see https://ghostty.org/docs/install"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),installed)
else ifeq ($(PKG_MGR),zypper)
	@echo "[install] $(PKG_NAME): trying zypper, then flatpak fallback..."
	@if sudo zypper install -y ghostty 2>/dev/null; then \
		echo "[install] $(PKG_NAME): installed via zypper"; \
	elif command -v flatpak >/dev/null 2>&1; then \
		flatpak install -y flathub app.ghostty.ghostty; \
		echo "[install] $(PKG_NAME): installed via flatpak"; \
	else \
		echo "[error] $(PKG_NAME): not in zypper repos and flatpak not available"; \
		echo "[hint]  see https://ghostty.org/docs/install"; \
		exit 1; \
	fi
	$(call mark_installed,$(PKG_NAME),installed)
else
	@echo "[error] $(PKG_NAME): unsupported package manager $(PKG_MGR)"
	@exit 1
endif

configure:
	$(call xdg_link,$(PKG_NAME),config/config,$(XDG_CONFIG_HOME)/ghostty/config)
	$(call xdg_link,$(PKG_NAME),config/macos,$(XDG_CONFIG_HOME)/ghostty/macos)
	$(call xdg_link,$(PKG_NAME),config/linux,$(XDG_CONFIG_HOME)/ghostty/linux)
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/ghostty.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	@rm -f "$(XDG_CONFIG_HOME)/ghostty/config"
	@rm -f "$(XDG_CONFIG_HOME)/ghostty/macos"
	@rm -f "$(XDG_CONFIG_HOME)/ghostty/linux"
	@rm -f "$(SHELL_D)/ghostty.zsh"
	$(call uninstall_pkg,$(PKG_NAME),)
