# ============================================================================
# Makefile — Dotfiles 全局总控
# ============================================================================
.DEFAULT_GOAL := help
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

include config.mk
include common/deps.mk
include common/functions.mk

# --- 自动发现所有软件包 ---
PACKAGES := $(sort $(patsubst packages/%/,%,$(wildcard packages/*/)))

# --- 主目标 ---
CONFIGURE_TARGETS := $(addprefix configure-,$(PACKAGES))

.PHONY: all sync help list shell-setup clean

all: shell-setup $(PACKAGES) ## 安装所有包 + Shell 环境

sync: shell-setup $(CONFIGURE_TARGETS) ## 同步所有包配置（仅软链，不重新安装）
	@echo ""
	@echo "✅ Sync done."

# --- Shell 环境部署 ---
SHELL_SHARE_DIR := $(LOCAL_SHARE)/dotfiles

shell-setup: ## 部署 Shell 增强配置
	@mkdir -p "$(SHELL_SHARE_DIR)/shell.d"
	$(call atomic_link,$(DOTFILES_ROOT)/common/shell/env.zsh,$(ENV_ENTRY))
	$(call atomic_link,$(DOTFILES_ROOT)/common/shell/aliases.sh,$(SHELL_SHARE_DIR)/aliases.sh)
	$(call atomic_link,$(DOTFILES_ROOT)/common/shell/functions.sh,$(SHELL_SHARE_DIR)/functions.sh)
	@if ! grep -qF 'source $(ENV_ENTRY)' "$(ZSHRC)" 2>/dev/null; then \
		echo '' >> "$(ZSHRC)"; \
		echo '# Dotfiles' >> "$(ZSHRC)"; \
		echo '[ -f $(ENV_ENTRY) ] && source $(ENV_ENTRY)' >> "$(ZSHRC)"; \
		echo "[shell] Injected source line into $(ZSHRC)"; \
	else \
		echo "[skip] $(ZSHRC) already sources $(ENV_ENTRY)"; \
	fi
	@echo "[shell] Shell environment ready"

# --- 包安装（委托给子 Makefile）---
.PHONY: $(PACKAGES)
$(PACKAGES):
	@if [ -f "packages/$@/Makefile" ]; then \
		echo ""; \
		echo "━━━ 📦 $@ ━━━"; \
		$(MAKE) -C "packages/$@" install; \
	else \
		echo "[warn] packages/$@/Makefile not found, skipping"; \
	fi

# --- 单包操作 ---
install-%: ## 安装指定包: make install-tmux
	@$(MAKE) -C "packages/$*" install

configure-%: ## 配置指定包: make configure-tmux
	@$(MAKE) -C "packages/$*" configure

clean-%: ## 清理指定包: make clean-tmux
	@$(MAKE) -C "packages/$*" clean

uninstall-%: ## 卸载指定包: make uninstall-tmux
	@$(MAKE) -C "packages/$*" uninstall

# --- 信息 ---
list: ## 列出所有已发现的包
	@echo "Discovered packages:"
	@$(foreach p,$(PACKAGES),echo "  - $(p)";)
	@if [ -z "$(PACKAGES)" ]; then echo "  (none)"; fi

status: ## 显示所有包的安装状态
	@echo "Installed packages (from $(STATE_DIR)):"
	@if [ -d "$(STATE_DIR)" ]; then \
		for f in $(STATE_DIR)/*; do \
			[ -f "$$f" ] && echo "  - $$(basename $$f): $$(cat $$f)"; \
		done; \
	fi

help: ## 显示帮助
	@echo "Dotfiles Manager"
	@echo "================"
	@echo "System: $(OS_ID) ($(PKG_MGR))"
	@echo ""
	@grep -hE '^[a-zA-Z_%-]+:.*##' $(MAKEFILE_LIST) | \
		sed 's/:.* ## /\t/' | \
		awk 'BEGIN {FS = "\t"}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

