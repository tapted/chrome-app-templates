LOCAL_RULES := $(wildcard local-*.mk)
include $(LOCAL_RULES)

SRCDIR := .
SRCS := $(shell cd $(SRCDIR) && ls *.js)

APPDIR := app
PROJECT := $(shell basename `pwd`)
STATIC_DEPS := $(shell find app -type f -not -name '.*')
GENERATED_DEPS := $(patsubst %,$(APPDIR)/%,$(SRCS)) $(APPDIR)/main.html
APP_DEPS := $(STATIC_DEPS) $(GENERATED_DEPS)

NPM ?= $(shell which npm)
BOWER ?= $(shell which bower)
VULCANIZE ?= $(shell which vulcanize)
CHROME ?= $(shell which chrome)

SYSTEM := $(shell uname -s)
PLATFORM ?= $(if \
  $(findstring Darwin, $(SYSTEM)),mac,$(if \
    $(findstring CYGWIN, $(SYSTEM)),win,linux))

all: $(PROJECT).zip

include requirements-$(PLATFORM).mk

run: $(PROJECT).zip
	$(CHROME) --load-and-launch-app=$(CURDIR)/app

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

build/Assets/resources :
	mkdir -p build/Assets/resources || true

build/Assets/resources/promo-440x280.png : build/Assets/resources/promo-440x280.jpg
	convert $< $@

build/Assets/resources/promo-440x280.jpg : build/Assets/resources
	convert -size 440x280 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage -shave 1x1 $@

build/Assets/resources/screenshot-640x400.png : build/Assets/resources/screenshot-640x400.jpg
	convert $< $@

build/Assets/resources/screenshot-640x400.jpg : build/Assets/resources
	convert -size 640x400 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage -shave 1x1 $@

dummyimages : build/Assets/resources/promo-440x280.png build/Assets/resources/screenshot-640x400.png

clean:
	rm -f $(GENERATED_DEPS)

distclean: clean
	rm $(PROJECT).zip

.PHONY : test build clean dummyimages

build : $(APP_DEPS)

test : build
	echo built

$(PROJECT).zip : $(APP_DEPS) $(APPDIR)/window.js
	rm -f $(PROJECT).zip
	cd $(APPDIR) && zip ../$(PROJECT).zip $(patsubst app/%,%,$(APP_DEPS))
