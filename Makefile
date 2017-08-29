all: install

.PHONY: install
install:
	@cd dotfiles && $(MAKE)
	@cd bin      && $(MAKE)
	@ln -sf $$HOME/git/bsdcfg/bashrc.d $$HOME/.bashrc.d
