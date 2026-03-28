PREFIX  ?= /usr/local
DESTDIR ?=

all: \
	asm \
	bash \
	busybox \
	c \
	cpp \
	csharp \
	dash \
	elvish \
	erlang \
	fish \
	fortran \
	go \
	java \
	ksh \
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
	typescript \
	vala \
	zsh

deps:
	# install build dependencies, detecting distro and package manager
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update; \
		sudo apt-get install -y \
			bash \
			busybox \
			dash \
			erlang \
			fish \
			gcc \
			g++ \
			gfortran \
			golang-go \
			default-jdk \
			guile-3.0 \
			elvish \
			ksh \
			lua5.4 \
			mksh \
			nasm \
			nodejs \
			ocaml \
			perl \
			php-cli \
			python3 \
			ruby \
			node-typescript \
			valac \
			r-base \
			rustc \
			tcl \
			yash \
			zsh \
			dotnet-sdk-8.0 \
			ghc \
			clisp \
			fp-compiler; \
	elif command -v apk >/dev/null 2>&1; then \
		apk add --no-cache \
			bash \
			build-base \
			busybox \
			dash \
			elvish \
			erlang \
			fish \
			gfortran \
			go \
			default-jdk \
			guile \
			ksh \
			lua5.4 \
			nasm \
			nodejs \
			ocaml \
			perl \
			php \
			dart \
			dotnet-8-sdk \
			powershell \
			nushell \
			zig \
			python3 \
			R \
			ruby \
			scala \
			rust \
			tcl \
			typescript \
			vala \
			zsh; \
	else \
		echo "Unsupported distro: no apt-get or apk found"; exit 1; \
	fi

run: all
	bin/howdy-asm
	bin/howdy-bash
	bin/howdy-busybox
	bin/howdy-c
	bin/howdy-cpp
	bin/howdy-csharp
	bin/howdy-dash
	bin/howdy-elvish
	bin/howdy-erlang
	bin/howdy-fish
	bin/howdy-fortran
	bin/howdy-go
	bin/howdy-java
	bin/howdy-ksh
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
	bin/howdy-vala
	bin/howdy-zsh

test: \
	test-asm \
	test-bash \
	test-busybox \
	test-c \
	test-cpp \
	test-csharp \
	test-dash \
	test-elvish \
	test-erlang \
	test-fish \
	test-fortran \
	test-go \
	test-java \
	test-ksh \
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
	test-typescript \
	test-vala \
	test-zsh
	@echo ""
	@echo "All tests passed!"

test-only-on-ubuntu: \
	test-mksh \
	test-yash
	@echo ""
	@echo "All Ubuntu-only tests passed!"

test-only-on-chainguard: \
	test-dart \
	test-pwsh \
	test-nushell \
	test-scala \
	test-zig
	@echo ""
	@echo "All Chainguard-only tests passed!"

