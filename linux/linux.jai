//
// This file was auto-generated using the following command:
//
// jai generate.jai - -compile
//



ts_malloc :: ts_current_malloc;

ts_calloc :: ts_current_calloc;

ts_realloc :: ts_current_realloc;

ts_free :: ts_current_free;

TREE_SITTER_LANGUAGE_VERSION :: 15;

TREE_SITTER_MIN_COMPATIBLE_LANGUAGE_VERSION :: 13;

ERROR_STATE :: 0;
ERROR_COST_PER_RECOVERY :: 500;
ERROR_COST_PER_MISSING_TREE :: 110;
ERROR_COST_PER_SKIPPED_TREE :: 100;
ERROR_COST_PER_SKIPPED_LINE :: 30;
ERROR_COST_PER_SKIPPED_CHAR :: 1;

TS_BIG_ENDIAN :: 0;

TS_PTR_SIZE :: 64;

ts_builtin_sym_error :: cast,trunc(TSSymbol) -1;
ts_builtin_sym_end :: 0;
TREE_SITTER_SERIALIZATION_BUFFER_SIZE :: 1024;

ts_builtin_sym_error_repeat :: ts_builtin_sym_error - 1;

LANGUAGE_VERSION_WITH_RESERVED_WORDS :: 15;
LANGUAGE_VERSION_WITH_PRIMARY_STATES :: 14;

TRUE :: 1;

FALSE :: 0;

U_SIZEOF_UCHAR :: 2;

U_CHAR16_IS_TYPEDEF :: 0;

U_SENTINEL :: -1;

U8_LEAD3_T1_BITS :: "\x20\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x10\x30\x30";

U8_LEAD4_T1_BITS :: "\x00\x00\x00\x00\x00\x00\x00\x00\x1E\x0F\x0F\x0F\x00\x00\x00\x00";

U8_MAX_LENGTH :: 4;

U16_SURROGATE_OFFSET :: (0xd800<<10)+0xdc00-0x10000;

U16_MAX_LENGTH :: 2;

STACK_VERSION_NONE :: cast,trunc(StackVersion) -1;

MAX_STEP_CAPTURE_COUNT :: 3;
MAX_NEGATED_FIELD_COUNT :: 8;
MAX_STATE_PREDECESSOR_COUNT :: 256;
MAX_ANALYSIS_STATE_DEPTH :: 8;
MAX_ANALYSIS_ITERATION_COUNT :: 256;

MAX_LINK_COUNT :: 8;
MAX_NODE_POOL_SIZE :: 50;
MAX_ITERATOR_COUNT :: 64;

TS_MAX_TREE_POOL_SIZE :: 32;

ts_current_malloc: #type (size: u64) -> *void #c_call #elsewhere libtree_sitter; // Allow clients to override allocation functions dynamically
ts_current_calloc: #type (count: u64, size: u64) -> *void #c_call #elsewhere libtree_sitter;
ts_current_realloc: #type (ptr: *void, size: u64) -> *void #c_call #elsewhere libtree_sitter;
ts_current_free: #type (ptr: *void) -> void #c_call #elsewhere libtree_sitter;

/*******************/
/* Section - Types */
/*******************/
TSStateId :: u16;
TSSymbol :: u16;
TSFieldId :: u16;

TSLookaheadIterator :: struct {}

// This function signature reads one code point from the given string,
// returning the number of bytes consumed. It should write the code point
// to the `code_point` pointer, or write -1 if the input is invalid.
TSDecodeFunction :: #type (_string: *u8, length: u32, code_point: *s32) -> u32 #c_call;

// Deprecated alias to be removed in ABI 16
DecodeFunction :: TSDecodeFunction;

TSInputEncoding :: enum u32 {
    UTF8    :: 0;
    UTF16LE :: 1;
    UTF16BE :: 2;
    Custom  :: 3;

    TSInputEncodingUTF8    :: UTF8;
    TSInputEncodingUTF16LE :: UTF16LE;
    TSInputEncodingUTF16BE :: UTF16BE;
    TSInputEncodingCustom  :: Custom;
}

TSSymbolType :: enum u32 {
    Regular   :: 0;
    Anonymous :: 1;
    Supertype :: 2;
    Auxiliary :: 3;

    TSSymbolTypeRegular   :: Regular;
    TSSymbolTypeAnonymous :: Anonymous;
    TSSymbolTypeSupertype :: Supertype;
    TSSymbolTypeAuxiliary :: Auxiliary;
}

TSPoint :: struct {
    row:    u32;
    column: u32;
}

TSRange :: struct {
    start_point: TSPoint;
    end_point:   TSPoint;
    start_byte:  u32;
    end_byte:    u32;
}

TSInput :: struct {
    payload:  *void;
    read:     #type (payload: *void, byte_index: u32, position: TSPoint, bytes_read: *u32) -> *u8 #c_call;
    encoding: TSInputEncoding;
    decode:   TSDecodeFunction;
}

TSParseState :: struct {
    payload:             *void;
    current_byte_offset: u32;
    has_error:           bool;
}

TSParseOptions :: struct {
    payload:           *void;
    progress_callback: #type (state: *TSParseState) -> bool #c_call;
}

TSLogType :: enum u32 {
    Parse :: 0;
    Lex   :: 1;

    TSLogTypeParse :: Parse;
    TSLogTypeLex   :: Lex;
}

TSLogger :: struct {
    payload: *void;
    log:     #type (payload: *void, log_type: TSLogType, buffer: *u8) -> void #c_call;
}

TSInputEdit :: struct {
    start_byte:    u32;
    old_end_byte:  u32;
    new_end_byte:  u32;
    start_point:   TSPoint;
    old_end_point: TSPoint;
    new_end_point: TSPoint;
}

TSNode :: struct {
    _context: [4] u32;
    id:       *void;
    tree:     *TSTree;
}

TSTreeCursor :: struct {
    tree:     *void;
    id:       *void;
    _context: [3] u32;
}

TSQueryCapture :: struct {
    node:  TSNode;
    index: u32;
}

TSQuantifier :: enum u32 {
    Zero       :: 0;
    ZeroOrOne  :: 1;
    ZeroOrMore :: 2;
    One        :: 3;
    OneOrMore  :: 4;

    TSQuantifierZero       :: Zero;
    TSQuantifierZeroOrOne  :: ZeroOrOne;
    TSQuantifierZeroOrMore :: ZeroOrMore;
    TSQuantifierOne        :: One;
    TSQuantifierOneOrMore  :: OneOrMore;
}

TSQueryMatch :: struct {
    id:            u32;
    pattern_index: u16;
    capture_count: u16;
    captures:      *TSQueryCapture;
}

TSQueryPredicateStepType :: enum u32 {
    Done    :: 0;
    Capture :: 1;
    String  :: 2;

    TSQueryPredicateStepTypeDone    :: Done;
    TSQueryPredicateStepTypeCapture :: Capture;
    TSQueryPredicateStepTypeString  :: String;
}

TSQueryPredicateStep :: struct {
    type:     TSQueryPredicateStepType;
    value_id: u32;
}

TSQueryError :: enum u32 {
    None      :: 0;
    Syntax    :: 1;
    NodeType  :: 2;
    Field     :: 3;
    Capture   :: 4;
    Structure :: 5;
    Language  :: 6;

    TSQueryErrorNone      :: None;
    TSQueryErrorSyntax    :: Syntax;
    TSQueryErrorNodeType  :: NodeType;
    TSQueryErrorField     :: Field;
    TSQueryErrorCapture   :: Capture;
    TSQueryErrorStructure :: Structure;
    TSQueryErrorLanguage  :: Language;
}

TSQueryCursorState :: struct {
    payload:             *void;
    current_byte_offset: u32;
}

TSQueryCursorOptions :: struct {
    payload:           *void;
    progress_callback: #type (state: *TSQueryCursorState) -> bool #c_call;
}

/**
* The metadata associated with a language.
*
* Currently, this metadata can be used to check the [Semantic Version](https://semver.org/)
* of the language. This version information should be used to signal if a given parser might
* be incompatible with existing queries when upgrading between major versions, or minor versions
* if it's in zerover.
*/
TSLanguageMetadata :: struct {
    major_version: u8;
    minor_version: u8;
    patch_version: u8;
}

/**
* Create a new parser.
*/
ts_parser_new :: () -> *TSParser #foreign libtree_sitter;

/**
* Delete the parser, freeing all of the memory that it used.
*/
ts_parser_delete :: (self: *TSParser) -> void #foreign libtree_sitter;

/**
* Get the parser's current language.
*/
ts_parser_language :: (self: *TSParser) -> *TSLanguage #foreign libtree_sitter;

/**
* Set the language that the parser should use for parsing.
*
* Returns a boolean indicating whether or not the language was successfully
* assigned. True means assignment succeeded. False means there was a version
* mismatch: the language was generated with an incompatible version of the
* Tree-sitter CLI. Check the language's ABI version using [`ts_language_abi_version`]
* and compare it to this library's [`TREE_SITTER_LANGUAGE_VERSION`] and
* [`TREE_SITTER_MIN_COMPATIBLE_LANGUAGE_VERSION`] constants.
*/
ts_parser_set_language :: (self: *TSParser, language: *TSLanguage) -> bool #foreign libtree_sitter;

/**
* Set the ranges of text that the parser should include when parsing.
*
* By default, the parser will always include entire documents. This function
* allows you to parse only a *portion* of a document but still return a syntax
* tree whose ranges match up with the document as a whole. You can also pass
* multiple disjoint ranges.
*
* The second and third parameters specify the location and length of an array
* of ranges. The parser does *not* take ownership of these ranges; it copies
* the data, so it doesn't matter how these ranges are allocated.
*
* If `count` is zero, then the entire document will be parsed. Otherwise,
* the given ranges must be ordered from earliest to latest in the document,
* and they must not overlap. That is, the following must hold for all:
*
* `i < count - 1`: `ranges[i].end_byte <= ranges[i + 1].start_byte`
*
* If this requirement is not satisfied, the operation will fail, the ranges
* will not be assigned, and this function will return `false`. On success,
* this function returns `true`
*/
ts_parser_set_included_ranges :: (self: *TSParser, ranges: *TSRange, count: u32) -> bool #foreign libtree_sitter;

/**
* Get the ranges of text that the parser will include when parsing.
*
* The returned pointer is owned by the parser. The caller should not free it
* or write to it. The length of the array will be written to the given
* `count` pointer.
*/
ts_parser_included_ranges :: (self: *TSParser, count: *u32) -> *TSRange #foreign libtree_sitter;

/**
* Use the parser to parse some source code and create a syntax tree.
*
* If you are parsing this document for the first time, pass `NULL` for the
* `old_tree` parameter. Otherwise, if you have already parsed an earlier
* version of this document and the document has since been edited, pass the
* previous syntax tree so that the unchanged parts of it can be reused.
* This will save time and memory. For this to work correctly, you must have
* already edited the old syntax tree using the [`ts_tree_edit`] function in a
* way that exactly matches the source code changes.
*
* The [`TSInput`] parameter lets you specify how to read the text. It has the
* following three fields:
* 1. [`read`]: A function to retrieve a chunk of text at a given byte offset
*    and (row, column) position. The function should return a pointer to the
*    text and write its length to the [`bytes_read`] pointer. The parser does
*    not take ownership of this buffer; it just borrows it until it has
*    finished reading it. The function should write a zero value to the
*    [`bytes_read`] pointer to indicate the end of the document.
* 2. [`payload`]: An arbitrary pointer that will be passed to each invocation
*    of the [`read`] function.
* 3. [`encoding`]: An indication of how the text is encoded. Either
*    `TSInputEncodingUTF8` or `TSInputEncodingUTF16`.
*
* This function returns a syntax tree on success, and `NULL` on failure. There
* are four possible reasons for failure:
* 1. The parser does not have a language assigned. Check for this using the
[`ts_parser_language`] function.
* 2. Parsing was cancelled due to the progress callback returning true. This callback
*    is passed in [`ts_parser_parse_with_options`] inside the [`TSParseOptions`] struct.
*
* [`read`]: TSInput::read
* [`payload`]: TSInput::payload
* [`encoding`]: TSInput::encoding
* [`bytes_read`]: TSInput::read
*/
ts_parser_parse :: (self: *TSParser, old_tree: *TSTree, input: TSInput) -> *TSTree #foreign libtree_sitter;

