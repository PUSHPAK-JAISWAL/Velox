module core

#flag windows -lshell32
#include <windows.h>
#include <shellapi.h>

pub fn launch(path string) bool {
    w := path.to_wide()

    res := C.ShellExecuteW(
        voidptr(0),
        voidptr(0),
        w,
        voidptr(0),
        voidptr(0),
        C.SW_SHOWNORMAL
    )

    return int(res) > 32
}