test-install:
	rm -rf /tmp/howdy-install
	$(MAKE) install PREFIX=/tmp/howdy-install
	/tmp/howdy-install/bin/howdy-asm        | grep -F "Assembly: Howdy!"
	/tmp/howdy-install/bin/howdy-bash       | grep -F "Bash: Howdy!"
	/tmp/howdy-install/bin/howdy-busybox    | grep -F "BusyBox: Howdy!"
	/tmp/howdy-install/bin/howdy-c          | grep -F "C: Howdy!"
	/tmp/howdy-install/bin/howdy-cpp        | grep -F "C++: Howdy!"
	/tmp/howdy-install/bin/howdy-csharp     | grep -F "C#: Howdy!"
	/tmp/howdy-install/bin/howdy-dash       | grep -F "Dash: Howdy!"
	/tmp/howdy-install/bin/howdy-erlang     | grep -F "Erlang: Howdy!"
	/tmp/howdy-install/bin/howdy-fish       | grep -F "Fish: Howdy!"
	/tmp/howdy-install/bin/howdy-fortran    | grep -F "Fortran: Howdy!"
	/tmp/howdy-install/bin/howdy-go         | grep -F "Golang: Howdy!"
	/tmp/howdy-install/bin/howdy-java       | grep -F "Java: Howdy!"
	/tmp/howdy-install/bin/howdy-ksh        | grep -F "Ksh: Howdy!"
	/tmp/howdy-install/bin/howdy-lua        | grep -F "Lua: Howdy!"
	/tmp/howdy-install/bin/howdy-node       | grep -F "NodeJS: Howdy!"
	/tmp/howdy-install/bin/howdy-ocaml      | grep -F "OCaml: Howdy!"
	/tmp/howdy-install/bin/howdy-perl       | grep -F "Perl: Howdy!"
	/tmp/howdy-install/bin/howdy-php        | grep -F "PHP: Howdy!"
	/tmp/howdy-install/bin/howdy-python     | grep -F "Python: Howdy!"
	/tmp/howdy-install/bin/howdy-r          | grep -F "R: Howdy!"
	/tmp/howdy-install/bin/howdy-ruby       | grep -F "Ruby: Howdy!"
	/tmp/howdy-install/bin/howdy-rust       | grep -F "Rust: Howdy!"
	/tmp/howdy-install/bin/howdy-scheme     | grep -F "Scheme: Howdy!"
	/tmp/howdy-install/bin/howdy-tcl        | grep -F "Tcl: Howdy!"
	/tmp/howdy-install/bin/howdy-typescript | grep -F "TypeScript: Howdy!"
	/tmp/howdy-install/bin/howdy-vala       | grep -F "Vala: Howdy!"
	/tmp/howdy-install/bin/howdy-zsh        | grep -F "Zsh: Howdy!"
	@echo ""
	@echo "All install tests passed!"

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m755 \
		bin/howdy-asm \
		bin/howdy-bash \
		bin/howdy-busybox \
		bin/howdy-c \
		bin/howdy-cpp \
		bin/howdy-csharp \
		bin/howdy-dash \
		bin/howdy-elvish \
		bin/howdy-fish \
		bin/howdy-fortran \
		bin/howdy-go \
		bin/howdy-ksh \
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
		bin/howdy-vala \
		bin/howdy-zsh \
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
	install -d $(DESTDIR)$(PREFIX)/share/howdy/typescript
	install -m644 bin/typescript/howdy.js $(DESTDIR)$(PREFIX)/share/howdy/typescript/howdy.js
	echo '#!/bin/sh'                                                                > $(DESTDIR)$(PREFIX)/bin/howdy-typescript
	echo 'exec node "$(PREFIX)/share/howdy/typescript/howdy.js"'                   >> $(DESTDIR)$(PREFIX)/bin/howdy-typescript
	chmod 755 $(DESTDIR)$(PREFIX)/bin/howdy-typescript

.PHONY: all deps run test test-install install clean
.PHONY: test-only-on-ubuntu test-only-on-chainguard
.PHONY: \
	asm \
	bash \
	busybox \
	c \
	cpp \
	csharp \
	dash \
	elvish \
	erlang \
	fish \
	fortran \
	go \
	java \
	ksh \
	lua \
	mksh \
	node \
	ocaml \
	perl \
	php \
	python \
	r \
	ruby \
	rust \
	scala \
	scheme \
	tcl \
	typescript \
	vala \
	yash \
	zsh
.PHONY: dart haskell lisp pascal pwsh nushell zig
.PHONY: \
	test-asm \
	test-bash \
	test-busybox \
	test-c \
	test-cpp \
	test-csharp \
	test-dash \
	test-elvish \
	test-erlang \
	test-fish \
	test-fortran \
	test-go \
	test-java \
	test-ksh \
	test-lua \
	test-mksh \
	test-node \
	test-ocaml \
	test-perl \
	test-php \
	test-python \
	test-r \
	test-ruby \
	test-rust \
	test-scala \
	test-scheme \
	test-tcl \
	test-typescript \
	test-vala \
	test-yash \
	test-zsh \
	test-dart \
	test-pwsh \
	test-nushell \
	test-zig

clean:
	rm -rf bin/
	rm -f haskell/howdy haskell/howdy.hi haskell/howdy.o
	rm -f pascal/howdy pascal/howdy.o

bin:
	mkdir -p bin

# --- compiled languages ---

# dart: Chainguard-only (not in 'all'; tested via test-only-on-chainguard)
dart: | bin
	dart compile exe dart/howdy.dart -o bin/howdy-dart

asm: | bin
	nasm -f elf64 asm/howdy.asm -o bin/howdy-asm.o
	ld bin/howdy-asm.o -o bin/howdy-asm
	rm bin/howdy-asm.o

c: | bin
	gcc -o bin/howdy-c c/howdy.c

cpp: | bin
	g++ -o bin/howdy-cpp cpp/howdy.cpp

csharp: | bin
	dotnet publish csharp/howdy.csproj \
		-c Release \
		--self-contained \
		-r linux-x64 \
		-p:PublishSingleFile=true \
		-o /tmp/howdy-csharp
	cp /tmp/howdy-csharp/howdy bin/howdy-csharp
	chmod 755 bin/howdy-csharp

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

# --- shell languages (all derived from shell/howdy.sh or shell/howdy.ps1) ---

bash: | bin
	cp shell/howdy.sh bin/howdy-bash
	sed -i '1s|.*|#!/usr/bin/env bash|; s/Shell:/Bash:/' bin/howdy-bash
	chmod 755 bin/howdy-bash

busybox: | bin
	cp shell/howdy.sh bin/howdy-busybox
	sed -i '1s|.*|#!/bin/busybox sh|; s/Shell:/BusyBox:/' bin/howdy-busybox
	chmod 755 bin/howdy-busybox

dash: | bin
	cp shell/howdy.sh bin/howdy-dash
	sed -i '1s|.*|#!/usr/bin/env dash|; s/Shell:/Dash:/' bin/howdy-dash
	chmod 755 bin/howdy-dash

elvish: | bin
	cp shell/howdy.sh bin/howdy-elvish
	sed -i '1s|.*|#!/usr/bin/env elvish|; s/Shell:/Elvish:/' bin/howdy-elvish
	chmod 755 bin/howdy-elvish

fish: | bin
	cp shell/howdy.sh bin/howdy-fish
	sed -i '1s|.*|#!/usr/bin/env fish|; s/Shell:/Fish:/' bin/howdy-fish
	chmod 755 bin/howdy-fish

ksh: | bin
	cp shell/howdy.sh bin/howdy-ksh
	sed -i '1s|.*|#!/usr/bin/env ksh|; s/Shell:/Ksh:/' bin/howdy-ksh
	chmod 755 bin/howdy-ksh

mksh: | bin
	cp shell/howdy.sh bin/howdy-mksh
	sed -i '1s|.*|#!/usr/bin/env mksh|; s/Shell:/Mksh:/' bin/howdy-mksh
	chmod 755 bin/howdy-mksh

yash: | bin
	cp shell/howdy.sh bin/howdy-yash
	sed -i '1s|.*|#!/usr/bin/env yash|; s/Shell:/Yash:/' bin/howdy-yash
	chmod 755 bin/howdy-yash

zsh: | bin
	cp shell/howdy.sh bin/howdy-zsh
	sed -i '1s|.*|#!/usr/bin/env zsh|; s/Shell:/Zsh:/' bin/howdy-zsh
	chmod 755 bin/howdy-zsh

# pwsh: Chainguard-only (not in 'all'; tested via test-only-on-chainguard)
pwsh: | bin
	cp powershell/howdy.ps1 bin/howdy-pwsh
	sed -i '1i #!/usr/bin/env pwsh' bin/howdy-pwsh
	chmod 755 bin/howdy-pwsh

# nushell: Chainguard-only (not in 'all'; tested via test-only-on-chainguard)
nushell: | bin
	cp nushell/howdy.nu bin/howdy-nushell
	chmod 755 bin/howdy-nushell

# zig: Chainguard-only (not in 'all'; tested via test-only-on-chainguard)
zig: | bin
	zig build-exe zig/howdy.zig -femit-bin=bin/howdy-zig

# --- other script languages (copy + fix shebang) ---

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

# scala: Chainguard-only (not in 'all'; tested via test-only-on-chainguard)
scala: | bin
	mkdir -p bin/scala
	JAVA_HOME= scalac -d bin/scala scala/howdy.scala
	# copy scala*library*.jar from maven2 — both scala3-library_3 and scala-library are required
	find /usr/share/scala/maven2 -name "scala*library*.jar" -exec cp {} bin/scala/ \;
	echo '#!/bin/sh'                                                                     > bin/howdy-scala
	echo 'exec java -cp "$(CURDIR)/bin/scala:$(CURDIR)/bin/scala/*" Howdy'              >> bin/howdy-scala
	chmod 755 bin/howdy-scala

vala: | bin
	valac vala/howdy.vala -o bin/howdy-vala

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
	bin/howdy-asm | grep -F "Assembly: Howdy!"
	@echo "PASS: asm"

