# howdy-yall

*Hello, World! — in every language.*

## Purpose

`howdy-yall` serves two purposes:

**Education.** Each source file is a minimal, self-contained example of how to
write, compile (if needed), and run a program in that language. The code itself
is trivial — print one line to stdout — which means there's nothing to
understand except the language's basic syntax, how it structures a program, and
how to invoke it. The comment style, license header, and inline description
comment are also intentional teaching examples: they show how each language
marks up code and how to apply a standard open-source license correctly.

**Smoke testing.** Running `make deps && make test` on a new distro, container
image, or compiler toolchain quickly answers: *does this environment actually
work?* If `howdy-rust` produces the right output, the Rust compiler and linker
are functional. If `howdy-java` fails, something is wrong with the JDK or
classpath setup. Thirty languages means thirty independent signals, which makes
`howdy-yall` a useful canary for regressions in packaging, runtime configuration, or
ABI compatibility.

---

## The Story

In September 2010, my wife Kim — a kindergarten teacher — and I were driving across
Utah after a dinner in Salt Lake City. Somewhere in the desert, she asked me a question
I had never been asked quite so directly:

> *"When you say you're coding, what are you actually doing?"*

I handed her my netbook running Ubuntu 10.04 and spent the next three hours on the
road teaching her to write "hello, world" in C, Perl, Python, Shell, and Java. She
found Shell the most intuitive. By the end of the drive she had written her own Byobu
status notifier that flipped between `:)` and `;)` — learning to wink and learning to
code in the same night.

The little collection of hello-world programs she and I wrote that night became this
repository.

Full story: https://blog.dustinkirkland.com/2010/09/learning-to-wink-learning-to-code.html

---

A couple of years later I was at Canonical, working with Microsoft on what would
eventually become the **Windows Subsystem for Linux** — long before it was publicly
announced at Microsoft Build 2016. WSL translates Linux syscalls into Windows OS
syscalls in real time (the inverse of Wine), and in the early days we needed a fast,
simple way to smoke-test syscall translation coverage across a broad set of language
runtimes and compiled binaries. `howdy-yall` was exactly the right tool: compile it in a
dozen languages, run it, see what crashes. I added Erlang, Fortran, Haskell, Java,
and others during that period.

References:
- https://blog.dustinkirkland.com/2010/09/learning-to-wink-learning-to-code.html
- https://blog.dustinkirkland.com/2016/03/ubuntu-on-windows.html

---

A decade after that, I joined **Chainguard**, where we build and ship minimal,
hardened Linux containers for the world's most critical software supply chains.
Testing that the latest compilers, runtimes, standard libraries, and toolchains
actually work — across multiple distros and architectures — is a daily concern.
`howdy-yall` lives here now, extended to even more languages, with proper CI on both
Ubuntu and Wolfi/Chainguard.

---

