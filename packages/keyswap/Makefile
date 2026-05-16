# packages/keyswap/Makefile
PKG_NAME    := keyswap
PKG_VERSION := 1.0

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

# macOS
PLIST_LABEL := com.user.keyswap
PLIST_FILE  := $(HOME)/Library/LaunchAgents/$(PLIST_LABEL).plist
# Linux
KEYD_CONF := /etc/keyd/default.conf

.PHONY: install configure clean uninstall

install: configure
ifeq ($(OS_ID),macos)
	@launchctl unload "$(PLIST_FILE)" 2>/dev/null || true
	@launchctl load -w "$(PLIST_FILE)"
	@/bin/bash "$(LOCAL_BIN)/keyswap.sh"
	@echo "[install] $(PKG_NAME): LaunchAgent loaded, key mapping applied"
else
	@sudo systemctl enable --now keyd 2>/dev/null || true
	@echo "[install] $(PKG_NAME): keyd service enabled and started"
endif
	$(call mark_installed,$(PKG_NAME),$(PKG_VERSION))

configure:
ifeq ($(OS_ID),macos)
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/config/keyswap.sh,$(LOCAL_BIN)/keyswap.sh)
	@mkdir -p "$(HOME)/Library/LaunchAgents"
	@printf '%s\n' \
		'<?xml version="1.0" encoding="UTF-8"?>' \
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
		'<plist version="1.0">' \
		'<dict>' \
		'    <key>Label</key>' \
		'    <string>$(PLIST_LABEL)</string>' \
		'    <key>ProgramArguments</key>' \
		'    <array>' \
		'        <string>/bin/bash</string>' \
		'        <string>$(LOCAL_BIN)/keyswap.sh</string>' \
		'    </array>' \
		'    <key>RunAtLoad</key>' \
		'    <true/>' \
		'    <key>KeepAlive</key>' \
		'    <false/>' \
		'</dict>' \
		'</plist>' > "$(PLIST_FILE)"
	@echo "[configure] $(PKG_NAME): plist written to $(PLIST_FILE)"
else
	$(call sys_install,keyd)
	@sudo mkdir -p /etc/keyd
	@sudo cp "$(DOTFILES_ROOT)/packages/$(PKG_NAME)/config/keyd.conf" "$(KEYD_CONF)"
	@echo "[configure] $(PKG_NAME): keyd config written to $(KEYD_CONF)"
endif

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
ifeq ($(OS_ID),macos)
	@if launchctl list 2>/dev/null | grep -q '$(PLIST_LABEL)'; then \
		launchctl unload "$(PLIST_FILE)" 2>/dev/null || true; \
		echo "[uninstall] $(PKG_NAME): LaunchAgent unloaded"; \
	fi
	@rm -f "$(PLIST_FILE)"
	@rm -f "$(LOCAL_BIN)/keyswap.sh"
	@rm -f "$(STATE_DIR)/$(PKG_NAME)"
	@echo "[uninstall] $(PKG_NAME) removed"
else
	@sudo systemctl disable --now keyd 2>/dev/null || true
	@sudo rm -f "$(KEYD_CONF)"
	@rm -f "$(STATE_DIR)/$(PKG_NAME)"
	@echo "[uninstall] $(PKG_NAME): keyd service stopped and config removed"
endif
