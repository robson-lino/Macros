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
global DevilDeuErro := false
global LeroDeuErro := false
global NemereDeuErro := false
global RazadorDeuErro := false
global ErebusDeuErro := false
global AkzadurDeuErro := false
global BaronesaPOS
global DragaoPOS
global TorrePOS
global DevilPOS
global LeroPOS
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
global ultimaVerificaBossDG := A_TickCount - MinToMili(6)
global Aviso := true
global EstaFazendoDG := false
global qntBaronesa := 0
global qntTorre := 0
global qntDevil := 0
global qntLero := 0
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
global temFila := false
global step1
global step2
FormatTime, InicioMacro, D1 T0

;variaveis de entrada
global optConta
global radMetin
global optDG
global optNV
global contTeste := 1
;InputBox, optConta, Qual conta?, 1 ou 2, , 256, 128
;InputBox, radMetin, Volta pra qual metin?, 1:retorno 2:45 3:70, , 256, 128
;InputBox, optDG, Quais DGs?, 0 = nenhuma, , 256, 128
;InputBox, optNV, Qual NV?,Da metin que ta matando, , 256, 128

global optConta
global radMetin
global ChkUpar
global ChkBaronesa
global ChkTorre
global ChkDevil
global ChkLero
global ChkDragao
global ChkNemere
global ChkRazador
global ChkErebus
global ChkAkzadur

Gui Add, Radio, Checked voptConta x24 y8 w70 h23, Conta1
Gui Add, Radio, x152 y8 w70 h23, Conta2
Gui Add, CheckBox, vChkUpar x250 y8 w65 h23, Upar
Gui Add, Button, gInicio x23 y176 w80 h23, Start
Gui Add, Radio, vradMetin x24 y40 w36 h23, 65
Gui Add, Radio, x71 y40 w36 h23, 70
Gui Add, Radio, Checked x119 y40 w36 h23, 90
Gui Add, Radio, x167 y40 w36 h23, 105
Gui Add, CheckBox, Checked vChkBaronesa x24 y80 w65 h23, Baronesa
Gui Add, CheckBox, Checked vChkTorre x96 y80 w65 h23, Torre
Gui Add, CheckBox, Checked vChkDragao x168 y80 w65 h23, Dragao
Gui Add, CheckBox, Checked vChkNemere x240 y80 w65 h23, Nemere
Gui Add, CheckBox, vChkRazador x24 y112 w65 h23, Razador
Gui Add, CheckBox, vChkErebus x96 y112 w65 h23, Erebus
Gui Add, CheckBox, vChkAkzadur x168 y112 w65 h23, Akzadur
Gui Add, CheckBox, Checked vChkDevil x240 y112 w65 h23, Devil
Gui Add, CheckBox, Checked vChkLero x24 y144 w65 h23, Lero

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
	GuiControlGet, ChkDevil
	GuiControlGet, ChkLero
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
		TorrePOS := 1
		BaronesaPOS := 2
		DragaoPOS := 3
		DevilPOS := 4
		LeroPOS := 5
		NemerePOS := 6
		RazadorPOS := 99
		ErebusPOS := 99
		AkzadurPOS := 99
	} else if (optConta = 2) {
		TorrePOS := 1
		BaronesaPOS := 2
		DragaoPOS := 3
		DevilPOS := 4
		LeroPOS := 5
		NemerePOS := 6
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
}
WinActivate, Rubinum
WinActivate, Rubinum
Yjanela := Yjanela+30
Gui Show, w329 h213, Window
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
	else 
		ArrumaMapaCamera0Zoom()
}

8::Pause

ExitFunc() {
	GeraLog("Encerrou")
	FormatTime, FimMacro, D1 T0
	ImprimeInfos()
}

TaDeslogado() {
	JogoAberto()
	Ativa()
	if (RetornaCorPixel(629, 173) = "0x31365B" or RetornaCorPixel( 625, 137) = "0x303659") {
		GeraLog("Estava no Rubinum, meu deus.")
		ClicaRandom(913, 181)
		EsperaRandom(3000)
		Ativa()
		TaDeslogado()
	}
	if (RetornaCorPixel(1032, 722) = "0x2A265C" or RetornaCorPixel(1031, 689) = "0x2A265C") {
		tentativaLogin := 0
		while (true) {
			GeraLog("Estava deslogado")
			deslogou := true
			Tecla("F" . optConta)
			EsperaRandom(5000)
			if ProcuraPixelAteAchar(1111, 784, "0x0D1539", 10000) {
				Tecla("NumpadEnter")
				GeraLog("Conseguiu logar, entra no personagem")
				if ProcuraPixelAteNaoAchar(1111, 784, "0x0D1539", 10000) {
					while (!ProcuraPixelAteNaoAchar(1240, 469, "0xB19C9F", 1000)) {
						GeraLog("Carregando mapa...")
						if (A_Index > 30) {
							FechaJogo()
							return
						}
					}
					if ProcuraPixelAteAchar(1199, 852, "0x111314", 15000) { 
						Sleep, 1000
						deslogou := true
						ZoomPraMatarPedra()
						GeraLog("Logou")
						return
					}
				} else {
					GeraLog("Não conseguiu entrar no personagem")
					FechaJogo()
					break
				}
			}
			GeraLog("Não conseguiu fazer o login.")
			tentativaLogin++
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 %a_scriptdir%\pleasepatch.png
			if (tentativaLogin >= 5 or OutX != "") {
				GeraLog("Tentou mais de 5 vezes ou o client estava desatualizado.")
				FechaJogo()
				break
			}
		} 
	}
	if (RetornaCorPixel(1111, 784) = "0x0D1539") {
		GeraLog("Estava na tela do personagem")
		Tecla("ESC")
		EsperaRandom(3000)
	}
}

