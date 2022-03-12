#SingleInstance Force
SendMode Event
SetKeyDelay 40, 50

^s::
Hotkey, ^s, off 
Send, ^s
Hotkey, ^s, on
Sleep, 200
Run, luna.ahk
return