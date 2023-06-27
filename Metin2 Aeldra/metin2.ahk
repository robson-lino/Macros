#SingleInstance Force
#MaxThreads 2
#Persistent ; (Interception hotkeys do not stop AHK from exiting, so use this)
#include Lib\AutoHotInterception.ahk
SetKeyDelay, 50, 50
#Include %A_LineFile%\..\JSON.ahk
#Include Lib\funcoes.ahk
SendMode Input

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window
global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25"
global Conta
global Conta1,Conta2,Conta3
global p := 1
global AchouOutX, AchouOutY
global Xjanela, Yjanela, Hjanela, Wjanela
global tickVerVara := A_TickCount - 600000

;global Conta1 := "XXXXXXX,XXXXXXXXX"
;global Conta2 := "rlino001,08567315L123"
;global Conta3 := "bufflino,08567315L123"

WinActivate, Aeldra
WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela,  Aeldra
if (Xjanela = "")
{
	GeraLog("METIN NÃO ESTAVA ABERTO")
	Pause
}
Yjanela := Yjanela+50
SetTimer PegaItens, 500, ON, 3

Gui +AlwaysOnTop
Gui Add, Text, x9 y13 w120 h23 +0x200, Contas:
Gui Add, Radio, hWndradConta vConta x10 y46 w50 h23 +Checked, Conta1
Gui Add, Radio, hWndradConta x64 y46 w50 h23, Conta2
Gui Add, Radio, hWndradConta x117 y47 w50 h23, Conta3

Gui Show, x1603 y72 w249 h418, Window

; Função para ler o arquivo JSON
ReadJSON(MEUDEUS) 
{
    FileRead, merda, %MEUDEUS%
    return %merda%
}

; Lê o arquivo JSON
putaquepariu := ReadJSON("contas.json")
quelixodelinguagem := JSON.Load(putaquepariu)
parsed := JSON.Load(json_str)

; Analisa o JSON e cria as variáveis globais
for key, value in quelixodelinguagem 
    %key% := value.ID . "," . value.Senha

F8::Pause

TaLogado()
{
	ImageSearch, OutX, OutY, 673, 223, 904, 395, *20 %a_scriptdir%\login.png
	if !ErrorLevel
	{
		GeraLog("Estava deslogado")
		SetKeyDelay, -1, -1
		Gui, Submit, NoHide
		GeraLog(Conta)
		ClicaRandom(876, 566, 5)
		Loop, parse, Conta%Conta%, `,
		{
			Loop, 60
				Send, {BackSpace}
			
			Sleep, 60
			Send, %A_LoopField%
			Sleep, 60
			Send, {Enter}
		}
		ProcuraAteAcharSemLogar(52, 263, 148, 325, 40, "flag", MinToMili(3))
		Send, {Enter}
		SetKeyDelay, 25, 25
	}
}


AbreSkill()
{
	ImageSearch, OutX, OutY, 40, 284, 279, 681, *40 %a_scriptdir%\skills.png
	if ErrorLevel
	{
		Send, v
	}
	if (!ProcuraAteAchar(40, 284, 279, 681, 40, "skills", 500))
		AbreSkill()
}

AbreInventario()
{
	MouseMove, 809, 484
	ImageSearch, OutX, OutY, 713, 603, 907, 648, *40 %a_scriptdir%\cancelar.png
	if !ErrorLevel
	{
		ClicaRandom(OutX, OutY, 2)
	}
	ImageSearch, OutX, OutY, 1427, 326, 1595, 859, *40 %a_scriptdir%\inventario.png
	if ErrorLevel
	{
		Send, i
	}
	if (!ProcuraAteAchar(1427, 326, 1595, 859, 40, "inventario", 500))
	{
		loop, 5
		{
			Send, {ESC}
		}
		AbreInventario()
	}
}

ProcuraAteAchar(X, Y, H, W, var, img, mili)
{   
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% *TransRed %a_scriptdir%\%img%.png
        if (!ErrorLevel)
        {
            AchouOutX := OutX
            AchouOutY := OutY
            return true
        }
    }
    return false
}

ProcuraAteAcharSemLogar(X, Y, H, W, var, img, mili)
{   
    ;Inicio := A_TickCount
    ;Ativa()
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% %a_scriptdir%\%img%.png
        if (!ErrorLevel)
        {
            AchouOutX := OutX
            AchouOutY := OutY
            return true
        }
    }
    return false
}

ProcuraAteNaoAchar(X, Y, H, W, var, img, mili)
{   
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% %a_scriptdir%\%img%.png
        if (ErrorLevel)
        {
            return true
        }
    }
    return false
}

ProcuraPixelAteNaoAchar(X, Y, color, mili)
{   
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        if (RetornaCorPixel(X, Y) != color)
        {
            return true
        }
    }
    return false
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


F6::
loop,
{
	GiraAteAchar()
	VaiAteMetin()
	MataPedra()
	ProcuraAteNaoAchar(799, 55, 882, 84, 40, "vida", 30000)
}
return

F7::
ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\s.png
if !ErrorLevel
{
	GeraLog("Pegou")
	Tecla("z", 50)
}
return

VaiAteMetin()
{
	SeguraTecla("w")
	if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 30, "metinpedra", 5000))
	{
		GeraLog("Achou metin")
		Sleep, 50
		SoltaTecla("w")
		return
	}
	SoltaTecla("w")
}

GiraAteAchar()
{
	SeguraTecla("e")
	if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "mapametin2", 5000))
	{
		GeraLog("Achou")
		Sleep, 50
		SoltaTecla("e")
		return
	}
	SoltaTecla("e")
}

MataPedra()
{
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\metinpedra.png
	if !ErrorLevel
	{
		ClicaRandom(OutX, OutY, 5)
	}
}

PegaItens()
{
	SetTimer PegaItens, off
	Inicio := A_TickCount
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\obe.png
	if !ErrorLevel
	{
		GeraLog("Pegou")
		Tecla("z", 50)
	}
	;GeraLog("PegaItens: " A_TickCount - Inicio)
	SetTimer PegaItens, 500, ON, 3
}
