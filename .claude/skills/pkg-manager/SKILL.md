---
name: pkg-manager
description: "Dotfiles 软件包全生命周期管理。Use when: (1) 添加/创建新软件包 add/create package, (2) 删除/卸载软件包 remove/delete/uninstall package, (3) 修改包配置或 Makefile modify/edit package, (4) 升级包版本 upgrade/update package version, (5) 查看包状态 status/list packages。支持三种安装方式: AppImage, source build, config-only。"
---

# pkg-manager — Dotfiles 软件包管理器

## 操作一览

| 操作 | 触发词 | 核心动作 |
|------|--------|----------|
| 添加 | 添加/创建/新建 xxx 包 | 在 `packages/<name>/` 生成 Makefile + 配置 |
| 删除 | 删除/移除/卸载 xxx 包 | 运行 `make uninstall-<name>` 后删除 `packages/<name>/` |
| 升级 | 升级/更新 xxx 版本 | 修改 Makefile 中 `PKG_VERSION` 后运行 `make install-<name>` |
| 修改 | 修改 xxx 配置 | 编辑 `packages/<name>/` 下相关文件 |
| 状态 | 列出/查看包 | 运行 `make list` 或 `make status` |

## 包结构

```
packages/<name>/
├── Makefile        # 必须，遵循标准接口
├── config/         # 可选，存放配置文件
├── shell.zsh       # 可选，Shell 注入(alias/PATH/env)
└── install.sh      # 可选，复杂安装逻辑
```

## Makefile 标准接口

```makefile
.PHONY: install configure clean uninstall
install: configure    # 安装 + 配置
configure:            # 仅部署配置
clean:                # 清理编译产物
uninstall:            # 完整卸载
```

## 操作流程

### 添加包

1. 确认包名和安装方式（AppImage / 源码编译 / 纯配置）
2. 用下方模板在 `packages/<name>/` 生成 Makefile
3. 验证 `make install-<name>` 可执行

### 删除包

1. 运行 `make uninstall-<name>` 卸载
2. 删除 `packages/<name>/` 目录
3. 若有 shell 注入，检查并清理 `shell.d/` 中的链接

### 升级包

1. 修改 `packages/<name>/Makefile` 中的 `PKG_VERSION`（及 `PKG_URL`/`PKG_TAG` 如需要）
2. 运行 `make install-<name>` 触发重装（幂等性检查会检测版本变化）

### 修改包

直接编辑 `packages/<name>/` 下相关文件，改完运行 `make configure-<name>` 验证。

## 模板

### 模板 A: AppImage 包

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
4. **Shell 注入**：若包需要 alias/PATH/env，创建 `packages/<name>/shell.zsh` 并在 `configure` 中链接：
   ```makefile
   configure:
   	$(call atomic_link,$(DOTFILES_ROOT)/packages/$(PKG_NAME)/shell.zsh,$(LOCAL_SHARE)/dotfiles/shell.d/$(PKG_NAME).zsh)
   ```
5. **本地覆盖**：机器专属、不入 git 的配置（如 PS1、公司代理等），写到 `~/.dotfiles.local.zsh`，自动最后加载
6. **不猜测**：URL、版本号、依赖名必须由用户提供或从官方文档确认

