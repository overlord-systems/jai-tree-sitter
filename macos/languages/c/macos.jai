tree_sitter_c :: () -> *TSLanguage #foreign libtree_sitter_c;

#if CPU == .X64 {
    libtree_sitter_c :: #library,no_dll "bin/x64/libtree-sitter-c";
} else #if CPU == .ARM64 {
    libtree_sitter_c :: #library,no_dll "bin/arm64/libtree-sitter-c";
}