GeraLog(msg) {
	if (!log)
		return
	FormatTime, DataFormatada, D1 T0
	FileRead,FileContents, %a_scriptdir%\metinlog%optConta%.log
	FileDelete %a_scriptdir%\metinlog%optConta%.log
	FileAppend, %DataFormatada% - %msg%`n%FileContents%,%a_scriptdir%\metinlog%optConta%.log
	;FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metinlog%optConta%.log
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
	Msg := Msg . "Devil: " . qntDevil . "`r`n"
	Msg := Msg . "Lero: " . qntLero . "`r`n"
	Msg := Msg . "Nemere: " . qntNemere . "`r`n"
	;Msg := Msg . "Razador: " . qntRazador . "`r`n"
	;Msg := Msg . "Erebus: " . qntErebus . "`r`n"
	;Msg := Msg . "Akzadur: " . qntAkzadur . "`r`n"
	Msg := Msg . "Tempo total em DG: " . FormataMilisegundos(tempoTotalDG) . "`r`n"
	Msg := Msg . "QntTravadas: " . qntTravadoTotal . "`r`n"
	;Msg := Msg . "Captcha resolvido: " . captcharesolvido . "`r`n"
	Msg := Msg . "Encerrado em: " . FimMacro . "`r`n"
	Msg := Msg . "-------------------------------------------`r`n"
	Msg := Msg . informacoesAnteriores
	file.Write(Msg)
	file.Close()
}

Player() {
	if (optNV = "DESATIVADO" and !EstaFazendoDG and !deslogou) { 
		Inicio := A_TickCount
		loop, 1 {
			Options = r x-11 y-4 oTransRed,10 e0.1 n
			listaCordPedras := FindClick("\player" A_index ".png", Options)
			TodasAsCoords := EncontrarCoordenadaOrdenada(listaCordPedras)
			if (TodasAsCoords != "") {
				GeraLog("Encontrou algum jogador, vai pro proximo canal. " A_TickCount - Inicio)
				ProximoCanal()
				return
			}
		}
		;GeraLog("Procura player: " A_TickCount - Inicio)
	}
}

Inicio:
log := true
PegaControles()
WinActivate, Rubinum
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
		;VoltaPraQuebrarMetin()
	}
	if (MatandoMetins()){
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

EsperaMatar(ClicaProximaMetin = false) {
	Achou := true
	SetTimer PegaItens, off
	jaEntrou := false
	SeguraTecla("e")
	if (ProcuraAteAchar(687, 389, 856, 488, 50, "metinpedra", 3000)) {
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		tempoMatarPedra := A_TickCount
		if (!jaEntrou and optNV != "" and !EstaFazendoDG){
			jaEntrou := true
			CimaMetin(optNV)
		}
		if (ClicaProximaMetin)
			ColocaMetinFila()
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
			;PegaItens()
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
		if (Mod(qntTravado,2) = 0)
			Tecla("d", 500)
		else 
			Tecla("a", 500)
		Tecla("s", 300)
		GiraAteAcharMetin()
		VaiAteMetin()
	}
	SetTimer PegaItens, 500, ON, 3
	ImprimeInfos()
}

Verifica() {
	;Inicio := A_TickCount
	Ativa()
	JogoAberto()
	TaDeslogado()
	Morto()
	Player()
	;TiraQuests()
	Mensagens()
	Biologo()
	;AtivaSkill()
	;ForaDoCavalo()
	if (!ChkUpar)
		AnelXP()
	;CaptchaMaldito()
	GiraRoda()
	ClicaNoNao()
	ErroRuntime()
	;VerificaNaoEssenciais()
	if (!EstaFazendoDG)
		VerificaBossDGs()
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
		;EquipaLuva()
		;Tecla("2")
		;EsperaRandom(500)
		;Tecla("2")
		;ForaDoCavalo()
		;ClicaRandom(1481, 131)
		;EsperaRandom(500)
		;MoveMouse(1393, 483)
		;Biologo()
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
		;GeraLog("Não deu o tempo do verifica DG.")
		if (tempoDeVerificaDG-((A_tickcount - ultimaVerificaBossDG)) < MinToMili(2) and Aviso) {
			GeraLog("Faltam menos de 2 minutos para fazer as DGs")
			Aviso := false
		}
	}
}

fY(y)
{
	if (y < 150) {
		return 40
	} else if (y >= 150 && y <= 900) {
		return -50 * (y - 600) // 600
	} else {
		return 0
	}
}

fX(x)
{
	if (x < 500) {
		return 70
	} else if (x <= 850) {
		return 45
	} else if (x > 850 and x <= 1000) {
		return 22
	} else if (x > 1000 and x <= 1250) {
		return 15
	} else if (x > 1250) {
		return -5
	}
}

0::
log := true
PegaControles()
JogoAberto()
Verifica()
While (true) {
	EsperaFisgar()
}
return

EsperaFisgar()
{
	Tecla("space")
	ProcuraAteAchar(650, 315, 954, 578, 20, "pescaria", 1000)
	ImageSearch, OutX, OutY, 650, 315, 954, 578, *20 %a_scriptdir%\pescaria.png
	while (!ErrorLevel)
	{
		GeraLog("na janela")
		ImageSearch, OutX, OutY, 723, 392, 885, 534, *50 %a_scriptdir%\vermelho.png
		if !ErrorLevel
		{
			GeraLog("Peixe dentro do alvo")
            Sleep, 30
			;ImageSearch, OutX, OutY, 744, 415, 879, 556, *20 %a_scriptdir%\peixe.png
			PixelSearch, OutX, OutY, 719, 393, 885, 528, 0x7B5D3A, 5, fast
            if !ErrorLevel
                ClicaRandom(OutX, OutY, 3)
		}
		ImageSearch, OutX, OutY, 650, 315, 954, 578, *20 %a_scriptdir%\pescaria.png
	}
}

9::
; TESTE
log := true
PegaControles()
JogoAberto()
;Verifica()
Devil1Metin()
PisoPadraoBossNome("2.1","hell")
PisoPadraoBoss("2.2")
Devil3Spawn()
DevilFinal()
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
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *70 *TransRed %a_scriptdir%\mapametin2.png
	if ErrorLevel {
		SeguraTecla("e")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 70, "mapametin2", 4000)) {
			MoveMouse(AchouOutX, AchouOutY)
			ImageSearch, OutX, OutY, Xjanela, Yjanela-60, Wjanela-80, Hjanela, 40 *TransRed %a_scriptdir%\metinpedra.png
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
	Options = r x-11 y-4 oTransRed,29 e0.1 n
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
		Verifica()
		qntVezesPassadas := 0
	}
	return false
}

MatandoMetins() {
	While (true) {
		Verifica()
		Inicio := A_TickCount
		qntVezesPassadas := 0
		While (!temFila) {
			if (ColocaMetinFila()) {
				break
			} else if (qntVezesPassadas < 2 and optNV != "") {
				qntVezesPassadas++
				SeguraTecla("e")
				EsperaRandom(300)
				SoltaTecla("e")
				EsperaRandom(500)
				GeraLog("Não achou metin mais perto: " qntVezesPassadas)
				CimaMetin(optNV)
			} else {
				GeraLog("Em branco ou " qntVezesPassadas " passada, anda até metin.")
				qntVezesPassadas := 0
				temFila := false
				return false
			}
		}
		; Se chegou aqui, conseguiu colocar metin na fila.
		Inicio := A_TickCount
		Achou := true
		jaEntrou := false
		SeguraTecla("e")
		ImprimeInfos()
		;if (ProcuraAteAchar(687, 389, 856, 488, 50, "metinpedra", 3000)) {
		if (ProcuraAteAchar(680, 367, 836, 480, 50, "metinpedra", 3000)) {
			Tecla("3")
			Sleep, 50
			SoltaTecla("e")
			tempoMatarPedra := A_TickCount
			if (!jaEntrou and optNV != "" and !EstaFazendoDG){
				jaEntrou := true
				CimaMetin(optNV)
			}
			ColocaMetinFila()
			while (TaMatandoMetin()) {
				GeraLog("Matando a metin...")
				Tecla("3")
				if (A_index > 5) {
					ImageSearch, OutX, OutY, 753, 36, 1122, 92, *50 %a_scriptdir%\vidacheia.png
					if !ErrorLevel {
						CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/vidacheia/" A_now ".png")
						GeraLog("Saiu pela a vida cheia")
						ClicaRandom(808, 447, 1)
						Verifica()
						Achou := false
						break
					}
				}
			}
			if (!Achou) {
				Tecla(1)
				qntTravado++
				qntTravadoTotal++
				;PegaItens()
				ClicaRandom(805, 450)
				GeraLog("Nao achou, travado: " qntTravado)
				;ClicaRandom(807, 447, 15)
				Tecla("d", 500)
				Tecla("s", 300)
			}
		} else {
			temFila := false
			SoltaTecla("e")
			Verifica()
			qntTravado++
			qntTravadoTotal++
			if (qntTravado > 1) {
				GeraLog("Não conseguiu chegar perto da metin, travado: " qntTravado)
				if (Mod(qntTravado,2) = 0)
					Tecla("d", 500)
				else 
					Tecla("a", 500)
				Tecla("s", 300)
				Tecla("s", 300)
				if (qntTravado > 10)
					VoltaPraQuebrarMetin()
				GiraAteAcharMetin()
				VaiAteMetin()
			} else {
				ColocaMetinFila()
			}
		}
	}
}

ColocaMetinFila(qntVezesPassadas := 0, qnts = 1) {
	Options = r x-11 y+4 oTransRed,29 e0.1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	TodasAsCoords := EncontrarCoordenadaOrdenada(listaCordPedras)
	if (TodasAsCoords != "") {
		SeguraTecla("LShift")
		Loop, parse, TodasAsCoords, `n, `r
		{
			if (A_Index > qnts)
				break
			coord := StrSplit(A_LoopField, ",")
			x := coord[1]
			y := coord[2]
			;PegaItens()
			loop, 2
			{
				ClicaRandom(x+fX(x), y+fY(y), 1, 1, 1)
			}
			GeraLog("Colocou metin na fila.")
		}
		SoltaTecla("LShift")
		temFila := true
		return true
	} 
	temFila := false
	return false
}

ProximaMetinFila(qntVezesPassadas := 0, qnts = 1) {
	Inicio := A_TickCount
	;Options = r oTransRed,29 e1 n
	Options = r x-11 y-4 oTransRed,29 e0.1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	TodasAsCoords := EncontrarCoordenadaOrdenada(listaCordPedras)
	if (TodasAsCoords != "") {
		SeguraTecla("LShift")
		Loop, parse, TodasAsCoords, `n, `r
		{
			if (A_Index > 1)
				break
			coord := StrSplit(A_LoopField, ",")
			x := coord[1]
			y := coord[2]
			;PegaItens()
			ClicaRandom(x+fX(x), y+fY(y), 0, 70, 1)
			GeraLog("Pxoima na fila: " A_TickCount - Inicio)
		}
		SoltaTecla("LShift")
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

TaMatandoMetin() {
	Inicio := A_TickCount
	;ImageSearch, OutX, OutY, 701, 359, 957, 818, *40 *TransRed %a_scriptdir%\itemchao.png
	if (ProcuraAteNaoAchar(753, 36, 1122, 92, 50, "vida", 2000)) {
		;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
		GeraLog("Matou a metin em " FormataMilisegundos(A_TickCount - tempoMatarPedra))
		if (!EstaFazendoDG)
			qntMetin++
		qntTravado := 0
		return false
	}
	return true
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
	}
	Tecla("NumpadSub", 70)
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
	ImageSearch, OutX, OutY, 1412, 150, 1595, 804, *50 *TransRed %a_scriptdir%\pmbiologo.png
	if !ErrorLevel{
		GeraLog("Achou o PM do biologo")
		SeguraTecla("LControl")
		ClicaRandom(OutX, OutY)
		SoltaTecla("LControl")
		ImageSearch, OutX, OutY, 1465, 40, 1514, 67, *50 *TransRed %a_scriptdir%\biologo.png
		if !ErrorLevel{
			ClicaRandom(OutX, OutY)
			If (ProcuraPixelAteAchar(877, 317, "0x0A285D", 1000)) {
				while (RetornaCorPixel(793, 549) != "0x252537") {
					ClicaRandom(867, 495)
					EsperaRandom(1500)	
					if (A_Index > 10) {
						FechaX()
						return
					}
				}
			}
			FechaX()
			GeraLog("Entregou Biologo")
		}
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
	loop, 3 {
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
		CanalAtual := 1
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
	loop, 3 {
		FechaX()
	}
	Tecla("x")
	while (!ProcuraPixelAteAchar(851, 392, "0x0B285F", 1000)) {
		Tecla("x")
		if (A_Index > 5) {
			GeraLog("Tentou abrir 5 vezes os canais.")
			loop, 3 {
				FechaX()
			}
			Tecla("Enter")
			Tecla("/")
			Tecla("c")
			Tecla("h")
			Tecla(" ")
			Tecla(canal)
			break
		}
	}
	pTam := 28
	ClicaRandom(802, (427-pTam)+(pTam*canal))
	if (TrocouMapa()) {
		CanalAtual := canal
		GeraLog("Foi pro Canal " CanalAtual " com sucesso.")
		Sleep, 2000
		loop, 3 {
			FechaX()
		}
		return true
	}
	else {
		GeraLog("Falhou em trocar para o canal " canal)
		loop, 3 {
			FechaX()
		}
		return false
	}
}

VoltaPraQuebrarMetin() {
	deuCerto := false
	while (!deuCerto) {
		Verifica()
		GeraLog("Voltando para quebrar a metin de nivel " optNv)
		if (radMetin = 1) {
		} else if (radMetin = 2)
			deuCerto := TeleportaAnel([5,5,"E",2])
		else if (radMetin = 3)
			;deuCerto := TeleportaAnel([5,"E",1,"E",5])
			deuCerto := TeleportaAnel([5,"E",1,"E","E",2])
		else if (radMetin = 4)
			;deuCerto := TeleportaAnel([6,1,"E",3])
			deuCerto := TeleportaAnel([6,2,4])
	}
	ZoomPraMatarPedra()
	CanalAtual := 1
	ProximoCanal()
	GeraLog("Conseguiu com sucesso voltar para metin.")
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
	if (ChkDevil)
		FezAlgum += Devil()
	if (ChkLero)
		FezAlgum += Lero()
	if (ChkDragao)
		FezAlgum += Dragao()
	if (ChkNemere)
		FezAlgum += Nemere()
	;if (ChkRazador)
	;	FezAlgum += Razador()
	;if (ChkErebus)
	;	FezAlgum += Erebus()
	EstaFazendoDG := false
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
		VaiPraCidadeRed()
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
		VaiPraCidadeRed()
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
		while (true) {
			if (ProcuraImgBanner("1"))
				Break
			if (A_Index > 5)
				return 1
		}
		if !PisoPadraoBoss("1")
			return 1
		if !PisoPadraoMetin("2")
			return 1
		if !PisoPadraoBoss("3")
			return 1
		if !PisoPadraoBoss("4")
			return 1
		if !PisoPadraoBoss("5")
			return 1
		if !PisoPadraoBoss("6.1")
			return 1
		if !PisoPadraoMetin("6.2")
			return 1
		if !PisoPadraoBoss("8")
			return 1
		NemerePiso9()
		if (NemereDeuErro)
			return 1
		if !PisoPadraoBoss("final")
			return 1
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioNemere
		qntNemere++
		GeraLog("---------------- Terminou Nemere em " FormataMilisegundos(A_TickCount - InicioNemere) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

NemerePiso9() {
	GeraLog("Piso9")
	while (ProcuraAteAchar(494, 135, 1135, 164, 50, "9", 1500)) {
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
		InicioDragao := A_TickCount
		while (true) {
			if (ProcuraImgBanner("1.1"))
				Break
			if (A_Index > 5)
				return 1
		}
		ArrumaMapaCamera1Zoom()
		if !PisoPadraoMetin("1.1")
			return 1
		if !PisoPadraoBossNome("1.2","witch")
			return 1
		if !PisoPadraoMetin("2.1")
			return 1
		if !PisoPadraoBossNome("2.2","witch")
			return 1
		if !PisoPadraoMetin("3")
			return 1
		if !PisoPadraoBoss("final")
			return 1
		ZoomPraMatarPedra()
		qntDragao++
		tempoTotalDG += A_TickCount - InicioDragao
		GeraLog("---------------- Terminou Dragao em " FormataMilisegundos(A_TickCount - InicioDragao) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

Dragao12Boss() {
	while (ProcuraImgBanner("1.2")) {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 *TransBlue %a_scriptdir%\witch.png
		if (!ErrorLevel) {
			ClicaRandom(OutX, OutY)
			EsperaRandom(2000)
			while (ProcuraImgBanner("1.2")) {
				GeraLog("Matando os bosses...")
				CicloMataAlgo()
				if (A_index > 40) {
					DevilDeuErro := true
					return false
				}
			}
		}
		SeguraTecla("e")
		EsperaRandom(500)
		SoltaTecla("e")
		if (A_index > 40) {
			DevilDeuErro := true
			return false
		}
	}
	GeraLog("Matou o boss.")
	return true
}

; FIM DRAGAO

AbreF7() {
	ImageSearch, OutX, OutY, 495, 167, 1141, 738, *50 %a_scriptdir%\temporizador.png
	if ErrorLevel {
		Tecla("F7")
		if (!ProcuraAteAchar(495, 167, 1141, 738, 50, "temporizador", 1500)) {
			GeraLog("Não abriu o F7, tenta de novo.")
			Verifica()
			return false
		} else {
			EsperaRandom(2500)
			return true
		}
	} else {
		return true
	}
}
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
		while (true) {
			if (ProcuraImgBanner("torrepiso1"))
				Break
			if (A_Index > 5)
				return 1
		}
		ArrumaMapaCamera1Zoom()
		TorrePiso1Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso12MataBoss()
		if (TorreDeuErro)
			return 1
		if !PisoPadraoMetin("torrepiso2")
			return 1
		TorrePiso22MataBoss()
		if (TorreDeuErro)
			return 1
		TorrePiso3Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso32Metin()
		if (TorreDeuErro)
			return 1
		TorrePiso33MataBoss()
		if (TorreDeuErro)
			return 1
		TorrePiso34MataTudo()
		if (TorreDeuErro)
			return 1
		TorrePisoFinal()
		if (TorreDeuErro)
			return 1
		tempoTotalDG += A_TickCount - InicioTorre
		qntTorre++
		ZoomPraMatarPedra()
		GeraLog("---------------- Terminou Torre em " FormataMilisegundos(A_TickCount - InicioTorre) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

TorrePiso1Metin() {
	GeraLog("Piso1")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraImgBanner("torrepiso1")) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			ClicaRandom(x+fX(x), y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 60) {
			TorreDeuErro := true
			return
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso12MataBoss() {
	while (ProcuraImgBanner("torrepiso12")) {
		GeraLog("Matando o boss...")
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
			TorreDeuErro := true
			return
		}
	}
	GeraLog("Matou o boss.")
}

TorrePiso2Metin() {
	GeraLog("Piso2")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraImgBanner("torrepiso2")) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			ClicaRandom(x+fX(x), y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 100) {
			TorreDeuErro := true
			return
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso22MataBoss() {
	while (ProcuraImgBanner("torrepiso22")) {
		GeraLog("Matando o boss...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(300)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			TorreDeuErro := true
			return
		}
	}
	GeraLog("Matou o boss.")
}

TorrePiso3Metin() {
	GeraLog("Piso3")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraImgBanner("torrepiso3")) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			ClicaRandom(x+fX(x), y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 60) {
			TorreDeuErro := true
			return
		}
		
		if (ProcuraImgBanner("3.2")) {
			GeraLog("Matou todas.")
			return true
		}
		if (ProcuraImgBanner("torrepiso33")) {
			GeraLog("Matou todas.")
			return true
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso32Metin() {
	GeraLog("Piso32")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraImgBanner("3.2")) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			ClicaRandom((x+fX(x))-15, y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
		}
		if (A_index > 60) {
			TorreDeuErro := true
			return
		}
		if (ProcuraImgBanner("torrepiso33")) {
			GeraLog("Matou todas.")
			return true
		}
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

TorrePiso33MataBoss() {
	while (ProcuraImgBanner("torrepiso33")) {
		GeraLog("Matando o boss...")
		Tecla("3")
		SeguraTecla("Space")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(300)
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			TorreDeuErro := true
			return
		}
	}
	GeraLog("Matou o boss.")
}

TorrePiso34MataTudo() {
	GeraLog("Piso34")
	while (ProcuraImgBanner("torrepiso34")) {
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

TorrePisoFinal() {
	while (ProcuraImgBanner("torrepisofinal")) {
		GeraLog("Matando o boss...")
		Tecla("3")
		SeguraTecla("Space")
		SeguraTecla("e")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(1000)
		Tecla("3")
		EsperaRandom(10000)
		SoltaTecla("e")
		SoltaTecla("Space")
		Verifica()
		if (A_index > 40) {
			BaronesaDeuErro := true
			return
		}
		if (ProcuraImgBanner("torrepisofinal11")) 
			break
	}
	GeraLog("Matou o boss.")
}
; FIM TORRE

CicloMataAlgo() {
	Tecla("3")
	SeguraTecla("Space")
	SeguraTecla("w")
	SeguraTecla("e")
	EsperaRandom(2500)
	Tecla("3")
	EsperaRandom(2500)
	SoltaTecla("Space")
	SoltaTecla("w")
	SoltaTecla("e")
	Verifica()
}

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
		InicioBaronesa := A_TickCount
		while (true) {
			if (ProcuraImgBanner("baronesainicio"))
				Break
			if (A_Index > 5)
				return 1
		}
		ArrumaMapaCamera1Zoom()
		BaronesaPiso1MataBoss()
		if (BaronesaDeuErro)
			return 1
		BaronesaPiso2MataBoss()
		if (BaronesaDeuErro)
			return 1
		ZoomPraMatarPedra()
		tempoTotalDG += A_TickCount - InicioBaronesa
		qntBaronesa++
		GeraLog("---------------- Terminou Baronesa em " FormataMilisegundos(A_TickCount - InicioBaronesa) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

BaronesaPiso1MataBoss() {
	while (ProcuraImgBanner("baronesainicio")) {
		GeraLog("Matando o boss...")
		CicloMataAlgo()
		if (A_index > 40) {
			BaronesaDeuErro := true
			return
		}
	}
	GeraLog("Matou o boss.")
}

BaronesaPiso2MataBoss() {
	while (ProcuraImgBanner("baronesafinal")) {
		GeraLog("Matando o boss...")
		CicloMataAlgo()
		if (A_index > 40) {
			BaronesaDeuErro := true
			return
		}
		if (!ProcuraImgBanner("baronesafinal1")) 
			break
	}
	GeraLog("Matou o boss.")
}
; FMI BARONESA

; DEVIL

Devil() {
	Inicio := A_TickCount
	DevilDeuErro := false
	Ativa()
	if (PodeEntrarDG(DevilPOS)) {
		GeraLog("---------------- Devil ---------------")
		if (!EntraDG(DevilPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(DevilPOS)) {
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (DevilDeuErro)
			return 1
		InicioDevil:= A_TickCount
		while (true) {
			if (ProcuraImgBanner("devil1"))
				Break
			if (A_Index > 5)
				return 1
		}
		ArrumaMapaCamera1Zoom()
		Devil1Metin()
		if (DevilDeuErro)
			return 1
		if !PisoPadraoBossNome("2.1","hell")
			return 1
		if !PisoPadraoBoss("2.2")
			return 1
		Devil3Spawn()
		if (DevilDeuErro)
			return 1
		DevilFinal()
		if (DevilDeuErro)
			return 1
		tempoTotalDG += A_TickCount - InicioDevil
		qntDevil++
		ZoomPraMatarPedra()
		GeraLog("---------------- Terminou Devil em " FormataMilisegundos(A_TickCount - InicioDevil) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

Devil1Metin() {
	GeraLog("Piso1")
	ArrumaMapa2Zoom()
	Sleep, 1500
	while (ProcuraImgBanner("devil1")) {
		GeraLog("Matando metins...")
		Options = r oTransRed,29 e1 n
		listaCordPedras := FindClick("\metinpedra.png", Options)
		CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
		if (CoordMaisProxima[1] != 0) {
			x := CoordMaisProxima[1]
			y := CoordMaisProxima[2]
			ClicaRandom(x+fX(x), y+fY(y), 0)
			Verifica()
			EsperaMatar()
		} else {
			if (ProcuraImgBanner("devil2")) 
				break
			Verifica()
			GiraAteAcharMetin()
			if (ProcuraImgBanner("devil2")) 
				break
			VaiAteMetin()
		}
		if (A_index > 60) {
			DevilDeuErro := true
			return
		}
		if (ProcuraImgBanner("devil2")) 
			break
	}
	GeraLog("Matou todas.")
	ArrumaMapa1Zoom()
	return true
}

Devil2Boss() {
	while (ProcuraImgBanner("devil2")) {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 *TransBlue %a_scriptdir%\hell.png
		if (!ErrorLevel) {
			ClicaRandom(OutX, OutY)
			EsperaRandom(2000)
			while (ProcuraImgBanner("devil2")) {
				GeraLog("Matando os bosses...")
				CicloMataAlgo()
				if (A_index > 40) {
					DevilDeuErro := true
					return
				}
			}
		}
		SeguraTecla("e")
		EsperaRandom(500)
		SoltaTecla("e")
		if (A_index > 40) {
			DevilDeuErro := true
			return
		}
	}
	GeraLog("Matou o boss.")
}

Devil3Spawn() {
	GeraLog("Comecou o stage 3 de spawn")
	while (ProcuraImgBanner("devil3")) {
		achoumetin := false
		ImageSearch, OutX, OutY, Xjanela, Yjanela-60, Wjanela-80, Hjanela, *30 *TransRed %a_scriptdir%\metinpedra.png
		if !ErrorLevel {
			achoumetin := true
			while (true) {
				GeraLog("Matando metins...")
				Options = r oTransRed,29 e1 n
				listaCordPedras := FindClick("\metinpedra.png", Options)
				CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
				if (CoordMaisProxima[1] != 0) {
					x := CoordMaisProxima[1]
					y := CoordMaisProxima[2]
					ClicaRandom(x+fX(x), y+fY(y), 0)
					Verifica()
					EsperaMatar()
				} else {
					break
				}
				if (A_index > 40) {
					DevilDeuErro := true
					return
				}
			}
		}
		if (!ProcuraImgBanner("devil3"))
			break
		GeraLog("Matando os bosses...")
		vezes := 0
		SeguraTecla("Space")
		SeguraTecla("w")
		SeguraTecla("e")
		while (true) {
			EsperaRandom(1000)
			vezes++
			ImageSearch, OutX, OutY, Xjanela, Yjanela-60, Wjanela-80, Hjanela, *30 *TransRed %a_scriptdir%\metinpedra.png
			if !ErrorLevel or vezes > 4
				break
			Tecla("3")
		}
		SoltaTecla("w")
		SoltaTecla("Space")
		SoltaTecla("e")
		Verifica()
		if (A_index > 60) {
			DevilDeuErro := true
			return
		}
		if (A_index > 5) {
			GiraAteAcharMetin()
			VaiAteMetin()
		}
	}
	GeraLog("Terminou stage 3")
}

DevilFinal() {
	while (ProcuraImgBanner("devilfinal")) {
		GeraLog("Matando o boss...")
		CicloMataAlgo()
		if (A_index > 40) {
			DevilDeuErro := true
			return
		}
		if (ProcuraImgBanner("devilfinal1")) 
			break
	}
	GeraLog("Matou o boss.")
}

; FIM DEVIL

; INICIO LERO

Lero() {
	Inicio := A_TickCount
	LeroDeuErro := false
	Ativa()
	if (PodeEntrarDG(LeroPOS)) {
		GeraLog("---------------- Lero ---------------")
		if (!EntraDG(LeroPOS)) {
			return 1
		}
		EsperaRandom(1000)
		if (PodeEntrarDG(LeroPOS)) {
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
		Verifica()
		if (LeroDeuErro)
			return 1
		InicioLero:= A_TickCount
		while (true) {
			if (ProcuraImgBanner("1.1"))
				Break
			if (A_Index > 5)
				return 1
		}
		ArrumaMapaCamera1Zoom()
		if !PisoPadraoMetin("1.1")
			return 1
		if !PisoPadraoBoss("1.2")
			return 1
		if !PisoPadraoMetin("2.1")
			return 1
		if !PisoPadraoBoss("2.2")
			return 1
		if !PisoPadraoMetin("3.1")
			return 1
		if !PisoPadraoBoss("3.2")
			return 1
		if !PisoPadraoBoss("3.3")
			return 1
		if !PisoPadraoBoss("final")
			return 1
		tempoTotalDG += A_TickCount - InicioLero
		qntLero++
		ZoomPraMatarPedra()
		GeraLog("---------------- Terminou Lero em " FormataMilisegundos(A_TickCount - InicioLero) " ---------------")
		VaiPraCidadeRed()
		return 1
	}
	return 0
}

;FIM LERO

PisoPadraoMetin(piso) {
	GeraLog("Inicio do Piso " piso)
	while (ProcuraImgBanner(piso)) {
		GeraLog("Matando metins...")
		EsperaRandom(500)
		if (ColocaMetinFila()) {
			EsperaMatar(true)
		} else {
			Verifica()
			if !ProcuraImgBanner(piso)
				break
			GiraAteAcharMetin()
			if !ProcuraImgBanner(piso)
				break
			VaiAteMetin()
		}
		if (A_index > 60) {
			return false
		}
	}
	GeraLog("Matou todas do Piso " piso)
	return true
}

PisoPadraoBoss(piso) {
	GeraLog("Inicio do piso " piso)
	while (ProcuraImgBanner(piso)) {
		GeraLog("Matando o boss...")
		CicloMataAlgo()
		if (A_index > 40) {
			return false
		}
	}
	GeraLog("Matou o boss do " piso)
	return true
}

PisoPadraoBossNome(piso, nome) {
	GeraLog("Inicio do Piso " piso)
	while (ProcuraImgBanner(piso)) {
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *40 *TransBlue %a_scriptdir%\%nome%.png
		if (!ErrorLevel) {
			ClicaRandom(OutX, OutY)
			EsperaRandom(2000)
			while (ProcuraImgBanner(piso)) {
				GeraLog("Matando os bosses...")
				CicloMataAlgo()
				if (A_index > 40) {
					DevilDeuErro := true
					return false
				}
			}
		}
		SeguraTecla("e")
		EsperaRandom(500)
		SoltaTecla("e")
		if (A_index > 40) {
			DevilDeuErro := true
			return false
		}
	}
	GeraLog("Matou o boss " nome " do piso " piso)
	return true
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
	Random, step1aux, 1,3
	Random, step2aux, 1,4
	while (step1aux = step1)
		Random, step1aux, 1,3
	step1 := step1aux
	step2 := step2aux
	While (!TeleportaAnel([step1,step2], false)) {
		if (A_Index > 5)
			return
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
	if (nv != "DESATIVADO")
		return false
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
	if WinExist("ahk_exe rbclient.exe") {
		return true
	}
	else {
		FechaJogo()
		try
			Run, % A_ScriptDir "\RubinumClient" optConta "\RubinumLauncher.exe"
		catch {
			Run, "D:\Desktop\Rubinum\Rubinum-Patcher.exe"
			return false
		}
		loop {
			if (WinExist("ahk_exe RubinumLauncher.exe") or WinExist("TORRENT")) {
				WinActivate, ahk_exe RubinumLauncher.exe
				GeraLog("Abriu o Launcher")
				InicioAtualizacao := A_TickCount
				while ((A_TickCount - InicioAtualizacao) < MinToMili(20)) {
					WinActivate, ahk_exe RubinumLauncher.exe
					if (ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 10, "start", 100)) {
						GeraLog("Pronto para inicar")
						EsperaRandom(1000)
						MouseClick, left, AchouOutX, AchouOutY
						InicioCarregandoJogo := A_TickCount
						while ((A_TickCount - InicioCarregandoJogo) < MinToMili(10)) {
							if WinExist("ahk_exe rbclient.exe") {
								GeraLog("Abriu o jogo.")
								ProcuraPixelAteAchar(1032, 722, "0x2A265C", 10000)
								WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Rubinum
								Yjanela := Yjanela+30
								GeraLog("Fecha Patch")
								loop, 5 
								{
									WinGet, PatcherPID, PID, ahk_exe RubinumLauncher.exe
									;GeraLog(PatcherPID)
									Run, taskkill /PID %PatcherPID% /F, , Hide
									WinKill, TORRENT
								}
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
					if (!ProcuraPixelAteNaoAchar(951, 551, "0x262626", 1000)) {
						GeraLog("Atualizando...")
					} else {
						GeraLog("Terminou de atualizar.")
					} if (ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 10, "erroatt", 100)) {
						Tecla("Enter")
					}
				}
				GeraLog("Deu ruim... Demorou mais de 20 miuntos pra atualizar a merda do patch.")
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

CalcularQuadrado(x, y, tamanho) {
    metade_tamanho := tamanho / 2
    x1 := x - metade_tamanho
    y1 := y - metade_tamanho
    x2 := x + metade_tamanho
    y2 := y + metade_tamanho
    retorno := { "x1": x1, "y1": y1, "x2": x2, "y2": y2 }
    return retorno
}

TestaMira() {
	MouseGetPos, x, y
	resultado := CalcularQuadrado(x, y, 200)
	x1 := resultado["x1"]
	y1 := resultado["y1"]
	x2 := resultado["x2"]
	y2 := resultado["y2"]
	ImageSearch, OutX, OutY, x1, y1, x2, y2, *30 *TransRed %a_scriptdir%\metinpedra.png
	GeraLog("Original: " OutX ", " OutY)
	GeraLog("Calculado: " OutX+fX(OutX) ", " OutY+fY(OutY))
	MoveMouse(OutX+fX(OutX), OutY+fY(OutY))
}

SelecionaDG(pos) {
	ClicaRandom(799, (287-60)+(pos*60))
}

PodeEntrarDG(pos) {
	if (!AbreF7())
		return false
	x := 799
	y := 287
	espaco := 61
	ClicaRandom(x, (y-espaco)+(pos*espaco), 0)
	corRetornada := RetornaCorPixel(x, (y-espaco)+(pos*espaco))
	GeraLog("Cor Retornada: " corRetornada)
	if (SubStr(corRetornada,3,2) >= 21) {
		GeraLog("Pode fazer DG " pos)
		return true
	} else {
		GeraLog("Não pode fazer DG " pos)
		return false
	}
}

EntraDG(pos) {
	if (!AbreF7())
		return false
	SelecionaDG(pos)
	EsperaRandom(500)
	ClicaRandom(933, 678)
	if (ProcuraAteAchar(518, 194, 1090, 701, 60, "sim", 1500)) {
		GeraLog("Clicou no sim.")
		ClicaRandom(AchouOutX, AchouOutY)
		return TrocouMapa()
	} else {
		GeraLog("Não conseguiu entrar na DG: " pos)
		FechaX()
		VaiPraCidadeRed()
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

GiraRoda() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\spin.png
	if !ErrorLevel{ 
		ClicaRandom(OutX, OutY)
	}
}

ClicaNoNao() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\no.png
	if !ErrorLevel{ 
		ClicaRandom(OutX, OutY)
	}
}

ErroRuntime() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 *TransRed %a_scriptdir%\errort.png
	if !ErrorLevel{ 
		ClicaRandom(OutX, OutY)
	}
}



TeleportaAnel(lista, city = true) {
	; Sempre vai pra city pra mostrar que deu TP.
	if (city) {
		Random, step1aux, 1,3
		Random, step2aux, 1,4
		while (step1aux = step1)
			Random, step1aux, 1,3
		step1 := step1aux
		step2 := step2aux
		GeraLog("Indo para cidade primeiro.")
		if (!TeleportaAnel([step1,step2], false)) {
			return false
		} else 
			return TeleportaAnel(lista, false)
	} else {
		Tecla(4)
		while (!ProcuraPixelAteAchar(874, 280, "0x092559", 1000)) {
			Tecla(4)
			if (A_Index > 5) {
				GeraLog("Tentou abrir 5 vezes o anel.")
				Verifica()
				return false
			}
		}
		if ProcuraPixelAteAchar(874, 280, "0x092559", 1000) {
			GeraLog("Iniciando teleporte")
			loop, 10 {
				Tecla("Q", 100)
			}
			for index, item in lista {
				Tecla(item, 100)
				EsperaRandom(300)
			}
			if (TrocouMapa()) {
				GeraLog("Conseguiu trocar de mapa.")
				return true
			} else { 
				GeraLog("Nao conseguiu trocar de mapa.")
				return false
			}
		} else {
			GeraLog("Não conseguiu abrir o anel.")
			return false
		}
	}
}

TrocouMapa() {
	GeraLog("Esperando ir para o local desejado.")
	if ProcuraPixelAteNaoAchar(1199, 852, "0x111314", 5000)	{
		GeraLog("Esperando carregar.")
		if ProcuraPixelAteAchar(1199, 852, "0x111314", 15000) {
			GeraLog("Teleporte com sucesso.")
			return true
		}
		GeraLog("Não carregou.")
		Verifica()
		if (deslogou) {
			return true
		}
		return false
	}
	GeraLog("Não começou o teleporte.")
	Verifica()
	return false
}

FechaJogo() {
	GeraLog("Jogo fechado")
	if (WinExist("ahk_exe RubinumLauncher.exe") or WinExist("TORRENT")) {
		GeraLog("Patcher estava aberto, fecha.")
		loop, 5 
		{
			WinGet, PatcherPID, PID, ahk_exe RubinumLauncher.exe
			;GeraLog(PatcherPID)
			Run, taskkill /PID %PatcherPID% /F, , Hide
			WinKill, TORRENT
		}
		EsperaRandom(5000)
	}
	if (WinExist("ahk_exe rbclient.exe")) {
		GeraLog("Jogo estava aberto, fecha.")
		loop, 5 
		{
			WinGet, JogoPID, PID, ahk_exe rbclient.exe
			;GeraLog(PatcherPID)
			Run, taskkill /PID %JogoPID% /F, , Hide
			WinKill, TORRENT
		}
		EsperaRandom(5000)
	}
}

ProcuraImgBanner(img) {
	return ProcuraAteAchar(8, 119, 1598, 179, 45, img, 3000)
}