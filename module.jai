#if OS == .WINDOWS {
    #load "windows/windows.jai";
} else #if OS == .LINUX {
    #load "linux/linux.jai";
} else {
    #assert false "this OS is not currently supported by tree-sitter. You must generate bindings for it. Check the README for information.";
}
