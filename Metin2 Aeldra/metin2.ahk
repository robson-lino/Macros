; 2.0.1

#SingleInstance Force
#MaxThreads 2
#Persistent ; (Interception hotkeys do not stop AHK from exiting, so use this)
#include Lib\AutoHotInterception.ahk
SetKeyDelay, 50, 50
#Include %A_LineFile%\..\JSON.ahk
#Include Lib\CaptureScreen.ahk
#Include Lib\funcoes.ahk
#Include Lib\FindClick.ahk
SendMode Input

OnExit("ExitFunc")

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window
global itensCaptcha := "pedra,escudo,peixe,colar,deus,elmo,armadura,arma,pulseira,orvalho,pocao,brincos,sapatos"
global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25"
global p := 1
global AchouOutX, AchouOutY
global Xjanela, Yjanela, Hjanela, Wjanela
global tickVerVara := A_TickCount - 600000
global qntMetin := 0
Global CanalAtual := 0
Global Tempo := ""
global InicioMacro
global FimMacro := ""
global PrimeiraPasadaImprime := true
global BaronesaDeuErro := false
global DragaoDeuErro := false
global TorreDeuErro := false
global NemereDeuErro := false
global RazadorDeuErro := false
global ErebusDeuErro := false
global AkzadurDeuErro := false
global BaronesaPOS
global DragaoPOS
global TorrePOS
global NemerePOS
global RazadorPOS
global ErebusPOS
global AkzadurPOS
global AbaInv := 0
global ItemInvOutX, ItemInvOutY
global listaCordPedras
global tempoDeNaoEssenciais := MinToMili(15)
global tempoDeVerificaDG := MinToMili(5)
global ultimaVerificaNaoEssenciais := A_TickCount - MinToMili(13)
global ultimaVerificaBossDG := A_TickCount - MinToMili(3)
global Aviso := true
global EstaFazendoDG := false
global qntBaronesa := 0
global qntTorre := 0
global qntDragao := 0
global qntNemere := 0
global qntRazador := 0
global qntErebus:= 0
global qntAkzadur:= 0
global qntTravado := 0
global qntTravadoTotal := 0
global tempoMatarPedra := 0
global tickInicioMacro := A_TickCount
global informacoesAnteriores
global captcharesolvido := 0
global ClicaX, ClicaY
global tempoTotalDG := 0
global deslogou := false
global varMetin
global qntVezesPassadas := 0
global log := false
global EstaTransfigurado
global TipoTransmog := ""
FormatTime, InicioMacro, D1 T0

;variaveis de entrada
global optConta
global optMetin := 1
global optDG
global optNV
;InputBox, optConta, Qual conta?, 1 ou 2, , 256, 128
;InputBox, optMetin, Volta pra qual metin?, 1:retorno 2:45 3:70, , 256, 128
;InputBox, optDG, Quais DGs?, 0 = nenhuma, , 256, 128
;InputBox, optNV, Qual NV?,Da metin que ta matando, , 256, 128

global optConta
global radMetin
global ChkUpar
global ChkBaronesa
global ChkTorre
global ChkDragao
global ChkNemere
global ChkRazador
global ChkErebus
global ChkAkzadur

Gui Add, Radio, voptConta x24 y8 w70 h23, Conta1
Gui Add, Radio, x152 y8 w70 h23, Conta2
Gui Add, CheckBox, vChkUpar x250 y8 w65 h23, Upar
Gui Add, Button, gInicio x23 y142 w80 h23, Start
Gui Add, Radio, vradMetin x24 y40 w36 h23, 65
Gui Add, Radio, x71 y40 w36 h23, 70
Gui Add, Radio, x119 y40 w36 h23, 90
Gui Add, Radio, x167 y40 w36 h23, 105
Gui Add, CheckBox, vChkBaronesa x24 y80 w65 h23, Baronesa
Gui Add, CheckBox, vChkTorre x96 y80 w65 h23, Torre
Gui Add, CheckBox, vChkDragao x168 y80 w65 h23, Dragao
Gui Add, CheckBox, vChkNemere x240 y80 w65 h23, Nemere
Gui Add, CheckBox, vChkRazador x24 y112 w65 h23, Razador
Gui Add, CheckBox, vChkErebus x96 y112 w65 h23, Erebus
Gui Add, CheckBox, vChkAkzadur x168 y112 w65 h23, Akzadur

PegaControles() {
	GuiControlGet, ChkUpar
	GuiControlGet, radMetin
	GuiControlGet, ChkBaronesa
	GuiControlGet, ChkTorre
	GuiControlGet, ChkDragao
	GuiControlGet, ChkNemere
	GuiControlGet, ChkRazador
	GuiControlGet, ChkErebus
	GuiControlGet, ChkAkzadur
	Gui, Submit, NoHide
	if (radMetin = 1) {
		optNV := 65
	} else if (radMetin = 2) {
		optNV := 70
	} else if (radMetin = 3) {
		optNV := 90
	} else if (radMetin = 4) {
		optNV := 105
	}
	if (optConta = 1) {
		BaronesaPOS := 99
		DragaoPOS := 1
		TorrePOS := 99
		NemerePOS := 2
		RazadorPOS := 3
		ErebusPOS := 4
		AkzadurPOS := 5
	} else if (optConta = 2) {
		BaronesaPOS := 1
		DragaoPOS := 3
		TorrePOS := 2
		NemerePOS := 99
		RazadorPOS := 99
		ErebusPOS := 99
		AkzadurPOS := 99
	}
	if (optNV = 70)
		varMetin := 25
	else if (optNV = 90)
		varMetin := 18
	else if (optNV = 65)
		varMetin := 15
	else if (optNV = 105)
		varMetin := 12

	;else if (optNV = 90)
	;	varMetin := 13
}

WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Aeldra.to - Zeta
if (Xjanela = "") {
	GeraLog("METIN NÃO ESTAVA ABERTO")
	JogoAberto()
}
WinActivate, Aeldra.to
Yjanela := Yjanela+30
Gui Show, w329 h181, Window
SetTimer PegaItens, 700, ON, 3

; -------- AUTO EXECUTE ---------;

ZoomPraMatarPedra() {
	if (optNV = 90)
		ArrumaMapaCamera0Zoom()
	else if (optNV = 70)
		ArrumaMapaCamera2Zoom()
	else if (optNV = 65)
		ArrumaMapaCamera1Zoom()
	else if (optNV = 105)
		ArrumaMapaCamera1Zoom()
}

8::Pause

ExitFunc() {
	GeraLog("Encerrou")
	FormatTime, FimMacro, D1 T0
	ImprimeInfos()
}

TaDeslogado() {
	Ativa()
	if (RetornaCorPixel(1538, 446) = "0xB281AD") {
		GeraLog("Estava no Aeldra, meu deus.")
		ClicaRandom(756, 305)
		EsperaRandom(300)
		ClicaRandom(788, 453)
		EsperaRandom(15000)
		Ativa()
		TaDeslogado()
	}
	if (RetornaCorPixel(861, 72) = "0x6482AC" or RetornaCorPixel(168, 608) = "0x3A9B00") {
		GeraLog("Estava deslogado")
		Tecla("F" . optConta)
		EsperaRandom(5000)
		ProcuraPixelAteAchar(168, 608, "0x3A9B00", 30000)
		Tecla("NumpadEnter")
		ProcuraPixelAteAchar(1093, 844, "0x1F2224", 30000)
		Sleep, 1000
		deslogou := true
		ZoomPraMatarPedra()
	}
}

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

ImprimeInfos() {
	Msg := ""
	file := FileOpen("metininfos" optConta ".log", "w")
	Msg := Msg . "Iniciado em: " . InicioMacro . "`r`n"
	Msg := Msg . "Informações da Conta: " . optConta . "`r`n"
	Msg := Msg . "Metins: " . qntMetin . "`r`n"
	Msg := Msg . "Metins por minuto: " . (qntMetin * 60000) / ((A_TickCount - tickInicioMacro) - tempoTotalDG) . "`r`n"
	Msg := Msg . "Baronesa: " . qntBaronesa . "`r`n"
	Msg := Msg . "Torre: " . qntTorre . "`r`n"
	Msg := Msg . "Dragao: " . qntDragao . "`r`n"
	Msg := Msg . "Nemere: " . qntNemere . "`r`n"
	Msg := Msg . "Razador: " . qntRazador . "`r`n"
	Msg := Msg . "Erebus: " . qntErebus . "`r`n"
	Msg := Msg . "Akzadur: " . qntAkzadur . "`r`n"
	Msg := Msg . "Tempo total em DG: " . FormataMilisegundos(tempoTotalDG) . "`r`n"
	Msg := Msg . "QntTravadas: " . qntTravadoTotal . "`r`n"
	Msg := Msg . "Captcha resolvido: " . captcharesolvido . "`r`n"
	Msg := Msg . "Encerrado em: " . FimMacro . "`r`n"
	Msg := Msg . "-------------------------------------------`r`n"
	Msg := Msg . informacoesAnteriores
	file.Write(Msg)
	file.Close()
}

Player() {
	loop, 4 {
		ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *30 %a_scriptdir%\player%A_index%.png
		if !ErrorLevel {
			GeraLog("Encontrou algum jogador, vai pro proximo canal.")
			ProximoCanal()
			Sleep, 10000
			return
		}
	}
}

5::
Inicio:
PegaControles()
EsperaRandom(1000)
WinActivate, Aeldra
FileRead, informacoesAnteriores, metininfos%optConta%.log
;SetTimer PegaItens, off
ClicaRandomDireito(824, 299)
Verifica()
ZoomPraMatarPedra()
tickInicioMacro := A_TickCount
qntMetin := 0
loop, {
	Tempo := A_TickCount
	Player()
	if (qntTravado >= 3) {
		qntTravado := 0
		GeraLog("Voltou por que estava travado.")
		VoltaPraQuebrarMetin()
	}
	if (MataPedraMaisPerto()){
		EsperaMatar()
	} else {
		Verifica()
		qntTravado++
		qntTravadoTotal++
		if (qntTravado > 6)
			GeraLog("Não achou nenhuma metin na tela, travado: " qntTravado)
		;GeraLog("Girou")
		GiraAteAcharMetin()
		VaiAteMetin()
	}
}
return

