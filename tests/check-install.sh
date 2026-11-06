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
# Check that "make install" ships the artifacts "make all" built, unchanged.
#
# Usage: tests/check-install.sh [make arguments ...]
#
# Records the checksum, mode, size and mtime of every file in bin/, runs
# "make install" into a scratch DESTDIR, and fails if anything in bin/ was
# rebuilt or modified, or if any installed program (or the bytecode, class
# or JavaScript file its wrapper runs) differs from its copy in bin/. Run
# "make all" first.

set -u

srcdir=$(cd "$(dirname "$0")/.." && pwd)
cd "$srcdir" || exit 1

if [ ! -d bin ]; then
	echo "check-install: bin/ not found; run 'make all' first" >&2
	exit 1
fi

scratch=$(mktemp -d "${TMPDIR:-/tmp}/howdy-install.XXXXXX") || exit 1
trap 'rm -rf "$scratch"' EXIT
dest="$scratch/dest"
prefix=/usr

snapshot() {
	find bin -type f | LC_ALL=C sort >"$scratch/files"
	tr '\n' '\0' <"$scratch/files" | xargs -0 sha256sum >"$1.sha256"
	tr '\n' '\0' <"$scratch/files" | xargs -0 stat -c '%a %s %Y %n' >"$1.stat"
}

snapshot "$scratch/before"
# mtimes are compared in whole seconds: start make in a later second so a
# rewrite of a file is always visible.
sleep 1
${MAKE:-make} "$@" install DESTDIR="$dest" PREFIX="$prefix" || exit 1
snapshot "$scratch/after"

bad=0
for kind in sha256 stat; do
	if ! diff -u "$scratch/before.$kind" "$scratch/after.$kind"; then
		bad=1
	fi
done
if [ "$bad" -ne 0 ]; then
	echo "check-install: FAIL: 'make install' rebuilt or changed files in bin/ (see diff above)"
	exit 1
fi

# Every installed file must be a byte-for-byte copy of one in bin/. The
# erlang, java, typescript and scala wrappers in $prefix/bin are generated
# for the install path, so compare the files they run instead.
checked=0
for f in "$dest$prefix"/bin/howdy-* "$dest$prefix"/share/howdy/*/*; do
	[ -f "$f" ] || continue
	base=${f##*/}
	case "$f" in
		*/bin/howdy-erlang|*/bin/howdy-java|*/bin/howdy-typescript|*/bin/howdy-scala)
			continue ;;
		*/share/howdy/erlang/*|*/share/howdy/java/*) src="bin/$base" ;;
		*/share/howdy/typescript/*) src="bin/typescript/$base" ;;
		*/share/howdy/scala/*) src="bin/scala/$base" ;;
		*) src="bin/$base" ;;
	esac
	if ! cmp "$src" "$f"; then
		echo "check-install: FAIL: ${f#"$dest"} differs from $src"
		bad=1
	fi
	checked=$((checked + 1))
done
if [ "$bad" -ne 0 ]; then
	exit 1
fi
if [ "$checked" -eq 0 ]; then
	echo "check-install: FAIL: nothing was installed under $prefix"
	exit 1
fi
echo "check-install: PASS: $checked installed files match bin/, and bin/ is unchanged"
