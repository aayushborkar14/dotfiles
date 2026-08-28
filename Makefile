STOW     := stow
PACKAGES := brew fish kitty nvim starship codelldb

.DEFAULT_GOAL := all

CODELLDB_URL := https://github.com/vadimcn/codelldb/releases/latest/download/codelldb-darwin-arm64.vsix
CODELLDB_DIR := $(HOME)/.local/share/codelldb

all: link

codelldb:
	@tmp=$$(mktemp -d); \
	curl -L $(CODELLDB_URL) -o $$tmp/codelldb.vsix; \
	unzip -q $$tmp/codelldb.vsix -d $$tmp; \
	rm -rf $(CODELLDB_DIR); \
	mv $$tmp/extension $(CODELLDB_DIR); \
	rm -rf $$tmp

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

