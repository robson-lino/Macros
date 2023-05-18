#SingleInstance Force
#Persistent

global X := 97
Gui +LastFound
hWnd := WinExist()

Gui, +hwndHwnd
Gui, Color, Blue
Gui, Show, w60 h1 x836 y712 NoActivate

Gui, +E0x80000
Gui, -Caption
Gui, -SysMenu
Gui, -0xC00000 ; WS_SIZEBOX
Gui, -0x40000 ; WS_MINIMIZEBOX
Gui, -0x20000 ; WS_MAXIMIZEBOX
Gui, +LastFound +AlwaysOnTop
WinSet, TransColor, Black
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
WinSet, TransColor, Black
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
WinSet, TransColor, Black
WinSet, Transparent, %X%
return


return

F11::ExitApp