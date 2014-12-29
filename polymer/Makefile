LOCAL_RULES := $(wildcard local-*.mk)
include $(LOCAL_RULES)

SRCDIR := .
SRCS := $(shell cd $(SRCDIR) && ls *.js)

APPDIR := app
PROJECT := $(shell basename `pwd`)
STATIC_DEPS := $(shell find app -type f -not -name '.*')
GENERATED_DEPS := $(patsubst %,$(APPDIR)/%,$(SRCS)) $(APPDIR)/main.html
APP_DEPS := $(STATIC_DEPS) $(GENERATED_DEPS)

all: $(PROJECT).zip

include ../common/polymer.mk
include ../common/webstore.mk

app/main.html: app/index.html bower_components.updated
	$(VULCANIZE) -o $@ $< --csp

build : $(APP_DEPS)

$(PROJECT).zip: $(APP_DEPS) $(APPDIR)/window.js
	rm -f $(PROJECT).zip
	cd $(APPDIR) && zip ../$(PROJECT).zip $(patsubst app/%,%,$(APP_DEPS))

clean:
	rm -f $(GENERATED_DEPS)

distclean: clean
	rm $(PROJECT).zip || true

test: build
	echo built

run: $(PROJECT).zip
	$(CHROME) --load-and-launch-app=$(CURDIR)/app

.PHONY: test build clean run
