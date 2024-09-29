; 0.0.1

#SingleInstance Force
#MaxThreads 2
#Persistent ; (Interception hotkeys do not stop AHK from exiting, so use this)
#include Lib\AutoHotInterception.ahk
SetKeyDelay, 50, 50
#Include Lib\CaptureScreen.ahk
#Include Lib\funcoes.ahk
#Include Lib\FindClick.ahk
#include <FindText>
SendMode Input

global log := true

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window
global AchouOutX, AchouOutY
global Xjanela, Yjanela, Hjanela, Wjanela
FormatTime, InicioMacro, D1 T0



global optConta
global radMetin
global ChkExplorar
global ChkInf
global ChkMag
global ChkCav
global ChkCel
global ChkArq
global TInf
global TMag
global TCav
global TCel
global TArq

global ChkWood
global TWood
global ChkRock
global TRock


Gui Add, Radio, Checked voptConta x24 y8 w70 h23, Conta1
Gui Add, Radio, x152 y8 w70 h23, Conta2
Gui Add, CheckBox, Checked vChkExplorar x250 y8 w65 h23, Explorar
Gui Add, CheckBox, Checked vChkInf x24 y40 w40 h23, Inf
Gui, Add, DropDownList, vTInf x24 y63 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, Checked vChkMag x74 y40 w40 h23, Mag
Gui, Add, DropDownList, vTMag x74 y63 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, Checked vChkCav x124 y40 w40 h23, Cav
Gui, Add, DropDownList, vTCav x124 y63 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, vChkCel x174 y40 w40 h23, Cel
Gui, Add, DropDownList, vTCel x174 y63 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, vChkArq x224 y40 w40 h23, Arq
Gui, Add, DropDownList, vTArq x224 y63 w30 Choose1, 1|2|3|4|5


Gui Add, CheckBox, Checked vChkWood x24 y93 w50 h23, Wood
Gui, Add, DropDownList, vTWood x24 y118 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, Checked vChkRock x74 y93 w50 h23, Rock
Gui, Add, DropDownList, vTRock x74 y118 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, Checked vChkGold x124 y93 w40 h23, Gold
Gui, Add, DropDownList, vTGold x124 y118 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, vChkMana x174 y93 w50 h23, Mana
Gui, Add, DropDownList, vTMana x174 y118 w30 Choose1, 1|2|3|4|5
Gui Add, CheckBox, vChkGema x224 y93 w50 h23, Gema
Gui, Add, DropDownList, vTGema x224 y118 w30 Choose1, 1|2|3|4|5


Gui Add, Button, gInicio x23 y176 w80 h23, Start

PegaControles() {
	GuiControlGet, ChkExplorar
	Gui, Submit, NoHide
}

WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Call of Dragons
if (Xjanela = "") {
	GeraLog("CALL OF DRAGONS NÃO ESTAVA ABERTO")
}
WinActivate, Call of Dragons
Yjanela := Yjanela+30
Gui, Show, w329 h213, Window

8::Pause

0::ExitApp 
; -------- AUTO EXECUTE ---------;