EsperaMatar() {
	Achou := true
	SetTimer PegaItens, off
	jaEntrou := false
	SeguraTecla("e")
	if (ProcuraAteAchar(687, 389, 856, 488, 50, "metinpedra", 5000)) {
		ImprimeInfos()
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		Verifica()
		SeguraTecla("Space")
		tempoMatarPedra := A_TickCount
		if (!jaEntrou and optNV != "" and !EstaFazendoDG){
			jaEntrou := true
			CimaMetin(optNV)
		}
		while (!PegaItensDaMetin()) {
			GeraLog("Matando a metin...")
			if (A_index > 1) {
				Tecla("3")
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vida.png
				if ErrorLevel {
					GeraLog("Saiu pela a vida")
					Verifica()
					Achou := PegaItens()
					break
				}
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vidacheia.png
				if !ErrorLevel {
					GeraLog("Saiu pela a vida cheia")
					Verifica()
					Achou := PegaItens()
					break
				}
			}
			Verifica()
		}
		if (!Achou) {
			qntTravado++
			qntTravadoTotal++
			PegaItens()
			GeraLog("Nao achou, travado: " qntTravado)
			SoltaTecla("Space")
			;ClicaRandom(807, 447, 15)
			Tecla("d", 500)
			Tecla("s", 300)
		} else {
			SoltaTecla("Space")
		}
	} else {
		qntTravado++
		qntTravadoTotal++
		GeraLog("Não conseguiu chegar perto da metin, travado: " qntTravado)
		SoltaTecla("e")
		Verifica()
		Tecla("d", 500)
		Tecla("s", 300)
		GiraAteAcharMetin()
		VaiAteMetin()
	}
	SetTimer PegaItens, 500, ON, 3
}

Verifica() {
	;Inicio := A_TickCount
	JogoAberto()
	Ativa()
	TaDeslogado()
	Morto()
	;TiraQuests()
	Mensagens()
	Biologo()
	AtivaSkill()
	ForaDoCavalo()
	if (!ChkUpar)
		AnelXP()
	CaptchaMaldito()
	VerificaNaoEssenciais()
	if (!EstaFazendoDG) {
		VerificaBossDGs()
		if (Transfigurado())
			SaiDaTransmog()
	} else {
		if (TipoTransmog != "" and !Transfigurado()) {
			GeraLog("Estava fazendo DG que precisa de transmog mas não estava com Transmog.")
			Transmog(TipoTransmog)
		} else if (Transfigurado() and TipoTransmog = "") {
			GeraLog("Estava fazendo DG que não precisa de transmog, mas estava com a Transmog.")
			SaiDaTransmog()
		}
	}
	FechaX()
	;GeraLog("Tempo: " A_TickCount - Inicio)
}

VerificaNaoEssenciais() {
	if ((A_tickcount - ultimaVerificaNaoEssenciais) > tempoDeNaoEssenciais) {
		GeraLog("Entrou não essenciais.")
		AvisoNaoEssenciais := true
		ultimaVerificaNaoEssenciais := A_tickcount
		EquipaLuva()
		Tecla("2")
		EsperaRandom(500)
		Tecla("2")
		ForaDoCavalo()
		ClicaRandom(1481, 131)
		EsperaRandom(500)
		MoveMouse(1393, 483)
		Biologo()
		if (ChkUpar)
			EquipaAnel()
	} else {
		if (tempoDeNaoEssenciais-((A_tickcount - ultimaVerificaNaoEssenciais)) < MinToMili(2) and AvisoNaoEssenciais) {
			GeraLog("Faltam menos de 3 minutos para fazer as DGs")
			AvisoNaoEssenciais := false
		}
	}
}

VerificaBossDGs() {
	;GeraLog("Entrando no VerificaBossDGs")
	;GeraLog(A_tickcount - ultimaVerificaBossDG " > " MinToMili(10))
	if ((A_tickcount - ultimaVerificaBossDG) > tempoDeVerificaDG) {
		GeraLog("Entrou no FazDG")
		ultimaVerificaBossDG := A_tickcount
		Aviso := true
		FazDGs()
	} else {
		GeraLog("Não deu o tempo do verifica DG.")
		if (tempoDeVerificaDG-((A_tickcount - ultimaVerificaBossDG)) < MinToMili(2) and Aviso) {
			;GeraLog("Faltam menos de 2 minutos para fazer as DGs")
			Aviso := false
		}
	}
}

fY(y)
{
	if (y < 150)
	{
		return 50
	}
	else if (y >= 150 && y <= 900)
	{
		return -50 * (y - 600) // 600
	}
	else
	{
		return 0
	}
}

fX(x)
{
	if (x < 500)
	{
		return 60
	}
	else if (x <= 850)
	{
		return 40
	} else if (x > 850 and x <= 1000) {
		return 5
	} else if (x > 1000 and x <= 1250) {
		return -5
	} else if (x > 1250) {
		return -30
	}
}

0::
log := !log
return

9::
log := true
SetTimer PegaItens, off
PegaControles()
;MataPedraMaisPerto()
;CimaMetin(optNV)
;ClicaRandom(1808, 447, 3)
;GiraAteAcharMetin()
;VaiAteMetin()
;Baronesa()
;GeraLog("Baronesa: " RetornaCorPixel(792, 307))
;GeraLog("Torre: " RetornaCorPixel(731, 345))
;GeraLog("Dragao: " RetornaCorPixel(736, 458))
;FazDGs()
;log := true
;TestaMira()
;CimaMetin(optNV)
;Upar()
;EstaFazendoDG := true
TipoTransmog := ""
SaiDaTransmog()
;RazadorAmheh()
Return

VaiAteMetin() {
	PegaItens()
	GeraLog("Andando até metin...")
	ClicaRandom(789, 182)
	if (ProcuraAteAchar(678, 339, 919, 514, 50, "metinpedra", 3000)) {
		ClicaRandom(808, 447, 1)
		return
	}
	Else {
		if (ProcuraAteAchar(Xjanela, Yjanela-60, Wjanela-80, Hjanela, 50, "metinpedra", 100))
			return
		;SoltaTecla("w")
		Tecla("d", 500)
		SeguraTecla("e")
		Sleep, 150
		SoltaTecla("e")
		return
	}
	;SoltaTecla("w")
}

GiraAteAcharMetin() {
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 *TransRed %a_scriptdir%\lendaria.png
	if !ErrorLevel {
		SeguraTecla("e")
		GeraLog("Achou metin lendaria")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "lendaria1", 4000)) {
			;GeraLog("Achou")
			Sleep, 320
			SoltaTecla("e")
			return
		}
	} else {
		ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 *TransRed %a_scriptdir%\rara.png
		if !ErrorLevel {
			SeguraTecla("e")
			GeraLog("Achou metin rara")
			if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "rara1", 4000)) {
				Sleep, 320
				SoltaTecla("e")
				return
			}
		} else {
			ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 *TransRed %a_scriptdir%\mapametin2.png
			if ErrorLevel {
				SeguraTecla("e")
				if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "mapametin2", 4000)) {
					;GeraLog("Achou")
					ImageSearch, OutX, OutY, Xjanela, Yjanela-60, Wjanela-80, Hjanela, *30 *TransRed %a_scriptdir%\metinpedra.png
					if !ErrorLevel
					{
						Sleep, 320
						SoltaTecla("e")
						Verifica()
						return
					}
					Sleep, 320
					SoltaTecla("e")
					Verifica()
					return
				}
			}
		}
	}
	SoltaTecla("e")
}

MataPedra() {
	CaptchaMaldito()
	ImageSearch, OutX, OutY, Xjanela, Yjanela-60, Wjanela-80, Hjanela, *30 *TransRed %a_scriptdir%\metinpedra.png
	if !ErrorLevel
	{
		;GeraLog("Mata normal")
		ClicaRandom(OutX+fX(OutX), OutY+fY(OutY), 5)
		return true
	}
	return false
}

MataPedraPequeno() {
	CaptchaMaldito()
	ImageSearch, OutX, OutY, 531, 268, 992, 586, *30 *TransRed %a_scriptdir%\metinpedra.png
	if !ErrorLevel
	{
		;GeraLog("Mata pequeno")
		ClicaRandom(OutX+fX(OutX), OutY+fY(OutY), 5)
		return true
	}
	return false
}

MataPedraMaisPerto(qntVezesPassadas := 0) {
	Inicio := A_TickCount
	CaptchaMaldito()
	GeraLog("Depois do Catpcha: " A_TickCount - Inicio)
	;Options = r oTransRed,29 e1 n
	Options = r x-11 y-4 oTransRed,1 e0.1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
	if (CoordMaisProxima[1] != 0 and CoordMaisProxima[1] != "") {
		;GeraLog("Achou com Distancia Euclidiana.")
		x := CoordMaisProxima[1]
		y := CoordMaisProxima[2]
		;PegaItens()
		ClicaRandom(x+fX(x), y+fY(y), 0, 70)
		GeraLog("Clicou: " A_TickCount - Inicio)
		return true
	} else if (qntVezesPassadas < 2 and optNV != ""){
		qntVezesPassadas++
		SeguraTecla("e")
		EsperaRandom(300)
		SoltaTecla("e")
		EsperaRandom(500)
		GeraLog("Não achou metin mais perto: " qntVezesPassadas)
		CimaMetin(optNV)
		return MataPedraMaisPerto(qntVezesPassadas)
	} else {
		GeraLog("Em branco ou " qntVezesPassadas " passada, anda até metin.")
		qntVezesPassadas := 0
	}
	return false
}

PegaItens() {
	Inicio := A_TickCount
	ImageSearch, OutX, OutY, 701, 359, 957, 818, *90 *TransRed %a_scriptdir%\itemchao.png
	if !ErrorLevel{
		loop, 2 {
			ImageSearch, OutX, OutY, 701, 359, 957, 818, *50 *TransRed %a_scriptdir%\itempedra%A_index%.png
			if !ErrorLevel {
				while (ProcuraAteAchar(701, 359, 957, 818, 90, "itemchao", 150)) {
					Tecla("z")
					if (A_index > 20) {
						if (A_index < 23){
							SoltaTecla("Space")
						}
						ClicaRandom(AchouOutX, AchouOutY)
					}
				}
				;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
				GeraLog("Matou a metin em: " FormataMilisegundos(A_TickCount - tempoMatarPedra))
				if (!EstaFazendoDG)
					qntMetin++
				ImprimeInfos()
				return true
			}
		}
		;GeraLog("Pegou itemchao e demorou " A_TickCount - Inicio)
		while (ProcuraAteAchar(701, 359, 957, 818, 90, "itemchao", 150)) {
			Tecla("z")
			if (A_index > 20) {
				if (A_index < 23){
					SoltaTecla("Space")
				}
				ClicaRandom(AchouOutX, AchouOutY)
			}
		}
		return false
	}
}

