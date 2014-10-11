# Determine package name and version from DESCRIPTION file
PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

# Roxygen version to check before generating documentation
ROXYGEN_VERSION=4.0.1

# Name of built package
PKG_TAR=$(PKG_NAME)_$(PKG_VERSION).tar.gz

# Install package
install:
	cd .. && R CMD INSTALL $(PKG_NAME)

README.md: README.Rmd
	Rscript -e "library(knitr); knit('README.Rmd', quiet = TRUE)"

# Build documentation with roxygen
# 1) Check version of roxygen2 before building documentation
# 2) Remove old doc
# 3) Generate documentation
roxygen:
	Rscript -e "library(roxygen2); stopifnot(packageVersion('roxygen2') == '$(ROXYGEN_VERSION)')"
	rm -f man/*.Rd
	cd .. && Rscript -e "library(methods); library(roxygen2); roxygenize('$(PKG_NAME)')"

# Build and check package
check: clean
	cd .. && R CMD build --no-build-vignettes $(PKG_NAME)
	cd .. && R CMD check --no-manual --no-vignettes --no-build-vignettes $(PKG_TAR)

clean:
	-rm -f config.log
	-rm -f config.status
	-rm -rf autom4te.cache
	-rm -f src/*.o
	-rm -f src/*.so
	-rm -rf src-x64
	-rm -rf src-i386

.PHONY: install roxygen check clean
