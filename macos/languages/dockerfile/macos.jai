tree_sitter_dockerfile :: () -> *TSLanguage #foreign libtree_sitter_dockerfile;

#if CPU == .X64 {
    libtree_sitter_dockerfile :: #library,no_dll "bin/x64/libtree-sitter-dockerfile";
} else #if CPU == .ARM64 {
    libtree_sitter_dockerfile :: #library,no_dll "bin/arm64/libtree-sitter-dockerfile";
}
