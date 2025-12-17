DOTFILES := $(HOME)/dotfiles
CONFIG   := $(HOME)/.config

SYMLINKS = \
    $(CONFIG)/fish \
    $(CONFIG)/kitty \
    $(CONFIG)/nvim \
	$(HOME)/.clang-format \
	$(HOME)/Brewfile

all: link

link: $(SYMLINKS)

$(CONFIG)/fish:
	ln -s $(DOTFILES)/fish $@

$(CONFIG)/kitty:
	ln -s $(DOTFILES)/kitty $@

$(CONFIG)/nvim:
	ln -s $(DOTFILES)/nvim $@

$(HOME)/.clang-format:
	ln -s $(DOTFILES)/.clang-format $@

$(HOME)/Brewfile:
	ln -s $(DOTFILES)/Brewfile $@

clean:
	@echo "Removing dotfile symlinks..."
	@for link in $(SYMLINKS); do \
	    if [ -L $$link ]; then \
	        echo "Removing $$link"; \
	        rm $$link; \
	    else \
	        echo "Skipping $$link (not a symlink)"; \
	    fi; \
	done

.PHONY: all link clean

