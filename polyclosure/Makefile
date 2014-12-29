LOCAL_RULES := $(wildcard local-*.mk)
include $(LOCAL_RULES)

PROJECT := $(shell basename `pwd`)

all: build/bundle.js $(PROJECT).zip

include ../common/closure.mk
include ../common/polymer.mk
include ../common/webstore.mk

APP_DEPS := $(STATIC_DEPS) $(GENERATED_DEPS) $(APPDIR)/main.html

build: $(APP_DEPS)

$(PROJECT).zip: $(APP_DEPS) $(APPDIR)/window.js
	rm -f $(PROJECT).zip
	cd $(APPDIR) && zip ../$(PROJECT).zip $(patsubst app/%,%,$(APP_DEPS))

clean:
	rm -f $(GENERATED_DEPS)

distclean: clean
	rm $(PROJECT).zip || true

test: build
	echo built

.PHONY: test build clean