PegaItensDaMetin() {
	Inicio := A_TickCount
	;ImageSearch, OutX, OutY, 701, 359, 957, 818, *40 *TransRed %a_scriptdir%\itemchao.png
	if (ProcuraAteAchar(701, 359, 957, 818, 90, "itemchao", 1000)) {
		loop, 2 {
			ImageSearch, OutX, OutY, 701, 359, 957, 818, *50 *TransRed %a_scriptdir%\itempedra%A_index%.png
			if !ErrorLevel {
				while (ProcuraAteAchar(701, 359, 957, 818, 90, "itemchao", 150)) {
					Tecla("z")
					GeraLog("Pegando itens...")
					if (A_index > 20) {
						if (A_index < 23){
							SoltaTecla("Space")
						}
						ClicaRandom(AchouOutX, AchouOutY)
					}
				}
				;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
				GeraLog("Matou a metin em " FormataMilisegundos(A_TickCount - tempoMatarPedra))
				if (!EstaFazendoDG)
					qntMetin++
				qntTravado := 0
				return true
			}
		}

	}
	return false
}

AtivaSkill() {
	ImageSearch, OutX, OutY, 9, 38, 389, 112, *60 *TransRed %a_scriptdir%\furia.png
	if ErrorLevel{
		EsperaRandom(300)
		SaiEntraCavalo()
		EsperaRandom(300)
		Tecla("F3")
		Tecla("F3")
		EsperaRandom(300)
		SaiEntraCavalo()
		SaiEntraCavalo()
		EsperaRandom(300)
		Tecla("F4")
		Tecla("F4")
		EsperaRandom(300)
		SaiEntraCavalo()
		ForaDoCavalo()
	}
}

Mensagens() {
	ImageSearch, OutX, OutY, 607, 293, 1036, 671, *60 *TransRed %a_scriptdir%\ok.png
	if !ErrorLevel{
		ClicaRandom(OutX, OutY)
	}
	ImageSearch, OutX, OutY, 607, 293, 1036, 671, *60 *TransRed %a_scriptdir%\nao.png
	if !ErrorLevel{
		ClicaRandom(OutX, OutY)
	}
}

SaiEntraCavalo() {
	EsperaRandom(150)
	SeguraTecla("LControl", 60)
	EsperaRandom(150)
	Tecla("h", 60)
	EsperaRandom(150)
	SoltaTecla("LControl", 60)
	EsperaRandom(150)
}

CaptchaMaldito() {
	Inicio := A_TickCount
	NaoSaiu := false
	ImageSearch, OutX, OutY, 408, 188, 1200, 623, *70 *TransRed %a_scriptdir%\bot.png
	if !ErrorLevel{
		ClicaX := OutX
		ClicaY := OutY
		GeraLog("Captcha maldito")
		EsperaRandom(2000)
		ClicaRandomDireito(1524, 174, 5, 1)
		; Tenta resolver captcha.
		; Pedra Espirita
		if (TentaResolverCaptcha()) {
			captcharesolvido++
			GeraLog("Captcha resolvido caralhooo!")
			; clica pra tentar resolver se não conseguiu...
			ClicaRandom(ClicaX, ClicaY+100, 25)
			EsperaRandom(3000)
			return
		} else {
			SoltaTecla("Space")
			while (ProcuraAteAchar(408, 188, 1200, 623, 70, "bot", 500)) {
				SoundBeep, 300, 1000
				if (A_Index > 60) {
					NaoSaiu := true
					Break
				}
			}
			if (NaoSaiu) {
				GeraLog("Não saiu, reloga")
				ClicaRandom(1581, 841)
				Sleep, 100
				loop, 3 {
					ClicaRandom(808, 439)
				}
				while (!ProcuraPixelAteAchar(231, 255, "0x131518", 5000)) {
					Ativa()
					ClicaRandom(1581, 841)
					Sleep, 100
					loop, 15 {
						ClicaRandom(808, 439)
					}
				}
				Tecla("NumpadEnter")
				ProcuraPixelAteAchar(1093, 844, "0x1F2224", 30000)
				Sleep, 1000
				ZoomPraMatarPedra()
			}
		}
	}
	;GeraLog("Captcha Maldito: " A_TickCount - Inicio)
}

TentaResolverCaptcha() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *70 *TransRed %a_scriptdir%\bot.png
	if !ErrorLevel{
		Random, qntVezes, 2, 7
		loop, %qntVezes% {
			Loop, parse, itensCaptcha, `,
			{
				ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\captchas\%A_LoopField%.png
				if !ErrorLevel {
					GeraLog("Achou a palavra " A_LoopField)
					MoveMouse(OutX, OutY)
					loop, 20 {
						ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\captchas\%A_LoopField%%A_Index%.png
						if !ErrorLevel {
							ClicaRandom(OutX, OutY)
							GeraLog("Achou com o "A_LoopField A_Index)
							return true
						}
					}
				}
			}
			GeraLog("Não resolveu o captcha, precisa fazer novo print.")
			CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/captchas/" A_now ".png")
			ClicaRandom(ClicaX, ClicaY+150, 25)
			EsperaRandom(2000)
			ClicaRandomDireito(1524, 174, 5, 1)
		}
	}
	return false
}

TestaResolverCaptcha() {
	SetTimer PegaItens, off
	WinActivate, 2023
	Xjanela := 14
	Yjanela := 183
	Wjanela := 1612
	Hjanela := 1024
	Random, qntVezes, 2, 7
	loop, %qntVezes% {
		Loop, parse, itensCaptcha, `,
		{
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\captchas\%A_LoopField%.png
			if !ErrorLevel {
				ClicaX := OutX
				ClicaY := OutY
				GeraLog("Achou a palavra " A_LoopField)
				MoveMouse(OutX, OutY)
				loop, 20 {
					ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\captchas\%A_LoopField%%A_Index%.png
					if !ErrorLevel {
						ClicaRandom(OutX, OutY)
						GeraLog("Achou com o "A_LoopField A_Index)
						return true
					}
				}
			}
		}
		ClicaRandom(ClicaX, ClicaY+70, 25)
	}
	return false
}

ArrumaMapaCamera1Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	SeguraTecla("f")
	EsperaRandom(1500)
	SoltaTecla("f")
	EsperaRandom(200)
	SeguraTecla("g")
	EsperaRandom(1500)
	SoltaTecla("g")
	EsperaRandom(200)
	GeraLog("ArrumaMapaCamera1Zoom")
}

ArrumaMapaCamera2Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	SeguraTecla("f")
	EsperaRandom(1500)
	SoltaTecla("f")
	SeguraTecla("g")
	EsperaRandom(1500)
	SoltaTecla("g")
	EsperaRandom(200)
	GeraLog("ArrumaMapaCamera2Zoom")
}

ArrumaMapaCamera0Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	EsperaRandom(200)
	SeguraTecla("f")
	EsperaRandom(1500)
	SoltaTecla("f")
	SeguraTecla("g")
	EsperaRandom(1500)
	SoltaTecla("g")
	EsperaRandom(200)
	GeraLog("ArrumaMapaCamera0Zoom")
}

ArrumaMapa0Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	EsperaRandom(200)
	GeraLog("ArrumaMapa0Zoom")
}

ArrumaMapa1Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	GeraLog("ArrumaMapa1Zoom")
}

ArrumaMapa2Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	GeraLog("ArrumaMapa2Zoom")
}

ArrumaMapa3Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd", 70)
		EsperaRandom(200)
	}
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	Tecla("NumpadSub", 70)
	EsperaRandom(200)
	GeraLog("ArrumaMapa3Zoom")
}

Biologo() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\biologo.png
	if !ErrorLevel{
		GeraLog("Achou janela biologo")
		while (!ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "esperar", 500)) {
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *50 *TransRed %a_scriptdir%\biologo.png
			if ErrorLevel
				break
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 %a_scriptdir%\entregar.png
			if !ErrorLevel{
				ClicaRandom(OutX, OutY)
				EsperaRandom(350)
			}
			if (A_Index > 10) {
				FechaX()
				return
			}
		}
		FechaX()
	}
}

TiraQuests() {
	ImageSearch, OutX, OutY, 15, 284, 255, 776, *60 %a_scriptdir%\quests.png
	if !ErrorLevel {
		GeraLog("Tirou as quests")
		EsperaRandom(150)
		SeguraTecla("LControl", 60)
		EsperaRandom(150)
		Tecla("q", 60)
		EsperaRandom(150)
		SoltaTecla("LControl", 60)
		EsperaRandom(150)
	}
}

Morto()
{
	loop, 2 {
		ImageSearch, OutX, OutY, 70, 99, 248, 122, *60 %a_scriptdir%\recomecar%A_index%.png
		if !ErrorLevel {
			GeraLog("Estava morto")
			ClicaRandom(OutX, OutY)
			ProcuraPixelAteAchar(211, 113, "0x555555", 5000)
			SaiEntraCavalo()
			return true
		}
	}
}

Ativa() {
	WinActivate, Aeldra
	;ClicaRandomDireito(1524, 174, 5, 1)
}

ForaDoCavalo() {
	if (!ProcuraAteAchar(750, 825, 786, 857, 40, "brilho", 100)) {
		if (!ProcuraAteAchar(750, 825, 786, 857, 40, "brilho", 500)) {
			Tecla("2")
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\boris.png
			if !ErrorLevel {
				GeraLog("Fora do cavalo.")
				SaiEntraCavalo()
				return true
			}
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\mount.png
			if !ErrorLevel {
				GeraLog("Fora do cavalo.")
				SaiEntraCavalo()
				return true
			}
		}
	}
	;Inicio := A_TickCount
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\boris.png
	if !ErrorLevel {
		GeraLog("Fora do cavalo.")
		SaiEntraCavalo()
		return true
	}
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\mount.png
	if !ErrorLevel {
		GeraLog("Fora do cavalo.")
		SaiEntraCavalo()
		return true
	}
	;GeraLog("Fora do Cavalo: " A_TickCount - Inicio)
	return false
}

FechaX() {
	Inicio := A_TickCount
	loop, 2 {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 *TransRed %a_scriptdir%\xjanela%A_index%.png
		if !ErrorLevel {
			ClicaRandom(OutX+15, OutY+5)
		}
	}
	ImageSearch, OutX, OutY, 704, 297, 903, 593, *30 %a_scriptdir%\cancelar.png
	if !ErrorLevel {
		ClicaRandom(OutX+15, OutY+5)
	}
	;GeraLog("X: " A_TickCount - Inicio)
}

