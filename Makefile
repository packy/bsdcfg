all: install

.PHONY: install
install:
	@cd dotfiles && $(MAKE)
	@cd bin      && $(MAKE)

