#SingleInstance Force
Process, Priority, , High
#MaxThreads 2

#Include FindClick.ahk

DefaultDirs = a_scriptdir


SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Aeldra"
global clt := 1
Pause::Pause

#IfWinActive Aeldra
~LButton::
Send, '
Send, '
Send, '
Send, '
return

#IfWinActive Aeldra
^F8::
Goto, skill
return

skill:
Send, ^g
Sleep, 300
Send, {F1}
Sleep, 300
Send, ^g
Sleep, 300
Send, ^g
Sleep, 300
Send, {F2}
Sleep, 300
Send, ^g
return


^F9::
clt := 1
SetTimer, skill, 700000
Gosub, skill
loop
{
	Send, {space down}
	Sleep, 300
	loop, 80
	{
		Send, 3
		Sleep, randSleep()
		Send, '
	}
	Sleep, randSleep()
	Sleep, randSleep()
	Send, '
	Send, {space up}
	if (clt = 1)
	{
		Send, {w down}
		Sleep, 5500
		Send, {w up}
		clt := 2
	}
	else
	{
		Send, {s down}
		Sleep, 5500
		Send, {s up}
		clt := 1
	}
}
Return


randSleep()
{
    Random, rand, 3000, 5000
    return rand
}

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	}
}
return
