#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1

global Push
global PushMais
global Farm
global Absal
global MiR
global ChkPrestige
global BOS
global ChkAll
global Alternado
global Nenhum
global Target



loop,
{
    ; Recupera
    ControlGet, Push, Checked,, Button10, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, PushMais, Checked,, Button11, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, Farm, Checked,, Button12, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, Absal, Checked,, Button13, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, HS, Checked,, Button14, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, MiR, Checked,, Button1, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, ChkPrestige, Checked,, Button2, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, BOS, Checked,, Button6, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, ChkAll, Checked,, Button7, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, Alternado, Checked,, Button8, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ControlGet, Nenhum, Checked,, Button9, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    
    ControlGet, Target, Line, 1, Edit1, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ;ControlGet, Media, Line, 1, Static16, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    ;ControlGet, Qnt, Line, 1, Static18, TapMacro ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    Sleep, 5000
    if (WinExist("tap.ahk") or !WinExist("TapMacro"))
    {
        ; Executa
        Run, tap.ahk
        Sleep, 300

        ControlSetText, Edit1, %Target%, TapMacro
        if (Push)
            Control, Check,, Button10, TapMacro
        else
            Control, Uncheck,, Button10, TapMacro
        
        if (PushMais)
            Control, Check,, Button11, TapMacro
        else
            Control, Uncheck,, Button11, TapMacro
        
        if (Farm)
            Control, Check,, Button12, TapMacro
        else
            Control, Uncheck,, Button12, TapMacro
        
        if (Absal)
            Control, Check,, Button13, TapMacro
        else
            Control, Uncheck,, Button13, TapMacro
         if (HS)
            Control, Check,, Button14, TapMacro
        else
            Control, Uncheck,, Button13, TapMacro
        if (MiR)
            Control, Check,, Button1, TapMacro
        else
            Control, Uncheck,, Button1, TapMacro
        
        if (ChkPrestige)
            Control, Check,, Button2, TapMacro
        else
            Control, Uncheck,, Button2, TapMacro
        
        if (BOS)
            Control, Check,, Button6, TapMacro
        else
            Control, Uncheck,, Button6, TapMacro
        
        if (ChkAll)
            Control, Check,, Button7, TapMacro
        else
            Control, Uncheck,, Button7, TapMacro
        
        if (Alternado)
            Control, Check,, Button8, TapMacro
        else
            Control, Uncheck,, Button8, TapMacro
        
        if (Nenhum)
            Control, Check,, Button9, TapMacro
        else
            Control, Uncheck,, Button9, TapMacro
        
        ; Clica no iniciar
        Sleep, 500
        ControlClick, Button5, TapMacro,,,, NA
        Sleep, 500
        Send, Enter
        GeraLog("Abriu de novo por que estava com erro.")
    }
}
return

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
	}
}