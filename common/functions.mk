# ============================================================================
# functions.mk — 核心函数库
# ============================================================================
# 依赖: config.mk, deps.mk 必须先被 include

# ----------------------------------------------------------------------------
# 1. 系统包安装
# $(call sys_install,pkg1 pkg2 ...)  — 自动映射包名并安装
# ----------------------------------------------------------------------------
define sys_install
	$(PKG_UPDATE)
	$(PKG_INSTALL) $(foreach p,$(1),$(call pkg_name,$(p)))
endef

# ----------------------------------------------------------------------------
# 2. 原子化软链接（带备份）
# $(call atomic_link,源文件绝对路径,目标路径)
# ----------------------------------------------------------------------------
define atomic_link
	@mkdir -p $(dir $(2))
	@if [ -e "$(2)" ] && [ ! -L "$(2)" ]; then \
		echo "[backup] $(2) → $(2).bak.$$(date +%Y%m%d%H%M%S)"; \
		mv "$(2)" "$(2).bak.$$(date +%Y%m%d%H%M%S)"; \
	fi
	@ln -sfn "$(1)" "$(2)"
	@echo "[link] $(1) → $(2)"
endef

# ----------------------------------------------------------------------------
# 3. 状态管理（幂等性）
# $(call check_installed,包名,版本号) — 返回 yes/空
# $(call mark_installed,包名,版本号)  — 写入标记
# $(call needs_install,包名,版本号)   — 用于 Makefile 条件判断
# ----------------------------------------------------------------------------
define check_installed
$(shell if [ -f "$(STATE_DIR)/$(1)" ] && [ "$$(cat $(STATE_DIR)/$(1))" = "$(2)" ]; then echo "yes"; fi)
endef

define mark_installed
	@echo "$(2)" > "$(STATE_DIR)/$(1)"
	@echo "[state] $(1)=$(2) marked installed"
endef

# needs_install 返回非空表示需要安装
needs_install = $(if $(call check_installed,$(1),$(2)),,yes)

# ----------------------------------------------------------------------------
# 4. AppImage 管理
# $(call appimage_install,名称,下载URL,版本号)
# 下载 → ~/.local/bin/<名称>.appimage, 建立 ~/.local/bin/<名称> 软链
# ----------------------------------------------------------------------------
define appimage_install
	@if [ -n "$(call needs_install,$(1),$(3))" ]; then \
		echo "[appimage] Installing $(1) $(3)..."; \
		curl -fSL "$(2)" -o "$(LOCAL_BIN)/$(1).appimage"; \
		chmod +x "$(LOCAL_BIN)/$(1).appimage"; \
		ln -sfn "$(LOCAL_BIN)/$(1).appimage" "$(LOCAL_BIN)/$(1)"; \
		echo "$(3)" > "$(STATE_DIR)/$(1)"; \
		echo "[appimage] $(1) $(3) installed"; \
	else \
		echo "[skip] $(1) $(3) already installed"; \
	fi
endef

# ----------------------------------------------------------------------------
# 5. 源码编译安装
# $(call source_build,名称,Git仓库URL,版本/Tag,编译命令,版本号)
# 编译命令中可使用 $$SRC_DIR 和 $$PREFIX
# ----------------------------------------------------------------------------
define source_build
	@if [ -n "$(call needs_install,$(1),$(5))" ]; then \
		echo "[build] Building $(1) $(5)..."; \
		SRC_DIR=$$(mktemp -d); \
		PREFIX="$(HOME)/.local"; \
		git clone --depth 1 --branch "$(3)" "$(2)" "$$SRC_DIR" && \
		cd "$$SRC_DIR" && \
		$(4) && \
		rm -rf "$$SRC_DIR" && \
		echo "$(5)" > "$(STATE_DIR)/$(1)" && \
		echo "[build] $(1) $(5) installed"; \
	else \
		echo "[skip] $(1) $(5) already installed"; \
	fi
endef

# ----------------------------------------------------------------------------
# 6. XDG 配置部署
# $(call xdg_link,包名,源目录/文件(相对包目录),XDG目标路径)
# ----------------------------------------------------------------------------
define xdg_link
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(1)/$(2),$(3))
endef

# ----------------------------------------------------------------------------
# 7. 清理/卸载辅助
# $(call uninstall_pkg,包名,已安装的文件列表...)
# ----------------------------------------------------------------------------
define uninstall_pkg
	@echo "[uninstall] Removing $(1)..."
	@rm -f $(foreach f,$(2),$(f))
	@rm -f "$(STATE_DIR)/$(1)"
	@echo "[uninstall] $(1) removed"
endef