/**
* Use the parser to parse some source code and create a syntax tree, with some options.
*
* See [`ts_parser_parse`] for more details.
*
* See [`TSParseOptions`] for more details on the options.
*/
ts_parser_parse_with_options :: (self: *TSParser, old_tree: *TSTree, input: TSInput, parse_options: TSParseOptions) -> *TSTree #foreign libtree_sitter;

/**
* Use the parser to parse some source code stored in one contiguous buffer.
* The first two parameters are the same as in the [`ts_parser_parse`] function
* above. The second two parameters indicate the location of the buffer and its
* length in bytes.
*/
ts_parser_parse_string :: (self: *TSParser, old_tree: *TSTree, _string: *u8, length: u32) -> *TSTree #foreign libtree_sitter;

/**
* Use the parser to parse some source code stored in one contiguous buffer with
* a given encoding. The first four parameters work the same as in the
* [`ts_parser_parse_string`] method above. The final parameter indicates whether
* the text is encoded as UTF8 or UTF16.
*/
ts_parser_parse_string_encoding :: (self: *TSParser, old_tree: *TSTree, _string: *u8, length: u32, encoding: TSInputEncoding) -> *TSTree #foreign libtree_sitter;

/**
* Instruct the parser to start the next parse from the beginning.
*
* If the parser previously failed because of the progress callback, then
* by default, it will resume where it left off on the next call to
* [`ts_parser_parse`] or other parsing functions. If you don't want to resume,
* and instead intend to use this parser to parse some other document, you must
* call [`ts_parser_reset`] first.
*/
ts_parser_reset :: (self: *TSParser) -> void #foreign libtree_sitter;

/**
* Set the logger that a parser should use during parsing.
*
* The parser does not take ownership over the logger payload. If a logger was
* previously assigned, the caller is responsible for releasing any memory
* owned by the previous logger.
*/
ts_parser_set_logger :: (self: *TSParser, logger: TSLogger) -> void #foreign libtree_sitter;

/**
* Get the parser's current logger.
*/
ts_parser_logger :: (self: *TSParser) -> TSLogger #foreign libtree_sitter;

/**
* Set the file descriptor to which the parser should write debugging graphs
* during parsing. The graphs are formatted in the DOT language. You may want
* to pipe these graphs directly to a `dot(1)` process in order to generate
* SVG output. You can turn off this logging by passing a negative number.
*/
ts_parser_print_dot_graphs :: (self: *TSParser, fd: s32) -> void #foreign libtree_sitter;

/**
* Create a shallow copy of the syntax tree. This is very fast.
*
* You need to copy a syntax tree in order to use it on more than one thread at
* a time, as syntax trees are not thread safe.
*/
ts_tree_copy :: (self: *TSTree) -> *TSTree #foreign libtree_sitter;

/**
* Delete the syntax tree, freeing all of the memory that it used.
*/
ts_tree_delete :: (self: *TSTree) -> void #foreign libtree_sitter;

/**
* Get the root node of the syntax tree.
*/
ts_tree_root_node :: (self: *TSTree) -> TSNode #foreign libtree_sitter;

/**
* Get the root node of the syntax tree, but with its position
* shifted forward by the given offset.
*/
ts_tree_root_node_with_offset :: (self: *TSTree, offset_bytes: u32, offset_extent: TSPoint) -> TSNode #foreign libtree_sitter;

/**
* Get the language that was used to parse the syntax tree.
*/
ts_tree_language :: (self: *TSTree) -> *TSLanguage #foreign libtree_sitter;

/**
* Get the array of included ranges that was used to parse the syntax tree.
*
* The returned pointer must be freed by the caller.
*/
ts_tree_included_ranges :: (self: *TSTree, length: *u32) -> *TSRange #foreign libtree_sitter;

/**
* Edit the syntax tree to keep it in sync with source code that has been
* edited.
*
* You must describe the edit both in terms of byte offsets and in terms of
* (row, column) coordinates.
*/
ts_tree_edit :: (self: *TSTree, edit: *TSInputEdit) -> void #foreign libtree_sitter;

/**
* Compare an old edited syntax tree to a new syntax tree representing the same
* document, returning an array of ranges whose syntactic structure has changed.
*
* For this to work correctly, the old syntax tree must have been edited such
* that its ranges match up to the new tree. Generally, you'll want to call
* this function right after calling one of the [`ts_parser_parse`] functions.
* You need to pass the old tree that was passed to parse, as well as the new
* tree that was returned from that function.
*
* The returned ranges indicate areas where the hierarchical structure of syntax
* nodes (from root to leaf) has changed between the old and new trees. Characters
* outside these ranges have identical ancestor nodes in both trees.
*
* Note that the returned ranges may be slightly larger than the exact changed areas,
* but Tree-sitter attempts to make them as small as possible.
*
* The returned array is allocated using `malloc` and the caller is responsible
* for freeing it using `free`. The length of the array will be written to the
* given `length` pointer.
*/
ts_tree_get_changed_ranges :: (old_tree: *TSTree, new_tree: *TSTree, length: *u32) -> *TSRange #foreign libtree_sitter;

/**
* Write a DOT graph describing the syntax tree to the given file.
*/
ts_tree_print_dot_graph :: (self: *TSTree, file_descriptor: s32) -> void #foreign libtree_sitter;

/**
* Get the node's type as a null-terminated string.
*/
ts_node_type :: (self: TSNode) -> *u8 #foreign libtree_sitter;

/**
* Get the node's type as a numerical id.
*/
ts_node_symbol :: (self: TSNode) -> TSSymbol #foreign libtree_sitter;

/**
* Get the node's language.
*/
ts_node_language :: (self: TSNode) -> *TSLanguage #foreign libtree_sitter;

/**
* Get the node's type as it appears in the grammar ignoring aliases as a
* null-terminated string.
*/
ts_node_grammar_type :: (self: TSNode) -> *u8 #foreign libtree_sitter;

/**
* Get the node's type as a numerical id as it appears in the grammar ignoring
* aliases. This should be used in [`ts_language_next_state`] instead of
* [`ts_node_symbol`].
*/
ts_node_grammar_symbol :: (self: TSNode) -> TSSymbol #foreign libtree_sitter;

/**
* Get the node's start byte.
*/
ts_node_start_byte :: (self: TSNode) -> u32 #foreign libtree_sitter;

/**
* Get the node's start position in terms of rows and columns.
*/
ts_node_start_point :: (self: TSNode) -> TSPoint #foreign libtree_sitter;

/**
* Get the node's end byte.
*/
ts_node_end_byte :: (self: TSNode) -> u32 #foreign libtree_sitter;

/**
* Get the node's end position in terms of rows and columns.
*/
ts_node_end_point :: (self: TSNode) -> TSPoint #foreign libtree_sitter;

/**
* Get an S-expression representing the node as a string.
*
* This string is allocated with `malloc` and the caller is responsible for
* freeing it using `free`.
*/
ts_node_string :: (self: TSNode) -> *u8 #foreign libtree_sitter;

/**
* Check if the node is null. Functions like [`ts_node_child`] and
* [`ts_node_next_sibling`] will return a null node to indicate that no such node
* was found.
*/
ts_node_is_null :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if the node is *named*. Named nodes correspond to named rules in the
* grammar, whereas *anonymous* nodes correspond to string literals in the
* grammar.
*/
ts_node_is_named :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if the node is *missing*. Missing nodes are inserted by the parser in
* order to recover from certain kinds of syntax errors.
*/
ts_node_is_missing :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if the node is *extra*. Extra nodes represent things like comments,
* which are not required the grammar, but can appear anywhere.
*/
ts_node_is_extra :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if a syntax node has been edited.
*/
ts_node_has_changes :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if the node is a syntax error or contains any syntax errors.
*/
ts_node_has_error :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Check if the node is a syntax error.
*/
ts_node_is_error :: (self: TSNode) -> bool #foreign libtree_sitter;

/**
* Get this node's parse state.
*/
ts_node_parse_state :: (self: TSNode) -> TSStateId #foreign libtree_sitter;

/**
* Get the parse state after this node.
*/
ts_node_next_parse_state :: (self: TSNode) -> TSStateId #foreign libtree_sitter;

/**
* Get the node's immediate parent.
* Prefer [`ts_node_child_with_descendant`] for
* iterating over the node's ancestors.
*/
ts_node_parent :: (self: TSNode) -> TSNode #foreign libtree_sitter;

/**
* Get the node that contains `descendant`.
*
* Note that this can return `descendant` itself.
*/
ts_node_child_with_descendant :: (self: TSNode, descendant: TSNode) -> TSNode #foreign libtree_sitter;

/**
* Get the node's child at the given index, where zero represents the first
* child.
*/
ts_node_child :: (self: TSNode, child_index: u32) -> TSNode #foreign libtree_sitter;

/**
* Get the field name for node's child at the given index, where zero represents
* the first child. Returns NULL, if no field is found.
*/
ts_node_field_name_for_child :: (self: TSNode, child_index: u32) -> *u8 #foreign libtree_sitter;

/**
* Get the field name for node's named child at the given index, where zero
* represents the first named child. Returns NULL, if no field is found.
*/
ts_node_field_name_for_named_child :: (self: TSNode, named_child_index: u32) -> *u8 #foreign libtree_sitter;

/**
* Get the node's number of children.
*/
ts_node_child_count :: (self: TSNode) -> u32 #foreign libtree_sitter;

/**
* Get the node's *named* child at the given index.
*
* See also [`ts_node_is_named`].
*/
ts_node_named_child :: (self: TSNode, child_index: u32) -> TSNode #foreign libtree_sitter;

/**
* Get the node's number of *named* children.
*
* See also [`ts_node_is_named`].
*/
ts_node_named_child_count :: (self: TSNode) -> u32 #foreign libtree_sitter;

/**
* Get the node's child with the given field name.
*/
ts_node_child_by_field_name :: (self: TSNode, name: *u8, name_length: u32) -> TSNode #foreign libtree_sitter;

/**
* Get the node's child with the given numerical field id.
*
* You can convert a field name to an id using the
* [`ts_language_field_id_for_name`] function.
*/
ts_node_child_by_field_id :: (self: TSNode, field_id: TSFieldId) -> TSNode #foreign libtree_sitter;

/**
* Get the node's next / previous sibling.
*/
ts_node_next_sibling :: (self: TSNode) -> TSNode #foreign libtree_sitter;

ts_node_prev_sibling :: (self: TSNode) -> TSNode #foreign libtree_sitter;

/**
* Get the node's next / previous *named* sibling.
*/
ts_node_next_named_sibling :: (self: TSNode) -> TSNode #foreign libtree_sitter;

ts_node_prev_named_sibling :: (self: TSNode) -> TSNode #foreign libtree_sitter;

/**
* Get the node's first child that contains or starts after the given byte offset.
*/
ts_node_first_child_for_byte :: (self: TSNode, byte: u32) -> TSNode #foreign libtree_sitter;

/**
* Get the node's first named child that contains or starts after the given byte offset.
*/
ts_node_first_named_child_for_byte :: (self: TSNode, byte: u32) -> TSNode #foreign libtree_sitter;

/**
* Get the node's number of descendants, including one for the node itself.
*/
ts_node_descendant_count :: (self: TSNode) -> u32 #foreign libtree_sitter;

/**
* Get the smallest node within this node that spans the given range of bytes
* or (row, column) positions.
*/
ts_node_descendant_for_byte_range :: (self: TSNode, start: u32, end: u32) -> TSNode #foreign libtree_sitter;

ts_node_descendant_for_point_range :: (self: TSNode, start: TSPoint, end: TSPoint) -> TSNode #foreign libtree_sitter;

