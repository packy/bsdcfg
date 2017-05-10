export gitdir   := $(HOME)/git
export bindir   := $(HOME)/bin

all: install

.PHONY: install
install: ack
	@cd dotfiles && $(MAKE)
	@cd bin      && $(MAKE)

