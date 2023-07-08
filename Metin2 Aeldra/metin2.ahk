; 1.0.1

#SingleInstance Force
#MaxThreads 2
#Persistent ; (Interception hotkeys do not stop AHK from exiting, so use this)
#include Lib\AutoHotInterception.ahk
SetKeyDelay, 50, 50
#Include %A_LineFile%\..\JSON.ahk
#Include, Lib\CaptureScreen.ahk
#Include Lib\funcoes.ahk
#Include Lib\FindClick.ahk
SendMode Input

OnExit("ExitFunc")

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window
global itensCaptcha := "pedra,escudo,peixe,colar,deus,elmo,armadura,arma,pulseira,orvalho,pocao,brincos,sapatos"
global listaPeixes := "p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25"
global Conta
global Conta1,Conta2,Conta3
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
global AbaInv := 0
global ItemInvOutX, ItemInvOutY
global listaCordPedras
global tempoDeNaoEssenciais := MinToMili(10)
global tempoDeVerificaDG := MinToMili(5)
global ultimaVerificaNaoEssenciais := A_TickCount - MinToMili(9)
global ultimaVerificaBossDG := A_TickCount - MinToMili(5)
global Aviso := true
global EstaFazendoDG := false
global qntBaronesa := 0
global qntTorre := 0
global qntDragao := 0
global qntTravado := 0
global tempoMatarPedra := 0
global tickInicioMacro := A_TickCount
global informacoesAnteriores
global captcharesolvido := 0
global ClicaX, ClicaY
FormatTime, InicioMacro, D1 T0

;variaveis de entrada
global optConta
global optMetin
global optDG
InputBox, optConta, Qual conta?, 1 ou 2, , 256, 128
InputBox, optMetin, Qual conta?, 1:retorno 2:45 3:70, , 256, 128
InputBox, optDG, Quais DGs?, 0 = nenhuma, , 256, 128

;global Conta1 := "XXXXXXX,XXXXXXXXX"
;global Conta2 := "rlino001,08567315L123"
;global Conta3 := "bufflino,08567315L123"

WinGetPos, Xjanela, Yjanela, Wjanela, Hjanela, Aeldra
if (Xjanela = "") {
	GeraLog("METIN NÃO ESTAVA ABERTO")
	;Pause
}
WinActivate, Aeldra.to
Yjanela := Yjanela+30
SetTimer PegaItens, 700, ON, 3

FileRead, informacoesAnteriores, metininfos%optConta%.log

;SetTimer Verifica(), 3000, ON, 3

; Função para ler o arquivo JSON
ReadJSON(MEUDEUS) {
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
		ZoomPraMatarPedra()
	}
}

GeraLog(msg) {
	FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2%optConta%.log
	if ErrorLevel{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2%optConta%.log
	}
}

