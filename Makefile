# This is the path to install (link) the script to
# Change it here, or as argument e.g.:
# make install PREFIX=$HOME/bin
PREFIX=/usr/bin

# Look up the current version from the script
VERSION=$(shell grep '^version=' ./anpro | head -1 | cut -d = -f 2)

.PHONY: clean exec help page uninstall

exec: $(CURDIR)/anpro ## Make the `./anpro` scrip executable
	chmod +x $?

help: ## Show this help message
	@echo "anpro - Annotation Processor ($(VERSION)) - Makefile\n"
	@echo "\033[36mPREFIX \033[0m$(PREFIX)\n"
	@awk -F ":.*?## " \
		'$$0 ~ /^\t/ {next;} \
		 $$0 ~ /#{2}/ {printf "\033[36m%s\033[0m %s\n", $$1, $$2}' \
		 $(MAKEFILE_LIST)

install: $(CURDIR)/anpro ## Install all files to PREFIX
	ln -s $? $(PREFIX)/anpro

uninstall: ## Remove all scripts from PREFIX
	rm -rf $(PREFIX)/anpro

page: index.html ## Generate website files
index.html: README.adoc ## Generate the entry point for the website
	asciidoctor -o $@ $?

clean: ## Remove generated files
	rm -rf index.html
