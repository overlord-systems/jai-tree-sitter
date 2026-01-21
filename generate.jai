#run build();
build :: () {

    set_build_options_dc(.{do_output=false});

	options := get_build_options();
    args := options.compile_time_command_line;

    if !generate_bindings(args) {
        compiler_set_workspace_status(.FAILED);
        return;
    }
}

// Current sources are from commit: https://github.com/tree-sitter/tree-sitter/tree/120f74723e694be4dc2f0033e01b24350dd73f19
BINDINGS_SRC_PATH :: "src/tree-sitter/lib/include/tree_sitter/api.h";
BINDINGS_INCLUDE_DIRS :: string.["src/tree-sitter/lib/include"];

BUILD_SRC_PATH :: "src/tree-sitter/lib/src/lib.c";
BUILD_INCLUDE_DIRS :: string.["src/tree-sitter/lib/src", "src/tree-sitter/lib/include"];

DECLARATIONS_TO_OMIT :: string.[
];

ENUMS_TO_OMIT :: string.[
];

generate_bindings :: (args: []string) -> bool {

    compile := array_find(args, "-compile");
    compile_json := array_find(args, "-compile_json");
    compile_go := array_find(args, "-compile_go");
    compile_jai := array_find(args, "-compile_jai");
    compile_sql := array_find(args, "-compile_sql");
    compile_dockerfile := array_find(args, "-compile_dockerfile");
    compile_yaml := array_find(args, "-compile_yaml");

    if compile {
        success := compile_tree_sitter();
        if !success return false;
    }

    if compile_json {
        success := compile_json_lang();
        if !success return false;
    }

    if compile_go {
        success := compile_go_lang();
        if !success return false;
    }

    if compile_jai {
        success := compile_jai_lang();
        if !success return false;
    }

    if compile_sql {
        success := compile_sql_lang();
        if !success return false;
    }

    if compile_dockerfile {
        success := compile_dockerfile_lang();
        if !success return false;
    }

    if compile_yaml {
        success := compile_yaml_lang();
        if !success return false;
    }

    output_filename: string;
    opts: Generate_Bindings_Options;

    array_add(*opts.source_files, BINDINGS_SRC_PATH);
    array_add(*opts.include_paths, ..BINDINGS_INCLUDE_DIRS);
    array_add(*opts.libraries, .{filename="libtree-sitter"});

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        output_filename = "windows/windows.jai";
        array_add(*opts.library_search_paths, "windows/bin/x64");

        opts.footer = FOOTER_WIN;
        opts.generate_library_declarations = false;

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        output_filename = "linux/linux.jai";
        array_add(*opts.library_search_paths, "linux/bin/x64");

        opts.footer = FOOTER_LINUX;
        opts.generate_library_declarations = false;

    } /*else #if OS == .MACOS {
        output_filename = "macos/macos.jai";
    }*/ else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    opts.visitor = tree_sitter_visitor;
    opts.generate_compile_time_struct_checks = false;

    return generate_bindings(opts, output_filename);
}

compile_tree_sitter :: () -> ok: bool {

    src_files: [..]string;
    array_add(*src_files, BUILD_SRC_PATH);

    success := false;

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/bin/x64/libtree-sitter", ..src_files, extra=.[
            tprint("/I%", BUILD_INCLUDE_DIRS[0]),
            tprint("/I%", BUILD_INCLUDE_DIRS[1]),
        ]);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/bin/x64/libtree-sitter", ..src_files, extra=.[
            tprint("-I%", BUILD_INCLUDE_DIRS[0]),
            tprint("-I%", BUILD_INCLUDE_DIRS[1]),
        ]);
    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_json_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/json/src/parser.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/json/src"];

    BINDINGS  :: #string EOF
tree_sitter_json :: () -> *TSLanguage #foreign libtree_sitter_json;

libtree_sitter_json :: #library,no_dll "bin/x64/libtree-sitter-json";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/json/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/json/bin/x64/libtree-sitter-json", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/json/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/json/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/json/bin/x64/libtree-sitter-json", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/json/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_sql_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/sql/src/parser.c", "src/languages/sql/src/scanner.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/sql/src"];

    BINDINGS  :: #string EOF
