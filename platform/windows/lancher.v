module windows

#flag windows -lshell32
#include <windows.h>
#include <shellapi.h>


pub fn lanch_path(path string) bool {
	wpath := path.to_wide()

	res := C.shellExecuteW(
		voidptr(0),
		voidptr(0),
		wpath,
		voidptr(0),
		voidptr(0),
		C.SW_SHOWNORMAL
	)

	return int(res)>32
}