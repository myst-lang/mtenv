SHELL := sh

# Both find and install have a BSD and a GNU version which differs and can cause problems.
# GNU install is required
FIND    := find
INSTALL := install
CRFLAGS :=
DESTDIR := /
PREFIX  := $(DESTDIR)usr/local/
BINDIR  := $(DESTDIR)$(PREFIX)bin/
SOURCES := $(shell $(FIND) src -type f -name '*.cr' 2>&-||:)

all: bin/mtenv

install: phony
	mkdir -p $(BINDIR)
	$(MAKE) all CRFLAGS="--release --no-debug"
	$(INSTALL) --mode=755 bin/mtenv $(BINDIR)

uninstall: phony
	rm -f $(BINDIR)/mtenv

ifdef CRFLAGS
bin/mtenv: phony
endif
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
	[ -f bin/mtenv ]

clean: phony
	rm -f bin/mtenv 2>&-||:

touch:
	touch src/mtenv.cr

phony:
