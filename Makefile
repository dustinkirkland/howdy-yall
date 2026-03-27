all: clean run

deps:
	# install build dependencies
	sudo apt-get update
	sudo apt-get install -y gcc g++ erlang-base gfortran golang ghc openjdk-7-jdk clisp nodejs fp-compiler perl php5-cli python ruby bash


run: bash c cpp erlang fortran golang haskell java lisp nodejs pascal perl php python ruby rust

test: test-bash test-c test-cpp test-erlang test-fortran test-golang test-java test-nodejs test-perl test-php test-python test-ruby test-rust
	@echo ""
	@echo "All tests passed!"

.PHONY: bash c cpp erlang fortran golang haskell java lisp nodejs pascal perl php python ruby rust
.PHONY: test test-bash test-c test-cpp test-erlang test-fortran test-golang test-java test-nodejs test-perl test-php test-python test-ruby test-rust

clean:
	rm -f c/howdy cpp/howdy howdy.beam golang/howdy haskell/howdy haskell/howdy.hi haskell/howdy.o java/Howdy.class pascal/howdy pascal/howdy.o fortran/howdy rust/howdy

bash:
	bash bash/howdy.sh

c:
	gcc -o c/howdy c/howdy.c
	./c/howdy

cpp:
	g++ -o cpp/howdy cpp/howdy.cpp
	./cpp/howdy

erlang:
	erlc erlang/howdy.erl
	erl -noshell -s howdy howdy -s init stop

fortran:
	gfortran fortran/howdy.f90 -o fortran/howdy
	./fortran/howdy

golang:
	go build -o golang/howdy golang/howdy.go
	./golang/howdy

haskell:
	ghc -o haskell/howdy haskell/howdy.hs
	./haskell/howdy

java:
	javac java/Howdy.java
	java -classpath java Howdy

pascal:
	pc pascal/howdy.pas
	./pascal/howdy

lisp:
	clisp lisp/howdy.lisp

nodejs:
	nodejs nodejs/howdy.js

perl:
	perl perl/howdy.pl

php:
	php php/howdy.php

python:
	python python/howdy.py

ruby:
	ruby ruby/howdy.rb

rust:
	rustc rust/howdy.rs -o rust/howdy
	./rust/howdy

test-bash:
	bash bash/howdy.sh | grep -q "Shell: Howdy!"
	@echo "PASS: bash"

test-c:
	gcc -o c/howdy c/howdy.c
	./c/howdy | grep -q "C: Howdy!"
	@echo "PASS: c"

test-cpp:
	g++ -o cpp/howdy cpp/howdy.cpp
	./cpp/howdy | grep -q "C++: Howdy!"
	@echo "PASS: cpp"

test-erlang:
	erlc -o /tmp erlang/howdy.erl
	erl -noshell -pa /tmp -s howdy howdy -s init stop | grep -q "Erlang: Howdy!"
	@echo "PASS: erlang"

test-fortran:
	gfortran fortran/howdy.f90 -o fortran/howdy
	./fortran/howdy | grep -q "Fortran: Howdy!"
	@echo "PASS: fortran"

test-golang:
	go run golang/howdy.go | grep -q "Golang: Howdy!"
	@echo "PASS: golang"

test-java:
	javac java/Howdy.java
	java -classpath java Howdy | grep -q "Java: Howdy!"
	@echo "PASS: java"

test-nodejs:
	node nodejs/howdy.js | grep -q "NodeJS: Howdy!"
	@echo "PASS: nodejs"

test-perl:
	perl perl/howdy.pl | grep -q "Perl: Howdy!"
	@echo "PASS: perl"

test-php:
	php php/howdy.php | grep -q "PHP: Howdy!"
	@echo "PASS: php"

test-python:
	python3 python/howdy.py | grep -q "Python: Howdy!"
	@echo "PASS: python"

test-ruby:
	ruby ruby/howdy.rb | grep -q "Ruby: Howdy!"
	@echo "PASS: ruby"

test-rust:
	rustc rust/howdy.rs -o rust/howdy
	./rust/howdy | grep -q "Rust: Howdy!"
	@echo "PASS: rust"
