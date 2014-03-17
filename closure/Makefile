SRCDIR := .
SRCS := $(shell cd $(SRCDIR) && ls *.js)

APPDIR := app
PROJECT := $(shell basename `pwd`)
STATIC_DEPS := $(shell find app -type f -not -name '.*')
GENERATED_DEPS := $(patsubst %,$(APPDIR)/%,$(SRCS))
APP_DEPS := $(STATIC_DEPS) $(GENERATED_DEPS)

# compilation_level options: WHITESPACE_ONLY SIMPLE_OPTIMIZATIONS, ADVANCED_OPTIMIZATIONS
LINT := /usr/local/bin/gjslint
CLOSURE := java -jar compiler.jar
CLOSURE_ARGS := --warning_level VERBOSE \
  --compilation_level ADVANCED_OPTIMIZATIONS \
  --language_in ECMASCRIPT5_STRICT \
  --externs build/externs.js \
  --formatting=pretty_print \
  --summary_detail_level 3

CLOSURE_LINT_ARGS := --warning_level VERBOSE \
  --compilation_level WHITESPACE_ONLY \
  --language_in ECMASCRIPT5_STRICT

all : build/bundle.js $(PROJECT).zip

$(APPDIR)/%.js : $(SRCDIR)/%.js
	$(LINT) --unix_mode $<
	$(CLOSURE) $(CLOSURE_LINT_ARGS) --js $< --js_output_file $@ || (rm $@ && false)

build/bundle.js : compiler.jar $(SRCS) Makefile build/externs.js
	$(CLOSURE) $(CLOSURE_ARGS) $(patsubst %,--js %,$(SRCS)) --js_output_file $@ || (rm $@ && false)
	cp build/bundle.js $(APPDIR)

$(APPDIR)/soy/%.js : soy/%.js
	$(CLOSURE) $(CLOSURE_ARGS) --js $< --js_output_file $@ || (rm $@ && false)

soy/%.js : $(SRCDIR)/%.soy
	java -jar SoyToJsSrcCompiler.jar --outputPathFormat $@ --srcs $< || (rm $@ && false)

build/Assets/resources :
	mkdir -p build/Assets/resources || true

Assets/resources/promo-440x280.png : build/Assets/resources/promo-440x280.jpg
	convert $< $@

build/Assets/resources/promo-440x280.jpg : build/Assets/resources
	convert -size 440x280 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage -shave 1x1 $@

Assets/resources/screenshot-640x400.png : build/Assets/resources/screenshot-640x400.jpg
	convert $< $@

build/Assets/resources/screenshot-640x400.jpg : build/Assets/resources
	convert -size 640x400 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage -shave 1x1 $@

dummyimages : Assets/resources/promo-440x280.png Assets/resources/screenshot-640x400.png

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

compiler.jar :
	curl -O http://dl.google.com/closure-compiler/compiler-latest.zip
	unzip compiler-latest.zip compiler.jar
	rm compiler-latest.zip
