#SingleInstance Force
#MaxThreads 1

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window
global listaPeixes := "p1,p2,p3,p4"

#Include, ocr.ahk
#include, utilitarios.ahk
#include, metin2_pesca.ahk

SetKeyDelay, 25, 25

Pause::Pause

F9::
loop,
{
	AbreInventario()
	UsaTodosOsPeixes()
	ProcuraIsca()
	EsperaFisgar()
	Sleep, 1500
}
return

F11::
GeraLog(listaPeixes)
Loop, parse, listaPeixes, `,
{
	GeraLog(A_LoopField)
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\%A_LoopField%.png
	if !ErrorLevel
	{
		MouseClick, right, OutX, OutY
	}
}
return