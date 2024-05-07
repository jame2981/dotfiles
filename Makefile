PKG := $(shell command -v dnf apt)
PWD := $(shell pwd)
BUILTS := curl wget
OBJS := tmux zsh emacs

ifeq ($(PKG),"/usr/bin/dnf")
	sudo $(PKG) update
endif

.PHONY: install
install: $(OBJS)
	@ln -sfvn ${PWD}/dot/tmux.conf ${HOME}/.tmux.conf
	@ln -sfvn ${PWD}/dot/zshrc ${HOME}/.zshrc
	@ln -sfvn ${PWD}/dot/vimrc ${HOME}/.vimrc

%:
	sudo ${PKG} install $@
