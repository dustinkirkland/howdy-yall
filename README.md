# howdy

*Hello, World! — in every language.*

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
runtimes and compiled binaries. `howdy` was exactly the right tool: compile it in a
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
`howdy` lives here now, extended to even more languages, with proper CI on both
Ubuntu and Wolfi/Chainguard.

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
| PowerShell    | `howdy-pwsh`        | shell    | source: `shell/howdy.ps1`; Chainguard only      |
| Python        | `howdy-python`      | script   |                                                 |
| R             | `howdy-r`           | script   |                                                 |
| Ruby          | `howdy-ruby`        | script   |                                                 |
| Rust          | `howdy-rust`        | compiled |                                                 |
| Scheme        | `howdy-scheme`      | script   | requires `guile`                                |
| Tcl           | `howdy-tcl`         | script   |                                                 |
| TypeScript    | `howdy-typescript`  | script   | compiled to JS, run via `node`                  |
| Vala          | `howdy-vala`        | compiled |                                                 |
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

- **Ubuntu** — `make deps` uses `apt-get`; runs `make test` (27 languages/shells) + `make test-only-on-ubuntu`
- **Wolfi/Chainguard** — `make deps` uses `apk`; runs `make test` (27 languages/shells) + `make test-only-on-chainguard` (dart, pwsh)

The Makefile is the single source of truth for both dependency installation and testing.

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

## License

Apache 2.0 — see [LICENSE](LICENSE).
