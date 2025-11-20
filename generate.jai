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
SRC_PATH :: "src/tree-sitter/lib/src/lib.c";
INCLUDE_DIRS :: string.["src/tree-sitter/lib/src", "src/tree-sitter/lib/include"];

DECLARATIONS_TO_OMIT :: string.[
];

ENUMS_TO_OMIT :: string.[
];

generate_bindings :: (args: []string) -> bool {

    output_filename: string;
    opts: Generate_Bindings_Options;
    compile := array_find(args, "-compile");

    if compile {

        src_files: [..]string;
        array_add(*src_files, SRC_PATH);

        success := false;
        defer if !success return false;

        #if OS == .WINDOWS {

            #if CPU != .X64 {
                assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
            }

            make_directory_if_it_does_not_exist("windows/bin/x64", recursive=true);

            success = build_cpp_static_lib("windows/bin/x64/libtree-sitter", ..src_files, extra=.[
                tprint("/I%", INCLUDE_DIRS[0]),
                tprint("/I%", INCLUDE_DIRS[1]),
            ]);

        } else #if OS == .LINUX {

            #if CPU != .X64 {
                assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
            }

            make_directory_if_it_does_not_exist("linux/bin/x64", recursive=true);

            success = build_cpp_static_lib("linux/bin/x64/libtree-sitter", ..src_files, extra=.[
                tprint("-I%", INCLUDE_DIRS[0]),
                tprint("-I%", INCLUDE_DIRS[1]),
            ]);
        } else {
            assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
        }
    }

    {
        using opts;

        array_add(*source_files, SRC_PATH);
        array_add(*include_paths, ..INCLUDE_DIRS);
        array_add(*libraries, .{filename="libtree-sitter"});

        #if OS == .WINDOWS {

            #if CPU != .X64 {
                assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
            }

            output_filename = "windows/windows.jai";
            array_add(*library_search_paths, "windows/bin/x64");

            footer = FOOTER_WIN;
            generate_library_declarations = false;

        } else #if OS == .LINUX {

            #if CPU != .X64 {
                assert("CPU=% isn't currently supported. You might be able to add support for it though!", CPU);
            }

            output_filename = "linux/linux.jai";
            array_add(*library_search_paths, "linux/bin/x64");

            footer = FOOTER_LINUX;
            generate_library_declarations = false;

        } /*else #if OS == .MACOS {
            output_filename = "macos/macos.jai";
        }*/ else {
            assert(false, "this OS is currently unsupported. You might be able to add support for it though!");
        }

        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";

FOOTER_WIN :: #string END
libtree_sitter :: #library,no_dll "bin/x64/libtree_sitter";
END

FOOTER_LINUX :: #string END
libtree_sitter :: #library,no_dll "bin/x64/libtree_sitter";
END
