NCPUS ?= 1

BASE := p1 p2 p3 # p4 p5

BASE_I := $(BASE:%=.install/%)

.PHONY: all install

all: install

install: $(BASE_I)

### Dependencies
.install/all: $(BASE_I)

depends = .install/$(1)

$(call depends,p1): .install/p2 .install/p3
$(call depends,p4): .install/p5

clean:
	rm -rf .install

.install/devtools:
	Rscript -e "if(!require('devtools')) install.packages('devtools', repos = 'http://cran.rstudio.com', Ncpus = ${NCPUS})"
	mkdir -p $(@D)
	echo `date` > $@

install_R_pkg = Rscript -e "devtools::install('$(strip $(1))', Ncpus = ${NCPUS});"

$(BASE_I): .install/devtools

.SECONDEXPANSION:
.install/%: $$(wildcard %/**/*) $$(wildcard %/*)
	$(call install_R_pkg, $(subst .install/,,$@))
	mkdir -p $(@D)
	echo `date` > $@
