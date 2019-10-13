.PHONY: install update requirements.txt

install: update

update:
	pip install -U pip
	pip install -U -r requirements.txt
	$(MAKE) requirements.txt

requirements.txt:
	pip freeze | grep -v 0.0.0 > $@

.PHONY: merge release

MERGE  = Makefile README.md .gitignore
MERGE += biz.py biz.ini
MERGE += biz.nim metaL.nim nim.cfg bis.nimble

merge:
	git checkout master
	git checkout ponyatov -- $(MERGE)

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
