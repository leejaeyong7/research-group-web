# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build

BIBBLE = bibble
SHELL = /bin/bash
HOME_PATH = /home/lee896
BIBBLE_ENV = bibble
APP_ENV = hoiemgroup
JEKYLL_ENV = jekyll

_includes/pubs.html: bib/pubs.bib bib/publications.tmpl
	mkdir -p _includes
	source $(HOME_PATH)/virtualenv/bibble/2.7/bin/activate && \
	$(BIBBLE) $+ > $@
	source $(HOME_PATH)/virtualenv/hoiemgroup/3.7/bin/activate

build:
	mkdir -p _includes
	source $(HOME_PATH)/virtualenv/$(BIBBLE_ENV)/2.7/bin/activate && \
	$(BIBBLE) bib/pubs.bib bib/publications.tmpl > _includes/pubs.html
	source $(HOME_PATH)/virtualenv/$(APP_ENV)/3.7/bin/activate
	source /home/lee896/rubyvenv/$(JEKYLL_ENV)/2.6/bin/activate && \
	jekyll build

# you can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

serve: _includes/pubs.html
	source /home/lee896/rubyvenv/jekyll/2.6/bin/activate
	jekyll serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
	$(RM) -r _site _includes/pubs.html

DEPLOY_PATH ?= $(HOME_PATH)/public_html/
RSYNC := rsync --compress --recursive --checksum --itemize-changes --delete -e ssh

deploy: clean build
	$(RSYNC) _site/ $(DEPLOY_PATH)
