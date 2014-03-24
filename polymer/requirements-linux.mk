CHROME := $(if $(CHROME),$(CHROME),/usr/bin/google-chrome)
DISTRO := $(shell sed -ne '/^DISTRIB_CODENAME=/ {s/.*=//;p}' /etc/lsb-release)

## npm on precise is too old. Just fetch the damn thing.
ifeq ($(DISTRO),precise)
NPM := $(if $(NPM),$(NPM),$(CURDIR)/node/bin/npm)

SHASUMS.txt:
	curl -O http://nodejs.org/dist/latest/SHASUMS.txt

NODEDL = $(shell grep -o 'node-v[0-9.]*.tar.gz' SHASUMS.txt)
NODEDIR = $(patsubst %.tar.gz,%,$(NODEDL))

$(NPM): SHASUMS.txt
	@echo "#################################################"
	@echo "## npm on Precise is too old. Fetching latest. ##"
	@echo "#################################################"
	curl -O http://nodejs.org/dist/latest/$(NODEDL)
	tar xf $(NODEDL)
	(cd $(NODEDIR) && ./configure --prefix=$(CURDIR)/node)
	$(MAKE) -C $(NODEDIR) install

else
NPM := $(if $(NPM),$(NPM),/usr/bin/npm)
$(NPM):
	sudo aptitude install npm

endif

BOWER := $(if $(BOWER),$(BOWER),$(dir $(NPM))bower)
VULCANIZE := $(if $(VULCANIZE),$(VULCANIZE),$(dir $(NPM))vulcanize)
