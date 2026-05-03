// Note the proc name in the library uses "Jai", with a capital "J"
tree_sitter_jai :: () -> *TSLanguage #foreign libtree_sitter_jai "tree_sitter_Jai";

#if CPU == .X64 {
    libtree_sitter_jai :: #library,no_dll "bin/x64/libtree-sitter-jai";
} else #if CPU == .ARM64 {
    libtree_sitter_jai :: #library,no_dll "bin/arm64/libtree-sitter-jai";
}
