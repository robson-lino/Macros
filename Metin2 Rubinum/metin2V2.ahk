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
global p := 1
global AchouOutX, AchouOutY
global Xjanela, Yjanela, Hjanela, Wjanela
global qntMetin := 0
Global CanalAtual := 0
Global Tempo := ""
global InicioMacro
global FimMacro := ""
global ItemInvOutX, ItemInvOutY
global listaCordPedras
global tempoDeNaoEssenciais := MinToMili(15)
global Aviso := true
global tickInicioMacro := A_TickCount
global informacoesAnteriores
global captcharesolvido := 0
global ClicaX, ClicaY
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

WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Rubinum
if (Xjanela = "") {
	GeraLog("METIN NÃO ESTAVA ABERTO")
	JogoAberto()
}
WinActivate, Rubinum
Yjanela := Yjanela+30
Gui Show, w329 h181, Window

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
		GeraLog("Estava no Rubinum, meu deus.")
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

Inicio:
PegaControles()
EsperaRandom(1000)
WinActivate, Rubinum
FileRead, informacoesAnteriores, metininfos%optConta%.log
ClicaRandomDireito(824, 299)
;Verifica()
;ZoomPraMatarPedra()
tickInicioMacro := A_TickCount
qntMetin := 0
loop, {
	Tempo := A_TickCount
	Player()
	if (qntTravado >= 3) {
		qntTravado := 0
		GeraLog("Voltou por que estava travado.")
		;VoltaPraQuebrarMetin()
	}
	if (FilaMetins()){
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
	jaEntrou := false
	SeguraTecla("e")
	if (ProcuraAteAchar(687, 389, 856, 488, 50, "metinpedra", 5000)) {
		ImprimeInfos()
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		Verifica()
		tempoMatarPedra := A_TickCount
		if (!jaEntrou and optNV != "" and !EstaFazendoDG){
			jaEntrou := true
			CimaMetin(optNV)
		}
		while (TaMatandoMetin()) {
			GeraLog("Matando a metin...")
			if (A_index > 1) {
				Tecla("3")
				ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vidacheia.png
				if !ErrorLevel {
					GeraLog("Saiu pela a vida cheia")
					Verifica()
					Achou := false
					break
				}
			}
			Verifica()
		}
		if (!Achou) {
			qntTravado++
			qntTravadoTotal++
			ClicaRandom(805, 450)
			GeraLog("Nao achou, travado: " qntTravado)
			;ClicaRandom(807, 447, 15)
			Tecla("d", 500)
			Tecla("s", 300)
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
	;ForaDoCavalo()
	if (!ChkUpar)
		AnelXP()
	CaptchaMaldito()
	GiraRoda()
	;VerificaNaoEssenciais()
	;if (!EstaFazendoDG) {
	;	VerificaBossDGs()
	;	if (Transfigurado())
	;		SaiDaTransmog()
	;} else {
	;	if (TipoTransmog != "" and !Transfigurado()) {
	;		GeraLog("Estava fazendo DG que precisa de transmog mas não estava com Transmog.")
	;		Transmog(TipoTransmog)
	;	} else if (Transfigurado() and TipoTransmog = "") {
	;		GeraLog("Estava fazendo DG que não precisa de transmog, mas estava com a Transmog.")
	;		SaiDaTransmog()
	;	}
	;}
	FechaX()
	;GeraLog("Tempo: " A_TickCount - Inicio)
}

VerificaNaoEssenciais() {
	if ((A_tickcount - ultimaVerificaNaoEssenciais) > tempoDeNaoEssenciais) {
		GeraLog("Entrou não essenciais.")
		AvisoNaoEssenciais := true
		ultimaVerificaNaoEssenciais := A_tickcount
		Tecla("2")
		EsperaRandom(500)
		Tecla("2")
		;ForaDoCavalo()
		ClicaRandom(1481, 131)
		EsperaRandom(500)
		MoveMouse(1393, 483)
	} else {
		if (tempoDeNaoEssenciais-((A_tickcount - ultimaVerificaNaoEssenciais)) < MinToMili(2) and AvisoNaoEssenciais) {
			GeraLog("Faltam menos de 3 minutos para fazer as DGs")
			AvisoNaoEssenciais := false
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
VaiCanal(5)
;RazadorAmheh()
Return

VaiAteMetin() {
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
	GeraLog("Depois do Catpcha: " A_TickCount - Inicio)
	;Options = r oTransRed,29 e1 n
	Options = r x-11 y-4 oTransRed,29 e0.1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
	if (CoordMaisProxima[1] != 0 and CoordMaisProxima[1] != "") {
		;GeraLog("Achou com Distancia Euclidiana.")
		x := CoordMaisProxima[1]
		y := CoordMaisProxima[2]
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

FilaMetins(qntVezesPassadas := 0) {
	Inicio := A_TickCount
	GeraLog("Depois do Catpcha: " A_TickCount - Inicio)
	;Options = r oTransRed,29 e1 n
	Options = r x-11 y-4 oTransRed,29 e0.1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
	GeraLog("Mais proxima: " CoordMaisProxima[1] "," CoordMaisProxima[2])
	TodasAsCoords := EncontrarCoordenadaOrdenada(listaCordPedras)
	GeraLog("Lista de Coords: " TodasAsCoords)
	if (CoordMaisProxima[1] != 0 and CoordMaisProxima[1] != "") {
		;GeraLog("Achou com Distancia Euclidiana.")
		x := CoordMaisProxima[1]
		y := CoordMaisProxima[2]
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

TaMatandoMetin() {
	Inicio := A_TickCount
	;ImageSearch, OutX, OutY, 701, 359, 957, 818, *40 *TransRed %a_scriptdir%\itemchao.png
	if (ProcuraAteNaoAchar(753, 36, 1122, 92, 50, "vida", 1000)) {
		;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
		GeraLog("Matou a metin em " FormataMilisegundos(A_TickCount - tempoMatarPedra))
		;PegaItensDaMetin()
		if (!EstaFazendoDG)
			qntMetin++
		qntTravado := 0
		return false
	}
	return true
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
	Tecla("g", 60)
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
	WinActivate, Rubinum
	;ClicaRandomDireito(1524, 174, 5, 1)
}

ForaDoCavalo() {
	;f (!ProcuraAteAchar(750, 825, 786, 857, 40, "brilho", 100)) {
	;	if (!ProcuraAteAchar(750, 825, 786, 857, 40, "brilho", 500)) {
	;		Tecla("2")
	;		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\boris.png
	;		if !ErrorLevel {
	;			GeraLog("Fora do cavalo.")
	;			SaiEntraCavalo()
	;			return true
	;		}
	;		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\mount.png
	;		if !ErrorLevel {
	;			GeraLog("Fora do cavalo.")
	;			SaiEntraCavalo()
	;			return true
	;		}
	;	}
	;
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
	if (CanalAtual = 6)
		CanalAtual := 0
	if (!VaiCanal(CanalAtual)) {
		ProximoCanal()
	}
}
#IfWinActive Rubinum
^Numpad0::
ProximoCanal()
return

#IfWinActive Rubinum
^Numpad1::
VaiCanal(1)
return

#IfWinActive Rubinum
^Numpad2::
VaiCanal(2)
return

#IfWinActive Rubinum
^Numpad3::
VaiCanal(3)
return

#IfWinActive Rubinum
^Numpad4::
VaiCanal(4)
return

#IfWinActive Rubinum
^Numpad5::
VaiCanal(5)
return

#IfWinActive Rubinum
^Numpad6::
VaiCanal(6)
return

#IfWinActive Rubinum
^Numpad7::
VaiCanal(7)
return

#IfWinActive Rubinum
^Numpad8::
VaiCanal(8)
return

VaiCanal(canal) {
	GeraLog("Tentando trocar de canal para o " canal)
	Tecla("Enter")
	Tecla("/")
	Tecla("c")
	Tecla("h")
	Tecla(" ")
	Tecla(canal)
	Tecla("Enter")
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
			VoltaPraQuebrarMetin()
		}
	}

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
	if (WinExist("Rubinum")) {
		return true
	}
	else {
		GeraLog("Jogo fechado")
		if (WinExist("ahk_exe Rubinum-Patcher.exe") or WinExist("TORRENT")) {
			GeraLog("Patcher estava aberto, fecha.")
			WinGet, PatcherPID, PID, ahk_exe Rubinum-Patcher.exe
			;GeraLog(PatcherPID)
			Run, taskkill /PID %PatcherPID% /F, , Hide
			WinKill, TORRENT
			EsperaRandom(1500)
		}
		try
		Run, "C:\Users\Tap\Desktop\Rubinum\Rubinum-Patcher.exe"
		catch
			Run, "D:\Desktop\Rubinum\Rubinum-Patcher.exe"
		loop {
			if (WinExist("ahk_exe Rubinum-Patcher.exe") or WinExist("TORRENT")) {
				WinActivate, ahk_exe Rubinum-Patcher.exe
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
							if (WinExist("Rubinum")) {
								GeraLog("Abriu o jogo.")
								EsperaRandom(5000)
								WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Rubinum
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

GiraRoda() {
	ImageSearch, OutX, OutY, 21, 634, 537, 828, *60 *TransRed %a_scriptdir%\spin.png
	if !ErrorLevel{ 
		ClicaRandom(OutX, OutY)
	}

}