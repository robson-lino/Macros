#SingleInstance Force
#NoTrayIcon
#Persistent

global X := 50
Gui +LastFound
hWnd := WinExist()

Gui, +hwndHwnd
Gui, Color, Blue
Gui, Show, w43 h1 x842 y712 NoActivate

Gui, +E0x80000
Gui, -Caption
Gui, -SysMenu
Gui, -0xC00000 ; WS_SIZEBOX
Gui, -0x40000 ; WS_MINIMIZEBOX
Gui, -0x20000 ; WS_MAXIMIZEBOX
Gui, +LastFound +AlwaysOnTop
WinSet, TransColor, Blue
WinSet, Transparent, %X%


F7::
X++
Gui, Destroy
Gui +LastFound
hWnd := WinExist()

Gui, +hwndHwnd
Gui, Color, Blue
Gui, Show, w70 h3 x900 y88 NoActivate

Gui, +E0x80000
Gui, -Caption
Gui, -SysMenu
Gui, -0xC00000 ; WS_SIZEBOX
Gui, -0x40000 ; WS_MINIMIZEBOX
Gui, -0x20000 ; WS_MAXIMIZEBOX
Gui, +LastFound +AlwaysOnTop
WinSet, TransColor, Blue
WinSet, Transparent, %X%
return

F8::
X--
Gui, Destroy
Gui +LastFound
hWnd := WinExist()

Gui, +hwndHwnd
Gui, Color, Blue
Gui, Show, w70 h3 x900 y88 NoActivate

Gui, +E0x80000
Gui, -Caption
Gui, -SysMenu
Gui, -0xC00000 ; WS_SIZEBOX
Gui, -0x40000 ; WS_MINIMIZEBOX
Gui, -0x20000 ; WS_MAXIMIZEBOX
Gui, +LastFound +AlwaysOnTop
WinSet, TransColor, Blue
WinSet, Transparent, %X%
return


return

F11::ExitApp