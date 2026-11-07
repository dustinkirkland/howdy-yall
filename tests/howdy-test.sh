#!/bin/sh
# Copyright 2010-2026 Dustin Kirkland
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Run the already-built bin/howdy-<lang> artifacts and report TAP.
#
# Usage: tests/howdy-test.sh [lang ...]   (default: every language below)
#
# Prints one TAP line per language and a "1..N" plan, then an
# automake-style "# TOTAL: / # PASS: / ..." summary block. Exits non-zero
# if any language fails.
#
# This script never builds anything and never writes to the source or build
# tree: each artifact runs as-is from a scratch directory (also used as HOME
# and TMPDIR), which is removed on exit. Run "make all" first.
#
# A language is a SKIP, not a pass, when its toolchain is absent: the build
# tool if the artifact was never built, or the interpreter the artifact
# needs at run time. A missing artifact whose build tool is present is a
# failure, since "make all" should have built it.

set -u

srcdir=$(cd "$(dirname "$0")/.." && pwd)
bindir="$srcdir/bin"

# lang | expected output | build tool | run-time tool ("-" for none)
languages() {
	cat <<EOF
asm|Assembly: Howdy!|as|-
bash|Bash: Howdy!|-|bash
busybox|BusyBox: Howdy!|-|busybox
c|C: Howdy!|gcc|-
cpp|C++: Howdy!|g++|-
csharp|C#: Howdy!|dotnet|-
cuda|CUDA: Howdy!|nvcc|-
dart|Dart: Howdy!|dart|-
dash|Dash: Howdy!|-|dash
elvish|Elvish: Howdy!|-|elvish
erlang|Erlang: Howdy!|erlc|erl
fish|Fish: Howdy!|-|fish
fortran|Fortran: Howdy!|gfortran|-
go|Golang: Howdy!|go|-
java|Java: Howdy!|javac|java
ksh|Ksh: Howdy!|-|ksh
lua|Lua: Howdy!|-|lua5.4
mksh|Mksh: Howdy!|mksh|mksh
node|NodeJS: Howdy!|-|node
nushell|Nushell: Howdy!|nu|nu
ocaml|OCaml: Howdy!|ocamlopt|-
perl|Perl: Howdy!|-|perl
php|PHP: Howdy!|-|php
pwsh|PowerShell: Howdy!|pwsh|pwsh
python|Python: Howdy!|-|python3
r|R: Howdy!|-|Rscript
ruby|Ruby: Howdy!|-|ruby
rust|Rust: Howdy!|rustc|-
scala|Scala: Howdy!|scalac|java
scheme|Scheme: Howdy!|-|guile
tcl|Tcl: Howdy!|-|tclsh
typescript|TypeScript: Howdy!|tsc|node
vala|Vala: Howdy!|valac|-
yash|Yash: Howdy!|yash|yash
zig|Zig: Howdy!|zig|-
zsh|Zsh: Howdy!|-|zsh
EOF
}

have() {
	[ "$1" = "-" ] || command -v "$1" >/dev/null 2>&1
}

# Select the requested languages (all of them by default).
if [ $# -gt 0 ]; then
	selected=""
	for want in "$@"; do
		line=$(languages | grep "^$want|")
		if [ -z "$line" ]; then
			echo "Bail out! unknown language: $want"
			exit 1
		fi
		selected="$selected$line
"
	done
else
	selected=$(languages)
fi

if [ ! -d "$bindir" ]; then
	echo "Bail out! $bindir not found; run 'make all' before 'make test'"
	exit 1
fi

scratch=$(mktemp -d "${TMPDIR:-/tmp}/howdy-test.XXXXXX") || {
	echo "Bail out! cannot create a scratch directory"
	exit 1
}
trap 'rm -rf "$scratch"' EXIT
trap 'exit 130' INT TERM

total=$(printf '%s\n' "$selected" | grep -c '|')
echo "1..$total"

n=0 pass=0 skip=0 fail=0 failed=""
while IFS='|' read -r lang expect buildtool runtool; do
	[ -n "$lang" ] || continue
	n=$((n + 1))
	name="howdy-$lang"
	artifact="$bindir/$name"

	if [ ! -e "$artifact" ] && ! have "$buildtool"; then
		echo "ok $n - $name # SKIP no $buildtool"
		skip=$((skip + 1))
		continue
	fi
	if ! have "$runtool"; then
		echo "ok $n - $name # SKIP no $runtool"
		skip=$((skip + 1))
		continue
	fi
	if [ ! -e "$artifact" ]; then
		echo "not ok $n - $name"
		echo "# $artifact is missing; run 'make all' before 'make test'"
		fail=$((fail + 1)) failed="$failed $name"
		continue
	fi

	# Run the artifact as built, from a per-language scratch directory, so
	# anything it writes (caches, crash dumps, runtime extraction) lands
	# outside the source and build tree.
	work="$scratch/$lang"
	mkdir "$work"
	rc=0
	(cd "$work" && HOME="$work" TMPDIR="$work" XDG_CACHE_HOME="$work/.cache" \
		XDG_CONFIG_HOME="$work/.config" XDG_DATA_HOME="$work/.local/share" \
		DOTNET_CLI_HOME="$work" DOTNET_BUNDLE_EXTRACT_BASE_DIR="$work" \
		"$artifact") >"$work/out" 2>&1 </dev/null || rc=$?

	if [ "$rc" -eq 0 ] && grep -qF "$expect" "$work/out"; then
		echo "ok $n - $name"
		pass=$((pass + 1))
	else
		echo "not ok $n - $name"
		echo "# expected \"$expect\" and exit status 0; got exit status $rc and output:"
		sed 's/^/#   /' "$work/out"
		fail=$((fail + 1)) failed="$failed $name"
	fi
done <<EOF
$selected
EOF

# automake-style summary, with one FAIL: line per failing language.
for name in $failed; do
	echo "FAIL: $name"
done
echo "============================================================================"
echo "Testsuite summary for howdy-yall"
echo "============================================================================"
echo "# TOTAL: $n"
echo "# PASS:  $pass"
echo "# SKIP:  $skip"
echo "# XFAIL: 0"
echo "# FAIL:  $fail"
echo "# XPASS: 0"
echo "# ERROR: 0"
echo "============================================================================"

[ "$fail" -eq 0 ]
