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

release ?=

CRFLAGS += $(if $(release),--release --no-debug,)

all: bin/mtenv

install: bin/mtenv phony
	mkdir -p $(BINDIR)
	$(INSTALL) --mode=755 bin/mtenv $(BINDIR)

uninstall: phony
	rm -f $(BINDIR)/mtenv

bin/mtenv: $(SOURCES) lib
	mkdir -p bin
	crystal build $(CRFLAGS) -o $@ src/mtenv.cr

ifneq ($(shell [ -f shard.lock ] && echo exists),)
lib: shard.lock
endif
lib: shard.yml
	shards install
	touch lib/

shard.lock: phony

check: phony
	@test -f bin/mtenv || (echo 'No executable found!' && exit 1)
	@echo 'All looks good.'

clean: phony
	rm -f bin/mtenv

touch:
	touch src/mtenv.cr

phony:
