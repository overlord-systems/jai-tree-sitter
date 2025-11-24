# jai-tree-sitter

Jai bindings for Tree-sitter.

This repo compiles tree sitter static libraries for Windows and Linux (Mac PRs welcome!), and generates jai bindings.

Libraries are compiled from the included source, which is from [this](https://github.com/tree-sitter/tree-sitter/tree/120f74723e694be4dc2f0033e01b24350dd73f19) Tree-Sitter commit.

To generate bindings run `jai generate.jai`.
To compile the static binaries run `jai generate - -compile`

## Languages

We include the source of some Tree-sitter languages (e.g., JSON), which is found under `src/languages/LANG_NAME` (e.g., `src/languages/json`).

We generate bindings for these languages and compile them into static libraries. The static libraries are placed in `OS/languages/json/bin/ARCH` (e.g., `windows/languages/json/bin/x64`).

To compile the static binaries for a language run `jai generate - -compile_LANG_NAME` (e.g., `jai generate - -compile_json`).

Bindings are placed in `OS/languages/LANG_NAME/OS.jai` (e.g., `windows/languages/json/windows.jai`).

Currently included languages:

- JSON

Which languages are loaded is controlled by a module parameter (e.g., `LOAD_JSON_LANG=true`).
By default, all languages are loaded, but you can adjust this to your preference.
