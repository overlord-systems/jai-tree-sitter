tree_sitter_go :: () -> *TSLanguage #foreign libtree_sitter_go;

#if CPU == .X64 {
    libtree_sitter_go :: #library,no_dll "bin/x64/libtree-sitter-go";
} else #if CPU == .ARM64 {
    libtree_sitter_go :: #library,no_dll "bin/arm64/libtree-sitter-go";
}
