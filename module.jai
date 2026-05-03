#module_parameters () {}

#if OS == .WINDOWS {

    #load "windows/windows.jai";
    #load "windows/languages/json/windows.jai";
    #load "windows/languages/go/windows.jai";
    #load "windows/languages/jai/windows.jai";
    #load "windows/languages/sql/windows.jai";
    #load "windows/languages/dockerfile/windows.jai";
    #load "windows/languages/yaml/windows.jai";
    #load "windows/languages/c/windows.jai";

} else #if OS == .LINUX {
    #load "linux/linux.jai";
    #load "linux/languages/json/linux.jai";
    #load "linux/languages/go/linux.jai";
    #load "linux/languages/jai/linux.jai";
    #load "linux/languages/sql/linux.jai";
    #load "linux/languages/dockerfile/linux.jai";
    #load "linux/languages/yaml/linux.jai";
    #load "linux/languages/c/linux.jai";
} else #if OS == .MACOS {
    #load "macos/macos.jai";
    #load "macos/languages/json/macos.jai";
    #load "macos/languages/go/macos.jai";
    #load "macos/languages/jai/macos.jai";
    #load "macos/languages/sql/macos.jai";
    #load "macos/languages/dockerfile/macos.jai";
    #load "macos/languages/yaml/macos.jai";
    #load "macos/languages/c/macos.jai";
} else {
    #assert false "this OS is not currently supported by tree-sitter. You must generate bindings for it. Check the README for information.";
}
