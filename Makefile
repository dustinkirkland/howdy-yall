PREFIX  ?= /usr/local
DESTDIR ?=

all: \
	asm \
	bash \
	c \
	cpp \
	erlang \
	fortran \
	go \
	java \
	lua \
	node \
	ocaml \
	perl \
	php \
	python \
	r \
	ruby \
	rust \
	scheme \
	tcl \
	typescript

deps:
	# install build dependencies, detecting distro and package manager
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update; \
		sudo apt-get install -y \
			bash \
			erlang \
			gcc \
			g++ \
			gfortran \
			golang-go \
			default-jdk \
			guile-3.0 \
			lua5.4 \
			nasm \
			nodejs \
			ocaml \
			perl \
			php-cli \
			python3 \
			ruby \
			node-typescript \
			r-base \
			rustc \
			tcl \
			ghc \
			clisp \
			fp-compiler; \
	elif command -v apk >/dev/null 2>&1; then \
		apk add --no-cache \
			bash \
			build-base \
			erlang \
			gfortran \
			go \
			default-jdk \
			guile \
			lua5.4 \
			nasm \
			nodejs \
			ocaml \
			perl \
			php \
			python3 \
			R \
			ruby \
			typescript \
			rust \
			tcl; \
	else \
		echo "Unsupported distro: no apt-get or apk found"; exit 1; \
	fi

run: all
	bin/howdy-asm
	bin/howdy-bash
	bin/howdy-c
	bin/howdy-cpp
	bin/howdy-erlang
	bin/howdy-fortran
	bin/howdy-go
	bin/howdy-java
	bin/howdy-lua
	bin/howdy-node
	bin/howdy-ocaml
	bin/howdy-perl
	bin/howdy-php
	bin/howdy-python
	bin/howdy-r
	bin/howdy-ruby
	bin/howdy-rust
	bin/howdy-scheme
	bin/howdy-tcl
	bin/howdy-typescript

