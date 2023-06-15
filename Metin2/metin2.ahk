#SingleInstance Force
#MaxThreads 1
#Include, ocr.ahk
#Include %A_LineFile%\..\JSON.ahk

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window

global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25"
global Conta
global Conta1,Conta2,Conta3
global p := 1

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
F8::Pause

F9::
loop,
{
	TaLogado()
	AbreInventario()
	Manual()
	JogaTintaFora()
	;UsaTodosOsPeixes()
	ProcuraIsca()
	EsperaFisgar()
	Sleep, 1500
}
return

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
			Loop, 30
				Send, {BackSpace}
			
			Sleep, 30
			Send, %A_LoopField%
			Sleep, 30
			Send, {Enter}
		}
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
                ClicaRandom(OutX, OutY, 3)
		}
		else
		{
			ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *30 %a_scriptdir%\p%p%.png
			if !ErrorLevel
			{
				ClicaRandomDIreito(OutX, OutY, 3)
				p++
			}
			else
			{
				p++
			}
			if (p = 26)
				p := 1
		}
		ImageSearch, OutX, OutY, 776, 357, 830, 375, *20 %a_scriptdir%\pescaria.png
	}
}

ProcuraIsca()
{
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\isca.png
	if !ErrorLevel
	{
		ClicaRandomDIreito(OutX, OutY, 3)
		return
	}
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\minhoca.png
	if !ErrorLevel
	{
		ClicaRandomDIreito(OutX+10, OutY+5, 3)
		return
	}
	CompraIsca()
	; Futura troca de aba
}

F11::
TaLogado()
return



F5::
Manual()
return


CompraManual()
{
	ImageSearch, OutX, OutY, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 *TransBlack %a_scriptdir%\pescador.png
	if !ErrorLevel
	{
		ClicaRandom(OutX+20, OutY+20, 3)
		Sleep, 300
		ClicaRandom(809, 367, 3)
		if (ProcuraAteAchar(1268, 53, 1332, 68, 20, "loja", 1000))
		{
			ClicaRandomDIreito(1303, 93, 3)
			Sleep, 300
			ClicaRandom(1374, 62, 3)
		}
		else
		{
			Send, {ESC}
			return
		}
		
	}
}
Manual()
{
	ImageSearch, OutX, OutY, 14, 40, 295, 61, *60 %a_scriptdir%\manual.png
	if ErrorLevel
	{
		ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 %a_scriptdir%\manualpesca.png
		if !ErrorLevel
		{
			ClicaRandomDIreito(OutX, OutY, 3)
			return
		}
		else
		{
			CompraManual()
		}
	}
}

CompraIsca()
{
	ImageSearch, OutX, OutY, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 *TransBlack %a_scriptdir%\pescador.png
	if !ErrorLevel
	{
		ClicaRandom(OutX+20, OutY+20, 3)
		Sleep, 300
		ClicaRandom(809, 367, 3)
		if (ProcuraAteAchar(1268, 53, 1332, 68, 20, "loja", 1000))
		{
			ClicaRandomDIreito(1301, 120, 3)
			Sleep, 300
			ClicaRandom(1374, 62, 3)
		}
		else
		{
			Send, {ESC}
			return
		}
	}
}

JogaTintaFora()
{
	ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *40 *TransBlack %a_scriptdir%\tinta.png
	if !ErrorLevel
	{
		MouseMove, OutX, OutY
		Sleep, 20
		Send {LButton down}
		MouseMove, 829, 357
		Send {LButton up}
		Sleep, 20
		ClicaRandom(765, 492, 3)
		Sleep, 20
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

ClicaSkillPesca()
{
	ImageSearch, OutX, OutY, 40, 284, 279, 681, *40 %a_scriptdir%\skillpesca.png
	if !ErrorLevel
	{
		ClicaRandomDIreito(OutX+5, OutY+5, 3)
		MouseMove, 804, 359
	}
	while (!ProcuraAteAchar(776, 357, 830, 375, 20, "pescaria", 100))
	{
		ImageSearch, OutX, OutY, 40, 284, 279, 681, *40 %a_scriptdir%\skillpesca.png
		if !ErrorLevel
		{
			ClicaRandomDIreito(OutX+5, OutY+5, 3)
			MouseMove, 804, 359
		}
		if (A_index > 5)
			return
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
        ;GeraLog("Procura " A_LoopField)
        ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *30 %a_scriptdir%\%A_LoopField%.png
        if !ErrorLevel
        {
            GeraLog("achou " A_LoopField)
            ClicaRandomDIreito(OutX, OutY, 3)
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


RetornaText(X, Y, W, H)
{
    hBitmap := HBitmapFromScreen(X, Y, W, H)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    text := StrReplace(ocr(pIRandomAccessStream), "`n","")
    return text 
}

ClicaRandom(X, Y, var)
{
    Random, rand, -var, var
    Random, rand2, -var, var
    MouseClick, left, X+rand, Y+rand2
}

ClicaRandomDireito(X, Y, var)
{
    Random, rand, -var, var
    Random, rand2, -var, var
    MouseClick, right, X+rand, Y+rand2
}