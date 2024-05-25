
#SingleInstance Force
#MaxThreads 2
#Persistent ; (Interception hotkeys do not stop AHK from exiting, so use this)
#include Lib\AutoHotInterception.ahk
SetKeyDelay, 50, 50
#Include Lib\CaptureScreen.ahk
#Include Lib\funcoes.ahk
#Include Lib\FindClick.ahk
SendMode Input

F9::Pause

~c::
    while (GetKeyState("c", "P")) {
        Tecla("r")
        Tecla("Enter")
    }
return

GeraLog(msg) {
	if (!log)
		return
	FormatTime, DataFormatada, D1 T0
	FileRead,FileContents, %a_scriptdir%\metinlog%optConta%.log
	FileDelete %a_scriptdir%\metinlog%optConta%.log
	FileAppend,%DataFormatada% - %msg%`n%FileContents%,%a_scriptdir%\metinlog%optConta%.log
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metinlog%optConta%.log
	if ErrorLevel{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metinlog%optConta%.log
	}
}