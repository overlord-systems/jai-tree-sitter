tree_sitter_json :: () -> *TSLanguage #foreign libtree_sitter_json;

#if CPU == .X64 {
    libtree_sitter_json :: #library,no_dll "bin/x64/libtree-sitter-json";
} else #if CPU == .ARM64 {
    libtree_sitter_json :: #library,no_dll "bin/arm64/libtree-sitter-json";
}
