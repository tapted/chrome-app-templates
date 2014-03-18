## If not in the path, try to find these in homebrew locations (mac)
BREW ?= $(shell which brew)

BREW_ROOT ?= $(patsubst %/bin/,%,$(dir $(BREW)))
BREW_ROOT := $(if $(BREW_ROOT),$(BREW_ROOT),$(HOME)/homebrew)
NPM := $(if $(NPM),$(NPM),$(BREW_ROOT)/bin/npm)
BOWER := $(if $(BOWER),$(BOWER),$(BREW_ROOT)/share/npm/bin/bower)
VULCANIZE := $(if $(VULCANIZE),$(VULCANIZE),$(BREW_ROOT)/share/npm/bin/vulcanize)

$(BREW):
	git clone https://github.com/mxcl/homebrew.git $(BREW_ROOT)

$(NPM): $(BREW)
	$(BREW) install npm
