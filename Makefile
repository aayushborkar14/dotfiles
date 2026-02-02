STOW     := stow
PACKAGES := brew fish kitty nvim starship

.DEFAULT_GOAL := all

all: link

link:
	$(STOW) $(PACKAGES)

unlink:
	$(STOW) -D $(PACKAGES)

restow:
	$(STOW) -R $(PACKAGES)

adopt:
	$(STOW) --adopt $(PACKAGES)

status:
	$(STOW) -n $(PACKAGES)

clean: unlink

.PHONY: all link unlink restow adopt status clean