test-bash: bash
	bin/howdy-bash | grep -F "Bash: Howdy!"
	@echo "PASS: bash"

test-busybox: busybox
	bin/howdy-busybox | grep -F "BusyBox: Howdy!"
	@echo "PASS: busybox"

test-c: c
	bin/howdy-c | grep -F "C: Howdy!"
	@echo "PASS: c"

test-cpp: cpp
	bin/howdy-cpp | grep -F "C++: Howdy!"
	@echo "PASS: cpp"

test-csharp: csharp
	bin/howdy-csharp | grep -F "C#: Howdy!"
	@echo "PASS: csharp"

test-dash: dash
	bin/howdy-dash | grep -F "Dash: Howdy!"
	@echo "PASS: dash"

test-elvish: elvish
	bin/howdy-elvish | grep -F "Elvish: Howdy!"
	@echo "PASS: elvish"

test-erlang: erlang
	bin/howdy-erlang | grep -F "Erlang: Howdy!"
	@echo "PASS: erlang"

test-fish: fish
	bin/howdy-fish | grep -F "Fish: Howdy!"
	@echo "PASS: fish"

test-fortran: fortran
	bin/howdy-fortran | grep -F "Fortran: Howdy!"
	@echo "PASS: fortran"

test-go: go
	bin/howdy-go | grep -F "Golang: Howdy!"
	@echo "PASS: go"

test-java: java
	bin/howdy-java | grep -F "Java: Howdy!"
	@echo "PASS: java"

test-ksh: ksh
	bin/howdy-ksh | grep -F "Ksh: Howdy!"
	@echo "PASS: ksh"

test-lua: lua
	bin/howdy-lua | grep -F "Lua: Howdy!"
	@echo "PASS: lua"

test-mksh: mksh
	bin/howdy-mksh | grep -F "Mksh: Howdy!"
	@echo "PASS: mksh"

test-node: node
	bin/howdy-node | grep -F "NodeJS: Howdy!"
	@echo "PASS: node"

test-ocaml: ocaml
	bin/howdy-ocaml | grep -F "OCaml: Howdy!"
	@echo "PASS: ocaml"

test-perl: perl
	bin/howdy-perl | grep -F "Perl: Howdy!"
	@echo "PASS: perl"

test-php: php
	bin/howdy-php | grep -F "PHP: Howdy!"
	@echo "PASS: php"

test-python: python
	bin/howdy-python | grep -F "Python: Howdy!"
	@echo "PASS: python"

test-r: r
	bin/howdy-r | grep -F "R: Howdy!"
	@echo "PASS: r"

test-ruby: ruby
	bin/howdy-ruby | grep -F "Ruby: Howdy!"
	@echo "PASS: ruby"

test-rust: rust
	bin/howdy-rust | grep -F "Rust: Howdy!"
	@echo "PASS: rust"

test-scheme: scheme
	bin/howdy-scheme | grep -F "Scheme: Howdy!"
	@echo "PASS: scheme"

test-tcl: tcl
	bin/howdy-tcl | grep -F "Tcl: Howdy!"
	@echo "PASS: tcl"

test-typescript: typescript
	bin/howdy-typescript | grep -F "TypeScript: Howdy!"
	@echo "PASS: typescript"

test-scala: scala
	bin/howdy-scala | grep -F "Scala: Howdy!"
	@echo "PASS: scala"

test-vala: vala
	bin/howdy-vala | grep -F "Vala: Howdy!"
	@echo "PASS: vala"

test-yash: yash
	bin/howdy-yash | grep -F "Yash: Howdy!"
	@echo "PASS: yash"

test-zsh: zsh
	bin/howdy-zsh | grep -F "Zsh: Howdy!"
	@echo "PASS: zsh"

test-dart: dart
	bin/howdy-dart | grep -F "Dart: Howdy!"
	@echo "PASS: dart"

test-pwsh: pwsh
	bin/howdy-pwsh | grep -F "PowerShell: Howdy!"
	@echo "PASS: pwsh"

test-nushell: nushell
	bin/howdy-nushell | grep -F "Nushell: Howdy!"
	@echo "PASS: nushell"

test-zig: zig
	bin/howdy-zig | grep -F "Zig: Howdy!"
	@echo "PASS: zig"
