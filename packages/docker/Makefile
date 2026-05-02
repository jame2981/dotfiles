# packages/docker/Makefile
PKG_NAME := docker

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
include $(ROOT)/config.mk
include $(ROOT)/common/deps.mk
include $(ROOT)/common/functions.mk

SHELL_D := $(LOCAL_SHARE)/dotfiles/shell.d

.PHONY: install configure clean uninstall

install: configure
ifeq ($(PKG_MGR),brew)
	@echo "[install] $(PKG_NAME): installing colima + docker CLI + compose via brew..."
	@brew install colima docker docker-compose 2>/dev/null || true
	@mkdir -p "$(HOME)/.docker"
	@if [ ! -f "$(HOME)/.docker/config.json" ]; then \
		echo '{"cliPluginsExtraDirs":["/opt/homebrew/lib/docker/cli-plugins","/usr/local/lib/docker/cli-plugins"]}' > "$(HOME)/.docker/config.json"; \
		echo "[configure] docker: created ~/.docker/config.json with cliPluginsExtraDirs"; \
	fi
	@echo "[note] Run 'colima start' to start the Docker runtime on macOS"
else
	$(call sys_install,docker docker-compose)
	@sudo systemctl enable --now docker 2>/dev/null || true
	@if ! groups | grep -q docker 2>/dev/null; then \
		sudo usermod -aG docker $$USER 2>/dev/null || true; \
		echo "[note] Added $$USER to docker group. Log out and back in for it to take effect."; \
	fi
endif
	@if command -v docker >/dev/null 2>&1; then \
		ver=$$(docker --version | awk '{print $$3}' | tr -d ','); \
		echo "$$ver" > "$(STATE_DIR)/$(PKG_NAME)"; \
		echo "[state] $(PKG_NAME)=$$ver marked installed"; \
	else \
		echo "[warn] docker not found in PATH after install"; \
	fi

configure:
	$(call xdg_link,$(PKG_NAME),shell.zsh,$(SHELL_D)/docker.zsh)

clean:
	@echo "[clean] $(PKG_NAME): nothing to clean"

uninstall:
ifeq ($(PKG_MGR),brew)
	@brew uninstall docker-compose docker colima 2>/dev/null || true
else
	$(call sys_install,)
	@sudo apt-get remove -y $(call pkg_name,docker) $(call pkg_name,docker-compose) 2>/dev/null || \
		sudo dnf remove -y $(call pkg_name,docker) $(call pkg_name,docker-compose) 2>/dev/null || \
		sudo zypper remove -y $(call pkg_name,docker) $(call pkg_name,docker-compose) 2>/dev/null || true
endif
	@rm -f "$(SHELL_D)/docker.zsh"
	$(call uninstall_pkg,$(PKG_NAME),)
