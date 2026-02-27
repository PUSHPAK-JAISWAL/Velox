module windows

#flag windows -luser32
#include <windows.h>

pub const (
	mod_ctrl = 0x0002
	mod_alt = 0x0001
	vk_space = 0x20
)

pub fn register_lancher_hotkey() bool {
	return C.RegisterHotKey(
		voidptr(0),
		1,
		mod_ctrl | mod_alt,
		vk_space
	) != 0
}

pub fn listen_hotkey(callback fn()) {
	mut msg:= C.MSG{}

	for C.GetMessage(&msg,voidptr(0),0,0)>0 {
		if msg.message == C.WM_HOTKEY {
			callback()
		}
		C.TranslateMessage(&msg)
		C.DispatchMessage(&msg)
	}
}