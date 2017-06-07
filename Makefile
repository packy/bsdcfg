export gitdir   := $(HOME)/git
export bindir   := $(HOME)/bin

all: install

.PHONY: install
install:
	@cd dotfiles && $(MAKE)
	@cd bin      && $(MAKE)

