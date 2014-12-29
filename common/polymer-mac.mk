## If not in the path, try to find these in homebrew locations (mac)
BREW ?= $(shell which brew)
BREW := $(if $(BREW),$(BREW),$(HOME)/homebrew/bin/brew)

BREW_ROOT ?= $(patsubst %/bin/,%,$(dir $(BREW)))
BREW_ROOT := $(if $(BREW_ROOT),$(BREW_ROOT),$(HOME)/homebrew)
NPM := $(if $(NPM),$(NPM),$(BREW_ROOT)/bin/npm)
BOWER := $(if $(BOWER),$(BOWER),$(BREW_ROOT)/bin/bower)
VULCANIZE := $(if $(VULCANIZE),$(VULCANIZE),$(BREW_ROOT)/bin/vulcanize)
CHROME := $(if $(CHROME),$(CHROME),open -a "Google Chrome" --args)

$(BREW):
	git clone https://github.com/mxcl/homebrew.git $(BREW_ROOT)

$(NPM): $(BREW)
	$(BREW) install npm || true
