#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1
SetKeyDelay, 25, 25

global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15"
DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window

#Include, ocr.ahk
#include, utilitarios.ahk

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
        ImageSearch, OutX, OutY, 1439, 521, 1602, 865, *60 %a_scriptdir%\%A_LoopField%.png
        if !ErrorLevel
        {
            GeraLog("achou " A_LoopField)
            MouseClick, right, OutX, OutY
        }
    }
}