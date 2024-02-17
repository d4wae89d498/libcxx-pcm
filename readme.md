## Libcxx CPM

Generates c++20 modules for libcxx (std.cpm & std.compat.cpm).

tested with brew's llvm17 (macos) only.


## Usage

`make test && ./test` should print hello


Now your compilation flags are :

clang++ -std=c++26  -nostdinc++  -fprebuilt-module-path=lib lib/libcxx.a <sources and other flags...>