AnelXP() {
	ImageSearch, OutX, OutY, 264, 825, 295, 859, *30 %a_scriptdir%\anelxp.png
	if !ErrorLevel {
		GeraLog("ANEL XP")
		ClicaRandom(OutX+7, OutY+7)
	}
}

ProximoCanal() {
	CanalAtual++
	if (CanalAtual = 8)
		CanalAtual := 0
	if (!VaiCanal(CanalAtual)) {
		ProximoCanal()
	}
}
#IfWinActive Aeldra
^Numpad0::
ProximoCanal()
return

#IfWinActive Aeldra
^Numpad1::
VaiCanal(1)
return

#IfWinActive Aeldra
^Numpad2::
VaiCanal(2)
return

#IfWinActive Aeldra
^Numpad3::
VaiCanal(3)
return

#IfWinActive Aeldra
^Numpad4::
VaiCanal(4)
return

#IfWinActive Aeldra
^Numpad5::
VaiCanal(5)
return

#IfWinActive Aeldra
^Numpad6::
VaiCanal(6)
return

#IfWinActive Aeldra
^Numpad7::
VaiCanal(7)
return

#IfWinActive Aeldra
^Numpad8::
VaiCanal(8)
return

VaiCanal(canal) {
	GeraLog("Tentando trocar de canal para o " canal)
	SeguraTecla("Escape")
	Tecla("F" . canal)
	SoltaTecla("Escape")
	Tecla("Escape")
	if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
		CanalAtual := canal
		GeraLog("Foi pro Canal " CanalAtual " e Esta carregando...")
		Sleep, 2000
		loop, 3 {
			FechaX()
		}
		return true
	}
	else {
		GeraLog("Falhou em trocar para o canal " canal)
		return false
	}
}

VoltaPraQuebrarMetin() {
	Verifica()
	if (optMetin = 1) {
		if (!ProcuraItemInventario("pergaitem")) {
			if (!ProcuraItemInventario("pergaitem")) {
				VaiPraCidadeRed()
				VoltaPraQuebrarMetin()
			}
		}
		Sleep, 500
		ClicaRandomDireito(1445, 509)
		if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 15000)) {
			GeraLog("Esta carregando...")
			Sleep, 5000
			loop, 15 {
				SeguraTecla("LAlt", 150)
				Tecla("4")
				SoltaTecla("LAlt", 150)
				ImageSearch, OutX, OutY, 1213, 34, 1605, 859, *30 *TransRed %a_scriptdir%\perga.png
				if !ErrorLevel {
					break
				}
				Sleep, 3000
			}
		}
		else {
			VaiPraCidadeRed()
			VoltaPraQuebrarMetin()
		}
		GeraLog("Voltou pra quebrar metin")
	} else if (optMetin = 2) {
		Tecla("4")
		EsperaRandom(1000)
		ClicaRandom(807, 589)
		EsperaRandom(1000)
		ClicaRandom(805, 555)
		if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 15000)) {
			GeraLog("Achou o loading")
			EsperaRandom(10000)
			GeraLog("Voltou pra quebrar metin")
		} else {
			VaiPraCidadeRed()
			VoltaPraQuebrarMetin()
		}
	} else if (optMetin = 3) {
		Tecla("4")
		EsperaRandom(1000)
		ClicaRandom(940, 469)
		EsperaRandom(1000)
		ClicaRandom(798, 525)
		EsperaRandom(1000)
		ClicaRandom(800, 498)
		if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 15000)) {
			GeraLog("Achou o loading")
			EsperaRandom(10000)
			GeraLog("Voltou pra quebrar metin")
		} else {
			VaiPraCidadeRed()
			VoltaPraQuebrarMetin()
		}
	}

}

FazDGs() {
	PegaControles()
	EstaFazendoDG := true
	FezAlgum := 0
	deslogou := false
	log := true
	if (ChkBaronesa)
		FezAlgum += Baronesa()
	if (ChkTorre)
		FezAlgum += Torre()
	if (ChkDragao)
		FezAlgum += Dragao()
	if (ChkNemere)
		FezAlgum += Nemere()
	if (ChkRazador)
		FezAlgum += Razador()
	if (ChkErebus) {
		FezAlgum += Erebus()
	}
	EstaFazendoDG := false
	log := false
	if (FezAlgum > 0) {
		VaiPraCidadeRed()
		VoltaPraQuebrarMetin()
	} else {
		FechaX()
	}
	return
}
; COMEÇO EREBUS

Erebus() {
	Inicio := A_TickCount
	ErebusDeuErro := false
	Ativa()
	if (PodeEntrarDG(ErebusPOS)) {
		GeraLog("---------------- Erebus ---------------")
		if (!EntraDG(ErebusPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(ErebusPOS)) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (ErebusDeuErro)
			return 1
		InicioErebus := A_TickCount
		ArrumaMapaCamera1Zoom()
		ErebusPiso1()
		if (ErebusDeuErro)
			return 1
		TipoTransmog := "terra"
		Transmog("terra")
		Verifica()
		ErebusPiso2()
		if (ErebusDeuErro)
			return 1
		ErebusPiso3()
		if (ErebusDeuErro)
			return 1
		ErebusPiso4()
		if (ErebusDeuErro)
			return 1
		ErebusPisoBoss()
		if (ErebusDeuErro)
			return 1
		ZoomPraMatarPedra()
		SaiDaTransmog()
		TipoTransmog := ""
		tempoTotalDG += A_TickCount - InicioErebus
		GeraLog("---------------- Terminou Erebus em " FormataMilisegundos(A_TickCount - InicioErebus) " ---------------")
		return 1
	}
	return 0
}

ErebusPiso1() {
	GeraLog("Piso1")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "erebuspiso1", 300)) {
		GeraLog("Matando os bixos...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		
		if (A_index > 40) {
			ErebusDeuErro := true
			return
		}
	}
	SoltaTecla("Space")
	SoltaTecla("w")
	SoltaTecla("e")
	GeraLog("Matou todos.")
}

ErebusPiso2() {
	GeraLog("Piso2")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "erebuspiso2", 1000)) {
		if (MataPedraMaisPerto()){
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 100) {
			ErebusDeuErro := true
			GeraLog("Deu ruim ao matar metin.")
			return
		}
	}
	GeraLog("Matou todas.")
}

ErebusPiso3() {
	GeraLog("Piso3")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "erebuspiso3", 300)) {
		GeraLog("Matando o Bagjanamu...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		if (A_index > 40) {
			ErebusDeuErro := true
			return
		}
	}
	GeraLog("Matou o Bagjanamu.")
	PegaItens()
	EsperaRandom(1000)
	return
}

ErebusPiso4() {
	GeraLog("Piso4")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "erebuspiso4", 1500)) {
		GeraLog("Matando metins...")
		Verifica()
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
			if (ProcuraItemInventario("erebuscurativo")) {
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				GeraLog("Usou o curativo.")
				if (!ProcuraAteAchar(494, 135, 1135, 164, 50, "erebuspiso4", 1500))
					break
			}
		} else {
			Verifica()
			if (!ProcuraAteAchar(494, 135, 1135, 164, 50, "erebuspiso4", 1500))
				break
			GiraAteAcharMetin()
			VaiAteMetin()
			if (ProcuraItemInventario("erebuscurativo")) {
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				GeraLog("Usou o curativo.")
			}
		}
	}
	GeraLog("Matou todas as metins e usou os curativos.")
	return
}

ErebusPisoBoss() {
	GeraLog("Piso boss")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "erebusboss", 1500)) {
		GeraLog("Matando o Erebus...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
	}
	SoltaTecla("w")
	SoltaTecla("e")
	SoltaTecla("Space")
	GeraLog("Matou o Erebus!!")
	qntErebus++
	PegaItens()
}

; FIM EREBUS
; COMEÇO RAZADOR
Razador() {
	Inicio := A_TickCount
	RazadorDeuErro := false
	Ativa()
	if (PodeEntrarDG(RazadorPOS)) {
		GeraLog("---------------- Razador ---------------")
		if (!EntraDG(RazadorPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(RazadorPOS)) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		InicioRazador := A_TickCount
		loop, {
			Verifica()
			RazadorAmheh()
			if (RazadorDeuErro)
				return 1
			if (FazProximaMissao() = "boss") {
				break
			}
		}
		tempoTotalDG += A_TickCount - InicioRazador
		GeraLog("---------------- Terminou Razador em " FormataMilisegundos(A_TickCount - InicioRazador) " ---------------")
		return 1
	}
	return 0
}

RazadorAmheh() {
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadoramheh", 1000)) {
		GeraLog("Proxima missão")
		if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadorheh", 300)) {
			ClicaRandom(AchouOutX, AchouOutY)
			break
		} else {
			SeguraTecla("e")
			EsperaRandom(300)
			SoltaTecla("e")
			EsperaRandom(300)
		}
		if (A_index > 20) {
			RazadorDeuErro := true
			return
		}
		GeraLog("Recebeu a proxima missão.")
	}
}

FazProximaMissao() {
	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadorMissaoIncendiario", 300))
		return RazadorMissaoIncendiario()

	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadormissaomatatudo", 300))
		return RazadorMissaoMatatudo()

	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadormissaometin", 300))
		return RazadorMissaoMetin()

	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadormissaomaat", 300))
		return RazadorMissaoMaat()

	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadormissaorodadentada", 300))
		return RazadorMissaoRodaDentada()

	if (ProcuraAteAchar(127, 113, 1466, 762, 10, "razadormissaoboss", 300))
		return RazadorMissaoBoss()
}

RazadorMissaoBoss() {
	GeraLog("Missao Boss")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "razadormissaoboss", 1500)) {
		SeguraTecla("Space")
		Verifica()
		GeraLog("Matando o Razador...")
		Tecla("3")
		EsperaRandom(10000)
	}
	SoltaTecla("Space")
	GeraLog("Matou o Razador!!")
	qntRazador++
	PegaItens()
	return "boss"
}

RazadorMissaoIncendiario() {
	GeraLog("Missão do Incendiario")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadorMissaoIncendiario", 300)) {
		GeraLog("Matando o Incendiario...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		if (A_index > 40) {
			RazadorDeuErro := true
			return "normal"
		}
	}
	GeraLog("Matou o Incendario.")
	PegaItens()
	EsperaRandom(1000)
	return "normal"
}

