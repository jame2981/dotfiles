PKG := $(shell command -v dnf apt)
PWD := $(shell pwd)

curl:
	@sudo $(PKG) install curl

zsh:
	@sudo $(PKG) install zsh

vim:
	@sudo $(PKG) install vim

rust: curl
        ifeq (,$(wildcard ~/.rustup))
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        endif

all: zsh
	@ln -fsvn $(PWD)/dot/zshrc $(HOME)/.zshrc	
