#module_parameters () (LOAD_JSON_LANG := true, LOAD_GO_LANG := true, LOAD_JAI_LANG := true) {}

#if OS == .WINDOWS {

    #load "windows/windows.jai";
    #if LOAD_JSON_LANG then #load "windows/languages/json/windows.jai";
    #if LOAD_GO_LANG then #load "windows/languages/go/windows.jai";
    #if LOAD_JAI_LANG then #load "windows/languages/jai/windows.jai";

} else #if OS == .LINUX {
    #load "linux/linux.jai";
    #if LOAD_JSON_LANG then #load "linux/languages/json/linux.jai";
    #if LOAD_GO_LANG then #load "linux/languages/go/linux.jai";
    #if LOAD_JAI_LANG then #load "linux/languages/jai/linux.jai";
} else {
    #assert false "this OS is not currently supported by tree-sitter. You must generate bindings for it. Check the README for information.";
}