GeraLog(msg) {
	if (!log)
		return
	FormatTime, DataFormatada, D1 T0
	FileRead,FileContents, %a_scriptdir%\codlog%optConta%.log
	FileDelete %a_scriptdir%\codlog%optConta%.log
	FileAppend, %DataFormatada% - %msg%`n%FileContents%,%a_scriptdir%\codlog%optConta%.log
	;FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\codlog%optConta%.log
	if ErrorLevel{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\codlog%optConta%.log
	}
}

Inicio:
PegaControles()
WinActivate, Call of Dragons
GeraLog("Começou")
loop, {
	Verifica()
}
return

9::
GeraLog("Entrou no teste.")
WinActivate, Call of Dragons
PegaControles()
Pedra()
GeraLog("Saiu do teste.")
return

7::
GeraLog("Entrou no teste.")
;WinActivate, Call of Dragons
PegaControles()
ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 150, "pan", 1000)
GeraLog("Saiu do teste.")
return

Verifica() {
	Explore()
	AjudaAlianca()
	Tropas()
	Madeira()
	Pedra()
}

Explore() {
	if (!ChkExplorar)
		return
	loop, 2 {
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "scout" . A_Index, 1000)) {
			GeraLog("Achou o scout")
			ClicaRandom(AchouOutX, AchouOutY)
			if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "scope", 1500)) {
				Tecla("a")
				if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "explore", 5000)) {
					GeraLog("Clicou pra explorar")
					ClicaRandom(AchouOutX, AchouOutY)
				}
				EsperaRandom(1000)
			}
		}
	}
}


MudaMapaRecursos() {
	SeguraTecla("LShift")
	Tecla("space")
	SoltaTecla("LShift")
	EsperaRandom(1000)
	ClicaRandom(1130, 728)
}


Tropas() {
	GeraLog("Faz tropas")
	if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "space", 1000)) {
		Tecla("Space")
		EsperaRandom(1000)
		Tecla("Space")
	} else
	{
		Tecla("Space")
		EsperaRandom(500)
	}
	tipos := "Inf,Mag,Cav,Cel,Arq"
	Loop, parse, tipos, `, 
	{
		tipoDaVez := "Chk" . A_LoopField
		NivelDaVez := "T"  . A_LoopField
		if (tipoDaVez) {
			if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 70, A_LoopField . %NivelDaVez%, 1000)) {
				GeraLog("Achou " A_LoopField . %NivelDaVez%)
				AuxX := AchouOutX
				AuxY := AchouOutY+50
				ClicaRandom(AuxX, AuxY)
				loop, 10 {
					if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "info", 200)) {
						ClicaRandom(AchouOutX+80, AchouOutY-40)
						ProcuraPixelAteAchar(1031, 699, "0xFFFFFF", 2000)
						X := 238 + (74 * %NivelDaVez%)
						Y := 693
						ClicaRandom(X, Y)
						EsperaRandom(300)
						ClicaRandom(936, 685)
						break
					}
					else {
						ClicaRandom(AuxX, AuxY)
					}
				}
				
			}
		}
	}
	GeraLog("Terminou faz tropas.")
}

AjudaAlianca() {
	if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "help", 300)) {
		GeraLog("Ajudou a aliança.")
		ClicaRandom(AchouOutX, AchouOutY)
	}
}


Coletar() {

}


Madeira() {
	if (!ChkWood)
		return
	if (!ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 70, "pan", 1000)) {
		GeraLog("Vai colocar madeira.")
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "space", 1000)) {
			Tecla("Space")
			EsperaRandom(500)
		} else
		{
			Tecla("Space")
			EsperaRandom(1000)
			Tecla("Space")
		}
		EsperaRandom(1000)
		Tecla("F")
		EsperaRandom(500)
		ClicaRandom(643, 771)
		EsperaRandom(500)
		Loop, 6 {
			ClicaRandom(552, 643)
			EsperaRandom(100)
		}
		ClicaRandom(646, 695)
		EsperaRandom(1000)
		ClicaRandom(647, 430)
		EsperaRandom(500)
		ClicaRandom(845, 550)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "legion", 2000)) {
			ClicaRandom(AchouOutX, AchouOutY)
			EsperaRandom(1500)
			ClicaRandom(1060, 334)
			EsperaRandom(500)
			ClicaRandom(856, 334)
			EsperaRandom(500)
			ClicaRandom(944, 699)
			GeraLog("Colocou a madeira.")
		}
	}
}


Pedra() {
	if (!ChkRock)
		return
	if (!ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 70, "chak", 1000)) {
		GeraLog("Vai colocar pedra.")
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "space", 1000)) {
			Tecla("Space")
			EsperaRandom(500)
		} else
		{
			Tecla("Space")
			EsperaRandom(1000)
			Tecla("Space")
		}
		EsperaRandom(1000)
		Tecla("F")
		EsperaRandom(500)
		ClicaRandom(795, 783)
		EsperaRandom(500)
		Loop, 6 {
			ClicaRandom(700, 641)
			EsperaRandom(100)
		}
		ClicaRandom(799, 701)
		EsperaRandom(1000)
		ClicaRandom(647, 430)
		EsperaRandom(500)
		ClicaRandom(845, 550)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "legion", 2000)) {
			ClicaRandom(AchouOutX, AchouOutY)
			EsperaRandom(1500)
			ClicaRandom(1060, 334)
			EsperaRandom(500)
			ClicaRandom(892, 338)
			EsperaRandom(500)
			ClicaRandom(944, 699)
			GeraLog("Colocou a pedra.")
		}
	}
}