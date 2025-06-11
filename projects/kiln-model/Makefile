FC      := /usr/bin/gfortran
PROFILE := "debug"

VENV := venv

.PHONY: all
all:
	fpm build --compiler $(FC) --profile $(PROFILE) --no-prune

.PHONY: dist
dist: all
	fpm install --prefix dist --bindir /

$(VENV): docs/requirements.txt
	python3 -m venv $(VENV)
	. $(VENV)/bin/activate && python3 -m pip install --upgrade pip
	. $(VENV)/bin/activate && pip install -r docs/requirements.txt

.PHONY: docs
docs: $(VENV) docs/src/*.md
	. $(VENV)/bin/activate && ford $(PWD)/docs/src/index.md -r 0.0.1

.PHONY: test
test: all
	fpm test
	
.PHONY: clean
clean:
	fpm clean --all

.PHONY: dist-clean
dist-clean: clean
	rm -rf dist/ docs/build/ $(VENV) src/*.mod test/*.mod