test: \
	test-asm \
	test-bash \
	test-c \
	test-cpp \
	test-erlang \
	test-fortran \
	test-go \
	test-java \
	test-lua \
	test-node \
	test-ocaml \
	test-perl \
	test-php \
	test-python \
	test-r \
	test-ruby \
	test-rust \
	test-scheme \
	test-tcl \
	test-typescript
	@echo ""
	@echo "All tests passed!"

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m755 \
		bin/howdy-asm \
		bin/howdy-bash \
		bin/howdy-c \
		bin/howdy-cpp \
		bin/howdy-fortran \
		bin/howdy-go \
		bin/howdy-lua \
		bin/howdy-node \
		bin/howdy-ocaml \
		bin/howdy-perl \
		bin/howdy-php \
		bin/howdy-python \
		bin/howdy-r \
		bin/howdy-ruby \
		bin/howdy-rust \
		bin/howdy-scheme \
		bin/howdy-tcl \
		bin/howdy-typescript \
		$(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/share/howdy/erlang
	install -m644 bin/howdy.beam $(DESTDIR)$(PREFIX)/share/howdy/erlang/howdy.beam
	echo '#!/bin/sh'                                                                             > $(DESTDIR)$(PREFIX)/bin/howdy-erlang
	echo 'exec erl -noshell -pa $(PREFIX)/share/howdy/erlang -s howdy howdy -s init stop'       >> $(DESTDIR)$(PREFIX)/bin/howdy-erlang
	chmod 755 $(DESTDIR)$(PREFIX)/bin/howdy-erlang
	install -d $(DESTDIR)$(PREFIX)/share/howdy/java
	install -m644 bin/Howdy.class $(DESTDIR)$(PREFIX)/share/howdy/java/Howdy.class
	echo '#!/bin/sh'                                                 > $(DESTDIR)$(PREFIX)/bin/howdy-java
	echo 'exec java -classpath $(PREFIX)/share/howdy/java Howdy'    >> $(DESTDIR)$(PREFIX)/bin/howdy-java
	chmod 755 $(DESTDIR)$(PREFIX)/bin/howdy-java

.PHONY: all deps run test install clean
.PHONY: \
	asm \
	bash \
	c \
	cpp \
	erlang \
	fortran \
	go \
	java \
	lua \
	node \
	ocaml \
	perl \
	php \
	python \
	r \
	ruby \
	rust \
	scheme \
	tcl \
	typescript
.PHONY: haskell lisp pascal
.PHONY: \
	test-asm \
	test-bash \
	test-c \
	test-cpp \
	test-erlang \
	test-fortran \
	test-go \
	test-java \
	test-lua \
	test-node \
	test-ocaml \
	test-perl \
	test-php \
	test-python \
	test-r \
	test-ruby \
	test-rust \
	test-scheme \
	test-tcl \
	test-typescript

clean:
	rm -rf bin/
	rm -f haskell/howdy haskell/howdy.hi haskell/howdy.o
	rm -f pascal/howdy pascal/howdy.o

bin:
	mkdir -p bin

# --- compiled languages ---

asm: | bin
	nasm -f elf64 asm/howdy.asm -o bin/howdy-asm.o
	ld bin/howdy-asm.o -o bin/howdy-asm
	rm bin/howdy-asm.o

c: | bin
	gcc -o bin/howdy-c c/howdy.c

cpp: | bin
	g++ -o bin/howdy-cpp cpp/howdy.cpp

fortran: | bin
	gfortran -o bin/howdy-fortran fortran/howdy.f90

go: | bin
	go build -o bin/howdy-go go/howdy.go

ocaml: | bin
	ocamlopt -o bin/howdy-ocaml ocaml/howdy.ml

rust: | bin
	rustc rust/howdy.rs -o bin/howdy-rust

erlang: | bin
	erlc -o bin erlang/howdy.erl
	echo '#!/bin/sh'                                                            > bin/howdy-erlang
	echo 'D=$$(cd "$$(dirname "$$0")" && pwd)'                                  >> bin/howdy-erlang
	echo 'exec erl -noshell -pa "$$D" -s howdy howdy -s init stop'              >> bin/howdy-erlang
	chmod 755 bin/howdy-erlang

java: | bin
	javac -d bin java/Howdy.java
	echo '#!/bin/sh'                                            > bin/howdy-java
	echo 'D=$$(cd "$$(dirname "$$0")" && pwd)'                  >> bin/howdy-java
	echo 'exec java -classpath "$$D" Howdy'                     >> bin/howdy-java
	chmod 755 bin/howdy-java

# optional compiled languages (not in 'all', not tested in CI)
haskell:
	ghc -o haskell/howdy haskell/howdy.hs
	./haskell/howdy

pascal:
	pc pascal/howdy.pas
	./pascal/howdy

# --- script languages (copy + fix shebang) ---

bash: | bin
	cp bash/howdy.sh bin/howdy-bash
	sed -i '1s|.*|#!/bin/bash|' bin/howdy-bash
	chmod 755 bin/howdy-bash

lua: | bin
	cp lua/howdy.lua bin/howdy-lua
	sed -i '1i #!/usr/bin/env lua5.4' bin/howdy-lua
	chmod 755 bin/howdy-lua

node: | bin
	cp node/howdy.js bin/howdy-node
	sed -i '1i #!/usr/bin/env node' bin/howdy-node
	chmod 755 bin/howdy-node

perl: | bin
	cp perl/howdy.pl bin/howdy-perl
	sed -i '1s|.*|#!/usr/bin/env perl|' bin/howdy-perl
	chmod 755 bin/howdy-perl

php: | bin
	cp php/howdy.php bin/howdy-php
	sed -i '1s|.*|#!/usr/bin/env php|' bin/howdy-php
	chmod 755 bin/howdy-php

python: | bin
	cp python/howdy.py bin/howdy-python
	sed -i '1s|.*|#!/usr/bin/env python3|' bin/howdy-python
	chmod 755 bin/howdy-python

ruby: | bin
	cp ruby/howdy.rb bin/howdy-ruby
	sed -i '1s|.*|#!/usr/bin/env ruby|' bin/howdy-ruby
	chmod 755 bin/howdy-ruby

typescript: | bin
	mkdir -p bin/typescript
	tsc typescript/howdy.ts --outDir bin/typescript
	echo '#!/bin/sh'                                                                     > bin/howdy-typescript
	echo 'D=$$(cd "$$(dirname "$$0")" && pwd)'                                           >> bin/howdy-typescript
	echo 'exec node "$$D/typescript/howdy.js"'                                           >> bin/howdy-typescript
	chmod 755 bin/howdy-typescript

r: | bin
	cp r/howdy.R bin/howdy-r
	sed -i '1i #!/usr/bin/env Rscript' bin/howdy-r
	chmod 755 bin/howdy-r

tcl: | bin
	cp tcl/howdy.tcl bin/howdy-tcl
	sed -i '1s|.*|#!/usr/bin/env tclsh|' bin/howdy-tcl
	chmod 755 bin/howdy-tcl

scheme: | bin
	cp scheme/howdy.scm bin/howdy-scheme
	sed -i '1i #!/usr/bin/env guile' bin/howdy-scheme
	sed -i '2i !#' bin/howdy-scheme
	chmod 755 bin/howdy-scheme

# optional script languages (not in 'all')
lisp:
	clisp lisp/howdy.lisp

# --- test targets ---

test-asm: asm
	bin/howdy-asm | grep -q "Assembly: Howdy!"
	@echo "PASS: asm"

test-bash: bash
	bin/howdy-bash | grep -q "Shell: Howdy!"
	@echo "PASS: bash"

test-c: c
	bin/howdy-c | grep -q "C: Howdy!"
	@echo "PASS: c"

test-cpp: cpp
	bin/howdy-cpp | grep -q "C++: Howdy!"
	@echo "PASS: cpp"

test-erlang: erlang
	bin/howdy-erlang | grep -q "Erlang: Howdy!"
	@echo "PASS: erlang"

test-fortran: fortran
	bin/howdy-fortran | grep -q "Fortran: Howdy!"
	@echo "PASS: fortran"

test-go: go
	bin/howdy-go | grep -q "Golang: Howdy!"
	@echo "PASS: go"

test-java: java
	bin/howdy-java | grep -q "Java: Howdy!"
	@echo "PASS: java"

test-lua: lua
	bin/howdy-lua | grep -q "Lua: Howdy!"
	@echo "PASS: lua"

test-node: node
	bin/howdy-node | grep -q "NodeJS: Howdy!"
	@echo "PASS: node"

test-ocaml: ocaml
	bin/howdy-ocaml | grep -q "OCaml: Howdy!"
	@echo "PASS: ocaml"

test-perl: perl
	bin/howdy-perl | grep -q "Perl: Howdy!"
	@echo "PASS: perl"

test-php: php
	bin/howdy-php | grep -q "PHP: Howdy!"
	@echo "PASS: php"

test-python: python
	bin/howdy-python | grep -q "Python: Howdy!"
	@echo "PASS: python"

test-r: r
	bin/howdy-r | grep -q "R: Howdy!"
	@echo "PASS: r"

test-ruby: ruby
	bin/howdy-ruby | grep -q "Ruby: Howdy!"
	@echo "PASS: ruby"

test-rust: rust
	bin/howdy-rust | grep -q "Rust: Howdy!"
	@echo "PASS: rust"

test-scheme: scheme
	bin/howdy-scheme | grep -q "Scheme: Howdy!"
	@echo "PASS: scheme"

test-tcl: tcl
	bin/howdy-tcl | grep -q "Tcl: Howdy!"
	@echo "PASS: tcl"

test-typescript: typescript
	bin/howdy-typescript | grep -q "TypeScript: Howdy!"
	@echo "PASS: typescript"