tree_sitter_sql :: () -> *TSLanguage #foreign libtree_sitter_sql;

libtree_sitter_sql :: #library,no_dll "bin/x64/libtree-sitter-sql";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/sql/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/sql/bin/x64/libtree-sitter-sql", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/sql/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/sql/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/sql/bin/x64/libtree-sitter-sql", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/sql/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_go_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/go/src/parser.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/go/src"];

    BINDINGS  :: #string EOF
tree_sitter_go :: () -> *TSLanguage #foreign libtree_sitter_go;

libtree_sitter_go :: #library,no_dll "bin/x64/libtree-sitter-go";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/go/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/go/bin/x64/libtree-sitter-go", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/go/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/go/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/go/bin/x64/libtree-sitter-go", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/go/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_jai_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/jai/src/parser.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/jai/src"];

    BINDINGS  :: #string EOF
// Note the proc name in the library uses "Jai", with a capital "J"
tree_sitter_jai :: () -> *TSLanguage #foreign libtree_sitter_jai "tree_sitter_Jai";

libtree_sitter_jai :: #library,no_dll "bin/x64/libtree-sitter-jai";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/jai/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/jai/bin/x64/libtree-sitter-jai", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/jai/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/jai/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/jai/bin/x64/libtree-sitter-jai", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/jai/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_dockerfile_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/dockerfile/src/parser.c", "src/languages/dockerfile/src/scanner.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/dockerfile/src"];

    BINDINGS  :: #string EOF
tree_sitter_dockerfile :: () -> *TSLanguage #foreign libtree_sitter_dockerfile;

libtree_sitter_dockerfile :: #library,no_dll "bin/x64/libtree-sitter-dockerfile";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/dockerfile/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/dockerfile/bin/x64/libtree-sitter-dockerfile", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/dockerfile/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/dockerfile/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/dockerfile/bin/x64/libtree-sitter-dockerfile", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/dockerfile/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

compile_yaml_lang :: () -> ok: bool {

    BUILD_LANGUAGES_SRC_PATHS :: string.["src/languages/yaml/src/parser.c", "src/languages/yaml/src/scanner.c", "src/languages/yaml/src/schema.core.c", "src/languages/yaml/src/schema.json.c", "src/languages/yaml/src/schema.legacy.c"];
    BUILD_LANGUAGES_INCLUDE_DIRS :: string.["src/languages/yaml/src"];

    BINDINGS  :: #string EOF
tree_sitter_yaml :: () -> *TSLanguage #foreign libtree_sitter_yaml;

libtree_sitter_yaml :: #library,no_dll "bin/x64/libtree-sitter-yaml";
    EOF

    success := false;

    src_files: [..]string;
    array_add(*src_files, ..BUILD_LANGUAGES_SRC_PATHS);

    includes: [..]string;
    for BUILD_LANGUAGES_INCLUDE_DIRS {
        tprint("/I%", it);
    }

    #if OS == .WINDOWS {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("windows/languages/yaml/bin/x64", recursive=true);

        success = build_cpp_static_lib("windows/languages/yaml/bin/x64/libtree-sitter-yaml", ..src_files, extra=includes);

        success &&= write_entire_file("windows/languages/yaml/windows.jai", BINDINGS);

    } else #if OS == .LINUX {

        #if CPU != .X64 {
            assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
        }

        make_directory_if_it_does_not_exist("linux/languages/yaml/bin/x64", recursive=true);

        success = build_cpp_static_lib("linux/languages/yaml/bin/x64/libtree-sitter-yaml", ..src_files, extra=includes);

        success &&= write_entire_file("linux/languages/yaml/linux.jai", BINDINGS);

    } else {
        assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
    }

    return success;
}

tree_sitter_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    return .RECURSE;
}

#scope_file

#import "String";
#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";

FOOTER_WIN :: #string END
libtree_sitter :: #library,no_dll "bin/x64/libtree-sitter";
END

FOOTER_LINUX :: #string END
libtree_sitter :: #library,no_dll "bin/x64/libtree-sitter";
END
