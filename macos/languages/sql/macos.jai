tree_sitter_sql :: () -> *TSLanguage #foreign libtree_sitter_sql;

#if CPU == .X64 {
    libtree_sitter_sql :: #library,no_dll "bin/x64/libtree-sitter-sql";
} else #if CPU == .ARM64 {
    libtree_sitter_sql :: #library,no_dll "bin/arm64/libtree-sitter-sql";
}
