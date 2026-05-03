tree_sitter_yaml :: () -> *TSLanguage #foreign libtree_sitter_yaml;

#if CPU == .X64 {
    libtree_sitter_yaml :: #library,no_dll "bin/x64/libtree-sitter-yaml";
} else #if CPU == .ARM64 {
    libtree_sitter_yaml :: #library,no_dll "bin/arm64/libtree-sitter-yaml";
}