RazadorMissaoMatatudo() {
	saiu := false
	GeraLog("Missão Mata tudo.")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadormissaomatatudo", 1500)) {
		GeraLog("Matando os bixos...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(15000)
		SoltaTecla("Space")
		if (!saiu) {
			SeguraTecla("e")
			ArrumaMapa1Zoom()
			Comeco := A_TickCount
			while ((A_TickCount - Comeco) < 4000)
			{
				loop, 2 {
					ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *10 %a_scriptdir%\razadormatameio%A_index%.png
					if !ErrorLevel {
						SoltaTecla("e")
						SeguraTecla("w", 70)
						EsperaRandom(1000)
						SoltaTecla("w", 70)
						GeraLog("Está no meio.")
						saiu := true
						break
					}
				}
			}
			SoltaTecla("e")
		}
		if (A_index > 40) {
			RazadorDeuErro := true
			return "normal"
		}
	}
	return "normal"
}

RazadorMissaoMetin() {
	GeraLog("Missão Mata metin.")
	ArrumaMapa2Zoom()
	GiraAteAcharMetin()
	SeguraTecla("w", 70)
	EsperaRandom(1000)
	SoltaTecla("w", 70)
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadormissaometin", 1000)) {
		if (MataPedraMaisPerto()){
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 40) {
			RazadorDeuErro := true
			GeraLog("Deu ruim ao matar metin.")
			return "normal"
		}
	}
	ArrumaMapa1Zoom()
	GeraLog("Matou a Metin.")
	return "normal"
}

RazadorMissaoMaat() {
	GeraLog("Missão Pedra Maat.")
	ArrumaMapa1Zoom()
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *30 *TransRed %a_scriptdir%\razadormaatmeio.png
	if ErrorLevel {
		SeguraTecla("e")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 30, "razadormaatmeio", 4000)) {
			Sleep, 320
			SoltaTecla("e")
			SeguraTecla("w", 70)
			EsperaRandom(2000)
			SoltaTecla("w", 70)
			PegaItens()
			GeraLog("Andou até mais perto do meio.")
		} else {
			SoltaTecla("e")
		}
	}
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadormissaomaat", 1000)) {
		GeraLog("Matando os bixos...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(7000)
		SoltaTecla("Space")
		if (ProcuraItemInventario("torresimbolo")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a Pedra Maat")
		}
		if (A_index > 40) {
			RazadorDeuErro := true
			return "normal"
		}
		if (A_index > 30) {
			GeraLog("Mais de 30, anda meio")
			GiraAteAcharNPC()
			SeguraTecla("w", 70)
			EsperaRandom(1000)
			SoltaTecla("w", 70)
		}
	}
	GeraLog("Matou todos e usou todas as Pedras.")
	return "normal"
}

RazadorMissaoRodaDentada() {
	GeraLog("Missão Roda Dentada.")
	GiraAteAcharNPC()
	Verifica()
	SeguraTecla("w", 70)
	EsperaRandom(1000)
	SoltaTecla("w", 70)
	GeraLog("Andou até mais perto do meio.")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "razadormissaorodadentada", 1000)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(15000)
		SoltaTecla("Space")
		PegaItens()
		if (ProcuraItemInventario("razadorrodadentada")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a Roda Dentada.")
		}
		if (A_index > 40) {
			RazadorDeuErro := true
			return "normal"
		}
	}
	GeraLog("Matou todos.")
	return "normal"
}

; FIM RAZADOR

; COMEÇO NEMERE

Nemere() {
	Inicio := A_TickCount
	NemereDeuErro := false
	Ativa()
	if (PodeEntrarDG(NemerePOS)) {
		GeraLog("---------------- Nemere ---------------")
		if (!EntraDG(NemerePOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(NemerePOS)) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (NemereDeuErro)
			return 1
		InicioNemere := A_TickCount
		ArrumaMapaCamera1Zoom()
		NemerePiso1()
		if (NemereDeuErro)
			return 1
		NemerePiso2()
		if (NemereDeuErro)
			return 1
		NemerePiso3()
		if (NemereDeuErro)
			return 1
		NemerePiso4()
		if (NemereDeuErro)
			return 1
		NemerePiso5()
		if (NemereDeuErro)
			return 1
		NemerePiso6()
		if (NemereDeuErro)
			return 1
		NemerePiso7()
		if (NemereDeuErro)
			return 1
		NemerePiso8()
		if (NemereDeuErro)
			return 1
		NemerePiso9()
		if (NemereDeuErro)
			return 1
		NemerePisoBoss()
		if (NemereDeuErro)
			return 1
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioNemere
		GeraLog("---------------- Terminou Nemere em " FormataMilisegundos(A_TickCount - InicioNemere) " ---------------")
		return 1
	}
	return 0
}

NemerePiso1() {
	GeraLog("Piso1")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso1", 300)) {
		Verifica()
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso2() {
	GeraLog("Piso2")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso2", 1000)) {
		Verifica()
		if (ProcuraItemInventario("nemerefrostkey")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a chave.")
		}
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(15000)
		SoltaTecla("Space")
		if (ProcuraItemInventario("nemerefrostkey")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a chave.")
		}
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 10) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso3() {
	GeraLog("Piso3")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso3", 1500)) {
		Verifica()
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso4() {
	GeraLog("Piso4")
	saiu := false
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso4", 1500)) {
		Verifica()
		while (true and !saiu) {
			ArrumaMapa1Zoom()
			ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *10 %a_scriptdir%\nemerepiso4meio.png
			if !ErrorLevel {
				GeraLog("Está no meio.")
				saiu := true
				break
			} else {
				SeguraTecla("e")
				EsperaRandom(300)
				SoltaTecla("e")
				EsperaRandom(300)
			}
			if (A_index > 20) {
				saiu := true
				break
			}
		}
		SeguraTecla("w")
		EsperaRandom(4000)
		SoltaTecla("w")
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso5() {
	GeraLog("Piso5")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso5", 1500)) {
		GeraLog("Matando os bixos...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(5000)
		SoltaTecla("Space")
		if (ProcuraItemInventario("nemerecubo")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou um cubo.")
		}
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 10) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso6() {
	GeraLog("Piso6")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso6", 1500)) {
		GeraLog("Matando os bixos...")
		Verifica()
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
		if (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso6metin", 300)) {
			GeraLog("Matou todos.")
			while (ProcuraAteAchar(494, 135, 1135, 164, 50, "nemerepiso6metin", 300)) {
				GeraLog("Matando metin...")
				Options = r oTransRed,29 e1 n
				listaCordPedras := FindClick("\metinpedra.png", Options)
				CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
				if (CoordMaisProxima[1] != 0) {
					x := CoordMaisProxima[1]
					y := CoordMaisProxima[2]
					PegaItens()
					ClicaRandom(x+fX(x), y+fY(y), 0)
					EsperaMatar()
				} else {
					Verifica()
					GiraAteAcharMetin()
					VaiAteMetin()
				}
			}
			GeraLog("Matou a metin.")
		}
	}
}

NemerePiso7() {
	GeraLog("Piso7")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso7", 1500)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

NemerePiso8() {
	GeraLog("Piso8")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "nemerepiso8", 1500)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(5000)
		SoltaTecla("Space")
		if (ProcuraItemInventario("nemereflowerkey")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a chave.")
		}
		Verifica()
		if (A_index > 40) {
			NemereDeuErro := true
			return
		}
		if (A_index > 10) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}
NemerePiso9() {
	GeraLog("Piso9")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "nemerepiso9", 1500)) {
		GeraLog("Matando metin...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\nemerepilar.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatarPilar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			if (ProcuraAteAchar(127, 113, 1466, 762, 50, "nemereleao", 300)) {
				SoltaTecla("Space")
				GeraLog("Achou o leão")
				while (ProcuraAteAchar(127, 113, 1466, 762, 50, "nemereleao", 300)) {
					GeraLog("Clicando no leão")
					ClicaRandom(AchouOutX+10, AchouOutY+10)
					EsperaRandom(500)
				}
			}
		}
	}
	GeraLog("Matou a metin.")
}

EsperaMatarPilar() {
	Achou := true
	SetTimer PegaItens, off
	jaEntrou := false
	SeguraTecla("e")
	if (ProcuraAteAchar(687, 389, 856, 488, 50, "nemerepilar", 5000)) {
		ImprimeInfos()
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		Verifica()
		SeguraTecla("Space")
		tempoMatarPedra := A_TickCount
		if (!jaEntrou and optNV != "" and !EstaFazendoDG){
			jaEntrou := true
			CimaMetin(optNV)
		}
		while (!PegaItensDaMetin()) {
			GeraLog("Matando a metin...")
			if (A_index > 1) {
				Tecla("3")
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vida.png
				if ErrorLevel {
					GeraLog("Saiu pela a vida")
					Verifica()
					Achou := PegaItens()
					SoltaTecla("Space")
					break
				}
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vidacheia.png
				if !ErrorLevel {
					GeraLog("Saiu pela a vida cheia")
					Verifica()
					Achou := PegaItens()
					SoltaTecla("Space")
					break
				}
			}
			Verifica()
		}
	}
	SetTimer PegaItens, 500, ON, 3
}

NemerePisoBoss() {
	GeraLog("Piso boss")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "nemereboss", 1500)) {
		SeguraTecla("Space")
		GeraLog("Matando o nemere...")
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
	}
	GeraLog("Matou o Nemere!!")
	qntNemere++
	PegaItens()
}
; FIM NEMERE

; COMEÇO DRAGAO

