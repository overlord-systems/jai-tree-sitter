#module_parameters () (LOAD_JSON_LANG := true) {}

#if OS == .WINDOWS {

    #load "windows/windows.jai";
    #if LOAD_JSON_LANG then #load "windows/languages/json/windows.jai";

} else #if OS == .LINUX {
    #load "linux/linux.jai";
    #if LOAD_JSON_LANG then #load "linux/languages/json/windows.jai";
} else {
    #assert false "this OS is not currently supported by tree-sitter. You must generate bindings for it. Check the README for information.";
}