/**
* Get the smallest named node within this node that spans the given range of
* bytes or (row, column) positions.
*/
ts_node_named_descendant_for_byte_range :: (self: TSNode, start: u32, end: u32) -> TSNode #foreign libtree_sitter;

ts_node_named_descendant_for_point_range :: (self: TSNode, start: TSPoint, end: TSPoint) -> TSNode #foreign libtree_sitter;

/**
* Edit the node to keep it in-sync with source code that has been edited.
*
* This function is only rarely needed. When you edit a syntax tree with the
* [`ts_tree_edit`] function, all of the nodes that you retrieve from the tree
* afterward will already reflect the edit. You only need to use [`ts_node_edit`]
* when you have a [`TSNode`] instance that you want to keep and continue to use
* after an edit.
*/
ts_node_edit :: (self: *TSNode, edit: *TSInputEdit) -> void #foreign libtree_sitter;

/**
* Check if two nodes are identical.
*/
ts_node_eq :: (self: TSNode, other: TSNode) -> bool #foreign libtree_sitter;

/**
* Edit a point to keep it in-sync with source code that has been edited.
*
* This function updates a single point's byte offset and row/column position
* based on an edit operation. This is useful for editing points without
* requiring a tree or node instance.
*/
ts_point_edit :: (point: *TSPoint, point_byte: *u32, edit: *TSInputEdit) -> void #foreign libtree_sitter;

/**
* Edit a range to keep it in-sync with source code that has been edited.
*
* This function updates a range's start and end positions based on an edit
* operation. This is useful for editing ranges without requiring a tree
* or node instance.
*/
ts_range_edit :: (range: *TSRange, edit: *TSInputEdit) -> void #foreign libtree_sitter;

/**
* Create a new tree cursor starting from the given node.
*
* A tree cursor allows you to walk a syntax tree more efficiently than is
* possible using the [`TSNode`] functions. It is a mutable object that is always
* on a certain syntax node, and can be moved imperatively to different nodes.
*
* Note that the given node is considered the root of the cursor,
* and the cursor cannot walk outside this node.
*/
ts_tree_cursor_new :: (node: TSNode) -> TSTreeCursor #foreign libtree_sitter;

/**
* Delete a tree cursor, freeing all of the memory that it used.
*/
ts_tree_cursor_delete :: (self: *TSTreeCursor) -> void #foreign libtree_sitter;

/**
* Re-initialize a tree cursor to start at the original node that the cursor was
* constructed with.
*/
ts_tree_cursor_reset :: (self: *TSTreeCursor, node: TSNode) -> void #foreign libtree_sitter;

/**
* Re-initialize a tree cursor to the same position as another cursor.
*
* Unlike [`ts_tree_cursor_reset`], this will not lose parent information and
* allows reusing already created cursors.
*/
ts_tree_cursor_reset_to :: (dst: *TSTreeCursor, src: *TSTreeCursor) -> void #foreign libtree_sitter;

/**
* Get the tree cursor's current node.
*/
ts_tree_cursor_current_node :: (self: *TSTreeCursor) -> TSNode #foreign libtree_sitter;

/**
* Get the field name of the tree cursor's current node.
*
* This returns `NULL` if the current node doesn't have a field.
* See also [`ts_node_child_by_field_name`].
*/
ts_tree_cursor_current_field_name :: (self: *TSTreeCursor) -> *u8 #foreign libtree_sitter;

/**
* Get the field id of the tree cursor's current node.
*
* This returns zero if the current node doesn't have a field.
* See also [`ts_node_child_by_field_id`], [`ts_language_field_id_for_name`].
*/
ts_tree_cursor_current_field_id :: (self: *TSTreeCursor) -> TSFieldId #foreign libtree_sitter;

/**
* Move the cursor to the parent of its current node.
*
* This returns `true` if the cursor successfully moved, and returns `false`
* if there was no parent node (the cursor was already on the root node).
*
* Note that the node the cursor was constructed with is considered the root
* of the cursor, and the cursor cannot walk outside this node.
*/
ts_tree_cursor_goto_parent :: (self: *TSTreeCursor) -> bool #foreign libtree_sitter;

/**
* Move the cursor to the next sibling of its current node.
*
* This returns `true` if the cursor successfully moved, and returns `false`
* if there was no next sibling node.
*
* Note that the node the cursor was constructed with is considered the root
* of the cursor, and the cursor cannot walk outside this node.
*/
ts_tree_cursor_goto_next_sibling :: (self: *TSTreeCursor) -> bool #foreign libtree_sitter;

/**
* Move the cursor to the previous sibling of its current node.
*
* This returns `true` if the cursor successfully moved, and returns `false` if
* there was no previous sibling node.
*
* Note, that this function may be slower than
* [`ts_tree_cursor_goto_next_sibling`] due to how node positions are stored. In
* the worst case, this will need to iterate through all the children up to the
* previous sibling node to recalculate its position. Also note that the node the cursor
* was constructed with is considered the root of the cursor, and the cursor cannot
* walk outside this node.
*/
ts_tree_cursor_goto_previous_sibling :: (self: *TSTreeCursor) -> bool #foreign libtree_sitter;

/**
* Move the cursor to the first child of its current node.
*
* This returns `true` if the cursor successfully moved, and returns `false`
* if there were no children.
*/
ts_tree_cursor_goto_first_child :: (self: *TSTreeCursor) -> bool #foreign libtree_sitter;

/**
* Move the cursor to the last child of its current node.
*
* This returns `true` if the cursor successfully moved, and returns `false` if
* there were no children.
*
* Note that this function may be slower than [`ts_tree_cursor_goto_first_child`]
* because it needs to iterate through all the children to compute the child's
* position.
*/
ts_tree_cursor_goto_last_child :: (self: *TSTreeCursor) -> bool #foreign libtree_sitter;

/**
* Move the cursor to the node that is the nth descendant of
* the original node that the cursor was constructed with, where
* zero represents the original node itself.
*/
ts_tree_cursor_goto_descendant :: (self: *TSTreeCursor, goal_descendant_index: u32) -> void #foreign libtree_sitter;

/**
* Get the index of the cursor's current node out of all of the
* descendants of the original node that the cursor was constructed with.
*/
ts_tree_cursor_current_descendant_index :: (self: *TSTreeCursor) -> u32 #foreign libtree_sitter;

/**
* Get the depth of the cursor's current node relative to the original
* node that the cursor was constructed with.
*/
ts_tree_cursor_current_depth :: (self: *TSTreeCursor) -> u32 #foreign libtree_sitter;

/**
* Move the cursor to the first child of its current node that contains or starts after
* the given byte offset or point.
*
* This returns the index of the child node if one was found, and returns -1
* if no such child was found.
*/
ts_tree_cursor_goto_first_child_for_byte :: (self: *TSTreeCursor, goal_byte: u32) -> s64 #foreign libtree_sitter;

ts_tree_cursor_goto_first_child_for_point :: (self: *TSTreeCursor, goal_point: TSPoint) -> s64 #foreign libtree_sitter;

ts_tree_cursor_copy :: (cursor: *TSTreeCursor) -> TSTreeCursor #foreign libtree_sitter;

/**
* Create a new query from a string containing one or more S-expression
* patterns. The query is associated with a particular language, and can
* only be run on syntax nodes parsed with that language.
*
* If all of the given patterns are valid, this returns a [`TSQuery`].
* If a pattern is invalid, this returns `NULL`, and provides two pieces
* of information about the problem:
* 1. The byte offset of the error is written to the `error_offset` parameter.
* 2. The type of error is written to the `error_type` parameter.
*/
ts_query_new :: (language: *TSLanguage, source: *u8, source_len: u32, error_offset: *u32, error_type: *TSQueryError) -> *TSQuery #foreign libtree_sitter;

/**
* Delete a query, freeing all of the memory that it used.
*/
ts_query_delete :: (self: *TSQuery) -> void #foreign libtree_sitter;

/**
* Get the number of patterns, captures, or string literals in the query.
*/
ts_query_pattern_count :: (self: *TSQuery) -> u32 #foreign libtree_sitter;

ts_query_capture_count :: (self: *TSQuery) -> u32 #foreign libtree_sitter;

ts_query_string_count :: (self: *TSQuery) -> u32 #foreign libtree_sitter;

/**
* Get the byte offset where the given pattern starts in the query's source.
*
* This can be useful when combining queries by concatenating their source
* code strings.
*/
ts_query_start_byte_for_pattern :: (self: *TSQuery, pattern_index: u32) -> u32 #foreign libtree_sitter;

/**
* Get the byte offset where the given pattern ends in the query's source.
*
* This can be useful when combining queries by concatenating their source
* code strings.
*/
ts_query_end_byte_for_pattern :: (self: *TSQuery, pattern_index: u32) -> u32 #foreign libtree_sitter;

/**
* Get all of the predicates for the given pattern in the query.
*
* The predicates are represented as a single array of steps. There are three
* types of steps in this array, which correspond to the three legal values for
* the `type` field:
* - `TSQueryPredicateStepTypeCapture` - Steps with this type represent names
*    of captures. Their `value_id` can be used with the
*   [`ts_query_capture_name_for_id`] function to obtain the name of the capture.
* - `TSQueryPredicateStepTypeString` - Steps with this type represent literal
*    strings. Their `value_id` can be used with the
*    [`ts_query_string_value_for_id`] function to obtain their string value.
* - `TSQueryPredicateStepTypeDone` - Steps with this type are *sentinels*
*    that represent the end of an individual predicate. If a pattern has two
*    predicates, then there will be two steps with this `type` in the array.
*/
ts_query_predicates_for_pattern :: (self: *TSQuery, pattern_index: u32, step_count: *u32) -> *TSQueryPredicateStep #foreign libtree_sitter;

/*
* Check if the given pattern in the query has a single root node.
*/
ts_query_is_pattern_rooted :: (self: *TSQuery, pattern_index: u32) -> bool #foreign libtree_sitter;

/*
* Check if the given pattern in the query is 'non local'.
*
* A non-local pattern has multiple root nodes and can match within a
* repeating sequence of nodes, as specified by the grammar. Non-local
* patterns disable certain optimizations that would otherwise be possible
* when executing a query on a specific range of a syntax tree.
*/
ts_query_is_pattern_non_local :: (self: *TSQuery, pattern_index: u32) -> bool #foreign libtree_sitter;

/*
* Check if a given pattern is guaranteed to match once a given step is reached.
* The step is specified by its byte offset in the query's source code.
*/
ts_query_is_pattern_guaranteed_at_step :: (self: *TSQuery, byte_offset: u32) -> bool #foreign libtree_sitter;

/**
* Get the name and length of one of the query's captures, or one of the
* query's string literals. Each capture and string is associated with a
* numeric id based on the order that it appeared in the query's source.
*/
ts_query_capture_name_for_id :: (self: *TSQuery, index: u32, length: *u32) -> *u8 #foreign libtree_sitter;

/**
* Get the quantifier of the query's captures. Each capture is * associated
* with a numeric id based on the order that it appeared in the query's source.
*/
ts_query_capture_quantifier_for_id :: (self: *TSQuery, pattern_index: u32, capture_index: u32) -> TSQuantifier #foreign libtree_sitter;

ts_query_string_value_for_id :: (self: *TSQuery, index: u32, length: *u32) -> *u8 #foreign libtree_sitter;

/**
* Disable a certain capture within a query.
*
* This prevents the capture from being returned in matches, and also avoids
* any resource usage associated with recording the capture. Currently, there
* is no way to undo this.
*/
ts_query_disable_capture :: (self: *TSQuery, name: *u8, length: u32) -> void #foreign libtree_sitter;

/**
* Disable a certain pattern within a query.
*
* This prevents the pattern from matching and removes most of the overhead
* associated with the pattern. Currently, there is no way to undo this.
*/
ts_query_disable_pattern :: (self: *TSQuery, pattern_index: u32) -> void #foreign libtree_sitter;

/**
* Create a new cursor for executing a given query.
*
* The cursor stores the state that is needed to iteratively search
* for matches. To use the query cursor, first call [`ts_query_cursor_exec`]
* to start running a given query on a given syntax node. Then, there are
* two options for consuming the results of the query:
* 1. Repeatedly call [`ts_query_cursor_next_match`] to iterate over all of the
*    *matches* in the order that they were found. Each match contains the
*    index of the pattern that matched, and an array of captures. Because
*    multiple patterns can match the same set of nodes, one match may contain
*    captures that appear *before* some of the captures from a previous match.
* 2. Repeatedly call [`ts_query_cursor_next_capture`] to iterate over all of the
*    individual *captures* in the order that they appear. This is useful if
*    don't care about which pattern matched, and just want a single ordered
*    sequence of captures.
*
* If you don't care about consuming all of the results, you can stop calling
* [`ts_query_cursor_next_match`] or [`ts_query_cursor_next_capture`] at any point.
*  You can then start executing another query on another node by calling
*  [`ts_query_cursor_exec`] again.
*/
ts_query_cursor_new :: () -> *TSQueryCursor #foreign libtree_sitter;

/**
* Delete a query cursor, freeing all of the memory that it used.
*/
ts_query_cursor_delete :: (self: *TSQueryCursor) -> void #foreign libtree_sitter;

/**
* Start running a given query on a given node.
*/
ts_query_cursor_exec :: (self: *TSQueryCursor, query: *TSQuery, node: TSNode) -> void #foreign libtree_sitter;

/**
* Start running a given query on a given node, with some options.
*/
ts_query_cursor_exec_with_options :: (self: *TSQueryCursor, query: *TSQuery, node: TSNode, query_options: *TSQueryCursorOptions) -> void #foreign libtree_sitter;

/**
* Manage the maximum number of in-progress matches allowed by this query
* cursor.
*
* Query cursors have an optional maximum capacity for storing lists of
* in-progress captures. If this capacity is exceeded, then the
* earliest-starting match will silently be dropped to make room for further
* matches. This maximum capacity is optional — by default, query cursors allow
* any number of pending matches, dynamically allocating new space for them as
* needed as the query is executed.
*/
ts_query_cursor_did_exceed_match_limit :: (self: *TSQueryCursor) -> bool #foreign libtree_sitter;

ts_query_cursor_match_limit :: (self: *TSQueryCursor) -> u32 #foreign libtree_sitter;

ts_query_cursor_set_match_limit :: (self: *TSQueryCursor, limit: u32) -> void #foreign libtree_sitter;

/**
* Set the range of bytes in which the query will be executed.
*
* The query cursor will return matches that intersect with the given point range.
* This means that a match may be returned even if some of its captures fall
* outside the specified range, as long as at least part of the match
* overlaps with the range.
*
* For example, if a query pattern matches a node that spans a larger area
* than the specified range, but part of that node intersects with the range,
* the entire match will be returned.
*
* This will return `false` if the start byte is greater than the end byte, otherwise
* it will return `true`.
*/
ts_query_cursor_set_byte_range :: (self: *TSQueryCursor, start_byte: u32, end_byte: u32) -> bool #foreign libtree_sitter;

/**
* Set the range of (row, column) positions in which the query will be executed.
*
* The query cursor will return matches that intersect with the given point range.
* This means that a match may be returned even if some of its captures fall
* outside the specified range, as long as at least part of the match
* overlaps with the range.
*
* For example, if a query pattern matches a node that spans a larger area
* than the specified range, but part of that node intersects with the range,
* the entire match will be returned.
*
* This will return `false` if the start point is greater than the end point, otherwise
* it will return `true`.
*/
ts_query_cursor_set_point_range :: (self: *TSQueryCursor, start_point: TSPoint, end_point: TSPoint) -> bool #foreign libtree_sitter;

/**
* Advance to the next match of the currently running query.
*
* If there is a match, write it to `*match` and return `true`.
* Otherwise, return `false`.
*/
ts_query_cursor_next_match :: (self: *TSQueryCursor, match: *TSQueryMatch) -> bool #foreign libtree_sitter;

ts_query_cursor_remove_match :: (self: *TSQueryCursor, match_id: u32) -> void #foreign libtree_sitter;

/**
* Advance to the next capture of the currently running query.
*
* If there is a capture, write its match to `*match` and its index within
* the match's capture list to `*capture_index`. Otherwise, return `false`.
*/
ts_query_cursor_next_capture :: (self: *TSQueryCursor, match: *TSQueryMatch, capture_index: *u32) -> bool #foreign libtree_sitter;

/**
* Set the maximum start depth for a query cursor.
*
* This prevents cursors from exploring children nodes at a certain depth.
* Note if a pattern includes many children, then they will still be checked.
*
* The zero max start depth value can be used as a special behavior and
* it helps to destructure a subtree by staying on a node and using captures
* for interested parts. Note that the zero max start depth only limit a search
* depth for a pattern's root node but other nodes that are parts of the pattern
* may be searched at any depth what defined by the pattern structure.
*
* Set to `UINT32_MAX` to remove the maximum start depth.
*/
ts_query_cursor_set_max_start_depth :: (self: *TSQueryCursor, max_start_depth: u32) -> void #foreign libtree_sitter;

/**
* Get another reference to the given language.
*/
ts_language_copy :: (self: *TSLanguage) -> *TSLanguage #foreign libtree_sitter;

/**
* Free any dynamically-allocated resources for this language, if
* this is the last reference.
*/
ts_language_delete :: (self: *TSLanguage) -> void #foreign libtree_sitter;

/**
* Get the number of distinct node types in the language.
*/
ts_language_symbol_count :: (self: *TSLanguage) -> u32 #foreign libtree_sitter;

/**
* Get the number of valid states in this language.
*/
ts_language_state_count :: (self: *TSLanguage) -> u32 #foreign libtree_sitter;

/**
* Get the numerical id for the given node type string.
*/
ts_language_symbol_for_name :: (self: *TSLanguage, _string: *u8, length: u32, is_named: bool) -> TSSymbol #foreign libtree_sitter;

/**
* Get the number of distinct field names in the language.
*/
ts_language_field_count :: (self: *TSLanguage) -> u32 #foreign libtree_sitter;

/**
* Get the field name string for the given numerical id.
*/
ts_language_field_name_for_id :: (self: *TSLanguage, id: TSFieldId) -> *u8 #foreign libtree_sitter;

/**
* Get the numerical id for the given field name string.
*/
ts_language_field_id_for_name :: (self: *TSLanguage, name: *u8, name_length: u32) -> TSFieldId #foreign libtree_sitter;

/**
* Get a list of all supertype symbols for the language.
*/
ts_language_supertypes :: (self: *TSLanguage, length: *u32) -> *TSSymbol #foreign libtree_sitter;

/**
* Get a list of all subtype symbol ids for a given supertype symbol.
*
* See [`ts_language_supertypes`] for fetching all supertype symbols.
*/
ts_language_subtypes :: (self: *TSLanguage, supertype: TSSymbol, length: *u32) -> *TSSymbol #foreign libtree_sitter;

/**
* Get a node type string for the given numerical id.
*/
ts_language_symbol_name :: (self: *TSLanguage, symbol: TSSymbol) -> *u8 #foreign libtree_sitter;

/**
* Check whether the given node type id belongs to named nodes, anonymous nodes,
* or a hidden nodes.
*
* See also [`ts_node_is_named`]. Hidden nodes are never returned from the API.
*/
ts_language_symbol_type :: (self: *TSLanguage, symbol: TSSymbol) -> TSSymbolType #foreign libtree_sitter;

/**
* Get the ABI version number for this language. This version number is used
* to ensure that languages were generated by a compatible version of
* Tree-sitter.
*
* See also [`ts_parser_set_language`].
*/
ts_language_abi_version :: (self: *TSLanguage) -> u32 #foreign libtree_sitter;

/**
* Get the metadata for this language. This information is generated by the
* CLI, and relies on the language author providing the correct metadata in
* the language's `tree-sitter.json` file.
*
* See also [`TSMetadata`].
*/
ts_language_metadata :: (self: *TSLanguage) -> *TSLanguageMetadata #foreign libtree_sitter;

/**
* Get the next parse state. Combine this with lookahead iterators to generate
* completion suggestions or valid symbols in error nodes. Use
* [`ts_node_grammar_symbol`] for valid symbols.
*/
ts_language_next_state :: (self: *TSLanguage, state: TSStateId, symbol: TSSymbol) -> TSStateId #foreign libtree_sitter;

/**
* Get the name of this language. This returns `NULL` in older parsers.
*/
ts_language_name :: (self: *TSLanguage) -> *u8 #foreign libtree_sitter;

/**
* Create a new lookahead iterator for the given language and parse state.
*
* This returns `NULL` if state is invalid for the language.
*
* Repeatedly using [`ts_lookahead_iterator_next`] and
* [`ts_lookahead_iterator_current_symbol`] will generate valid symbols in the
* given parse state. Newly created lookahead iterators will contain the `ERROR`
* symbol.
*
* Lookahead iterators can be useful to generate suggestions and improve syntax
* error diagnostics. To get symbols valid in an ERROR node, use the lookahead
* iterator on its first leaf node state. For `MISSING` nodes, a lookahead
* iterator created on the previous non-extra leaf node may be appropriate.
*/
ts_lookahead_iterator_new :: (self: *TSLanguage, state: TSStateId) -> *TSLookaheadIterator #foreign libtree_sitter;

/**
* Delete a lookahead iterator freeing all the memory used.
*/
ts_lookahead_iterator_delete :: (self: *TSLookaheadIterator) -> void #foreign libtree_sitter;

/**
* Reset the lookahead iterator to another state.
*
* This returns `true` if the iterator was reset to the given state and `false`
* otherwise.
*/
ts_lookahead_iterator_reset_state :: (self: *TSLookaheadIterator, state: TSStateId) -> bool #foreign libtree_sitter;

/**
* Reset the lookahead iterator.
*
* This returns `true` if the language was set successfully and `false`
* otherwise.
*/
ts_lookahead_iterator_reset :: (self: *TSLookaheadIterator, language: *TSLanguage, state: TSStateId) -> bool #foreign libtree_sitter;

/**
* Get the current language of the lookahead iterator.
*/
ts_lookahead_iterator_language :: (self: *TSLookaheadIterator) -> *TSLanguage #foreign libtree_sitter;

/**
* Advance the lookahead iterator to the next symbol.
*
* This returns `true` if there is a new symbol and `false` otherwise.
*/
ts_lookahead_iterator_next :: (self: *TSLookaheadIterator) -> bool #foreign libtree_sitter;

/**
* Get the current symbol of the lookahead iterator;
*/
ts_lookahead_iterator_current_symbol :: (self: *TSLookaheadIterator) -> TSSymbol #foreign libtree_sitter;

/**
* Get the current symbol type of the lookahead iterator as a null terminated
* string.
*/
ts_lookahead_iterator_current_symbol_name :: (self: *TSLookaheadIterator) -> *u8 #foreign libtree_sitter;

wasm_engine_t :: struct {}
/*************************************/
/* Section - WebAssembly Integration */
/************************************/
TSWasmEngine :: wasm_engine_t;
TSWasmStore :: struct {}

TSWasmErrorKind :: enum u32 {
    None        :: 0;
    Parse       :: 1;
    Compile     :: 2;
    Instantiate :: 3;
    Allocate    :: 4;

    TSWasmErrorKindNone        :: None;
    TSWasmErrorKindParse       :: Parse;
    TSWasmErrorKindCompile     :: Compile;
    TSWasmErrorKindInstantiate :: Instantiate;
    TSWasmErrorKindAllocate    :: Allocate;
}

TSWasmError :: struct {
    kind:    TSWasmErrorKind;
    message: *u8;
}

/**
* Free the memory associated with the given Wasm store.
*/
ts_wasm_store_delete :: (unknown0: *TSWasmStore) -> void #foreign libtree_sitter;

/**
* Check if the language came from a Wasm module. If so, then in order to use
* this language with a Parser, that parser must have a Wasm store assigned.
*/
ts_language_is_wasm :: (unknown0: *TSLanguage) -> bool #foreign libtree_sitter;