Dragao() {
	Inicio := A_TickCount
	DragaoDeuErro := false
	Ativa()
	if (PodeEntrarDG(DragaoPOS)) {
		GeraLog("---------------- Dragao ---------------")
		if (!EntraDG(DragaoPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(DragaoPOS)) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (DragaoDeuErro)
			return 1
		InicioDragao := A_TickCount
		ArrumaMapaCamera1Zoom()
		DragaoStage1AndaMeio()
		if (DragaoDeuErro)
			return 1
		DragaoStage1Metin()
		if (DragaoDeuErro)
			return 1
		DragaoStage2MataTudo()
		if (DragaoDeuErro)
			return 1
		DragaoStage3MataTudo()
		if (DragaoDeuErro)
			return 1
		DragaoStage4Metin()
		if (DragaoDeuErro)
			return 1
		DragaoStage5MataTudoEUsa()
		if (DragaoDeuErro)
			return 1
		DragaoStageBoss()
		if (DragaoDeuErro)
			return 1
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioDragao
		GeraLog("---------------- Terminou Dragao em " FormataMilisegundos(A_TickCount - InicioDragao) " ---------------")
		return 1
	}
	return 0
}

AbreF6() {
	ImageSearch, OutX, OutY, 500, 222, 1116, 670, *70 %a_scriptdir%\temporizador.png
	if ErrorLevel {
		Tecla("F6")
		if (!ProcuraAteAchar(500, 222, 1116, 670, 70, "temporizador", 1500)) {
			GeraLog("Não abriu o F6, tenta de novo.")
			Verifica()
			return false
		} else {
			GeraLog("Abriu o F6")
			EsperaRandom(3000)
			;ImageSearch, OutX, OutY, 500, 222, 1116, 670, *40 %a_scriptdir%\redefinir.png
			;if !ErrorLevel {
			;	ClicaRandom(OutX, OutY)
			;	GeraLog("Redefiniu")
			;	EsperaRandom(3000)
			;}
			return true
		}
	} else {
		;ImageSearch, OutX, OutY, 500, 222, 1116, 670, *40 %a_scriptdir%\redefinir.png
		;if !ErrorLevel {
		;	ClicaRandom(OutX, OutY)
		;	GeraLog("Redefiniu")
		;	ClicaRandom(677, 606)
		;	EsperaRandom(3000)
		;}
		return true
	}
}

EntraDragao() {
	if (!AbreF6())
		return false
	if (RetornaCorPixel(736, 458) != "0x22244F") {
		GeraLog("Pode fazer Dragao")
		ClicaRandom(736, 458)
		EsperaRandom(500)
		ClicaRandom(886, 608)
		;ClicaRandom(721, 464)
		;EsperaRandom(500)
		;ClicaRandom(721, 464)
		EsperaRandom(1000)
		MoveMouse(798, 223)
		;PegaItens()
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				DragaoDeuErro := true
				VaiPraCidadeRed()
				return false
			}
		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				VaiPraCidadeRed()
				return false
			}
		}
		return true
	} else {
		GeraLog("Não pode fazer Dragao")
		return false
	}
}

DragaoStage1AndaMeio() {
	; Piso 1
	; Anda até o meio
	Tentativa := 0
	AndaAteMeioDragao:
	if (Tentativa > 20) {
		DragaoDeuErro := true
		return
	}
	while (true) {
		loop, 20 {
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *70 *TransRed %a_scriptdir%\dragaochao.png
			if !ErrorLevel{
				ClicaRandom(OutX+15, OutY+15, 3, 300)
				GeraLog("Encontrou o chão.")
				break 2
			}
		}
		Verifica()
		SeguraTecla("e")
		EsperaRandom(150)
		SoltaTecla("e")
		EsperaRandom(300)
		if (A_index > 30) {
			if (deslogou) {
				DragaoDeuErro := true
				deslogou := false
				return
			}
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
			Verifica()
			GeraLog("Não encontrou o chão, anda um pouco.")
			Goto, AndaAteMeioDragao
		}
	}
	Sleep, 1500
	ArrumaMapa1Zoom()
	while (true) {
		ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 %a_scriptdir%\dragaomeio.png
		if !ErrorLevel {
			GeraLog("Está no meio.")
			break
		} else {
			SeguraTecla("e")
			EsperaRandom(300)
			SoltaTecla("e")
			EsperaRandom(300)
		}
		if (A_index > 10) {
			if (deslogou) {
				DragaoDeuErro := true
				deslogou := false
				return
			}
			Tentativa++
			GeraLog("Não encontrou o meio, tenta de novo")
			SeguraTecla("d")
			EsperaRandom(1500)
			SoltaTecla("d")
			Verifica()
			Goto, AndaAteMeioDragao
		}
	}
	; Andou até o meio.
}

DragaoStage1Metin() {
	GeraLog("Stage1")
	Sleep, 1500
	ArrumaMapa2Zoom()
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "dragaostage1", 1500)) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			;()
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

DragaoStage2MataTudo() {
	GeraLog("Stage2")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "dragaostage2", 300)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

DragaoStage3MataTudo() {
	GeraLog("Stage3")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "dragaostage3", 300)) {
		GeraLog("Matando os bosses...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 10) {
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

DragaoStage4Metin() {
	GeraLog("Stage4")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "dragaostage4", 1500)) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

DragaoStage5MataTudoEUsa() {
	GeraLog("Stage5")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "dragaostage5", 300)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(7000)
		SoltaTecla("Space")
		if (ProcuraItemInventario("dragaosimbolo")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou o simbolo.")
		}
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 10) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todos.")
}

DragaoStageBoss() {
	EsperaRandom(1000)
	if (ProcuraItemInventario("dragaosimbolo")) {
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		GeraLog("Usou o simbolo.")
	}
	GeraLog("Stage boss")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "dragaoboss", 1500)) {
		SeguraTecla("Space")
		GeraLog("Matando o dragao...")
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
	}
	GeraLog("Matou o Dragao!!")
	qntDragao++
	PegaItens()
}

; FIM DRAGAO

; COMEÇO TORRE

Torre() {
	Inicio := A_TickCount
	TorreDeuErro := false
	Ativa()
	if (PodeEntrarDG(TorrePOS)) {
		GeraLog("---------------- Torre ---------------")
		if (!EntraDG(TorrePOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(TorrePOS)) {
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (TorreDeuErro)
			return 1
		InicioTorre := A_TickCount
		ArrumaMapaCamera1Zoom()
		TorrePiso1Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso2MataTudo()
		if (TorreDeuErro)
			return 1
		TorrePiso3MataTudo()
		if (TorreDeuErro)
			return 1
		TorrePiso4Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso5Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso6Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso7MataTudo()
		if (TorreDeuErro)
			return 1
		TorrePiso8Boss()
		if (TorreDeuErro)
			return 1
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioTorre
		GeraLog("---------------- Terminou Torre em " FormataMilisegundos(A_TickCount - InicioTorre) " ---------------")
		return 1
	}
	return 0
}

EntraTorre() {
	if (!AbreF6())
		return false
	if (RetornaCorPixel(731, 345) != "0x22224D") {
		GeraLog("Pode fazer Torre")
		ClicaRandom(731, 345)
		EsperaRandom(500)
		ClicaRandom(886, 608)
		;EsperaRandom(500)
		;ClicaRandom(721, 464)
		EsperaRandom(1000)
		MoveMouse(798, 223)
		;PegaItens()
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				TorreDeuErro := true
				VaiPraCidadeRed()
				return false
			}
		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				VaiPraCidadeRed()
				return false
			}
		}
		return true
	} else {
		GeraLog("Não pode fazer Torre")
		return false
	}
}

TorrePiso1Metin() {
	GeraLog("Piso1")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso1", 1500)) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			;()
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso2AndaMeio()
{
	; Anda até o meio
	Tentativa := 0
	AndaAteMeioTorre:
	if (Tentativa > 20) {
		TorreDeuErro := true
		return
	}
	while (true) {
		loop, 20 {
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *80 *TransRed %a_scriptdir%\torrechao.png
			if !ErrorLevel{
				ClicaRandom(OutX+15, OutY+15, 3, 300)
				Tecla(1)
				GeraLog("Encontrou o chão.")
				break 2
			}
		}
		SeguraTecla("e")
		EsperaRandom(150)
		SoltaTecla("e")
		EsperaRandom(300)
		if (A_index > 30) {
			Tentativa++
			if (deslogou) {
				DragaoDeuErro := true
				deslogou := false
				return
			}
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
			Verifica()
			GeraLog("Não encontrou o chão, anda um pouco.")
			Goto, AndaAteMeioTorre
		}
	}
}
TorrePiso2AndaMeio2()
{
	loop, 20 {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *80 *TransRed %a_scriptdir%\torrechao.png
		if !ErrorLevel{
			ClicaRandom(OutX+15, OutY+15, 3, 300)
			Tecla(1)
			GeraLog("Encontrou o chão.")
			break
		}
	}
}

TorrePiso2MataTudo() {
	TorrePiso2AndaMeio()
	GeraLog("Piso2")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "torrepiso2", 300)) {
		GeraLog("Matando os bixos e boss...")
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("w")
		SoltaTecla("e")
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
		TorrePiso2AndaMeio2()
	}
	GeraLog("Matou todos.")
}

TorrePiso3MataTudo() {
	TorrePiso2AndaMeio()
	GeraLog("Piso3")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "torrepiso3", 300)) {
		GeraLog("Matando os bixos e boss...")
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("w")
		SoltaTecla("e")
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 2) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
		TorrePiso2AndaMeio2()
	}
	GeraLog("Matou todos.")
}

TorrePiso4Metin() {
	GeraLog("Piso4")
	ArrumaMapa1Zoom()
	Sleep, 1500
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso4", 1500)) {
		GeraLog("Matando metins...")
		if (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso4rei", 300))
			break
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
			if (ProcuraItemInventario("torresimbolo")) {
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				GeraLog("Usou o simbolo.")
			}
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			if (ProcuraItemInventario("torresimbolo")) {
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
				GeraLog("Usou o simbolo.")
			}
			;()
		}
	}
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "torrepiso4rei", 1500)) {
		GeraLog("Matando Rei Demonio ...")
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("w")
		SoltaTecla("e")
		SoltaTecla("Space")
		if (A_index > 40) {
			TorreDeuErro := true
			return
		}
		if (A_index > 2) {
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
	}
	GeraLog("Matou todas as Metin e o Rei Demonio.")
	ArrumaMapa1Zoom()
}

TorrePiso5Metin() {
	GeraLog("Piso5")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso5", 1500)) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			;()
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso6Metin() {
	GeraLog("Piso6")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso6", 1500)) {
		GeraLog("Matando a metin.")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			;()
		}
	}
	GeraLog("Matou.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso7AndaMeio()
{
	loop, 20 {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 *TransRed %a_scriptdir%\torrechao7.png
		if !ErrorLevel{
			ClicaRandom(OutX+15, OutY+15, 3, 300)
			Tecla(1)
			GeraLog("Encontrou o chão.")
			break
		}
	}
}

TorrePiso7MataTudo() {
	GeraLog("Piso7")
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "torrepiso7", 300)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("w")
		SoltaTecla("e")
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			DragaoDeuErro := true
			return
		}
		if (A_index > 3) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
		TorrePiso7AndaMeio()
		if (ProcuraItemInventario("torrechave")) {
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
			GeraLog("Usou a chave.")
		}
	}
	GeraLog("Matou todos.")
}

TorrePiso8Boss() {
	GeraLog("Stage8")
	EsperaRandom(1000)
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "torrepiso8", 1500)) {
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		GeraLog("Matando a Death Reaper...")
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("w")
		SoltaTecla("e")
		SoltaTecla("Space")
		Verifica()
		TorrePiso7AndaMeio()
		Verifica()
	}
	qntTorre++
	GeraLog("Matou o Death Reaper!!")
	PegaItens()
}

