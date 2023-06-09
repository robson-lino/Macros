#SingleInstance Force
#MaxThreads 1
#Include, ocr.ahk
#Include %A_LineFile%\..\JSON.ahk

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window

global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15"
global Conta
global Conta1,Conta2,Conta3

;global Conta1 := "XXXXXXX,XXXXXXXXX"
;global Conta2 := "rlino001,08567315L123"
;global Conta3 := "bufflino,08567315L123"

Gui +AlwaysOnTop
Gui Add, Text, x9 y13 w120 h23 +0x200, Contas:
Gui Add, Radio, hWndradConta vConta x10 y46 w50 h23 +Checked, Conta1
Gui Add, Radio, hWndradConta x64 y46 w50 h23, Conta2
Gui Add, Radio, hWndradConta x117 y47 w50 h23, Conta3

Gui Show, x1603 y72 w249 h418, Window
SetKeyDelay, 25, 25

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

Pause::Pause

F9::
loop,
{
	TaLogado()
	AbreInventario()
	UsaTodosOsPeixes()
	ProcuraIsca()
	EsperaFisgar()
	Sleep, 1500
}
return

F11::
TaLogado()
return

TaLogado()
{
	ImageSearch, OutX, OutY, 673, 223, 904, 395, *20 %a_scriptdir%\login.png
	if !ErrorLevel
	{
		SetKeyDelay, -1, -1
		Gui, Submit, NoHide
		GeraLog(Conta)
		MouseClick, left, 876, 566
		Loop, parse, Conta%Conta%, `,
		{
			Loop, 30
				Send, {BackSpace}
			
			Sleep, 30
			Send, %A_LoopField%
			Sleep, 30
			Send, {Enter}
		}
		GeraLog("Saiu do loop")
		ProcuraAteAcharSemLogar(52, 263, 148, 325, 40, "flag", 30000)
		Send, {Enter}
		SetKeyDelay, 25, 25
	}
}


EsperaFisgar()
{
	AbreSkill()
	ClicaSkillPesca()
	ProcuraAteAchar(776, 357, 830, 375, 20, "pescaria", 500)
	ImageSearch, OutX, OutY, 776, 357, 830, 375, *20 %a_scriptdir%\pescaria.png
	while (!ErrorLevel)
	{
		ImageSearch, OutX, OutY, 775, 416, 838, 449, *20 %a_scriptdir%\vermelho.png
		if !ErrorLevel
		{
            Sleep, 30
			ImageSearch, OutX, OutY, 744, 415, 879, 556, *20 %a_scriptdir%\peixe.png
            if !ErrorLevel
                MouseClick, left, OutX, OutY
		}
		ImageSearch, OutX, OutY, 776, 357, 830, 375, *20 %a_scriptdir%\pescaria.png
	}
	Sleep, 3000
}

ProcuraIsca()
{
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\isca.png
	if !ErrorLevel
	{
		MouseClick, right, OutX, OutY
		return
	}
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\minhoca.png
	if !ErrorLevel
	{
		MouseClick, right, OutX, OutY
		return
	}
	GeraLog("Sem isca")
	; Futura troca de aba
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

ClicaSkillPesca()
{
	ImageSearch, OutX, OutY, 40, 284, 279, 681, *40 %a_scriptdir%\skillpesca.png
	if !ErrorLevel
	{
		MouseClick, right, OutX+5, OutY+5
	    MouseMove, 804, 359
	}
}

AbreInventario()
{
	MouseMove, 804, 359
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\inventario.png
	if ErrorLevel
	{
		Send, i
	}
	if (!ProcuraAteAchar(1439, 521, 1602, 865, 40, "inventario", 500))
		AbreInventario()
}

TiraItemNovo()
{
	MouseMove, 804, 359
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\itemnovo.png
	if !ErrorLevel
	{
		MouseMove, OutX, OutY+5
	}
}
return

UsaTodosOsPeixes()
{
    Loop, parse, listaPeixes, `,
    {
        GeraLog("Procura " A_LoopField)
        ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *30 %a_scriptdir%\%A_LoopField%.png
        if !ErrorLevel
        {
            GeraLog("achou " A_LoopField)
            MouseClick, right, OutX, OutY
        }
    }
}


ProcuraAteAchar(X, Y, H, W, var, img, mili)
{   
    ;Inicio := A_TickCount
    ;Ativa()
	TaLogado()
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

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	}
}

randSleep()
{
    Random, rand, 3000, 5000
    return rand
}
