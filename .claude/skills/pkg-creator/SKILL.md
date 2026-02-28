---
name: pkg-creator
description: "Dotfiles package template generator. 为 dotfiles 仓库创建新的软件包模块。Use when: (1) 用户要求添加新软件包到 dotfiles / add new package, (2) 用户说'添加/创建/新建 xxx 包' or 'create/add xxx package', (3) 需要为 packages/ 目录生成新的包结构。支持三种安装方式: AppImage, source build, config-only."
---

# pkg-creator — Dotfiles 软件包生成器

## 工作流

1. 确认包名和安装方式（AppImage / 源码编译 / 纯配置）
2. 在 `packages/<name>/` 下生成 Makefile 和配置文件
3. 验证 `make install-<name>` 可执行

## 包结构

```
packages/<name>/
├── Makefile        # 必须，遵循标准接口
├── config/         # 可选，存放配置文件
└── install.sh      # 可选，复杂安装逻辑
```

## Makefile 标准接口

每个包的 Makefile **必须**提供以下 targets:

```makefile
.PHONY: install configure clean uninstall
install: configure    # 安装 + 配置
configure:            # 仅部署配置
clean:                # 清理编译产物
uninstall:            # 完整卸载
```

## 模板

### 模板 A: AppImage 包

适用于：Neovim, Zed 等分发 AppImage 的软件。

```makefile
# packages/<name>/Makefile
PKG_NAME    := <name>
PKG_VERSION := <version>
PKG_URL     := <appimage-download-url>

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

.PHONY: install configure clean uninstall

install: configure
	$(call appimage_install,$(PKG_NAME),$(PKG_URL),$(PKG_VERSION))

configure:
	# $(call xdg_link,$(PKG_NAME),config,$(XDG_CONFIG_HOME)/$(PKG_NAME))

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	$(call uninstall_pkg,$(PKG_NAME),$(LOCAL_BIN)/$(PKG_NAME) $(LOCAL_BIN)/$(PKG_NAME).appimage)
```

### 模板 B: 源码编译包

适用于：tmux, zsh 等需要从源码编译的软件。

```makefile
# packages/<name>/Makefile
PKG_NAME    := <name>
PKG_VERSION := <version>
PKG_REPO    := <git-repo-url>
PKG_TAG     := <git-tag>
PKG_DEPS    := build-essential <other-deps>

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

BUILD_CMD = ./configure --prefix=$$PREFIX && make -j$$(nproc) && make install

.PHONY: install configure clean uninstall

install: configure
	$(call sys_install,$(PKG_DEPS))
	$(call source_build,$(PKG_NAME),$(PKG_REPO),$(PKG_TAG),$(BUILD_CMD),$(PKG_VERSION))

configure:
	# $(call xdg_link,$(PKG_NAME),config,$(XDG_CONFIG_HOME)/$(PKG_NAME))

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
	$(call uninstall_pkg,$(PKG_NAME),$(LOCAL_BIN)/$(PKG_NAME))
```

### 模板 C: 纯配置包

适用于：git, starship 等仅需部署配置文件的软件。

```makefile
# packages/<name>/Makefile
PKG_NAME := <name>

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
```

## 规则

1. **ROOT 路径**：必须使用 `$(abspath ...)` 从包 Makefile 反推到仓库根
2. **include 顺序**：config.mk → deps.mk → functions.mk
3. **版本号**：必须硬编码在包 Makefile 中，用于幂等性检查
4. **Shell 扩展**：若包需要注入 alias/PATH，在 `configure` 中链接到 `$(LOCAL_SHARE)/dotfiles/shell.d/<name>.zsh`
5. **不猜测**：URL、版本号、依赖名必须由用户提供或从官方文档确认
6. **Shell 注入**：若包需要 alias/PATH/env，创建 `packages/<name>/shell.zsh` 并在 `configure` 中链接：

```makefile
configure:
	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh)
```