; FIM TORRE
Baronesa() {
	Inicio := A_TickCount
	BaronesaDeuErro := false
	Ativa()
	if (PodeEntrarDG(BaronesaPOS)) {
		GeraLog("---------------- Baronesa ---------------")
		if (!EntraDG(BaronesaPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(BaronesaPOS)) {
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (BaronesaDeuErro)
			return 1
		InicioBaronesa := A_TickCount
		ArrumaMapaCamera1Zoom()
		BaronesaPiso1AndaMeio()
		if (BaronesaDeuErro)
			return 1
		AtivaSkill()
		BaronesaPiso1MataTudo()
		if (BaronesaDeuErro)
			return 1
		AtivaSkill()
		BaronesaPiso2Ovos()
		if (BaronesaDeuErro)
			return 1
		AtivaSkill()
		SetTimer PegaItens, 500, ON, 3
		BaronesaPiso3()
		if (BaronesaDeuErro)
			return 1
		BaronesaPisoBoss()
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioBaronesa
		GeraLog("---------------- Terminou Baronesa em " FormataMilisegundos(A_TickCount - InicioBaronesa) " ---------------")
		return 1
	}
	return 0
}

EntraBaronesa() {
	if (!AbreF6())
		return false
	if (RetornaCorPixel(792, 307) != "0x1F2659") {
		GeraLog("Pode fazer baronesa")
		ClicaRandom(792, 307)
		EsperaRandom(500)
		ClicaRandom(886, 608)
		;EsperaRandom(500)
		;ClicaRandom(721, 464)
		EsperaRandom(1000)
		MoveMouse(798, 223)
		;PegaItens()
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				BaronesaDeuErro := true
				VaiPraCidadeRed()
				return false
			}

		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				VaiPraCidadeRed()
				return false
			}
		}
		return true
	} else {
		GeraLog("Não pode fazer Baronesa")
		return false
	}
}

BaronesaPiso1AndaMeio()
{
	; Piso 1
	; Anda até o meio
	Tentativa := 0
	AndaAteMeio:
	if (Tentativa > 20) {
		GeraLog("Deu erro por conta de tentativa.")
		BaronesaDeuErro := true
		return
	}
	while (true) {
		loop, 20 {
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *39 *TransRed %a_scriptdir%\baronesachao.png
			if !ErrorLevel{
				ClicaRandom(OutX+15, OutY+15, 3, 300)
				GeraLog("Encontrou o chão.")
				break 2
			}
		}
		SeguraTecla("e")
		EsperaRandom(150)
		SoltaTecla("e")
		EsperaRandom(300)
		if (A_index > 30) {
			if (deslogou) {
				DragaoDeuErro := true
				deslogou := false
				return
			}
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
			Verifica()
			GeraLog("Não encontrou o chão, anda um pouco.")
			Goto, AndaAteMeio
		}
	}
	Sleep, 1500
	ArrumaMapa1Zoom()
	while (true) {
		ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 %a_scriptdir%\baronesameio.png
		if !ErrorLevel {
			GeraLog("Está no meio.")
			break
		} else {
			SeguraTecla("e")
			EsperaRandom(300)
			SoltaTecla("e")
			EsperaRandom(300)
		}
		if (A_index > 10) {
			Tentativa++
			if (deslogou) {
				DragaoDeuErro := true
				deslogou := false
				return
			}
			GeraLog("Não encontrou o meio, tenta de novo")
			SeguraTecla("d")
			EsperaRandom(1500)
			SoltaTecla("d")
			Verifica()
			Goto, AndaAteMeio
		}
	}
	; Andou até o meio.
}

BaronesaPiso1MataTudo() {
	while (ProcuraAteAchar(494, 135, 1135, 164, 40, "baronesapiso1matatodos", 300)) {
		GeraLog("Matando os bixos...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			BaronesaDeuErro := true
			return
		}
		if (A_index > 1) {
			PegaItens()
			SeguraTecla("w")
			EsperaRandom(3000)
			SoltaTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("e")
		}
		if (mod(A_index, 5) = 0) {
			BaronesaPiso1AndaMeio()
		}
	}
	GeraLog("Matou todos.")
}

BaronesaPiso2Ovos() {
	GeraLog("Piso2")
	Sleep, 1500
	ArrumaMapa2Zoom()
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "baronesapiso2ovo", 1500)) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\baronesaovo.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			;GeraLog("Achou com Distancia Euclidiana.")
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0)
			BaronesaEsperaMatarOvo()
		} else {
			Verifica()
			GiraAteAcharBaronesa()
			VaiAteMetinBaronesa()
			;BaronesaPiso1AndaMeio()
		}
	}
	ArrumaMapa1Zoom()
	GeraLog("Matou todas.")
	return true
}

GiraAteAcharBaronesa() {
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *60 *TransRed %a_scriptdir%\mapametin2.png
	if ErrorLevel {
		SeguraTecla("e")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 60, "mapametin2", 8000)) {
			;GeraLog("Achou")
			Sleep, 150
			SoltaTecla("e")
			Verifica()
			return
		}
		SoltaTecla("e")
	}
}

VaiAteMetinBaronesa() {
	PegaItens()
	SeguraTecla("w")
	if (ProcuraAteAchar(Xjanela, Yjanela-60, Wjanela-80, Hjanela, 40, "baronesaovo", 4000)) {
		SoltaTecla("w")
		return
	}
	Else {
		SoltaTecla("w")
		Tecla("d", 500)
		SeguraTecla("e")
		Sleep, 150
		SoltaTecla("e")
		return
	}
	SoltaTecla("w")
}

BaronesaEsperaMatarOvo() {
	Achou := true
	SetTimer PegaItens, off
	SeguraTecla("e")
	if (ProcuraAteAchar(722, 363, 908, 477, 40, "baronesaovo", 2000)) {
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		Verifica()
		SeguraTecla("Space")
		while (!PegaItens()) {
			if (A_index > 6) {
				Tecla("3")
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vida.png
				if ErrorLevel {
					GeraLog("Saiu pela a vida")
					Verifica()
					Achou := PegaItens()
					break
				}
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vidacheia.png
				if !ErrorLevel {
					GeraLog("Saiu pela a vida cheia")
					Achou := PegaItens()
					break
				}
			}
			Verifica()
		}
		if (!Achou) {
			GeraLog("Nao achou")
			SoltaTecla("Space")
			;ClicaRandom(807, 447, 15)
			Tecla("d", 500)
			Tecla("s", 300)
		} else {
			SoltaTecla("Space")
		}
	} else {
		SoltaTecla("e")
		VaiAteMetinBaronesa()
	}
	SetTimer PegaItens, 500, ON, 3
}

BaronesaPiso3() {
	EsperaRandom(1000)
	GeraLog("Piso3")
	SeguraTecla("Space")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "baronesapiso3", 1500)) {
		GeraLog("Matando a aranha...")
		Verifica()
		Tecla("3")
		EsperaRandom(1500)
		ImageSearch, OutX, OutY, 494, 135, 1135, 164, *50 *TransRed %a_scriptdir%\baronesapiso3usaapito.png
		if !ErrorLevel {
			GeraLog("Matou a aranha.")
			Break
		}
	}
	EsperaRandom(2000)
	SoltaTecla("Space")
	if (ProcuraItemInventario("baronesaapito")) {
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		GeraLog("Usou o apito.")
	} else
		BaronesaDeuErro := true
}

BaronesaPisoBoss() {
	EsperaRandom(1000)
	if (ProcuraItemInventario("baronesaapito")) {
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		ClicaRandomDireito(ItemInvOutX+15, ItemInvOutY+7)
		GeraLog("Usou o apito de novo?")
	}
	GeraLog("Piso boss")
	SeguraTecla("Space")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "baronesapisoboss", 1500)) {
		GeraLog("Matando a baronesa...")
		Verifica()
		Tecla("3")
		EsperaRandom(1500)
	}
	GeraLog("Matou a baronesa!")
	PegaItens()
	qntBaronesa++
	SoltaTecla("Space")
}

AbreInventario() {
	;Inicio := A_TickCount
	ImageSearch, OutX, OutY, 1477, 257, 1579, 280, *40 %a_scriptdir%\inventario.png
	if ErrorLevel {
		Tecla("i")
		MoveMouse(798, 223)
		if (!ProcuraAteAchar(1477, 257, 1579, 280, 40, "inventario", 1000)) {
			Verifica()
			AbreInventario()
		}
	}
}

FechaInventario() {
	;Inicio := A_TickCount
	ImageSearch, OutX, OutY, 1477, 257, 1579, 280, *40 %a_scriptdir%\inventario.png
	if !ErrorLevel {
		Tecla("i")
	}
}

ProximaPaginaInv() {
	AbreInventario()
	Xinv := 1420
	Yinv := 483
	AbaInv++
	if (AbaInv < 6) {
		ClicaRandom(Xinv+(30*AbaInv), Yinv)
		MoveMouse(1393, 483)
		return true
	} else {
		AbaInv := 0
		return false
	}
	EsperaRandom(100)
	;if (AbaInv = 1) {
	;	ClicaRandom(1461, 483)
	;	MoveMouse(1393, 483)
	;	return true
	;} else if (AbaInv = 2) {
	;	ClicaRandom(1481, 483)
	;	MoveMouse(1393, 483)
	;	return true
	;} else if (AbaInv = 3) {
	;	ClicaRandom(1519, 483)
	;	MoveMouse(1393, 483)
	;	return true
	;} else {
	;	AbaInv := 0
	;	return false
	;}
}

ProcuraItemInventario(item) {
	ImageSearch, ItemInvOutX, ItemInvOutY, 1432, 472, 1595, 788, *50 %a_scriptdir%\%item%.png
	if !ErrorLevel {
		return true
	}
	AbaInv := 0
	while (ProximaPaginaInv()) {
		ImageSearch, ItemInvOutX, ItemInvOutY, 1432, 472, 1595, 788, *50 %a_scriptdir%\%item%.png
		if !ErrorLevel {
			return true
		}
		EsperaRandom(300)
	}
	return false
}

VaiPraCidadeRed() {
	Tecla("4")
	if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "anel", 2000)) {
		ClicaRandom(802, 464)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "desert", 2000)) {
			ClicaRandom(AchouOutX, AchouOutY)
			if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "middle", 2000)) {
				Random, opts, 1, 3
				if (opts = 1)
					ClicaRandom(802, 491)
				else if (opts = 2)
					ClicaRandom(798, 428)
				else if (opts = 3)
					ClicaRandom(809, 455)
				if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
					GeraLog("Achou o loading")
					EsperaRandom(10000)
					GeraLog("Foi pra vila red")
				} else {
					GeraLog("Não achou o loading, tenta de novo.")
					Verifica()
					VaiPraCidadeRed()
				}
			}
		}
	}
}

