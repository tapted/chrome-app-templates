NPM ?= $(shell which npm)
BOWER ?= $(shell which bower)
VULCANIZE ?= $(shell which vulcanize)
CHROME ?= $(shell which chrome)

SYSTEM := $(shell uname -s)
PLATFORM ?= $(if \
	$(findstring Darwin, $(SYSTEM)),mac,$(if \
		$(findstring CYGWIN, $(SYSTEM)),win,linux))

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)polymer-$(PLATFORM).mk

$(BOWER): $(NPM)
	$(NPM) install -g bower
	touch $@

$(VULCANIZE): $(NPM)
	$(NPM) install -g vulcanize
	touch $@

bower_components.updated: $(BOWER) $(VULCANIZE)
	## Bower is screwy if it finds other things in $PATH.
	(cd app && PATH="$(dir $(BOWER)):${PATH}" bower update)
	touch $@

app/main.html: app/index.html bower_components.updated
	$(VULCANIZE) -o $@ $< --csp
