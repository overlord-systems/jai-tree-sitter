#import "Basic";
#import,file "../module.jai";

// These alloc procs perhaps aren't prod ready...or perhaps they are.
ts_malloc :: (size: u64) -> *void #c_call {
    push_context {
        return alloc(size.(s64));
    }
}

ts_calloc :: (count: u64, size: u64) -> *void #c_call {
    // Calloc expects zeroed data
    push_context {
        total_bytes := (count * size).(s64);
        data := alloc(total_bytes);
        if data then memset(data, 0, total_bytes);
        return data;
    }
}

ts_realloc :: (data: *void, size: u64) -> *void #c_call {
    push_context {
        return realloc(data, size.(s64), 0);
    }
}

ts_free :: (data: *void) #c_call {
    push_context {
        free(data);
    }
}

main :: () {

    ts_set_allocator(
        ts_malloc,
        ts_calloc,
        ts_realloc,
        ts_free,
    );

    parser := ts_parser_new();

    json_lang := tree_sitter_json();
    assert(json_lang != null, "tree_sitter_json returned null");

    go_lang := tree_sitter_go();
    assert(go_lang != null, "tree_sitter_go returned null");

    jai_lang := tree_sitter_jai();
    assert(jai_lang != null, "tree_sitter_jai returned null");

    sql_lang := tree_sitter_sql();
    assert(sql_lang != null, "tree_sitter_sql returned null");

    dockerfile_lang := tree_sitter_dockerfile();
    assert(sql_lang != null, "tree_sitter_dockerfile returned null");

    ts_parser_set_language(parser, json_lang);

    // Build a syntax tree based on source code stored in a string.
    json_source_code := #string EOF
    {"name": "overlord", "age": 1000}
    EOF
    tree := ts_parser_parse_string(
        parser,
        null,
        json_source_code.data,
        json_source_code.count.(u32)
    );

    // Get the root node of the syntax tree.
    root_node := ts_tree_root_node(tree);

    // Get some child nodes.
    object_node := ts_node_named_child(root_node, 0);

    name_kv_node := ts_node_named_child(object_node, 0);
    name_key_node := ts_node_named_child(name_kv_node, 0);
    name_value_node := ts_node_named_child(name_kv_node, 1);

    age_kv_node := ts_node_named_child(object_node, 1);
    age_key_node := ts_node_named_child(age_kv_node, 0);
    age_value_node := ts_node_named_child(age_kv_node, 1);

    // Check that the nodes have the expected types.
    assert(to_string(ts_node_type(root_node)) == "document");
    assert(to_string(ts_node_type(object_node)) == "object");

    assert(to_string(ts_node_type(name_kv_node)) == "pair");
    assert(to_string(ts_node_type(name_key_node)) == "string");
    assert(to_string(ts_node_type(name_value_node)) == "string");

    assert(to_string(ts_node_type(age_kv_node)) == "pair");
    assert(to_string(ts_node_type(age_key_node)) == "string");
    assert(to_string(ts_node_type(age_value_node)) == "number");

    assert(ts_node_named_child(object_node, 2).id == null);

    // Check that the nodes have the expected child counts.
    assert(ts_node_child_count(root_node) == 1);
    assert(ts_node_child_count(object_node) == 5);
    assert(ts_node_named_child_count(object_node) == 2);

    assert(ts_node_child_count(name_kv_node) == 3);
    assert(ts_node_named_child_count(name_kv_node) == 2);

    assert(ts_node_child_count(age_kv_node) == 3);
    assert(ts_node_named_child_count(age_kv_node) == 2);

    // Print the syntax tree as an S-expression.
    tree_s_expr := to_string(ts_node_string(root_node));
    print("syntax tree = %\n", tree_s_expr);

    // Test querying
    json_highlights_query := #string EOF
(pair
  key: (_) @string.special.key)

(string) @string

(number) @number

[
  (null)
  (true)
  (false)
] @constant.builtin

(escape_sequence) @escape

(comment) @comment
    EOF;

    query_error_offset: u32;
    query_error: TSQueryError;
    query := ts_query_new(json_lang, json_highlights_query.data, json_highlights_query.count.(u32), *query_error_offset, *query_error);
    assert(query != null, "ts_query_new returned a null query");

    query_cursor := ts_query_cursor_new();
    ts_query_cursor_exec(query_cursor, query, root_node);

    query_match_index: u32;
    query_match: TSQueryMatch;
    print("\nstarting to print query captures:\n");
    while ts_query_cursor_next_capture(query_cursor, *query_match, *query_match_index) {

        captures: []TSQueryCapture;
        captures.data = query_match.captures;
        captures.count = query_match.capture_count;

        for cap: captures {

            node_type := to_string(ts_node_type(cap.node));
            start_point := ts_node_start_point(cap.node);
            end_point := ts_node_end_point(cap.node);

            print("\ncapture(%,%): type=%; start_point=%; end_point=%\n",
                query_match_index,
                it_index,
                node_type,
                start_point,
                end_point,
            );
        }
    }
    print("\nfinished printing query captures\n");

    // Free allocs
    ts_free(tree_s_expr.data);
    ts_query_delete(query);
    ts_query_cursor_delete(query_cursor);
    ts_tree_delete(tree);
    ts_parser_delete(parser);

    print("\nTests successful!\n");
}
