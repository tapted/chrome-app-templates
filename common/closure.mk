SRCDIR ?= .
APPDIR ?= app

SRCS := $(shell cd $(SRCDIR) && ls *.js)
STATIC_DEPS := $(shell find $(APPDIR) -type f -not -name '.*')
GENERATED_DEPS := $(patsubst %,$(APPDIR)/%,$(SRCS))

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
CHROME_EXTERNS := $(SELF_DIR)chrome-externs.js

# compilation_level options: WHITESPACE_ONLY SIMPLE_OPTIMIZATIONS, ADVANCED_OPTIMIZATIONS
LINT := /usr/local/bin/gjslint
CLOSURE := java -jar compiler.jar
CLOSURE_ARGS := --warning_level VERBOSE \
	--compilation_level ADVANCED_OPTIMIZATIONS \
	--language_in ECMASCRIPT5_STRICT \
	--externs $(CHROME_EXTERNS) \
	--formatting=pretty_print \
	--summary_detail_level 3

CLOSURE_LINT_ARGS := --warning_level VERBOSE \
	--compilation_level WHITESPACE_ONLY \
	--language_in ECMASCRIPT5_STRICT

$(APPDIR)/%.js : $(SRCDIR)/%.js
	$(LINT) --unix_mode $<
	$(CLOSURE) $(CLOSURE_LINT_ARGS) --js $< --js_output_file $@ || (rm $@ && false)

build/bundle.js : compiler.jar $(SRCS) Makefile $(CHROME_EXTERNS)
	mkdir -p build
	$(CLOSURE) $(CLOSURE_ARGS) $(patsubst %,--js %,$(SRCS)) --js_output_file $@ || (rm $@ && false)
	cp build/bundle.js $(APPDIR)

$(APPDIR)/soy/%.js : soy/%.js
	$(CLOSURE) $(CLOSURE_ARGS) --js $< --js_output_file $@ || (rm $@ && false)

soy/%.js : $(SRCDIR)/%.soy
	java -jar SoyToJsSrcCompiler.jar --outputPathFormat $@ --srcs $< || (rm $@ && false)

compiler.jar :
	curl -O http://dl.google.com/closure-compiler/compiler-latest.zip
	unzip compiler-latest.zip compiler.jar
	rm compiler-latest.zip
