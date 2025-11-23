#import "Basic";
#import,file "../module.jai";

main :: () {

    parser := ts_parser_new();

    json_lang := tree_sitter_json();
    assert(json_lang != null, "tree_sitter_json returned null");

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

    print("Tests successful!\n");
}
