SHELL := sh

# Both find and install have a BSD and a GNU version which differs and can cause problems.
# GNU install is required
FIND    := find
INSTALL := install

CRFLAGS :=

DESTDIR :=
PREFIX  := /usr/local/
BINDIR  := $(DESTDIR)/$(PREFIX)/bin/
SOURCES := $(shell $(FIND) src -type f -name '*.cr' 2>&-||:)
BUILDDIR:= $(DESTDIR)bin/
MTENV   := $(BUILDDIR)mtenv

release ?=

CRFLAGS += $(if $(release),--release --no-debug,)

all: $(MTENV)

install: $(MTENV) phony
	mkdir -p $(BINDIR)
	$(INSTALL) --mode=755 $(MTENV) $(BINDIR)

uninstall: phony
	if [ -f $(BINDIR)mtenv ]; then; \
		rm -f $(BINDIR)mtenv; \
	else; \
		echo "No installed mtenv found! (Looked in $(BINDIR))"; \
	fi

$(MTENV): $(SOURCES) lib
	mkdir -p $$(dirname $(MTENV))
	$(strip crystal build $(CRFLAGS) -o $@ src/mtenv.cr)

ifneq ($(shell [ -f shard.lock ] && echo exists),)
lib: shard.lock
endif
lib: shard.yml
	shards install
	touch lib/

shard.lock: phony

check: phony
	@test -x $(MTENV) || (echo 'No executable found!' && exit 1)

clean: phony
	rm -f $(MTENV)

touch:
	touch src/mtenv.cr

help:
	@echo -e "all:\t\t Build $(MTENV)"
	@echo -e "install:\t Install mtenv to $(BINDIR)mtenv"
	@echo -e "uninstall:\t Uninstall mtenv"
	@echo -e "clean:\t\t Delete built files"

phony:
