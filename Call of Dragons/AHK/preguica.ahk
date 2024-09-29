#SingleInstance Force
SendMode Event
SetKeyDelay 40, 50

#IfWinActive ahk_exe Code.exe ; Classe da janela do Visual Studio Code
^s::
Hotkey, ^s, off 
Send, ^s
Hotkey, ^s, on
Sleep, 200
Run, cod.ahk
return
#IfWinActive 

^F10::
Run, cod.ahk
return