In 2026, [Claude Code](https://claude.ai/code) helped extend `howdy-yall` to its
current breadth — adding many new languages, overhauling the build system, and
adding license headers and source comments throughout. It turns out that AI is
much faster than me at learning and writing "hello, world."

---

## Supported Languages

| Language      | Binary              | Type     | Notes                                           |
|---------------|---------------------|----------|-------------------------------------------------|
| Assembly      | `howdy-asm`         | compiled |                                                 |
| Bash          | `howdy-bash`        | shell    | source: `shell/howdy.sh`                        |
| BusyBox sh    | `howdy-busybox`     | shell    | source: `shell/howdy.sh`                        |
| C             | `howdy-c`           | compiled |                                                 |
| C#            | `howdy-csharp`      | compiled |                                                 |
| C++           | `howdy-cpp`         | compiled |                                                 |
| Dart          | `howdy-dart`        | compiled | Chainguard only                                 |
| Dash          | `howdy-dash`        | shell    | source: `shell/howdy.sh`                        |
| Elvish        | `howdy-elvish`      | shell    | source: `shell/howdy.sh`                        |
| Erlang        | `howdy-erlang`      | compiled |                                                 |
| Fish          | `howdy-fish`        | shell    | source: `shell/howdy.sh`                        |
| Fortran       | `howdy-fortran`     | compiled |                                                 |
| Go            | `howdy-go`          | compiled |                                                 |
| Java          | `howdy-java`        | compiled |                                                 |
| Ksh           | `howdy-ksh`         | shell    | source: `shell/howdy.sh`                        |
| Lua           | `howdy-lua`         | script   |                                                 |
| Node.js       | `howdy-node`        | script   |                                                 |
| OCaml         | `howdy-ocaml`       | compiled |                                                 |
| Perl          | `howdy-perl`        | script   |                                                 |
| PHP           | `howdy-php`         | script   |                                                 |
| Nushell       | `howdy-nushell`     | shell    | source: `nushell/howdy.nu`; Chainguard only     |
| PowerShell    | `howdy-pwsh`        | shell    | source: `powershell/howdy.ps1`; Chainguard only |
| Python        | `howdy-python`      | script   |                                                 |
| R             | `howdy-r`           | script   |                                                 |
| Ruby          | `howdy-ruby`        | script   |                                                 |
| Rust          | `howdy-rust`        | compiled |                                                 |
| Scala         | `howdy-scala`       | script   | Chainguard only                                 |
| Scheme        | `howdy-scheme`      | script   | requires `guile`                                |
| Tcl           | `howdy-tcl`         | script   |                                                 |
| TypeScript    | `howdy-typescript`  | script   | compiled to JS, run via `node`                  |
| Vala          | `howdy-vala`        | compiled |                                                 |
| Zig           | `howdy-zig`         | compiled | Chainguard only                                 |
| Zsh           | `howdy-zsh`         | shell    | source: `shell/howdy.sh`                        |
| Haskell       | —                   | compiled | optional; requires `ghc` (not on all distros)   |
| Common Lisp   | —                   | script   | optional; requires `clisp` (not on all distros) |
| Pascal        | —                   | compiled | optional; requires `fpc` (not on all distros)   |

---

## Usage

### Install dependencies

Detects your distro and uses the right package manager automatically:

```bash
make deps
```

Supports **Ubuntu/Debian** (`apt-get`) and **Wolfi/Chainguard/Alpine** (`apk`).

### Build

```bash
make
```

All outputs land in `bin/`:

```
bin/howdy-asm       bin/howdy-bash      bin/howdy-busybox   bin/howdy-c
bin/howdy-cpp       bin/howdy-csharp    bin/howdy-dash      bin/howdy-erlang
bin/howdy-fish      bin/howdy-fortran   bin/howdy-go        bin/howdy-java
bin/howdy-ksh       bin/howdy-lua       bin/howdy-node      bin/howdy-ocaml
bin/howdy-perl      bin/howdy-php       bin/howdy-python    bin/howdy-r
bin/howdy-ruby      bin/howdy-rust      bin/howdy-scheme    bin/howdy-tcl
bin/howdy-typescript bin/howdy-vala     bin/howdy-zsh
```

### Run everything

```bash
make run
```

### Test (verify each binary produces correct output)

```bash
make test
```

### Install system-wide

```bash
sudo make install                        # installs to /usr/local/bin/
sudo make install PREFIX=/usr            # installs to /usr/bin/
make install DESTDIR=/tmp/pkg PREFIX=/usr  # staged install for packaging
```

### Clean

```bash
make clean
```

---

## CI

Every push and pull request is tested on two platforms via GitHub Actions:

- **Ubuntu** — `make deps` uses `apt-get`; runs `make test` (26 languages/shells) + `make test-only-on-ubuntu`
- **Wolfi/Chainguard** — `make deps` uses `apk`; runs `make test` (26 languages/shells) + `make test-only-on-chainguard` (dart, pwsh, scala, nushell, zig)

The Makefile is the single source of truth for both dependency installation and testing.

---

## Source File Comments and License Headers

Every source file in this repository includes two types of comments, intended
to be instructional examples of each language's native comment syntax:

1. **Apache 2.0 license header** — the standard boilerplate from
   https://www.apache.org/licenses/LICENSE-2.0, with `Copyright 2010-2026
   Dustin Kirkland`. Each language uses its own comment style: `//` for C-family
   languages, `#` for scripting languages, `--` for Haskell and Lua, `;` for
   Lisp and Scheme, `(* *)` for OCaml, `{ }` for Pascal, and so on.

2. **Inline description comment** — a single line `Print a howdy greeting to
   stdout.` immediately before the code, again using the language's native
   comment syntax.

These are intentional teaching examples, not boilerplate to be ignored — they
show how each language marks code as licensed and how to document intent inline.

---

## Extending

### Adding a new language

1. Create a `yourlang/` directory with a source file that prints:
   ```
       ====> YourLang: Howdy!
   ```

2. Add a build target to `Makefile`:
   ```makefile
   # compiled language
   yourlang: | bin
       yourcompiler -o bin/howdy-yourlang yourlang/howdy.ext

   # or script language
   yourlang: | bin
       cp yourlang/howdy.ext bin/howdy-yourlang
       sed -i '1s|.*|#!/usr/bin/env yourinterp|' bin/howdy-yourlang
       chmod 755 bin/howdy-yourlang
   ```

3. Add a test target:
   ```makefile
   test-yourlang: yourlang
       bin/howdy-yourlang | grep -q "YourLang: Howdy!"
       @echo "PASS: yourlang"
   ```

4. Wire it in to `all:`, `test:`, and `.PHONY:`:
   ```makefile
   all: ... yourlang
   test: ... test-yourlang
   .PHONY: ... yourlang test-yourlang
   ```

5. Add the compiler/runtime to `make deps` for each supported distro:
   ```makefile
   # Ubuntu
   sudo apt-get install -y ... yourcompiler-dev
   # Wolfi/apk
   apk add --no-cache ... yourlang
   ```

### Supporting a new distro

The `deps` target in the Makefile detects the package manager (`apt-get` vs `apk`)
and maps language packages to the right names for each ecosystem. To add support for
a new distro (e.g., Fedora/`dnf`, openSUSE/`zypper`):

```makefile
elif command -v dnf >/dev/null 2>&1; then \
    sudo dnf install -y gcc g++ erlang gcc-gfortran golang java-latest-openjdk \
        nodejs perl php python3 ruby rust; \
```

Add a new `elif` block in the `deps` target following the same pattern.

---

## Similar Projects

If you enjoy this sort of thing, check out these other takes on the "hello, world" genre — with hundreds more languages:

- **[leachim6/hello-world](https://github.com/leachim6/hello-world)** — one of the most comprehensive collections, organized alphabetically
- **[agnilondapakou/helloWorld](https://github.com/agnilondapakou/helloWorld)** — community-driven collection across many languages
- **[project-aki/Hello-World](https://github.com/project-aki/Hello-World)** — another broad multilanguage collection
- **[Polyglot Hello World](https://github.com/thomasnield/polyglot_hello_world)** — focused on breadth and variety across language families

---

## License

Apache 2.0 — see [LICENSE](LICENSE).
