# packages/keyswap/Makefile
PKG_NAME    := keyswap
PLIST_LABEL := com.user.keyswap
PLIST_FILE  := $(HOME)/Library/LaunchAgents/$(PLIST_LABEL).plist

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
ifneq ($(OS_ID),macos)
	@echo "[skip] $(PKG_NAME): macOS only"
else
	@if launchctl list 2>/dev/null | grep -q '$(PLIST_LABEL)'; then \
		launchctl unload "$(PLIST_FILE)" 2>/dev/null || true; \
	fi
	@launchctl load "$(PLIST_FILE)"
	@echo "[install] $(PKG_NAME): LaunchAgent loaded"
endif

configure:
ifneq ($(OS_ID),macos)
	@echo "[skip] $(PKG_NAME): macOS only"
else
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
endif

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
ifneq ($(OS_ID),macos)
	@echo "[skip] $(PKG_NAME): macOS only"
else
	@if launchctl list 2>/dev/null | grep -q '$(PLIST_LABEL)'; then \
		launchctl unload "$(PLIST_FILE)" 2>/dev/null || true; \
		echo "[uninstall] $(PKG_NAME): LaunchAgent unloaded"; \
	fi
	@rm -f "$(PLIST_FILE)"
	@rm -f "$(LOCAL_BIN)/keyswap.sh"
	@rm -f "$(STATE_DIR)/$(PKG_NAME)"
	@echo "[uninstall] $(PKG_NAME) removed"
endif