ImprimeInfos() {
	Msg := ""
	file := FileOpen("metininfos" optConta ".log", "w")
	Msg := Msg . "Iniciado em: " . InicioMacro . "`r`n"
	Msg := Msg . "Informações da Conta: " . optConta . "`r`n"
	Msg := Msg . "Metins: " . qntMetin . "`r`n"
	Msg := Msg . "Metins por minuto: " . (qntMetin * 60000) / (A_TickCount - tickInicioMacro) . "`r`n"
	Msg := Msg . "Baronesa: " . qntBaronesa . "`r`n"
	Msg := Msg . "Torre: " . qntTorre . "`r`n"
	Msg := Msg . "Dragao: " . qntDragao . "`r`n"
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

ZoomPraMatarPedra() {
	if (optMetin = 1)
		ArrumaMapaCamera0Zoom()
	else if (optMetin = 2)
		ArrumaMapaCamera2Zoom()
	else if (optMetin = 3)
		ArrumaMapaCamera1Zoom()
}

^F6::
Inicio:
WinActivate, Aeldra
;SetTimer PegaItens, off
ClicaRandomDireito(824, 299)
Verifica()
ZoomPraMatarPedra()
tickInicioMacro := A_TickCount
qntMetin := 0
loop, {
	Tempo := A_TickCount
	Player()
	if (qntTravado >= 15) {
		qntTravado := 0
		GeraLog("Voltou por que estava travado.")
		VoltaPraQuebrarMetin()
	}
	;Verifica()
	if (MataPedraMaisPerto()){
		EsperaMatar()
	} else if (MataPedraPequeno()) {
		EsperaMatar()
	} else if (MataPedra()) {
		EsperaMatar()
	} else {
		Verifica()
		qntTravado++
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
	SeguraTecla("e")
	if (ProcuraAteAchar(722, 363, 908, 477, 50, "metinpedra", 2000)) {
		tempoMatarPedra := A_TickCount
		Tecla("3")
		Sleep, 50
		SoltaTecla("e")
		Verifica()
		SeguraTecla("Space")
		while (!PegaItensDaMetin()) {
			if (A_index > 2) {
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
			GeraLog("Nao achou, travado: " qntTravado)
			SoltaTecla("Space")
			ClicaRandom(807, 447, 15)
			Tecla("d", 500)
			Tecla("s", 300)
		} else {
			SoltaTecla("Space")
		}
	} else {
		qntTravado++
		GeraLog("Não conseguiu chegar perto da metin, travado: " qntTravado)
		SoltaTecla("e")
		Verifica()
		GiraAteAcharMetin()
		VaiAteMetin()
	}
	SetTimer PegaItens, 500, ON, 3
}

Verifica() {
	;Inicio := A_TickCount
	Ativa()
	TaDeslogado()
	Morto()
	;TiraQuests()
	Mensagens()
	Biologo()
	AtivaSkill()
	ForaDoCavalo()
	if (optConta = 2)
		AnelXP()
	CaptchaMaldito()
	VerificaNaoEssenciais()
	if (!EstaFazendoDG and optDG != 0) {
		VerificaBossDGs()
	}
	FechaX()
	;GeraLog("Tempo: " A_TickCount - Inicio)
}

VerificaNaoEssenciais() {
	;GeraLog(A_tickcount - ultimaVerificaBossDG " > " MinToMili(10))
	if ((A_tickcount - ultimaVerificaNaoEssenciais) > tempoDeNaoEssenciais) {
		GeraLog("Entrou não essenciais.")
		AvisoNaoEssenciais := true
		ultimaVerificaNaoEssenciais := A_tickcount
		EquipaLuva()
		if (optConta != 2)
			EquipaAnel()
	} else {
		if (tempoDeNaoEssenciais-((A_tickcount - ultimaVerificaNaoEssenciais)) < MinToMili(2) and AvisoNaoEssenciais) {
			GeraLog("Faltam menos de 3 minutos para fazer as DGs")
			AvisoNaoEssenciais := false
		}
	}
}

VerificaBossDGs() {
	;GeraLog(A_tickcount - ultimaVerificaBossDG " > " MinToMili(10))
	if ((A_tickcount - ultimaVerificaBossDG) > tempoDeVerificaDG) {
		GeraLog("Entrou no FazDG")
		ultimaVerificaBossDG := A_tickcount
		Aviso := true
		FazDGs()
	} else {
		if (tempoDeVerificaDG-((A_tickcount - ultimaVerificaBossDG)) < MinToMili(2) and Aviso) {
			GeraLog("Faltam menos de 2 minutos para fazer as DGs")
			Aviso := false
		}
	}
}

^F7::
SaiEntraCavalo()
EsperaRandom(300)
Tecla("F1")
Tecla("F1")
EsperaRandom(300)
SaiEntraCavalo()
SaiEntraCavalo()
EsperaRandom(300)
Tecla("F2")
Tecla("F2")
EsperaRandom(300)
SaiEntraCavalo()
return

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

F11::
TestaResolverCaptcha()
ClicaRandom(ClicaX, ClicaY+100, 25)
return

F12::
CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/captchas/" A_now ".png")
return

F9::
VoltaPraQuebrarMetin()
Return

VaiAteMetin() {
	PegaItens()
	ClicaRandom(807, 447, 15)
	SeguraTecla("w")
	if (ProcuraAteAchar(678, 339, 919, 514, 50, "metinpedra", 2000)) {
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

GiraAteAcharMetin() {
	ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 *TransRed %a_scriptdir%\lendaria.png
	if !ErrorLevel {
		SeguraTecla("e")
		GeraLog("Achou metin lendaria")
		if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "lendaria1", 4000)) {
			;GeraLog("Achou")
			Sleep, 150
			SoltaTecla("e")
			return
		}
	} else {
		ImageSearch, OutX, OutY, 1473, 40, 1608, 178, *40 *TransRed %a_scriptdir%\rara.png
		if !ErrorLevel {
			SeguraTecla("e")
			GeraLog("Achou metin rara")
			if (ProcuraAteAchar(1473, 40, 1608, 178, 40, "rara1", 4000)) {
				Sleep, 150
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
						Sleep, 150
						SoltaTecla("e")
						Verifica()
						return
					}
					Sleep, 150
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

MataPedraMaisPerto() {
	CaptchaMaldito()
	Options = r oTransRed,29 e1 n
	listaCordPedras := FindClick("\metinpedra.png", Options)
	CoordMaisProxima := EncontrarCoordenadaMaisProxima(listaCordPedras)
	if (CoordMaisProxima[1] != 0) {
		;GeraLog("Achou com Distancia Euclidiana.")
		x := CoordMaisProxima[1]
		y := CoordMaisProxima[2]
		PegaItens()
		ClicaRandom(x+fX(x), y+fY(y), 0)
		return true
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
				Tecla("z", randSleep(150))
				Tecla("z", randSleep(150))
				;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
				GeraLog("Matou a metin em: " FormataMilisegundos(A_TickCount - tempoMatarPedra))
				qntMetin++
				ImprimeInfos()
				return true
			}
		}
		GeraLog("Pegou itemchao e demorou " A_TickCount - Inicio)
		Tecla("z", randSleep(150))
		Tecla("z", randSleep(150))
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
				Tecla("z", randSleep(150))
				Tecla("z", randSleep(150))
				;GeraLog("Pegou com itempedra" A_index " e demorou " A_TickCount - Inicio)
				GeraLog("Matou a metin em " FormataMilisegundos(A_TickCount - tempoMatarPedra))
				qntMetin++
				ImprimeInfos()
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
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *70 *TransRed %a_scriptdir%\bot.png
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
			return
		} else {
			SoltaTecla("Space")
			while (ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 70, "bot", 500)) {
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
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	Tecla("NumpadSub")
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
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	Tecla("NumpadSub")
	EsperaRandom(200)
	Tecla("NumpadSub")
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
		Tecla("NumpadAdd")
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
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	EsperaRandom(200)
	GeraLog("ArrumaMapa0Zoom")
}

ArrumaMapa1Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	Tecla("NumpadSub")
	EsperaRandom(200)
	GeraLog("ArrumaMapa1Zoom")
}

ArrumaMapa2Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	Tecla("NumpadSub")
	EsperaRandom(200)
	Tecla("NumpadSub")
	EsperaRandom(200)
	GeraLog("ArrumaMapa2Zoom")
}

ArrumaMapa3Zoom()
{
	Loop, 5 {
		Tecla("NumpadAdd")
		EsperaRandom(200)
	}
	Tecla("NumpadSub")
	EsperaRandom(200)
	Tecla("NumpadSub")
	EsperaRandom(200)
	Tecla("NumpadSub")
	EsperaRandom(200)
	GeraLog("ArrumaMapa3Zoom")
}

Biologo() {
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *110 *TransRed %a_scriptdir%\biologo.png
	if !ErrorLevel{
		GeraLog("Achou janela biologo")
		while (!ProcuraAteAchar(Xjanela, Yjanela, Wjanela, Hjanela, 60, "esperar", 500)) {
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *60 %a_scriptdir%\entregar.png
			if !ErrorLevel{
				ClicaRandom(OutX, OutY)
				EsperaRandom(350)
			}
			if (A_Index > 10) {
				break
			}
		}
		Tecla("Escape")
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
	ImageSearch, OutX, OutY, 70, 99, 248, 122, *60 %a_scriptdir%\recomecar.png
	if !ErrorLevel {
		GeraLog("Estava morto")
		ClicaRandom(OutX, OutY)
		ProcuraPixelAteAchar(211, 113, "0x555555", 5000)
		SaiEntraCavalo()
	}
}

Ativa() {
	WinActivate, Aeldra
	;ClicaRandomDireito(1524, 174, 5, 1)
}

ForaDoCavalo() {
	;Inicio := A_TickCount
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\boris.png
	if !ErrorLevel {
		GeraLog("Fora do cavalo.")
		SaiEntraCavalo()
	}
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\mount.png
	if !ErrorLevel {
		GeraLog("Fora do cavalo.")
		SaiEntraCavalo()
	}
	;GeraLog("Fora do Cavalo: " A_TickCount - Inicio)
}

FechaX() {
	Inicio := A_TickCount
	ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 %a_scriptdir%\xjanela.png
	if !ErrorLevel {
		ClicaRandom(OutX+15, OutY+5)
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
	if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 5000)) {
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
	if (optMetin = 1) {
		ProcuraItemInventario("pergaitem")
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
	EstaFazendoDG := true
	FezAlgum := 0
	if optDG contains 1
		FezAlgum += Baronesa()
	if optDG contains 2
		FezAlgum += Torre()
	if optDG contains 4
		FezAlgum += Dragao()
	if (FezAlgum > 0) {
		VaiPraCidadeRed()
		VoltaPraQuebrarMetin()
	} else {
		FechaX()
	}
	EstaFazendoDG := false
	return
}

; COMEÇO DRAGAO

Dragao() {
	Inicio := A_TickCount
	DragaoDeuErro := false
	Ativa()
	if (EntraDragao()) {
		GeraLog("---------------- Dragao ---------------")
		SoundBeep, 500, 500
		EsperaRandom(1000)
		if (EntraDragao()) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
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
		GeraLog("---------------- Dragao " FormataMilisegundos(A_TickCount - InicioDragao) " ---------------")
		return 1
	}
	return 0
}

AbreF6() {
	if (RetornaCorPixel(911, 246) != "0x0B225F") {
		Tecla("F6")
		if (!ProcuraPixelAteAchar(911, 246, "0x0B225F", 1000)) {
			GeraLog("Não abriu o F6, tenta de novo.")
			Verifica()
			return false
		} else {
			return true
			GeraLog("Abriu o F6")
		}
	} else {
			return true
			GeraLog("F6 já estava aberto.")
	}

}

EntraDragao() {
	if (!AbreF6())
		return false
	ClicaRandom(736, 458)
	EsperaRandom(300)
	if (RetornaCorPixel(736, 458) = "0x444E49") {
		GeraLog("Pode fazer Dragao")
		EsperaRandom(500)
		ClicaRandom(886, 608)
		EsperaRandom(500)
		ClicaRandom(721, 464)
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
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
	if (Tentativa > 60) {
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
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
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
			;()
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
			GeraLog("Usou o simbolo.")
		}
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

DragaoStageBoss() {
	EsperaRandom(1000)
	if (ProcuraItemInventario("dragaosimbolo")) {
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
	if (EntraTorre()) {
		GeraLog("---------------- Torre ---------------")
		SoundBeep, 500, 500
		EsperaRandom(1000)
		if (EntraTorre()) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
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
		GeraLog("---------------- Torre " FormataMilisegundos(A_TickCount - InicioTorre) " ---------------")
		return 1
	}
	return 0
}

EntraTorre() {
	if (!AbreF6())
		return false
	ClicaRandom(731, 345)
	EsperaRandom(300)
	if (RetornaCorPixel(731, 345) = "0x444E49") {
		GeraLog("Pode fazer Torre")
		EsperaRandom(500)
		ClicaRandom(886, 608)
		EsperaRandom(500)
		ClicaRandom(721, 464)
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
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
	if (Tentativa > 60) {
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
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
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
				GeraLog("Usou o simbolo.")
			}
		} else {
			Verifica()
			GiraAteAcharMetin()
			VaiAteMetin()
			if (ProcuraItemInventario("torresimbolo")) {
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
	if (EntraBaronesa()) {
		GeraLog("---------------- Baronesa ---------------")
		SoundBeep, 500, 500
		EsperaRandom(1000)
		if (EntraBaronesa()) {
			SoundBeep, 500, 1500
			GeraLog("Não estava dentro da DG.")
			return 1
		} else {
			FechaX()
		}
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
		GeraLog("---------------- Baronesa " FormataMilisegundos(A_TickCount - InicioBaronesa) " ---------------")
		return 1
	}
	return 0
}

EntraBaronesa() {
	if (!AbreF6())
		return false
	ClicaRandom(640, 293)
	EsperaRandom(500)
	if (RetornaCorPixel(792, 307) = "0x444D48") {
		GeraLog("Pode fazer baronesa")
		EsperaRandom(500)
		ClicaRandom(886, 608)
		EsperaRandom(500)
		ClicaRandom(721, 464)
		EsperaRandom(1000)
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sozinho.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
		}
		ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sim.png
		if !ErrorLevel {
			ClicaRandom(OutX+5, OutY+5)
			EsperaRandom(9000)
			return true
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
			SeguraTecla("w")
			SeguraTecla("e")
			EsperaRandom(500)
			SoltaTecla("w")
			SoltaTecla("e")
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
	if (ProcuraAteAchar(Xjanela, Yjanela-60, Wjanela-80, Hjanela, 40, "baronesaovo", 2000)) {
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
			ClicaRandom(807, 447, 15)
			Tecla("d", 500)
			Tecla("s", 300)
		} else {
			SoltaTecla("Space")
		}
	} else {
		SoltaTecla("e")
		VaiAteMetin()
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
		GeraLog("Usou o apito.")
	} else
		BaronesaDeuErro := true
}

BaronesaPisoBoss() {
	EsperaRandom(1000)
	if (ProcuraItemInventario("baronesaapito")) {
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
	AbaInv++
	EsperaRandom(100)
	if (AbaInv = 1) {
		ClicaRandom(1461, 483)
		MoveMouse(1393, 483)
		return true
	} else if (AbaInv = 2) {
		ClicaRandom(1481, 483)
		MoveMouse(1393, 483)
		return true
	} else if (AbaInv = 3) {
		ClicaRandom(1519, 483)
		MoveMouse(1393, 483)
		return true
	} else {
		AbaInv := 0
		ProximaPaginaInv()
		return false
	}
}

ProcuraItemInventario(item) {
	loop, 4 {
		AbreInventario()
		ImageSearch, ItemInvOutX, ItemInvOutY, 1432, 472, 1595, 788, *40 %a_scriptdir%\%item%.png
		if !ErrorLevel {
			return true
		}
		ProximaPaginaInv()
		EsperaRandom(300)
	}
	return false
}

VaiPraCidadeRed() {
	Tecla("4")
	EsperaRandom(1000)
	ClicaRandom(826, 361)
	EsperaRandom(1000)
	ClicaRandom(808, 368)
	if (ProcuraPixelAteAchar(877, 443, "0x1D252F", 5000)) {
		GeraLog("Achou o loading")
		EsperaRandom(10000)
		GeraLog("Foi pra vila red")
	} else {
		Verifica()
		VaiPraCidadeRed()
	}

}

^F11::
Run, metin2.ahk
return

EquipaLuva() {
	AbreInventario()
	EsperaRandom(150)
	if (RetornaCorPixel(1460, 448) != "0x606C7D") {
		GeraLog("Estava sem luva.")
		if (ProcuraItemInventario("luva")) {
			GeraLog("Achou a luva pra equipar.")
			ClicaRandomDireito(ItemInvOutX, ItemInvOutY)
			EsperaRandom(250)
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sim.png
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
			ImageSearch, OutX, OutY, Xjanela, Yjanela, Wjanela, Hjanela, *30 *TransRed %a_scriptdir%\sim.png
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