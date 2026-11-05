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
# Check that "make test" is read-only on the tree "make install" copies from.
#
# Usage: tests/check-readonly.sh [make arguments ...]
#
# Records the checksum, mode, size and mtime of every file in the tree
# (bin/ and the sources, but not .git), runs "make test", and fails if
# anything was added, removed, rebuilt or modified. The mtime catches a
# rebuild even when it reproduces identical bytes. Run "make all" first.

set -u

srcdir=$(cd "$(dirname "$0")/.." && pwd)
cd "$srcdir" || exit 1

if [ ! -d bin ]; then
	echo "check-readonly: bin/ not found; run 'make all' first" >&2
	exit 1
fi

snap=$(mktemp -d "${TMPDIR:-/tmp}/howdy-readonly.XXXXXX") || exit 1
trap 'rm -rf "$snap"' EXIT

snapshot() {
	find . -path ./.git -prune -o -type f -print | LC_ALL=C sort >"$snap/files"
	tr '\n' '\0' <"$snap/files" | xargs -0 sha256sum >"$1.sha256"
	tr '\n' '\0' <"$snap/files" | xargs -0 stat -c '%a %s %Y %n' >"$1.stat"
}

snapshot "$snap/before"
# mtimes are compared in whole seconds: start make in a later second so a
# rewrite of a file is always visible.
sleep 1
echo "check-readonly: recorded $(wc -l <"$snap/before.sha256") files ($(grep -c ' \./bin/' "$snap/before.sha256") under bin/)"

rc=0
${MAKE:-make} "$@" test || rc=$?

snapshot "$snap/after"
changed=0
for kind in sha256 stat; do
	if ! diff -u "$snap/before.$kind" "$snap/after.$kind"; then
		changed=1
	fi
done

if [ "$changed" -ne 0 ]; then
	echo "check-readonly: FAIL: 'make test' changed the tree (see diff above)"
	exit 1
fi
echo "check-readonly: PASS: 'make test' left all $(wc -l <"$snap/after.sha256") files unchanged"
if [ "$rc" -ne 0 ]; then
	echo "check-readonly: 'make test' itself failed (exit $rc)"
	exit "$rc"
fi