EquipaLuva() {
	AbreInventario()
	EsperaRandom(500)
	if (RetornaCorPixel(1457, 447) != "0x667283") {
		GeraLog("Estava sem luva.")
		if (ProcuraItemInventario("luva")) {
			GeraLog("Achou a luva pra equipar.")
			ClicaRandomDireito(ItemInvOutX, ItemInvOutY)
			EsperaRandom(250)
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
			if !ErrorLevel {
				ClicaRandom(OutX+5, OutY+5)
			}
		} else {
			GeraLog("Não tinha luva.")
		}
	}
	FechaInventario()
}

EquipaAnel() {
	AbreInventario()
	EsperaRandom(150)
	if (RetornaCorPixel(1528, 443) != "0xCDBEC3") {
		GeraLog("Estava sem anel.")
		if (ProcuraItemInventario("anelxp")) {
			GeraLog("Achou o anel pra equipar.")
			ClicaRandomDireito(ItemInvOutX, ItemInvOutY)
			EsperaRandom(250)
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
			if !ErrorLevel {
				ClicaRandom(OutX+5, OutY+5)
			}
		} else {
			GeraLog("Não tinha anel pra equipar.")
		}
	}
	FechaInventario()
}

GiraAteAchar(tipo) {
	Inicio := A_TickCount
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *2 %a_scriptdir%\%tipo%1.png
	if !ErrorLevel {
		GeraLog("Já estava mirando.")
		return true
	}
}

CimaMetin(nv) {
	;GeraLog("Cima Metin")
	Inicio := A_TickCount
	Options = a,30,,-43 r oTransRed,%varMetin% e0.000000000000000001 n
	listaCordPedras := ""
	Loop, 2 {
		listaCordPedras := listaCordPedras . FindClick("\metin" nv ".png", Options) . "`n"
	}
	CoordMaisProxima := EncontrarCoordenadaMaisProxima(SubStr(listaCordPedras, 1, StrLen(listaCordPedras)-2))
	if (CoordMaisProxima[1] != 0 and CoordMaisProxima[1] != "") {
		;GeraLog("Achou com Distancia Euclidiana.")
		x := CoordMaisProxima[1]
		y := CoordMaisProxima[2]
		GeraLog("Achou via cima Metin: " A_TickCount - Inicio)
		MoveMouse(x+5, y, 1)
		return true
	} else {
		GeraLog("Não achou nenhuma cima metin: " A_TickCount - Inicio)
		return false
	}
}

TemPM() {
	ImageSearch, ItemInvOutX, ItemInvOutY, 1432, 472, 1595, 788, *40 %a_scriptdir%\pm.png
	if !ErrorLevel {
		SoundBeep, [ Frequency, Duration]
		return true
	}
}

JogoAberto() {
	ExecutouLocal := false
	if (WinExist("Aeldra.to - Zeta")) {
		return true
	}
	else {
		GeraLog("Jogo fechado")
		if (WinExist("ahk_exe Aeldra-Patcher.exe") or WinExist("TORRENT")) {
			GeraLog("Patcher estava aberto, fecha.")
			WinGet, PatcherPID, PID, ahk_exe Aeldra-Patcher.exe
			;GeraLog(PatcherPID)
			Run, taskkill /PID %PatcherPID% /F, , Hide
			WinKill, TORRENT
			EsperaRandom(1500)
		}
		try
		Run, "C:\Users\Tap\Desktop\Aeldra\Aeldra-Patcher.exe"
		catch
			Run, "D:\Desktop\Aeldra\Aeldra-Patcher.exe"
		loop {
			if (WinExist("ahk_exe Aeldra-Patcher.exe") or WinExist("TORRENT")) {
				WinActivate, ahk_exe Aeldra-Patcher.exe
				WinActivate, TORRENT
				GeraLog("Abriu o Launcher")
				InicioAtualizacao := A_TickCount
				while ((A_TickCount - InicioAtualizacao) < MinToMili(60)) {
					if (ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 10, "start", 100)) {
						GeraLog("Pronto para inicar")
						EsperaRandom(1000)
						MouseClick, left, AchouOutX, AchouOutY
						InicioCarregandoJogo := A_TickCount
						while ((A_TickCount - InicioCarregandoJogo) < MinToMili(10)) {
							if (WinExist("Aeldra.to - Zeta")) {
								GeraLog("Abriu o jogo.")
								EsperaRandom(5000)
								WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Aeldra.to - Zeta
								Yjanela := Yjanela+30
								TaDeslogado()
								return true
							} else {
								GeraLog("Esperando carregar o jogo...")
								EsperaRandom(3000)
							}
						}
						GeraLog("Demorou mais de 10 minutos pra abrir o jogo, deu merda?")
						return false
					}
					if (!ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 10, "finished", 1000)) {
						GeraLog("Atualizando...")
					} else {
						GeraLog("Terminou de atualizar.")
					}
				}
				GeraLog("Deu ruim... Demorou mais de uma Hora pra atualizar a merda do patch.")
				return false
			} else {
				EsperaRandom(1000)
			}
			if (A_Index > 30)
				return false
		}
	}
}

TrocaGaya() {
	loop {
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "vendedor", 1000))
			ClicaRandom(AchouOutX, AchouOutY, 3)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "pedaco", 1000))
			ClicaRandom(AchouOutX, AchouOutY, 5)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "max", 1000))
			ClicaRandom(AchouOutX, AchouOutY, 5)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 50, "sim", 2000)) {
			ClicaRandom(AchouOutX, AchouOutY, 5)
			EsperaRandom(500)
		}
	}
}

TestaMira() {
	MouseGetPos, x, y
	GeraLog("Original: " x ", " x)
	GeraLog("Calculado: " x+fX(x) ", " y+fY(y))
	MoveMouse(x+fX(x), y+fY(y))
}

SelecionaDG(pos) {
	ClicaRandom(647, (281-53)+(pos*53))
}

PodeEntrarDG(pos) {
	if (!AbreF6())
		return false
	MoveMouse(933, 555, 1)
	if (RetornaCorPixel(647, (281-53)+(pos*53)) = "0x29332D" or RetornaCorPixel(647, (281-53)+(pos*53)) = "0x3E4742") {
		GeraLog("Pode fazer DG " pos)
		return true
	} else {
		GeraLog("Não pode fazer DG " pos)
		return false
	}
}

EntraDG(pos) {
	if (!AbreF6())
		return false
	SelecionaDG(pos)
	EsperaRandom(500)
	ClicaRandom(895, 613)
	MoveMouse(779, 710)
	if (ProcuraPixelAteAchar(869, 419, "0x202121", 2000)) {
		GeraLog("Achou a janela pra entrar.")
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG: " pos)
				BaronesaDeuErro := true
				VaiPraCidadeRed()
				return false
			}

		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG: " pos)
				VaiPraCidadeRed()
				return false
			}
		}
		return true
	} else {
		GeraLog("Não conseguiu entrar na DG: " pos)
		VaiPraCidadeRed()
		return false
	}
}

EntraBaronaaesa() {
	if (!AbreF6())
		return false
	if (RetornaCorPixel(792, 307) != "0x1F2659") {
		GeraLog("Pode fazer baronesa")
		ClicaRandom(792, 307)
		EsperaRandom(500)
		ClicaRandom(886, 608)
		;EsperaRandom(500)
		;ClicaRandom(721, 464)
		EsperaRandom(1000)
		MoveMouse(798, 223)
		;PegaItens()
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				BaronesaDeuErro := true
				VaiPraCidadeRed()
				return false
			}

		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 10000)) {
				GeraLog("Esta carregando...")
				EsperaRandom(8000)
				return true
			} else {
				GeraLog("Não conseguiu entrar na DG.")
				VaiPraCidadeRed()
				return false
			}
		}
		return true
	} else {
		GeraLog("Não pode fazer Baronesa")
		return false
	}
}

Upar() {
	SeguraTecla("Space", 70)
	SeguraTecla("q", 70)
	SeguraTecla("w", 70)
	loop, {
		Tecla("3")
		VerificaNaoEssenciais()
		CaptchaMaldito()
		EsperaRandom(1000)
	}
}

GiraAteAcharNPC() {
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *30 *TransRed %a_scriptdir%\mapanpc1.png
	if !ErrorLevel {
		SeguraTecla("e")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 30, "mapanpc2", 4000)) {
			Sleep, 320
			SoltaTecla("e")
			return
		}
	}
}

Transmog(tipo) {
	if (!Transfigurado()) {
		if (ProcuraItemInventario("trans"tipo)) {
			GeraLog("Achou a Esfera de Transmog tipo " tipo)
			ClicaRandomDireito(ItemInvOutX, ItemInvOutY)
			if (!ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "sim", 1000)) {
				Verifica()
				Transmog(tipo)
			} else {
				GeraLog("Transfigurado no tipo " tipo)
				ClicaRandom(AchouOutX+5, AchouOutY+5)
			}
		} else {
			GeraLog("Não tinha nenhuma esfera de Transmog")
			if (ProcuraItemInventario("bilhetetransmog")) {
				GeraLog("Achou o Bilhete para comprar.")
				ClicaRandomDireito(ItemInvOutX, ItemInvOutY)
				if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "trans"tipo, 1000)) {
					GeraLog("Comprou a esfera de Transmog")
					ClicaRandomDireito(AchouOutX+5, AchouOutY+5)
					Loop, 2
						FechaX()
					Transmog(tipo)
				} else {
					GeraLog("Não achou para comprar. Porra?")
				}

			}
		}
	}
}

SaiDaTransmog() {
	ImageSearch, OutX, OutY, 9, 38, 389, 112, *60 *TransRed %a_scriptdir%\iconetransmog.png
	if !ErrorLevel{
		GeraLog("Está transfigurado, tira.")
		ClicaRandom(OutX, OutY)
		if (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "sim", 1000)) {
			ClicaRandom(AchouOutX+5, AchouOutY+5)
			GeraLog("Tirou a transfiguração.")
			while (!ForaDoCavalo()) {
				Tecla("2")
				EsperaRandom(1000)
				Tecla("2")
				EsperaRandom(500)
			}
		}
	}
}

Transfigurado() {
	ImageSearch, OutX, OutY, 9, 38, 389, 112, *60 *TransRed %a_scriptdir%\iconetransmog.png
	if !ErrorLevel{
		return true
	} else {
		return false
	}
}