/**
* Assign the given Wasm store to the parser. A parser must have a Wasm store
* in order to use Wasm languages.
*/
ts_parser_set_wasm_store :: (unknown0: *TSParser, unknown1: *TSWasmStore) -> void #foreign libtree_sitter;

/**
* Remove the parser's current Wasm store and return it. This returns NULL if
* the parser doesn't have a Wasm store.
*/
ts_parser_take_wasm_store :: (unknown0: *TSParser) -> *TSWasmStore #foreign libtree_sitter;

/**
* Set the allocation functions used by the library.
*
* By default, Tree-sitter uses the standard libc allocation functions,
* but aborts the process when an allocation fails. This function lets
* you supply alternative allocation functions at runtime.
*
* If you pass `NULL` for any parameter, Tree-sitter will switch back to
* its default implementation of that function.
*
* If you call this function after the library has already been used, then
* you must ensure that either:
*  1. All the existing objects have been freed.
*  2. The new allocator shares its state with the old one, so it is capable
*     of freeing memory that was allocated by the old allocator.
*/
ts_set_allocator :: (new_malloc: #type (unknown0: u64) -> *void #c_call, new_calloc: #type (unknown0: u64, unknown1: u64) -> *void #c_call, new_realloc: #type (unknown0: *void, unknown1: u64) -> *void #c_call, new_free: #type (unknown0: *void) -> void #c_call) -> void #foreign libtree_sitter;

// Allow clients to override allocation functions dynamically
ts_current_malloc_1: #type (unknown0: u64) -> *void #c_call;
ts_current_calloc_1: #type (unknown0: u64, unknown1: u64) -> *void #c_call;
ts_current_realloc_1: #type (unknown0: *void, unknown1: u64) -> *void #c_call;
ts_current_free_1: #type (unknown0: *void) -> void #c_call;

Length :: struct {
    bytes:  u32;
    extent: TSPoint;
}

// Private
Array :: struct {
    // Private
    contents: *void;
    size:     u32;
    capacity: u32;
}

TSFieldMapEntry :: struct {
    field_id:    TSFieldId;
    child_index: u8;
    inherited:   bool;
}

// Used to index the field and supertype maps.
TSMapSlice :: struct {
    index:  u16;
    length: u16;
}

TSSymbolMetadata :: struct {
    visible:   bool;
    named:     bool;
    supertype: bool;
}

TSLexer :: struct {
    lookahead:                  s32;
    result_symbol:              TSSymbol;
    advance:                    #type (unknown0: *TSLexer, unknown1: bool) -> void #c_call;
    mark_end:                   #type (unknown0: *TSLexer) -> void #c_call;
    get_column:                 #type (unknown0: *TSLexer) -> u32 #c_call;
    is_at_included_range_start: #type (unknown0: *TSLexer) -> bool #c_call;
    eof:                        #type (unknown0: *TSLexer) -> bool #c_call;
    log:                        #type (unknown0: *TSLexer, unknown1: *u8, __args: ..Any) -> void #c_call;
}

TSParseActionType :: enum u32 {
    Shift   :: 0;
    Reduce  :: 1;
    Accept  :: 2;
    Recover :: 3;

    TSParseActionTypeShift   :: Shift;
    TSParseActionTypeReduce  :: Reduce;
    TSParseActionTypeAccept  :: Accept;
    TSParseActionTypeRecover :: Recover;
}

TSParseAction :: union {
    shift:  struct {
        type:       u8;
        state:      TSStateId;
        extra:      bool;
        repetition: bool;
    };

    reduce: struct {
        type:               u8;
        child_count:        u8;
        symbol:             TSSymbol;
        dynamic_precedence: s16;
        production_id:      u16;
    };

    type:   u8;
}

TSLexMode :: struct {
    lex_state:          u16;
    external_lex_state: u16;
}

TSLexerMode :: struct {
    lex_state:            u16;
    external_lex_state:   u16;
    reserved_word_set_id: u16;
}

TSParseActionEntry :: union {
    action: TSParseAction;
    entry:  struct {
        count:    u8;
        reusable: bool;
    };
}

TSCharacterRange :: struct {
    start: s32;
    end:   s32;
}

TSLanguage :: struct {
    abi_version:                u32;
    symbol_count:               u32;
    alias_count:                u32;
    token_count:                u32;
    external_token_count:       u32;
    state_count:                u32;
    large_state_count:          u32;
    production_id_count:        u32;
    field_count:                u32;
    max_alias_sequence_length:  u16;
    parse_table:                *u16;
    small_parse_table:          *u16;
    small_parse_table_map:      *u32;
    parse_actions:              *TSParseActionEntry;
    symbol_names:               **u8;
    field_names:                **u8;
    field_map_slices:           *TSMapSlice;
    field_map_entries:          *TSFieldMapEntry;
    symbol_metadata:            *TSSymbolMetadata;
    public_symbol_map:          *TSSymbol;
    alias_map:                  *u16;
    alias_sequences:            *TSSymbol;
    lex_modes:                  *TSLexerMode;
    lex_fn:                     #type (unknown0: *TSLexer, unknown1: TSStateId) -> bool #c_call;
    keyword_lex_fn:             #type (unknown0: *TSLexer, unknown1: TSStateId) -> bool #c_call;
    keyword_capture_token:      TSSymbol;
    external_scanner:           struct {
        states:      *bool;
        symbol_map:  *TSSymbol;
        create:      #type () -> *void #c_call;
        destroy:     #type (unknown0: *void) -> void #c_call;
        scan:        #type (unknown0: *void, unknown1: *TSLexer, symbol_whitelist: *bool) -> bool #c_call;
        serialize:   #type (unknown0: *void, unknown1: *u8) -> u32 #c_call;
        deserialize: #type (unknown0: *void, unknown1: *u8, unknown2: u32) -> void #c_call;
    };

    primary_state_ids:          *TSStateId;
    name:                       *u8;
    reserved_words:             *TSSymbol;
    max_reserved_word_set_size: u16;
    supertype_count:            u32;
    supertype_symbols:          *TSSymbol;
    supertype_map_slices:       *TSMapSlice;
    supertype_map_entries:      *TSSymbol;
    metadata:                   TSLanguageMetadata;
}

// The serialized state of an external scanner.
//
// Every time an external token subtree is created after a call to an
// external scanner, the scanner's `serialize` function is called to
// retrieve a serialized copy of its state. The bytes are then copied
// onto the subtree itself so that the scanner's state can later be
// restored using its `deserialize` function.
//
// Small byte arrays are stored inline, and long ones are allocated
// separately on the heap.
ExternalScannerState :: struct {
    union {
        long_data:  *u8;
        short_data: [24] u8;
    }

    length: u32;
}

SubtreeInlineData :: struct {
    is_inline:       bool; /* 1 bits */
    visible:         bool #align 1; /* 1 bits */
    named:           bool #align 1; /* 1 bits */
    extra:           bool #align 1; /* 1 bits */
    has_changes:     bool #align 1; /* 1 bits */
    is_missing:      bool #align 1; /* 1 bits */
    is_keyword:      bool #align 1; /* 1 bits */
    symbol:          u8;
    parse_state:     u16;
    padding_columns: u8;
    __bitfield:      u8;
    /*
        padding_rows: u8; /* 4 bits */
        lookahead_bytes: u8; /* 4 bits */;
    */
    padding_bytes:   u8;
    size_bytes:      u8;
}

// A heap-allocated representation of a subtree.
//
// This representation is used for parent nodes, external tokens,
// errors, and other leaf nodes whose data is too large to fit into
// the inline representation.
SubtreeHeapData :: struct {
    ref_count:                         u32;
    padding:                           Length;
    size:                              Length;
    lookahead_bytes:                   u32;
    error_cost:                        u32;
    child_count:                       u32;
    symbol:                            TSSymbol;
    parse_state:                       TSStateId;

    visible:                           bool; /* 1 bits */
    named:                             bool #align 1; /* 1 bits */
    extra:                             bool #align 1; /* 1 bits */
    fragile_left:                      bool #align 1; /* 1 bits */
    fragile_right:                     bool #align 1; /* 1 bits */
    has_changes:                       bool #align 1; /* 1 bits */
    has_external_tokens:               bool #align 1; /* 1 bits */
    has_external_scanner_state_change: bool #align 1; /* 1 bits */
    depends_on_column:                 bool; /* 1 bits */
    is_missing:                        bool #align 1; /* 1 bits */
    is_keyword:                        bool #align 1; /* 1 bits */

    union {
        // Non-terminal subtrees (`child_count > 0`)
        struct {
            visible_child_count:      u32;
            named_child_count:        u32;
            visible_descendant_count: u32;
            dynamic_precedence:       s32;
            repeat_depth:             u16;
            production_id:            u16;
            first_leaf:               struct {
                symbol:      TSSymbol;
                parse_state: TSStateId;
            };
        }

        // External terminal subtrees (`child_count == 0 && has_external_tokens`)
        external_scanner_state: ExternalScannerState;

        // Error terminal subtrees (`child_count == 0 && symbol == ts_builtin_sym_error`)
        lookahead_char:         s32;
    }
}

// The fundamental building block of a syntax tree.
Subtree :: union {
    data: SubtreeInlineData;
    ptr:  *SubtreeHeapData;
}

// Like Subtree, but mutable.
MutableSubtree :: union {
    data: SubtreeInlineData;
    ptr:  *SubtreeHeapData;
}

SubtreeArray :: struct {
    contents: *Subtree;
    size:     u32;
    capacity: u32;
}
MutableSubtreeArray :: struct {
    contents: *MutableSubtree;
    size:     u32;
    capacity: u32;
}

SubtreePool :: struct {
    free_trees: MutableSubtreeArray;
    tree_stack: MutableSubtreeArray;
}

// ExternalScannerState
ts_external_scanner_state_init :: (self: *ExternalScannerState, data: *u8, length: u32) -> void #foreign libtree_sitter;

ts_external_scanner_state_data :: (self: *ExternalScannerState) -> *u8 #foreign libtree_sitter;

ts_external_scanner_state_eq :: (self: *ExternalScannerState, buffer: *u8, length: u32) -> bool #foreign libtree_sitter;

ts_external_scanner_state_delete :: (self: *ExternalScannerState) -> void #foreign libtree_sitter;

// SubtreeArray
ts_subtree_array_copy :: (self: SubtreeArray, dest: *SubtreeArray) -> void #foreign libtree_sitter;

ts_subtree_array_clear :: (pool: *SubtreePool, self: *SubtreeArray) -> void #foreign libtree_sitter;

ts_subtree_array_delete :: (pool: *SubtreePool, self: *SubtreeArray) -> void #foreign libtree_sitter;

ts_subtree_array_remove_trailing_extras :: (self: *SubtreeArray, destination: *SubtreeArray) -> void #foreign libtree_sitter;

ts_subtree_array_reverse :: (self: *SubtreeArray) -> void #foreign libtree_sitter;

// SubtreePool
ts_subtree_pool_new :: (capacity: u32) -> SubtreePool #foreign libtree_sitter;

ts_subtree_pool_delete :: (self: *SubtreePool) -> void #foreign libtree_sitter;

ts_subtree_new_leaf :: (pool: *SubtreePool, symbol: TSSymbol, padding: Length, size: Length, lookahead_bytes: u32, parse_state: TSStateId, has_external_tokens: bool, depends_on_column: bool, is_keyword: bool, language: *TSLanguage) -> Subtree #foreign libtree_sitter;

ts_subtree_new_error :: (pool: *SubtreePool, lookahead_char: s32, padding: Length, size: Length, bytes_scanned: u32, parse_state: TSStateId, language: *TSLanguage) -> Subtree #foreign libtree_sitter;

// Create a new parent node with the given children.
//
// This takes ownership of the children array.
ts_subtree_new_node :: (symbol: TSSymbol, chiildren: *SubtreeArray, production_id: u32, language: *TSLanguage) -> MutableSubtree #foreign libtree_sitter;

// Create a new error node containing the given children.
//
// This node is treated as 'extra'. Its children are prevented from having
// having any effect on the parse state.
ts_subtree_new_error_node :: (children: *SubtreeArray, extra: bool, language: *TSLanguage) -> Subtree #foreign libtree_sitter;

// Create a new 'missing leaf' node.
//
// This node is treated as 'extra'. Its children are prevented from having
// having any effect on the parse state.
ts_subtree_new_missing_leaf :: (pool: *SubtreePool, symbol: TSSymbol, padding: Length, lookahead_bytes: u32, language: *TSLanguage) -> Subtree #foreign libtree_sitter;

// Get mutable version of a subtree.
//
// This takes ownership of the subtree. If the subtree has only one owner,
// this will directly convert it into a mutable version. Otherwise, it will
// perform a copy.
ts_subtree_make_mut :: (pool: *SubtreePool, self: Subtree) -> MutableSubtree #foreign libtree_sitter;

ts_subtree_retain :: (self: Subtree) -> void #foreign libtree_sitter;

ts_subtree_release :: (pool: *SubtreePool, self: Subtree) -> void #foreign libtree_sitter;

ts_subtree_compare :: (left: Subtree, right: Subtree, pool: *SubtreePool) -> s32 #foreign libtree_sitter;

ts_subtree_set_symbol :: (self: *MutableSubtree, symbol: TSSymbol, language: *TSLanguage) -> void #foreign libtree_sitter;

ts_subtree_compress :: (self: MutableSubtree, count: u32, language: *TSLanguage, stack: *MutableSubtreeArray) -> void #foreign libtree_sitter;

// Assign all of the node's properties that depend on its children.
ts_subtree_summarize_children :: (self: MutableSubtree, language: *TSLanguage) -> void #foreign libtree_sitter;

ts_subtree_edit :: (self: Subtree, edit: *TSInputEdit, pool: *SubtreePool) -> Subtree #foreign libtree_sitter;

ts_subtree_string :: (self: Subtree, alias_symbol: TSSymbol, alias_is_named: bool, language: *TSLanguage, include_all: bool) -> *u8 #foreign libtree_sitter;

ts_subtree_print_dot_graph :: (self: Subtree, language: *TSLanguage, f: *FILE) -> void #foreign libtree_sitter;

ts_subtree_last_external_token :: (tree: Subtree) -> Subtree #foreign libtree_sitter;

ts_subtree_external_scanner_state :: (self: Subtree) -> *ExternalScannerState #foreign libtree_sitter;

ts_subtree_external_scanner_state_eq :: (self: Subtree, other: Subtree) -> bool #foreign libtree_sitter;

TreeCursorEntry :: struct {
    subtree:                *Subtree;
    position:               Length;
    child_index:            u32;
    structural_child_index: u32;
    descendant_index:       u32;
}

TreeCursor :: struct {
    tree:              *TSTree;
    stack:             struct {
        contents: *TreeCursorEntry;
        size:     u32;
        capacity: u32;
    };
    root_alias_symbol: TSSymbol;
}

TreeCursorStep :: enum u32 {
    None    :: 0;
    Hidden  :: 1;
    Visible :: 2;

    TreeCursorStepNone    :: None;
    TreeCursorStepHidden  :: Hidden;
    TreeCursorStepVisible :: Visible;
}

ts_tree_cursor_init :: (self: *TreeCursor, node: TSNode) -> void #foreign libtree_sitter;

// Private - Get various facts about the current node that are needed
// when executing tree queries.
ts_tree_cursor_current_status :: (_self: *TSTreeCursor, field_id: *TSFieldId, has_later_siblings: *bool, has_later_named_siblings: *bool, can_have_later_siblings_with_this_field: *bool, supertypes: *TSSymbol, supertype_count: *u32) -> void #foreign libtree_sitter;

ts_tree_cursor_parent_node :: (_self: *TSTreeCursor) -> TSNode #foreign libtree_sitter;

TSRangeArray :: struct {
    contents: *TSRange;
    size:     u32;
    capacity: u32;
}

ts_range_array_get_changed_ranges :: (old_ranges: *TSRange, old_range_count: u32, new_ranges: *TSRange, new_range_count: u32, differences: *TSRangeArray) -> void #foreign libtree_sitter;

ts_range_array_intersects :: (self: *TSRangeArray, start_index: u32, start_byte: u32, end_byte: u32) -> bool #foreign libtree_sitter;

ts_subtree_get_changed_ranges :: (old_tree: *Subtree, new_tree: *Subtree, cursor1: *TreeCursor, cursor2: *TreeCursor, language: *TSLanguage, included_range_differences: *TSRangeArray, ranges: **TSRange) -> u32 #foreign libtree_sitter;

TableEntry :: struct {
    actions:      *TSParseAction;
    action_count: u32;
    is_reusable:  bool;
}

LookaheadIterator :: struct {
    language:       *TSLanguage;
    data:           *u16;
    group_end:      *u16;
    state:          TSStateId;
    table_value:    u16;
    section_index:  u16;
    group_count:    u16;
    is_small_state: bool;

    actions:        *TSParseAction;
    symbol:         TSSymbol;
    next_state:     TSStateId;
    action_count:   u16;
}

ts_language_table_entry :: (self: *TSLanguage, state: TSStateId, symbol: TSSymbol, result: *TableEntry) -> void #foreign libtree_sitter;

ts_language_lex_mode_for_state :: (self: *TSLanguage, state: TSStateId) -> TSLexerMode #foreign libtree_sitter;

ts_language_is_reserved_word :: (self: *TSLanguage, state: TSStateId, symbol: TSSymbol) -> bool #foreign libtree_sitter;

ts_language_symbol_metadata :: (self: *TSLanguage, symbol: TSSymbol) -> TSSymbolMetadata #foreign libtree_sitter;

ts_language_public_symbol :: (self: *TSLanguage, symbol: TSSymbol) -> TSSymbol #foreign libtree_sitter;

Iterator :: struct {
    cursor:              TreeCursor;
    language:            *TSLanguage;
    visible_depth:       u32;
    in_padding:          bool;
    prev_external_token: Subtree;
}

IteratorComparison :: enum u32 {
    Differs   :: 0;
    MayDiffer :: 1;
    Matches   :: 2;

    IteratorDiffers   :: Differs;
    IteratorMayDiffer :: MayDiffer;
    IteratorMatches   :: Matches;
}

ts_wasm_store_start :: (self: *TSWasmStore, lexer: *TSLexer, language: *TSLanguage) -> bool #foreign libtree_sitter;

ts_wasm_store_reset :: (self: *TSWasmStore) -> void #foreign libtree_sitter;

ts_wasm_store_has_error :: (self: *TSWasmStore) -> bool #foreign libtree_sitter;

ts_wasm_store_call_lex_main :: (self: *TSWasmStore, state: TSStateId) -> bool #foreign libtree_sitter;

ts_wasm_store_call_lex_keyword :: (self: *TSWasmStore, state: TSStateId) -> bool #foreign libtree_sitter;

ts_wasm_store_call_scanner_create :: (self: *TSWasmStore) -> u32 #foreign libtree_sitter;

ts_wasm_store_call_scanner_destroy :: (self: *TSWasmStore, scanner_address: u32) -> void #foreign libtree_sitter;

ts_wasm_store_call_scanner_scan :: (self: *TSWasmStore, scanner_address: u32, valid_tokens_ix: u32) -> bool #foreign libtree_sitter;

ts_wasm_store_call_scanner_serialize :: (self: *TSWasmStore, scanner_address: u32, buffer: *u8) -> u32 #foreign libtree_sitter;

ts_wasm_store_call_scanner_deserialize :: (self: *TSWasmStore, scanner: u32, buffer: *u8, length: u32) -> void #foreign libtree_sitter;

ts_wasm_language_retain :: (self: *TSLanguage) -> void #foreign libtree_sitter;

ts_wasm_language_release :: (self: *TSLanguage) -> void #foreign libtree_sitter;

ColumnData :: struct {
    value: u32;
    valid: bool;
}

Lexer :: struct {
    data:                         TSLexer;
    current_position:             Length;
    token_start_position:         Length;
    token_end_position:           Length;

    included_ranges:              *TSRange;
    chunk:                        *u8;
    input:                        TSInput;
    logger:                       TSLogger;

    included_range_count:         u32;
    current_included_range_index: u32;
    chunk_start:                  u32;
    chunk_size:                   u32;
    lookahead_size:               u32;
    did_get_column:               bool;
    column_data:                  ColumnData;

    debug_buffer:                 [1024] u8;
}

ts_lexer_init :: (self: *Lexer) -> void #foreign libtree_sitter;

ts_lexer_delete :: (self: *Lexer) -> void #foreign libtree_sitter;

ts_lexer_set_input :: (self: *Lexer, input: TSInput) -> void #foreign libtree_sitter;

// Move the lexer to the given position. This doesn't do any work
// if the parser is already at the given position.
ts_lexer_reset :: (self: *Lexer, position: Length) -> void #foreign libtree_sitter;

ts_lexer_start :: (self: *Lexer) -> void #foreign libtree_sitter;

ts_lexer_finish :: (self: *Lexer, lookahead_end_byte: *u32) -> void #foreign libtree_sitter;

ts_lexer_mark_end :: (self: *Lexer) -> void #foreign libtree_sitter;

ts_lexer_set_included_ranges :: (self: *Lexer, ranges: *TSRange, count: u32) -> bool #foreign libtree_sitter;

ts_lexer_included_ranges :: (self: *Lexer, count: *u32) -> *TSRange #foreign libtree_sitter;

/** The ICU boolean type @stable ICU 2.0 */
UBool :: s8;

UChar :: u16;

OldUChar :: u16;

/**
* Define UChar32 as a type for single Unicode code points.
* UChar32 is a signed 32-bit integer (same as int32_t).
*
* The Unicode code point range is 0..0x10ffff.
* All other values (negative or >=0x110000) are illegal as Unicode code points.
* They may be used as sentinel values to indicate "done", "error"
* or similar non-code point conditions.
*
* Before ICU 2.4 (Jitterbug 2146), UChar32 was defined
* to be wchar_t if that is 32 bits wide (wchar_t may be signed or unsigned)
* or else to be uint32_t.
* That is, the definition of UChar32 was platform-dependent.
*
* @see U_SENTINEL
* @stable ICU 2.4
*/
UChar32 :: s32;

TS_DECODE_ERROR: s32 : -1;

BYTE_ORDER_MARK: s32 : 65279;

ParentCacheEntry :: struct {
    child:        *Subtree;
    parent:       *Subtree;
    position:     Length;
    alias_symbol: TSSymbol;
}

TSTree :: struct {
    root:                 Subtree;
    language:             *TSLanguage;
    included_ranges:      *TSRange;
    included_range_count: u32;
}

ts_tree_new :: (root: Subtree, language: *TSLanguage, included_ranges: *TSRange, included_range_count: u32) -> *TSTree #foreign libtree_sitter;

// TSNode - constructors
ts_node_new :: (tree: *TSTree, subtree: *Subtree, position: Length, alias: TSSymbol) -> TSNode #foreign libtree_sitter;

NodeChildIterator :: struct {
    parent:                 Subtree;
    tree:                   *TSTree;
    position:               Length;
    child_index:            u32;
    structural_child_index: u32;
    alias_sequence:         *TSSymbol;
}

ReduceAction :: struct {
    count:              u32;
    symbol:             TSSymbol;
    dynamic_precedence: s32;
    production_id:      u16;
}

ReduceActionSet :: struct {
    contents: *ReduceAction;
    size:     u32;
    capacity: u32;
}

StackEntry :: struct {
    tree:        Subtree;
    child_index: u32;
    byte_offset: u32;
}

ReusableNode :: struct {
    stack:               struct {
        contents: *StackEntry;
        size:     u32;
        capacity: u32;
    };
    last_external_token: Subtree;
}

StackVersion :: u32;

StackSlice :: struct {
    subtrees: SubtreeArray;
    version:  StackVersion;
}

StackSliceArray :: struct {
    contents: *StackSlice;
    size:     u32;
    capacity: u32;
}

StackSummaryEntry :: struct {
    position: Length;
    depth:    u32;
    state:    TSStateId;
}

StackSummary :: struct {
    contents: *StackSummaryEntry;
    size:     u32;
    capacity: u32;
}

// Create a stack.
ts_stack_new :: (subtree_pool: *SubtreePool) -> *Stack #foreign libtree_sitter;

// Release the memory reserved for a given stack.
ts_stack_delete :: (self: *Stack) -> void #foreign libtree_sitter;

// Get the stack's current number of versions.
ts_stack_version_count :: (self: *Stack) -> u32 #foreign libtree_sitter;

// Get the stack's current number of halted versions.
ts_stack_halted_version_count :: (self: *Stack) -> u32 #foreign libtree_sitter;

// Get the state at the top of the given version of the stack. If the stack is
// empty, this returns the initial state, 0.
ts_stack_state :: (self: *Stack, version: StackVersion) -> TSStateId #foreign libtree_sitter;

// Get the last external token associated with a given version of the stack.
ts_stack_last_external_token :: (self: *Stack, version: StackVersion) -> Subtree #foreign libtree_sitter;

// Set the last external token associated with a given version of the stack.
ts_stack_set_last_external_token :: (self: *Stack, version: StackVersion, token: Subtree) -> void #foreign libtree_sitter;

// Get the position of the given version of the stack within the document.
ts_stack_position :: (unknown0: *Stack, unknown1: StackVersion) -> Length #foreign libtree_sitter;

// Push a tree and state onto the given version of the stack.
//
// This transfers ownership of the tree to the Stack. Callers that
// need to retain ownership of the tree for their own purposes should
// first retain the tree.
ts_stack_push :: (self: *Stack, version: StackVersion, subtree: Subtree, pending: bool, state: TSStateId) -> void #foreign libtree_sitter;

// Pop the given number of entries from the given version of the stack. This
// operation can increase the number of stack versions by revealing multiple
// versions which had previously been merged. It returns an array that
// specifies the index of each revealed version and the trees that were
// removed from that version.
ts_stack_pop_count :: (self: *Stack, version: StackVersion, count: u32) -> StackSliceArray #foreign libtree_sitter;

// Remove an error at the top of the given version of the stack.
ts_stack_pop_error :: (self: *Stack, version: StackVersion) -> SubtreeArray #foreign libtree_sitter;

// Remove any pending trees from the top of the given version of the stack.
ts_stack_pop_pending :: (self: *Stack, version: StackVersion) -> StackSliceArray #foreign libtree_sitter;

// Remove all trees from the given version of the stack.
ts_stack_pop_all :: (self: *Stack, version: StackVersion) -> StackSliceArray #foreign libtree_sitter;

// Get the maximum number of tree nodes reachable from this version of the stack
// since the last error was detected.
ts_stack_node_count_since_error :: (self: *Stack, version: StackVersion) -> u32 #foreign libtree_sitter;

ts_stack_dynamic_precedence :: (self: *Stack, version: StackVersion) -> s32 #foreign libtree_sitter;

ts_stack_has_advanced_since_error :: (self: *Stack, version: StackVersion) -> bool #foreign libtree_sitter;

// Compute a summary of all the parse states near the top of the given
// version of the stack and store the summary for later retrieval.
ts_stack_record_summary :: (self: *Stack, version: StackVersion, max_depth: u32) -> void #foreign libtree_sitter;

// Retrieve a summary of all the parse states near the top of the
// given version of the stack.
ts_stack_get_summary :: (self: *Stack, version: StackVersion) -> *StackSummary #foreign libtree_sitter;

// Get the total cost of all errors on the given version of the stack.
ts_stack_error_cost :: (self: *Stack, version: StackVersion) -> u32 #foreign libtree_sitter;

// Merge the given two stack versions if possible, returning true
// if they were successfully merged and false otherwise.
ts_stack_merge :: (self: *Stack, version1: StackVersion, version2: StackVersion) -> bool #foreign libtree_sitter;

// Determine whether the given two stack versions can be merged.
ts_stack_can_merge :: (self: *Stack, version1: StackVersion, version2: StackVersion) -> bool #foreign libtree_sitter;

ts_stack_resume :: (self: *Stack, version: StackVersion) -> Subtree #foreign libtree_sitter;

ts_stack_pause :: (self: *Stack, version: StackVersion, lookahead: Subtree) -> void #foreign libtree_sitter;

ts_stack_halt :: (self: *Stack, version: StackVersion) -> void #foreign libtree_sitter;

ts_stack_is_active :: (self: *Stack, version: StackVersion) -> bool #foreign libtree_sitter;

ts_stack_is_paused :: (self: *Stack, version: StackVersion) -> bool #foreign libtree_sitter;

ts_stack_is_halted :: (self: *Stack, version: StackVersion) -> bool #foreign libtree_sitter;

ts_stack_renumber_version :: (self: *Stack, v1: StackVersion, v2: StackVersion) -> void #foreign libtree_sitter;

ts_stack_swap_versions :: (unknown0: *Stack, v1: StackVersion, v2: StackVersion) -> void #foreign libtree_sitter;

ts_stack_copy_version :: (self: *Stack, version: StackVersion) -> StackVersion #foreign libtree_sitter;

// Remove the given version from the stack.
ts_stack_remove_version :: (self: *Stack, version: StackVersion) -> void #foreign libtree_sitter;

ts_stack_clear :: (self: *Stack) -> void #foreign libtree_sitter;

ts_stack_print_dot_graph :: (self: *Stack, language: *TSLanguage, f: *FILE) -> bool #foreign libtree_sitter;

MAX_VERSION_COUNT: u32 : 6;
MAX_VERSION_COUNT_OVERFLOW: u32 : 4;
MAX_SUMMARY_DEPTH: u32 : 16;
MAX_COST_DIFFERENCE: u32 : 1800;
OP_COUNT_PER_PARSER_CALLBACK_CHECK: u32 : 100;

TokenCache :: struct {
    token:               Subtree;
    last_external_token: Subtree;
    byte_index:          u32;
}

TSParser :: struct {
    lexer:                           Lexer;
    stack:                           *Stack;
    tree_pool:                       SubtreePool;
    language:                        *TSLanguage;
    wasm_store:                      *TSWasmStore;
    reduce_actions:                  ReduceActionSet;
    finished_tree:                   Subtree;
    trailing_extras:                 SubtreeArray;
    trailing_extras2:                SubtreeArray;
    scratch_trees:                   SubtreeArray;
    token_cache:                     TokenCache;
    reusable_node:                   ReusableNode;
    external_scanner_payload:        *void;
    dot_graph_file:                  *FILE;
    accept_count:                    u32;
    operation_count:                 u32;
    old_tree:                        Subtree;
    included_range_differences:      TSRangeArray;
    parse_options:                   TSParseOptions;
    parse_state:                     TSParseState;
    included_range_difference_index: u32;
    has_scanner_error:               bool;
    canceled_balancing:              bool;
    has_error:                       bool;
}

ErrorStatus :: struct {
    cost:               u32;
    node_count:         u32;
    dynamic_precedence: s32;
    is_in_error:        bool;
}

ErrorComparison :: enum u32 {
    TakeLeft    :: 0;
    PreferLeft  :: 1;
    None        :: 2;
    PreferRight :: 3;
    TakeRight   :: 4;

    ErrorComparisonTakeLeft    :: TakeLeft;
    ErrorComparisonPreferLeft  :: PreferLeft;
    ErrorComparisonNone        :: None;
    ErrorComparisonPreferRight :: PreferRight;
    ErrorComparisonTakeRight   :: TakeRight;
}

TSStringInput :: struct {
    _string: *u8;
    length:  u32;
}

/*
* Stream - A sequence of unicode characters derived from a UTF8 string.
* This struct is used in parsing queries from S-expressions.
*/
Stream :: struct {
    input:     *u8;
    start:     *u8;
    end:       *u8;
    next:      s32;
    next_size: u8;
}

/*
* QueryStep - A step in the process of matching a query. Each node within
* a query S-expression corresponds to one of these steps. An entire pattern
* is represented as a sequence of these steps. The basic properties of a
* node are represented by these fields:
* - `symbol` - The grammar symbol to match. A zero value represents the
*    wildcard symbol, '_'.
* - `field` - The field name to match. A zero value means that a field name
*    was not specified.
* - `capture_ids` - An array of integers representing the names of captures
*    associated with this node in the pattern, terminated by a `NONE` value.
* - `depth` - The depth where this node occurs in the pattern. The root node
*    of the pattern has depth zero.
* - `negated_field_list_id` - An id representing a set of fields that must
*    not be present on a node matching this step.
*
* Steps have some additional fields in order to handle the `.` (or "anchor") operator,
* which forbids additional child nodes:
* - `is_immediate` - Indicates that the node matching this step cannot be preceded
*   by other sibling nodes that weren't specified in the pattern.
* - `is_last_child` - Indicates that the node matching this step cannot have any
*   subsequent named siblings.
*
* For simple patterns, steps are matched in sequential order. But in order to
* handle alternative/repeated/optional sub-patterns, query steps are not always
* structured as a linear sequence; they sometimes need to split and merge. This
* is done using the following fields:
*  - `alternative_index` - The index of a different query step that serves as
*    an alternative to this step. A `NONE` value represents no alternative.
*    When a query state reaches a step with an alternative index, the state
*    is duplicated, with one copy remaining at the original step, and one copy
*    moving to the alternative step. The alternative may have its own alternative
*    step, so this splitting is an iterative process.
* - `is_dead_end` - Indicates that this state cannot be passed directly, and
*    exists only in order to redirect to an alternative index, with no splitting.
* - `is_pass_through` - Indicates that state has no matching logic of its own,
*    and exists only to split a state. One copy of the state advances immediately
*    to the next step, and one moves to the alternative step.
* - `alternative_is_immediate` - Indicates that this step's alternative step
*    should be treated as if `is_immediate` is true.
*
* Steps also store some derived state that summarizes how they relate to other
* steps within the same pattern. This is used to optimize the matching process:
*  - `contains_captures` - Indicates that this step or one of its child steps
*     has a non-empty `capture_ids` list.
*  - `parent_pattern_guaranteed` - Indicates that if this step is reached, then
*     it and all of its subsequent sibling steps within the same parent pattern
*     are guaranteed to match.
*  - `root_pattern_guaranteed` - Similar to `parent_pattern_guaranteed`, but
*     for the entire top-level pattern. When iterating through a query's
*     captures using `ts_query_cursor_next_capture`, this field is used to
*     detect that a capture can safely be returned from a match that has not
*     even completed yet.
*/
QueryStep :: struct {
    symbol:                    TSSymbol;
    supertype_symbol:          TSSymbol;
    field:                     TSFieldId;
    capture_ids:               [3] u16;
    depth:                     u16;
    alternative_index:         u16;
    negated_field_list_id:     u16;
    is_named:                  bool; /* 1 bits */
    is_immediate:              bool #align 1; /* 1 bits */
    is_last_child:             bool #align 1; /* 1 bits */
    is_pass_through:           bool #align 1; /* 1 bits */
    is_dead_end:               bool #align 1; /* 1 bits */
    alternative_is_immediate:  bool #align 1; /* 1 bits */
    contains_captures:         bool #align 1; /* 1 bits */
    root_pattern_guaranteed:   bool #align 1; /* 1 bits */
    parent_pattern_guaranteed: bool; /* 1 bits */
    is_missing:                bool #align 1; /* 1 bits */
}

/*
* Slice - A slice of an external array. Within a query, capture names,
* literal string values, and predicate step information are stored in three
* contiguous arrays. Individual captures, string values, and predicates are
* represented as slices of these three arrays.
*/
Slice :: struct {
    offset: u32;
    length: u32;
}

/*
* SymbolTable - a two-way mapping of strings to ids.
*/
SymbolTable :: struct {
    characters: struct {
        contents: *u8;
        size:     u32;
        capacity: u32;
    };
    slices:     struct {
        contents: *Slice;
        size:     u32;
        capacity: u32;
    };
}

/**
* CaptureQuantifiers - a data structure holding the quantifiers of pattern captures.
*/
CaptureQuantifiers :: struct {
    /**
    * CaptureQuantifiers - a data structure holding the quantifiers of pattern captures.
    */
    contents: *u8;
    size:     u32;
    capacity: u32;
}

/*
* PatternEntry - Information about the starting point for matching a particular
* pattern. These entries are stored in a 'pattern map' - a sorted array that
* makes it possible to efficiently lookup patterns based on the symbol for their
* first step. The entry consists of the following fields:
* - `pattern_index` - the index of the pattern within the query
* - `step_index` - the index of the pattern's first step in the shared `steps` array
* - `is_rooted` - whether or not the pattern has a single root node. This property
*   affects decisions about whether or not to start the pattern for nodes outside
*   of a QueryCursor's range restriction.
*/
PatternEntry :: struct {
    step_index:    u16;
    pattern_index: u16;
    is_rooted:     bool;
}

QueryPattern :: struct {
    steps:           Slice;
    predicate_steps: Slice;
    start_byte:      u32;
    end_byte:        u32;
    is_non_local:    bool;
}

StepOffset :: struct {
    byte_offset: u32;
    step_index:  u16;
}

/*
* QueryState - The state of an in-progress match of a particular pattern
* in a query. While executing, a `TSQueryCursor` must keep track of a number
* of possible in-progress matches. Each of those possible matches is
* represented as one of these states. Fields:
* - `id` - A numeric id that is exposed to the public API. This allows the
*    caller to remove a given match, preventing any more of its captures
*    from being returned.
* - `start_depth` - The depth in the tree where the first step of the state's
*    pattern was matched.
* - `pattern_index` - The pattern that the state is matching.
* - `consumed_capture_count` - The number of captures from this match that
*    have already been returned.
* - `capture_list_id` - A numeric id that can be used to retrieve the state's
*    list of captures from the `CaptureListPool`.
* - `seeking_immediate_match` - A flag that indicates that the state's next
*    step must be matched by the very next sibling. This is used when
*    processing repetitions, or when processing a wildcard node followed by
*    an anchor.
* - `has_in_progress_alternatives` - A flag that indicates that there is are
*    other states that have the same captures as this state, but are at
*    different steps in their pattern. This means that in order to obey the
*    'longest-match' rule, this state should not be returned as a match until
*    it is clear that there can be no other alternative match with more captures.
*/
QueryState :: struct {
    id:                           u32;
    capture_list_id:              u32;
    start_depth:                  u16;
    step_index:                   u16;
    pattern_index:                u16;
    consumed_capture_count:       u16; /* 12 bits */
    seeking_immediate_match:      bool #align 1; /* 1 bits */
    has_in_progress_alternatives: bool #align 1; /* 1 bits */
    dead:                         bool #align 1; /* 1 bits */
    needs_parent:                 bool #align 1; /* 1 bits */
}

CaptureList :: struct {
    contents: *TSQueryCapture;
    size:     u32;
    capacity: u32;
}

/*
* CaptureListPool - A collection of *lists* of captures. Each query state needs
* to maintain its own list of captures. To avoid repeated allocations, this struct
* maintains a fixed set of capture lists, and keeps track of which ones are
* currently in use by a query state.
*/
CaptureListPool :: struct {
    list:                    struct {
        contents: *CaptureList;
        size:     u32;
        capacity: u32;
    };
    empty_list:              CaptureList;

    // The maximum number of capture lists that we are allowed to allocate. We
    // never allow `list` to allocate more entries than this, dropping pending
    // matches if needed to stay under the limit.
    max_capture_list_count:  u32;

    // The number of capture lists allocated in `list` that are not currently in
    // use. We reuse those existing-but-unused capture lists before trying to
    // allocate any new ones. We use an invalid value (UINT32_MAX) for a capture
    // list's length to indicate that it's not in use.
    free_capture_list_count: u32;
}

/*
* AnalysisState - The state needed for walking the parse table when analyzing
* a query pattern, to determine at which steps the pattern might fail to match.
*/
AnalysisStateEntry :: struct {
    parse_state:   TSStateId;
    parent_symbol: TSSymbol;
    child_index:   u16;
    field_id:      TSFieldId; /* 15 bits */
    done:          bool #align 1; /* 1 bits */
}

AnalysisState :: struct {
    stack:       [8] AnalysisStateEntry;
    depth:       u16;
    step_index:  u16;
    root_symbol: TSSymbol;
}

AnalysisStateSet :: struct {
    contents: **AnalysisState;
    size:     u32;
    capacity: u32;
}

QueryAnalysis :: struct {
    states:                  AnalysisStateSet;
    next_states:             AnalysisStateSet;
    deeper_states:           AnalysisStateSet;
    state_pool:              AnalysisStateSet;
    final_step_indices:      struct {
        contents: *u16;
        size:     u32;
        capacity: u32;
    };
    finished_parent_symbols: struct {
        contents: *TSSymbol;
        size:     u32;
        capacity: u32;
    };
    did_abort:               bool;
}

/*
* AnalysisSubgraph - A subset of the states in the parse table that are used
* in constructing nodes with a certain symbol. Each state is accompanied by
* some information about the possible node that could be produced in
* downstream states.
*/
AnalysisSubgraphNode :: struct {
    state:         TSStateId;
    production_id: u16;
    child_index:   u8; /* 7 bits */
    done:          bool #align 1; /* 1 bits */
}

AnalysisSubgraph :: struct {
    symbol:       TSSymbol;
    start_states: struct {
        contents: *TSStateId;
        size:     u32;
        capacity: u32;
    };
    nodes:        struct {
        contents: *AnalysisSubgraphNode;
        size:     u32;
        capacity: u32;
    };
}

AnalysisSubgraphArray :: struct {
    contents: *AnalysisSubgraph;
    size:     u32;
    capacity: u32;
}

/*
* StatePredecessorMap - A map that stores the predecessors of each parse state.
* This is used during query analysis to determine which parse states can lead
* to which reduce actions.
*/
StatePredecessorMap :: struct {
    contents: *TSStateId;
}

/*
* TSQuery - A tree query, compiled from a string of S-expressions. The query
* itself is immutable. The mutable state used in the process of executing the
* query is stored in a `TSQueryCursor`.
*/
TSQuery :: struct {
    captures:                              SymbolTable;
    predicate_values:                      SymbolTable;
    capture_quantifiers:                   struct {
        contents: *CaptureQuantifiers;
        size:     u32;
        capacity: u32;
    };
    steps:                                 struct {
        contents: *QueryStep;
        size:     u32;
        capacity: u32;
    };
    pattern_map:                           struct {
        contents: *PatternEntry;
        size:     u32;
        capacity: u32;
    };
    predicate_steps:                       struct {
        contents: *TSQueryPredicateStep;
        size:     u32;
        capacity: u32;
    };
    patterns:                              struct {
        contents: *QueryPattern;
        size:     u32;
        capacity: u32;
    };
    step_offsets:                          struct {
        contents: *StepOffset;
        size:     u32;
        capacity: u32;
    };
    negated_fields:                        struct {
        contents: *TSFieldId;
        size:     u32;
        capacity: u32;
    };
    string_buffer:                         struct {
        contents: *u8;
        size:     u32;
        capacity: u32;
    };
    repeat_symbols_with_rootless_patterns: struct {
        contents: *TSSymbol;
        size:     u32;
        capacity: u32;
    };
    language:                              *TSLanguage;
    wildcard_root_pattern_count:           u16;
}

/*
* TSQueryCursor - A stateful struct used to execute a query on a tree.
*/
TSQueryCursor :: struct {
    query:                  *TSQuery;
    cursor:                 TSTreeCursor;
    states:                 struct {
        contents: *QueryState;
        size:     u32;
        capacity: u32;
    };
    finished_states:        struct {
        contents: *QueryState;
        size:     u32;
        capacity: u32;
    };
    capture_list_pool:      CaptureListPool;
    depth:                  u32;
    max_start_depth:        u32;
    start_byte:             u32;
    end_byte:               u32;
    start_point:            TSPoint;
    end_point:              TSPoint;
    next_state_id:          u32;
    query_options:          *TSQueryCursorOptions;
    query_state:            TSQueryCursorState;
    operation_count:        u32;
    on_visible_node:        bool;
    ascending:              bool;
    halted:                 bool;
    did_exceed_match_limit: bool;
}

PARENT_DONE: TSQueryError : -1;
PATTERN_DONE_MARKER: u16 : U16_MAX;
NONE: u16 : U16_MAX;
WILDCARD_SYMBOL: TSSymbol : 0;
OP_COUNT_PER_QUERY_CALLBACK_CHECK: u32 : 100;

ts_query__step_is_fallible :: (self: *TSQuery, step_index: u16) -> bool #foreign libtree_sitter;

// Determine which node is first in a depth-first traversal
ts_query_cursor__compare_nodes :: (left: TSNode, right: TSNode) -> s32 #foreign libtree_sitter;

// Determine if either state contains a superset of the other state's captures.
ts_query_cursor__compare_captures :: (self: *TSQueryCursor, left_state: *QueryState, right_state: *QueryState, left_contains_right: *bool, right_contains_left: *bool) -> void #foreign libtree_sitter;

StackLink :: struct {
    node:       *StackNode;
    subtree:    Subtree;
    is_pending: bool;
}

StackNode :: struct {
    state:              TSStateId;
    position:           Length;
    links:              [8] StackLink;
    link_count:         u16;
    ref_count:          u32;
    error_cost:         u32;
    node_count:         u32;
    dynamic_precedence: s32;
}

StackIterator :: struct {
    node:          *StackNode;
    subtrees:      SubtreeArray;
    subtree_count: u32;
    is_pending:    bool;
}

StackNodeArray :: struct {
    contents: **StackNode;
    size:     u32;
    capacity: u32;
}

StackStatus :: enum u32 {
    Active :: 0;
    Paused :: 1;
    Halted :: 2;

    StackStatusActive :: Active;
    StackStatusPaused :: Paused;
    StackStatusHalted :: Halted;
}

StackHead :: struct {
    node:                     *StackNode;
    summary:                  *StackSummary;
    node_count_at_last_error: u32;
    last_external_token:      Subtree;
    lookahead_when_paused:    Subtree;
    status:                   StackStatus;
}

Stack :: struct {
    heads:        struct {
        contents: *StackHead;
        size:     u32;
        capacity: u32;
    };
    slices:       StackSliceArray;
    iterators:    struct {
        contents: *StackIterator;
        size:     u32;
        capacity: u32;
    };
    node_pool:    StackNodeArray;
    base_node:    *StackNode;
    subtree_pool: *SubtreePool;
}

StackAction :: u32;
StackAction_1 :: enum u32 {
    None :: 0;
    Stop :: 1;
    Pop  :: 2;

    StackActionNone :: None;
    StackActionStop :: Stop;
    StackActionPop  :: Pop;
}

StackCallback :: #type (unknown0: *void, unknown1: *StackIterator) -> StackAction #c_call;

SummarizeStackSession :: struct {
    summary:   *StackSummary;
    max_depth: u32;
}

Edit :: struct {
    start:   Length;
    old_end: Length;
    new_end: Length;
}

ts_external_scanner_state_copy :: (self: *ExternalScannerState) -> ExternalScannerState #foreign libtree_sitter;

// Clone a subtree.
ts_subtree_clone :: (self: Subtree) -> MutableSubtree #foreign libtree_sitter;

ROOT_FIELD: *u8 : "__ROOT__";

ts_subtree__print_dot_graph :: (self: *Subtree, start_offset: u32, language: *TSLanguage, alias_symbol: TSSymbol, f: *FILE) -> void #foreign libtree_sitter;

CursorChildIterator :: struct {
    parent:                 Subtree;
    tree:                   *TSTree;
    position:               Length;
    child_index:            u32;
    structural_child_index: u32;
    descendant_index:       u32;
    alias_sequence:         *TSSymbol;
}

_ts_dup :: (file_descriptor: s32) -> s32 #foreign libtree_sitter;

#scope_file

libtree_sitter :: #library,no_dll "bin/x64/libtree_sitter";
