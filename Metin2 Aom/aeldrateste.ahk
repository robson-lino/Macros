#SingleInstance Force
#MaxThreads 1
#Include, ocr.ahk
#Include %A_LineFile%\..\JSON.ahk

DefaultDirs = a_scriptdir

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

F9::
ImageSearch, OutX, OutY, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 %a_scriptdir%\inventario.png
if !ErrorLevel
{
    MsgBox, "Ta aberto"
}
else
{
    MsgBox, "Não está"
}
return