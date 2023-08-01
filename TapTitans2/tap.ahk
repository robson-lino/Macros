; 0.5
#SingleInstance Force
#NoEnv
DefaultDirs = a_scriptdir
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 25, 25
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
#MaxThreads 1

#Include, ocr.ahk
#Include, edge.ahk
#Include, CaptureScreen.ahk
#Include, FindClick.ahk

global Dontpad := false

if (Dontpad) {
    global ChromeInst,ChromeProfile,PageInst
    FileCreateDir, ChromeProfile
    ChromeInst := new Edge(A_ScriptDir "\EdgeProfile",, "--no-first-run")

    ; --- Connect to the page ---

    if !(PageInst := ChromeInst.GetPage()) {
        MsgBox, Could not retrieve page!
        ChromeInst.Kill()
    } else {
        PageInst.Call("Page.navigate", {"url": "https://dontpad.com/robsonlino/taptitans.log"})
        PageInst.WaitForLoad()
        ;Sleep, 15000
    }
}

DefaultDirs = a_scriptdir

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
global X, Y, W, H,
global PrimeiraColor := "0x00ADFE"
global SegundaColor := "0x00ADFE"
global TerceiraColor := "0x00ADFE"
global QuartaColor := "0x00ADFE"
global QuintaColor := "0x00AEFF"
global SextaColor := "0x00AEFF"
global PrimeiraAtiva := false
global SegundaAtiva := false
global TerceiraAtiva := false
global QuartaAtiva := false
global QuintaAtiva := false
global SextaAtiva := false
global PrimeiraFull := false
global SegundaFull := false
global TerceiraFull := false
global QuartaFull := false
global QuintaFull := false
global SextaFull := false
global stage
global stageanterior
global 10ultimos := []
global PrimeiraPixelX = 589
global PrimeiraPixelY = 752
global SegundaPixelX = 667
global SegundaPixelY = 751
global TerceiraPixelX = 744
global TerceiraPixelY = 752
global QuartaPixelX = 821
global QuartaPixelY = 752
global QuintaPixelX = 899
global QuintaPixelY = 753
global SextaPixelX = 976
global SextaPixelY = 753
global PrimeiraiCount := 0
global SegundaiCount := 0
global TerceiraiCount := 0
global QuartaiCount := 0
global QuintaiCount := 0
global SextaiCount := 0
global StageProgess := 0
global ChkMiR
global iUltimaAtualizada = A_TickCount
global TickPrestigio
global TempoTotal := 0
global QntPrestigio := 0
global QntPrestigioDia := 0
global auxcomprou := false
global forcaprestige :=
global totalStage := 0
global qntStage := 0
global mediaStage := 0
global media := 0
global alternado := false
global nenhum := false
global Qual
global qntVezesAll := 0
global TravadoCount := 0
global ChkAbsal := false
global ChkPrestige := true
global Teste2 := 0
global Pagina := 1
global Aba := 0
global AbaDaily := 0
global indo := true
global AchouOutX := ""
global AchouOutY := ""
global ComprouSkill
global Boost := A_TickCount - MinToMili(60)
global aumento_percentual_media := 0
global StageProgess
global prestmili := 1000
global listaPartes := "cabeca,torso,ombro esquerdo,ombro direito,mao esquerda,mao direita,perna direita,perna esquerda"
global InicioAchou := A_TickCount
global qntAchou := 0
global ultimaVerificadaClan := A_TickCount
global ultimaVerificadaNaoEssenciais := A_TickCount
global randVerificaClan
global Aviso := true
global grand, grand2
global EntradaX := 0
global EntradaY := 0
global EntradaW := 0
global EntradaH := 0
global contrato
global PodeContratoStage := false
global PodeContratoMana := false
global ItemEquipado := "nenhum"
global TipoHeroi := "warrior,mage,ranger"
global SaidaX,SaidaY,SaidaW,SaidaH
global Segurando := false
global porcentagem
global paraPrestigioDia := false
global dataQueTerminou, horaQueTerminou, horaQueTerminou, minutoQueTerminou
; hora do Resete
global horaFixa := "21", minutoFixo := "00", segundoFixo := "00"
; hora do Resete
; Configuração de rands
global randClanMin := 30, randClanMax := 60
global randNaoEssenciaisMin := 60, randNaoEssenciaisMax := 120
; Configuração de rands
global arrayPetX := 0
global arrayPetY := 0
global subiuPet := 0
global fezreroll := false
global passadaViaAba := 0
global PID := ""

GeraLog(msg, sms=false) {
    FormatTime, DataFormatada, D1 T0
    FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
    if (Dontpad) {
        try {
            CARALHOOO := DataFormatada . " - " . msg . "\r\n"
            Mensagem := "document.getElementById(""text"").value = document.getElementById(""text"").value + """ . CARALHOOO . """"
            Result := PageInst.Evaluate(Mensagem)
            Result := PageInst.Evaluate("if (document.getElementsByClassName(""btn"")[1]) document.getElementsByClassName(""btn"")[1].click()")
        }
        Catch e {
            GeraLog("Deu erro no Edge, sei lá oque aconteceu " e)
            ChromeInst.Kill()
            ChromeInst := new Edge(A_ScriptDir "\EdgeProfile",, "--no-first-run")
            ; --- Connect to the page ---

            if !(PageInst := ChromeInst.GetPage()) {
                MsgBox, Could not retrieve page!
            } else {
                PageInst.Call("Page.navigate", {"url": "https://dontpad.com/robsonlino/taptitans.log"})
                PageInst.WaitForLoad()
                ;Sleep, 15000
            }
            Ativa()
        }
    }
    if ErrorLevel {
        FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
    }
    If (sms) {
        SendSMS("`n" DataFormatada " - " msg)
    }
}

OnExit("ExitFunc")

ExitFunc() {
    try
    PageInst.Call("Browser.close") ; Fails when running headless
    catch
        ChromeInst.Kill()
    ExitApp
    ExitApp
    ExitFunc()
}

GeraLogTempoPrest(msg) {
    FormatTime, DataFormatada, D1 T0
    FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitanstemp.log
    if ErrorLevel {
        FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitanstemp.log
    }
}

Gui -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Add, Text, hWndhTxtStage vTxtStage x40 y8 w78 h23 +0x200, Stage
Gui Add, Text, hWndhtxtPrimeira vtxtPrimeira x8 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhTxtSegunda vtxtSegunda x56 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtTerceira vtxtTerceira x104 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtQuarta vtxtQuarta x152 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtQuinta vtxtQuinta x200 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtSexta vtxtSexta x248 y120 w42 h23 +0x200, SIM
GuiControl, Hide, txtPrimeira
GuiControl, Hide, txtSegunda
GuiControl, Hide, txtTerceira
GuiControl, Hide, txtQuarta
GuiControl, Hide, txtQuinta
GuiControl, Hide, txtSexta
Gui Add, Text, hWndhtxtTempoStage vtxtTempoStage x140 y8 w30 h23 +0x200, 0
Gui Add, Text, x170 y8 w39 h23 +0x200, Med:
Gui Add, Text, hWndhtxtMediana vtxtMediana x205 y8 w42 h23 +0x200, 0
Gui Add, Progress, vPrgStage x176 y40 w120 h20 -Smooth, 10
;Gui Add, Edit, x48 y40 w120 h21 vEdit1, CORD
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 127500
Gui Add, Text, x8 y40 w36 h23 +0x200, Target
Gui Add, Progress, vPrgMana x8 y96 w120 h20 -Smooth, 100
Gui Add, CheckBox, vChkMiR x8 y144 w63 h23, MiR
Gui Add, CheckBox, vChkPrestige x8 y168 w63 h23 +Checked, Prestige
Gui Add, CheckBox, vChkFairy x8 y192 w63 h23 +Checked, Fairy
Gui Add, Button, vPrestige gFazPrestige x96 y272 w80 h23, Prestige
Gui Add, Button, vBtnIniciar gIniciar x8 y272 w80 h23, Iniciar

Gui Add, Radio, vQual x8 y216 w37 h23, BoS
Gui Add, Radio, x50 y216 w37 h23, All
Gui Add, Radio, x90 y216 w70 h23, Alternado
Gui Add, Radio, x160 y216 w70 h23 +Checked, Nenhum

Gui Add, Text, x8 y8 w30 h23 +0x200, Atual:
Gui Add, Text, vtxtPode x90 y8 w39 h23 +0x200, NAO
Gui Add, Radio, hWndhRadPush vPush x8 y64 w49 h23, Push
Gui Add, Radio, hWndhRadPushForte x60 y64 w49 h23, Push+
Gui Add, Radio, hWndhRadFarm x110 y64 w49 h23 +Checked, Farm

Gui Add, CheckBox, hWndhRadFarm vChkAbsal x160 y64 w49 h23, Absal

Gui Add, Text, vtxtMana x132 y96 w300 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gCompraSkills x216 y272 w80 h23, Teste
Gui Add, Button, vBtnCalibrar gCalibrar x216 y300 w80 h23, Calibrar

Gui Add, Text, x8 y300 w42 h23 +0x200, Media:
Gui Add, Text, hWndhtxtMediaStage vtxtMediaStage x45 y300 w30 h23 +0x200, 0
Gui Add, Text, x8 y320 w42 h23 +0x200, Qnt:
Gui Add, Text, hWndhtxtQntPres vtxtQntPres x45 y320 w30 h23 +0x200, 0
; ------------ Linha para estilo de jogo
Gui, Add, Text, x5 y350 w298 0x10 ;Horizontal Line > Etched Gray
Gui Add, Radio, hWndhRadEstilo vEstilo x8 y360 w60 h23 +Checked, Clanship
Gui Add, Radio, hWndhRadEstilo x70 y360 w35 h23, SC
Gui Add, Radio, hWndhRadEstilo x110 y360 w35 h23, HS
Gui Add, Radio, hWndhRadEstilo x150 y360 w60 h23 +, Dagger

Gui Add, Text, x8 y383 w120 h23 +0x200, Qnt Prestigio por dia:
Gui Add, Edit, x115 y385 w40 h21 +Number vQntPrestigioDiaConfig, 100

Gui Show, x35 y35 w303 h420, TapMacro
global TxtStage, txtPrimeira, txtSegunda, txtTerceira, txtQuarta, txtQuinta, txtSexta
global txtTempoStage, txtMediana, PrgStage, Edit1, PrgMana, ChkMiR, ChkPrestige, ChkFairy
global Prestige, BtnIniciar, Qual, txtPode, Push, ChkAbsal, txtMana, BtnAtualizar, BtnCalibrar
global txtMediaStage, txtQntPres, Estilo, QntPrestigioDiaConfig

Return

Prestige:
Return

Iniciar:
WinActivate, taptitans.log
Sleep, 300
TickPrestigio := A_TickCount
Ativa()
Random, randVerificaClan, MinToMili(0), MinToMili(0)
Random, randVerificaNaoEssenciais, MinToMili(randNaoEssenciaisMin), MinToMili(randNaoEssenciaisMax)
if (!JogoAberto())
    AbreBluestacks()
FechaAllRapido()
ClicaEAtualiza()
Return

ClicaEAtualiza() {
    SetTimer ClicaEAtualiza, off
    Ativa()
    Clica()
    Clica()
    Atualizar()
    if (!paraPrestigioDia) {
        setTimer NaoEssenciais, off
        SetTimer ClicaEAtualiza, 500, ON, 3
    } else {
        GeraLog("Não colocou o timer, pq parou o presitigo dia.")
        NaoEssenciais()
    }

}

Clica() {
    TempoPassado := TempoPassado()
    GuiControl, , txtTempoStage, %TempoPassado%
    FechaAllRapido()
    FechaSeta()
    AtualizaStageViaAba()
    PegaControles()
    Gui, Submit, NoHide
    if (Estilo = 1) {
        CliqueClanShip()
    } else if (Estilo = 2) {
        CliqueSC()
    } else if (Estilo = 3) {
        CliqueHS()
    }
    AttMana()

}

CliqueSC() {
    if (!ChkAbsal) {
        if (!ChkMiR) {
            if(!ContratoAtivo()) {
                ;AtivaContratoViaBS()
                AtivaContratoViaClique()
            }
            else {
                loop, 5 {
                    ClicaRandom(620, 258, 6)
                    ClicaRandom(972, 247, 6)
                    ClicaRandom(775, 242, 6)
                    ClicaRandom(784, 393, 6)
                    ;AtivaAAv2()
                }
            }
        }
        else {
            SendMouse_AbsoluteMove(786, 452)
            Send, {LButton down}
            Sleep, 300
            SendMouse_AbsoluteMove(753, 452)
            Sleep, 20
            SendMouse_AbsoluteMove(708, 437)
            Sleep, 20
            SendMouse_AbsoluteMove(676, 389)
            Sleep, 20
            SendMouse_AbsoluteMove(658, 338)
            Sleep, 20
            SendMouse_AbsoluteMove(673, 283)
            Sleep, 20
            SendMouse_AbsoluteMove(703, 235)
            Sleep, 20
            SendMouse_AbsoluteMove(741, 223)
            Sleep, 20
            SendMouse_AbsoluteMove(785, 223)
            Sleep, 20
            SendMouse_AbsoluteMove(826, 234)
            Sleep, 20
            SendMouse_AbsoluteMove(862, 252)
            Sleep, 20
            SendMouse_AbsoluteMove(889, 289)
            Sleep, 20
            SendMouse_AbsoluteMove(870, 389)
            Sleep, 20
            SendMouse_AbsoluteMove(841, 425)
            Sleep, 20
            SendMouse_AbsoluteMove(798, 452)
            Send, {LButton up}
            Sleep, 20
        }
    }
    FechaSeta()
}

CliqueHS() {
    PegaControles()
    if (!ChkAbsal) {

    } else {
        ClicaRandom(1142, 250, 2)
        ClicaRandom(1051, 246, 2)
        ClicaRandom(935, 242, 2)
        ClicaRandom(827, 245, 2)
        ClicaRandom(769, 254, 2)
        ClicaRandom(939, 426, 2)
        loop, 4 {
            Send, a
            Sleep, 30
            Send, {a up}
            Sleep, 30
        }
        Sleep, 200
        loop, 1 {
            Send, {a down}
            Sleep, 300
        }
    }
}

CliqueClanShip() {
    if (!ChkAbsal) {
        if (!ChkMiR) {
            if(!ContratoAtivo()) {
                ;AtivaContratoViaBS()
                AtivaContratoViaClique()
            }
            else {
                loop, 1 {
                    ;ClicaRandom(620, 258, 3)
                    ;ClicaRandom(972, 247, 3)
                    ;ClicaRandom(775, 242, 3)
                    ;ClicaRandom(784, 393, 3)
                    ;ClicaRandom(727, 456, 3)
                    ;ClicaRandom(784, 343, 3)
                    ClicaRandom(786, 326)
                    ClicaRandom(786, 392)
                    ClicaRandom(734, 461)
                }
            }
        }
        else {
            SendMouse_AbsoluteMove(786, 452)
            Send, {LButton down}
            Sleep, 300
            SendMouse_AbsoluteMove(753, 452)
            Sleep, 20
            SendMouse_AbsoluteMove(708, 437)
            Sleep, 20
            SendMouse_AbsoluteMove(676, 389)
            Sleep, 20
            SendMouse_AbsoluteMove(658, 338)
            Sleep, 20
            SendMouse_AbsoluteMove(673, 283)
            Sleep, 20
            SendMouse_AbsoluteMove(703, 235)
            Sleep, 20
            SendMouse_AbsoluteMove(741, 223)
            Sleep, 20
            SendMouse_AbsoluteMove(785, 223)
            Sleep, 20
            SendMouse_AbsoluteMove(826, 234)
            Sleep, 20
            SendMouse_AbsoluteMove(862, 252)
            Sleep, 20
            SendMouse_AbsoluteMove(889, 289)
            Sleep, 20
            SendMouse_AbsoluteMove(870, 389)
            Sleep, 20
            SendMouse_AbsoluteMove(841, 425)
            Sleep, 20
            SendMouse_AbsoluteMove(798, 452)
            Send, {LButton up}
            Sleep, 20
        }
    }
    else {
        ClicaRandom(982, 223)
        ClicaRandom(780, 226)
        ClicaRandom(643, 251)
        ClicaRandom(577, 236)
        ClicaRandom(786, 326)
        ClicaRandom(786, 392)
        ClicaRandom(734, 461)
    }
    FechaSeta()
}

PegaControles() {
    GuiControlGet, TxtStage
    GuiControlGet, txtPrimeira
    GuiControlGet, txtSegunda
    GuiControlGet, txtTerceira
    GuiControlGet, txtQuarta
    GuiControlGet, txtQuinta
    GuiControlGet, txtSexta
    GuiControlGet, txtTempoStage
    GuiControlGet, txtMediana
    GuiControlGet, PrgStage
    GuiControlGet, Edit1
    GuiControlGet, PrgMana
    GuiControlGet, ChkMiR
    GuiControlGet, ChkPrestige
    GuiControlGet, ChkFairy
    GuiControlGet, Prestige
    GuiControlGet, BtnIniciar
    GuiControlGet, Qual
    GuiControlGet, txtPode
    GuiControlGet, Push
    GuiControlGet, ChkAbsal
    GuiControlGet, txtMana
    GuiControlGet, BtnAtualizar
    GuiControlGet, BtnCalibrar
    GuiControlGet, txtMediaStage
    GuiControlGet, txtQntPres
    GuiControlGet, Estilo
    GuiControlGet, QntPrestigioDiaConfig
    Gui, Submit, NoHide
}

AtivaContratoViaBS() {
    AtivaAAv2()
    loop, 3
    {
        ;AtualizaStage()
        Send, l
        Sleep, 10
        Send, p
        Sleep, 10
        Send, a
        Sleep, 10
        Send, b
        Sleep, 10
        Send, c
        Sleep, 10
        Send, d
        Sleep, 10
        Send, o
        Sleep, 10
        Send, f
        Sleep, 10
        Send, g
        Sleep, 10
        Send, h
        Sleep, 10
        Send, i
        Sleep, 10
        if (FechaColetaRapida()) {
            loop, 2 {
                Send, a
                Sleep, 10
                Send, b
                Sleep, 10
                Send, c
                Sleep, 10
                Send, d
                Sleep, 10
                Send, o
                Sleep, 10
                Send, f
                Sleep, 10
                Send, g
                Sleep, 10
                Send, h
                Sleep, 10
                Send, i
                Sleep, 10
            }
            break
        }
    }
}

AtivaContratoViaClique() {
    loop, 5
    {
        FechaAllRapido()
        ClicaRandom(782, 225, 5)
        ClicaRandom(858, 259, 5)
        ClicaRandom(883, 331, 5)
        ClicaRandom(861, 407, 5)
        ClicaRandom(802, 447, 5)
        ClicaRandom(781, 423, 5)
        ClicaRandom(733, 436, 5)
        ClicaRandom(688, 384, 5)
        ClicaRandom(673, 317, 5)
        ClicaRandom(708, 247, 5)
        ClicaRandom(782, 225, 5)

    }
}

;ok
AbreHeroi() {
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(670, 846) = "0xB1A161") {
        return
    } else {
        ClicaSegundaAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(670, 846, "0xB1A161", 700)) {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbreHeroi()
        }
        ProcuraPixelAteAchar(770, 66, "0x505155", 700)
        ;GeraLog("AbreHeroi: " A_TickCount - Inicio)
        return
    }
}

Fechaheroi() {
    ImageSearch, OutX, OutY, 780, 841, 857, 880, *60 %a_scriptdir%\heroes.png
    if (ErrorLevel = 0) {
        ClicaSegundaAba()
        Sleep, 120
    } else {
        return
    }
}


CLicaCompraHeroi() {
    ;Inicio := A_TickCount
    PixelSearch, OutputVarX, OutputVarY, 944, 143, 948, 489, 0x0786EC, 20, fast
    if !ErrorLevel
    {
        ClicaRandom(937, 166, 4, 60)
        ClicaRandom(940, 249, 4, 60)
        ClicaRandom(950, 319, 4, 60)
        ClicaRandom(933, 387, 4, 60)
    }
    ;GeraLog("ClicaCompraHeroi: " A_TickCount - Inicio)
}


CompraHeroiRapido() {
    Inicio := A_TickCount
    contrato := ContratoAtivo()
    AbreHeroi()
    CLicaCompraHeroi()
    ImageSearch, OutX, OutY, 622, 134, 748, 207, *90 %a_scriptdir%\lv0.png
    if ErrorLevel {
        SobeUmaPagina()
    }
    PegaControles()
    EquipaMelhorItem()
    ;FechaAllRapido()
    ;GeraLog("CompraHeroiRapido: " A_TickCount - Inicio)
}

CompraHeroi() {
    ;Inicio := A_TickCount
    AbreHeroi()
    Sleep, 150
    Loop, 2
    {
        AbreHeroi()
        FechaColetaRapida()
        CLicaCompraHeroi()
        DesceUmaPagina()
        CLicaCompraHeroi()
        Clica()
    }
    Fechaheroi()
    Loop, 3
    {
        AbreHeroi()
        FechaColetaRapida()
        AbreHeroi()
        CLicaCompraHeroi()
        SobeUmaPagina()
        Clica()
    }
    Fechaheroi()
    AttMana()
    ;GeraLog("ComprouHerois: " A_TickCount - Inicio)

}

AtualizaStage() {
    ;Inicio := A_TickCount
    loop, 5
    {
        stagetemp := RetornaText(888, 60, 99, 66)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp > 80000 and stagetemp < 180000) {
            stageanterior := stage
            stage := stagetemp
            ;GeraLog(stage)
            AttBarraStage()
            FazPrestige()
            GuiControl, , TxtStage, %stage%
            iUltimaAtualizada := A_TickCount
            break
        }
    }
    ;GeraLog("AtualizaStage(): " A_TickCount - Inicio)
}
AtualizaStageViaConfig() {
    ;Inicio := A_TickCount
    MouseClick left, 727, 99
    while (A_TickCount-iUltimaAtualizada)>5000
    {
        Sleep, 50
        stagetemp := RetornaText(903, 57, 73, 62)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp > 80000 and stagetemp < 180000) {
            stageanterior := stage
            stage := stagetemp
            AttBarraStage()
            FazPrestige()
            GuiControl, , TxtStage, %stage%
            iUltimaAtualizada := A_TickCount
            Sleep, 300
        }
        if (A_Index>50) {
            iUltimaAtualizada := A_TickCount
            Break
        }
    }
    Sleep, 30
    MouseClick left, 727, 99
    ;GeraLog("AtualizaStageViaConfig(): " A_TickCount - Inicio)
}

ProcuraAteAchar(X, Y, H, W, var, img, mili) {
    ;Inicio := A_TickCount
    ;Ativa()
    ;GeraLog("Ativa(): " A_TickCount - Inicio)
    Comeco := A_TickCount
    ;GeraLog(img)
    while ((A_TickCount - Comeco) < mili) {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% %a_scriptdir%\%img%.png
        if (!ErrorLevel) {
            AchouOutX := OutX
            AchouOutY := OutY
            return true
        }
        FechaColetaRapida()
    }
    return false
}

ProcuraAteAcharTransBlack(X, Y, H, W, var, img, mili) {
    ;Inicio := A_TickCount
    ;Ativa()
    ;GeraLog("Ativa(): " A_TickCount - Inicio)
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% *TransBlack %a_scriptdir%\%img%.png
        if (!ErrorLevel) {
            AchouOutX := OutX
            AchouOutY := OutY
            return true
        }
        FechaColetaRapida()
    }
    return false
}

ProcuraPixelAteAchar(X, Y, color, mili) {
    ;Inicio := A_TickCount
    ;Ativa()
    ;GeraLog("Ativa(): " A_TickCount - Inicio)
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        if (RetornaCorPixel(X, Y) = color) {
            AchouOutX := X
            AchouOutY := Y
            return true
        }
        FechaColetaRapida()
    }
    return false
}

ProcuraAteNaoAchar(X, Y, H, W, var, img, mili) {
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% %a_scriptdir%\%img%.png
        if (ErrorLevel) {
            return true
        }
        IncrementaAchou()
    }
    return false
}

ProcuraPixelAteNaoAchar(X, Y, color, mili) {
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        if (RetornaCorPixel(X, Y) != color) {
            return true
        }
        IncrementaAchou()
    }
    return false
}

ProcuraPixelAteNaoAcharSI(X, Y, color, mili) {
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        if (RetornaCorPixel(X, Y) != color) {
            return true
        }
    }
    return false
}

IncrementaAchou() {
    if (A_TickCount - InicioAchou > 60000) {
        GeraLog("Estava com " qntAchou)
        qntAchou := 0
        InicioAchou := A_TickCount
    } else {
        qntAchou++
        ;GeraLog("Estava com " qntAchou)
    }
}

ContratoAtivo() {
    AttMana()
    if (PodeContratoStage and PodeContratoMana) {
        ;Inicio := A_TickCount
        PixelSearch, OutputVarX, OutputVarY, 651, 472, 861, 479, 0xFF01FF, 5, Fast
        if (!ErrorLevel) {
            ;GeraLog("Contrato ativo " A_TickCount - Inicio)
            return true
        }
        else {
            ;GeraLog("Contrato não ativo " A_TickCount - Inicio)
            return false
        }
    } else
        return true
}

AtualizaStageViaAba() {
    Inicio := A_TickCount
    Achou := false
    if (passadaViaAba > 2) {
        CompraHeroiRapido()
        passadaViaAba := 0
    }
    AbreSkillDiretoProPresitigo()
    ;Protecao pra não ficar aqui muito tempo, 6.0.
    if (RetornaCorPixel(943, 252) = "0x494949"){
        passadaViaAba++
        return
    }
    if (!ProcuraPixelAteAchar(777, 304,"0xFFFFFF", 3000))
        return
    Comeco := A_TickCount
    ;GeraLog("Step 1: " A_TickCount - Inicio)
    while ((A_TickCount - Comeco) < prestmili) {
        FechaColetaRapida()
        ;GeraLog("Step 2: " A_TickCount - Inicio)
        ;stagetemp := RetornaText(583, 655, 226, 94)
        stagetemp := RetornaText(591, 656, 210, 94)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if (stage = "" and (StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp < 180000)
            stage := stagetemp
        aumento_percentual := ((stagetemp - stage) / stage) * 100
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp < 180000 and aumento_percentual >= 0) {
            stageanterior := stage
            stage := stagetemp
            GuiControl, , TxtStage, %stage%
            AttBarraStage()
            GeraLog(FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " TempoPassado() " - " stage " - %" StageProgess " - %" aumento_percentual)
            FazPrestige()
            PegaControles()
            If (StageProgess >= 99.98 and contrato and ChkPrestige and PodeContratoMana)
                prestmili := 1000
            else
                prestmili := 1000
            Achou := true
            iUltimaAtualizada := A_TickCount
            ;GeraLog("Step 3: " A_TickCount - Inicio)
            if (prestmili < 1010)
                break
        } else {
            GeraLog("NÃO ATUALIZOU PQ?" "Temp: " stagetemp " - Calculado:" stage " - %" StageProgess " - %" aumento_percentual)
        }
    }
    if (false) {
        CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/erros/Stage - " A_now ".png")
        ClicaRandom(782, 696, 4)
        ;MouseClick, left, 840, 720
        loop, 5 {
            FechaColetaRapida()
            stagetemp := RetornaText(826, 235, 144, 84)
            stagetemp := RegExReplace(stagetemp, "\D", "")
            if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit) {
                stageanterior := stage
                stage := stagetemp
                GuiControl, , TxtStage, %stage%
                AttBarraStage()
                GeraLog("Dentro: " FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " TempoPassado() " - " stage " - %" StageProgess)
                ;GeraLog("Step 4: " A_TickCount - Inicio)
                FazPrestige()
                iUltimaAtualizada := A_TickCount
                Achou := true
            }
        }
    }
    if (false) {
        GeraLog("Não subiu a pagina, precisa fazer de novo.")
        loop, 3 {
            FechaAllRapido()
        }
        AbreSkill()
        SobeUmaPagina()
        Sleep, 400
        AtualizaStageViaAba()
    }
    FechaAllRapido()
    passadaViaAba++
    ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
    ;AttMana()
}

Atualizar() {
    FechaAllRapido()
    VaiProBoss()
    VerificaClanRaid()
    Presente()
    Ovo()
    ;lua()
    FechaSeta()
    tempo := A_TickCount - Inicio
}

SoloRaid() {
    ImageSearch, OutX, OutY, 787, 54, 841, 101, *90 *TransBlack %a_scriptdir%\soloraid.png
    if !ErrorLevel {
        GeraLog("Achou")
        Sleep, 3000
        ClicaRandom(1017, 673, 5)
        Sleep, 1000
        ClicaRandom(1032, 739, 5)
    }
}

NaoEssenciais() {
    SetTimer, NaoEssenciais, off
    PegaControles()
    if ((A_tickcount - ultimaVerificadaNaoEssenciais) > randVerificaNaoEssenciais and !ChkAbsal) {
        GeraLog("Entrou no verifica nao essenciais")
        if (!JogoAberto())
            AbreBluestacks()
        ultimaVerificadaNaoEssenciais := A_tickcount
        VerificaNaoEssenciais()
        Random, randVerificaNaoEssenciais, MinToMili(randNaoEssenciaisMin), MinToMili(randNaoEssenciaisMax)
        if (JogoAberto() and paraPrestigioDia)
            FechaBluestacks()
        setTimer NaoEssenciais, %randVerificaNaoEssenciais%, ON, 3
    }
}

VerificaClanRaid() {
    PegaControles()
    if ((A_tickcount - ultimaVerificadaClan) > randVerificaClan and !ChkAbsal) {
        GeraLog("Entrou no verifica clan")
        ;GeraLog(A_tickcount - ultimaVerificadaClan " > " randVerificaClan)
        ultimaVerificadaClan := A_tickcount
        VerificaNaoEssenciais(randVerificaClan)
    } else {
        if (randVerificaClan-((A_tickcount - ultimaVerificadaClan)) < MinToMili(10) and randVerificaClan > 120001 and Aviso) {
            ImageSearch, OutX, OutY, 745, 55, 801, 100, *60 %a_scriptdir%\raid.png
            if (ErrorLevel = 0) {
                GeraLog("Faltam menos de 10 minutos para atacar a Raid.", true)
                Aviso := false
            }
        }
    }
}

RetornaText(X, Y, W, H) {
    hBitmap := HBitmapFromScreen(X, Y, W, H)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    text := StrReplace(ocr(pIRandomAccessStream), "`n","")
    return text
}
;ok
AttMana() {
    ;Inicio := A_Tickcount
    FechaAllRapido()
    AtivaAAv2()
    AtualizaStatusSkillAtiva()
    ;mana := RegExReplace(RetornaText(677, 714, 175, 74), "\D(?<!\/)", "")
    mana := RegExReplace(RetornaText(555, 708, 116, 50), "\D(?<!\/)", "")
    atual := SubStr(mana, 1, InStr(mana, "/")-1)
    total := SubStr(mana, InStr(mana, "/")+1, 4)
    porcentagem := (atual / total) * 100
    if (porcentagem > 0 and porcentagem <= 100) {
        GuiControl, , PrgMana, %porcentagem%
        GuiControl, , TxtMana, %mana%
    }
    if (PrimeiraAtiva AND SegundaAtiva AND TerceiraAtiva AND QuartaAtiva AND QuintaAtiva AND SextaAtiva
        AND (!PrimeiraFull or !SegundaFull or !TerceiraFull or !QuartaFull or !QuintaFull or !SextaFull )) {
        PegaControles()
        if (Estilo = 1) {
            AtivaSkillsCS()
        }
        else if (Estilo = 2) {
            AtivaSkillsSC()
        }
    }
    ;GeraLog("AttMana: " A_TickCount - Inicio)
}
;ok
AtivaSkillsCS() {
    if (!ChkAbsal) {
        if (RetornaCorPixel(640, 788) != "0x27D6F8") {
            Loop, 1 {
                ClicaSegundaSkill()
                SegundaFull := false
            }
        }
        else
            SegundaFull := true
        if (RetornaCorPixel(875, 787) != "0x27D6F8" and SegundaFull) {
            Loop, 1 {
                ClicaQuintaSkill()
                QuintaFull := false
            }
        }
        else
            QuintaFull := true
        if (RetornaCorPixel(798, 792) != "0xF861AC" and SegundaFull and QuintaFull) {
            Loop, 1 {
                ClicaQuartaSkill()
                QuartaFull := false
            }
        }
        else
            QuartaFull := true
        if (RetornaCorPixel(721, 798) != "0x1BD0AC" and SegundaFull and QuintaFull) {
            Loop, 1 {
                ClicaTerceiraSkill()
                TerceiraFull := false
            }
        }
        else
            TerceiraFull := true
        if (RetornaCorPixel(963, 791) != "0x73767F" and SegundaFull and QuintaFull) {
            Loop, 1 {
                ClicaSextaSkill()
                SextaFull := false
            }
        }
        else
            SextaFull := true
        ;if (RetornaCorPixel(574, 791) != "0x0059E1" and SegundaFull and QuintaFull)
        ;{
        ;    Loop, 4
        ;    {
        ;        ClicaPrimeiraSkill()
        ;        PrimeiraFull := false
        ;    }
        ;}
        ;else
        PrimeiraFull := true
        if (PrimeiraFull AND SegundaFull AND TerceiraFull AND QuartaFull AND QuintaFull AND SextaFull)
            PodeContratoMana := true
        else
            PodeContratoMana := false
    } else {
        Loop, 5 {
            ClicaPrimeiraSkill()
            ClicaSegundaSkill()
            ClicaTerceiraSkill()
            ClicaQuartaSkill()
            ClicaQuintaSkill()
            ClicaSextaSkill()
        }
    }
}

AtivaSkillsSC() {
    if (!ChkAbsal) {
        ; Sexta Primeiro, depois quinta e o resto...
        ; Sexta
        if (RetornaCorPixel(953, 787) != "0x72A8E1") {
            Loop, 4 {
                ClicaSextaSkill()
                SextaFull := false
            }
        }
        else
            SextaFull := true
        if (RetornaCorPixel(873, 787) != "0xE8E263" and SextaFull) {
            Loop, 4 {
                ClicaQuintaSkill()
                QuintaFull := false
            }
        }
        else
            QuintaFull := true
        if (RetornaCorPixel(798, 793) != "0xF861AC" and SextaFull and QuintaFull) {
            Loop, 4 {
                ClicaQuartaSkill()
                QuartaFull := false
            }
        }
        else
            QuartaFull := true
        if (RetornaCorPixel(721, 798) != "0x1BD0AC" and SextaFull and QuintaFull) {
            Loop, 4 {
                ClicaTerceiraSkill()
                TerceiraFull := false
            }
        }
        else
            TerceiraFull := true
        if (RetornaCorPixel(643, 798) != "0x27D6F8" and SextaFull and QuintaFull) {
            Loop, 4 {
                ClicaSegundaSkill()
                SegundaFull := false
            }
        }
        else
            SegundaFull := true
        if (RetornaCorPixel(566, 798) != "0x2651F8" and SextaFull and QuintaFull) {
            Loop, 4 {
                ClicaPrimeiraSkill()
                PrimeiraFull := false
            }
        }
        else
            PrimeiraFull := true
        if (PrimeiraFull AND SegundaFull AND TerceiraFull AND QuartaFull AND QuintaFull AND SextaFull)
            PodeContratoMana := true
        else
            PodeContratoMana := false
    } else {
        Loop, 5 {
            ClicaPrimeiraSkill()
            ClicaSegundaSkill()
            ClicaTerceiraSkill()
            ClicaQuartaSkill()
            ClicaQuintaSkill()
            ClicaSextaSkill()
        }
    }
}

ClicaPrimeiraSkill(){
    ClicaRandom(591, 779, 2)
}
ClicaSegundaSkill(){
    ClicaRandom(668, 781, 2)
}
ClicaTerceiraSkill(){
    ClicaRandom(749, 780, 2)
}
ClicaQuartaSkill(){
    ClicaRandom(822, 779, 2)
}
ClicaQuintaSkill(){
    ClicaRandom(899, 781, 2)
}
ClicaSextaSkill(){
    ClicaRandom(980, 780, 2)
}

AttBarraStage() {
    ;for k,v in 10ultimos
    ;    sum +=v

    ;mediaStage := sum/10ultimos.Count()

    ;aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100

    ;if (aumento_percentual_media <= 1 and aumento_percentual_media >= 0 or 10ultimos.Count() = 0 or 10ultimos.Count() = "")
    ;{
    ;    10ultimos.Push(stage)
    ;}

    ;if (10ultimos.Count() >= 10)
    ;{
    ;    f := 10ultimos.RemoveAt(1)
    ;}

    ;GeraLog(10ultimos.Count() " - Removido: " f)
    ;aumento_percentual := ((stage - stageanterior) / stageanterior) * 100

    ;GeraLog("Stage: " stage " / StageAnterior: " stageanterior)
    ;GeraLog("Aumento: " 0aumento_percentual " - AumentoMedia:" aumento_percentual_media)
    ;GeraLog("MediaStage: " mediaStage)
    ;GeraLog(stage " / " stageanterior " - " aumento_percentual " - " aumento_percentual_media)

    PegaControles()
    StageProgess := (stage / Edit1) * 100
    if (stage > 1)
        PodeContratoStage := true
    else
        PodeContratoStage := false
    GuiControl, , PrgStage, %StageProgess%
}

AtualizaStatusSkillAtiva() {
    Inicio := A_TickCount
    FechaAllRapido()
    PegaControles()
    if (Estilo = 1) {
        EstaAtiva("Sexta")
        EstaAtiva("Quinta")
        EstaAtiva("Quarta")
        EstaAtiva("Terceira")
        EstaAtiva("Segunda")
        PrimeiraAtiva := true
        PrimeiraFull := true
        GuiControl, show, txtPrimeira
    } else {
        EstaAtiva("Sexta")
        EstaAtiva("Quinta")
        EstaAtiva("Quarta")
        EstaAtiva("Terceira")
        EstaAtiva("Segunda")
        EstaAtiva("Primeira")
    }
    ;GeraLog("AtualizaStatusSkillAtiva: " A_TickCount - Inicio)
}
;ok
EstaAtiva(skill) {
    X := %skill%PixelX
    Y := %skill%PixelY
    if (RetornaCorPixel(X, Y)=%skill%Color) {
        sulfixo := "iCount"
        nomeContadorVariavel := skill . sulfixo
        %nomeContadorVariavel% := 0
        %skill%Ativa := true
        GuiControl, show, txt%skill%
    } else {
        PodeContratoMana := false
        GuiControl, Hide, txt%skill%
        if (skill = "Primeira") {
            ClicaRandom(591, 779, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
        if (skill = "Segunda") {
            ClicaRandom(668, 781, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
        if (skill = "Terceira") {
            ClicaRandom(749, 780, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
        if (skill = "Quarta") {
            ClicaRandom(822, 779, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
        if (skill = "Quinta") {
            ClicaRandom(899, 781, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
        if (skill = "Sexta") {
            ClicaRandom(980, 780, 2)
            %skill%Ativa := false
            %skill%Full := false
            %skill%iCount++
        }
    }
    If (PrimeiraiCount >= 15 OR SegundaiCount >= 15 OR TerceiraiCount >= 15 OR QuartaiCount >= 15 OR QuintaiCount >= 15 OR SextaiCount >= 15) {
        GeraLog("Não comprou uma : " PrimeiraiCount SegundaiCount TerceiraiCount QuartaiCount QuintaiCount SextaiCount)
        CompraSkills()
    }
}

Calibrar() {
    PixelGetColor, PrimeiraColor, PrimeiraPixelX, PrimeiraPixelY
    PixelGetColor, SegundaColor, SegundaPixelX, SegundaPixelY
    PixelGetColor, TerceiraColor, TerceiraPixelX, TerceiraPixelY
    PixelGetColor, QuartaColor, QuartaPixelX, QuartaPixelY
    PixelGetColor, QuintaColor, QuintaPixelX, QuintaPixelY
    PixelGetColor, SextaColor, SextaPixelX, SextaPixelY

}

Travado() {
    if (A_Tickcount - TickPrestigio > 1800000) {
        if (TravadoCount > 0) {
            ChkMiR := false
            SetTimer CompraHeroi, 60000, On, 4
        }
        GeraLog("Estava mais de 30 minutos e fez o prestige")
        forcaprestige := true
        FazPrestige()
        TravadoCount++

    }
}

TempoDePrestigio() {
    PegaControles()
    if (!ChkAbsal) {
        if (A_Tickcount - TickPrestigio > MinToMili(20)) {
            Gui, Submit, NoHide
            if (Push = 3) {
                ;ChkMiR := false
                GeraLog("Estava mais de 20 minutos em um unico prestigio, desmarca o MiR, e forca")
                forcaprestige := true
            }
            Else {
                ;ChkMiR := false
                GeraLog("Estava mais de 20 minutos em um unico prestigio, desmarca o MiR, e forca")
                forcaprestige := true
            }
        }
    } else
        if (A_Tickcount - TickPrestigio > MinToMili(20)) {
            Gui, Submit, NoHide
            if (Push = 3 OR Push = 1) {
                ;ChkMiR := false
                GeraLog("Estava mais de 20 minutos em um unico prestigio, desmarca o MiR, e forca")
                forcaprestige := true
            }
        }
}

FazPrestige() {
    ;Inicio := A_TickCount
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100
    TempoDePrestigio()
    PegaControles()
    ;if ((StageProgess > 100 and stage > Edit1 and aumento_percentual >= 0 and aumento_percentual <= 0.2 and aumento_percentual_media < 0.5 and ChkPrestige)
    if ((StageProgess >= 100 and stage > Edit1 and ChkPrestige and Stage < 180000 and aumento_percentual < 2)
        or (forcaprestige and ChkPrestige)) {
        GeraLog("FazPrestige: " TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        GeraLogTempoPrest(TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        TravadoCount := 0
        forcaprestige := false
        if (!ProcuraAteAchar(573, 60, 635, 113, 60, "icone", 300)) {
            if (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500)) {
                while (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500)) {
                    if (A_Index > 40)
                    {
                        GeraLog("Deu erro ao Fazer Prestigio...")
                        return
                    }
                    FechaAllRapido()
                    AbreSkill()
                    SobeUmaPagina()
                    Sleep, 500
                }
            }
            ClicaRandom(AchouOutX, AchouOutY, 4)
            ;MouseClick, left, AchouOutX, AchouOutY
            Sleep, 300
        }
        ClicaRandom(780, 754, 4)
        ;MouseClick, left, 931, 769
        Sleep, 5000
        AtualizaInfosPrest()
        CompraSkills()
        GeraLog("Faltam " FormataMilisegundos(randVerificaClan - (A_tickcount - ultimaVerificadaClan)) " para verificar novamente.")
        PegaControles()
        GeraLog("Media : " txtMediaStage " - quantidade : " txtQntPres " - faltam : " QntPrestigioDiaConfig - QntPrestigioDia)
        FechaAllRapido()
        AtualizaStatusSkillAtiva()
        Sleep, 300
        AtualizaStatusSkillAtiva()
        CompraReliquia()
        DecideContinuaPrestige()
        ;SobeTudo()
        ;GeraLog("Tempo do FazPrestige(): " A_TickCount - Inicio)
        return
    }
    return
}

DecideContinuaPrestige() {
    PegaControles()
    if (QntPrestigioDia >= QntPrestigioDiaConfig) {
        paraPrestigioDia := true
        dataQueTerminou := A_Now
        horaQueTerminou := A_Hour
        minutoQueTerminou := A_Min

    }
}

AtualizaInfosPrest() {
    10ultimos := []
    prestmili := 1000
    aumento_percentual_media := 0
    StageProgess := 0
    totalStage := 0
    qntStage := 0
    if (A_Tickcount - TickPrestigio > 120000) {
        QntPrestigio++
        QntPrestigioDia++
        TempoTotal += A_Tickcount - TickPrestigio
        Media := TempoTotal/QntPrestigio
        Formatado := FormataMilisegundos(Media)
        GuiControl, , txtMediaStage, %Formatado%
        GuiControl, , txtQntPres, %QntPrestigio%
    }
    TickPrestigio := A_TickCount
    AtualizaTarget()
    stage := ""
}

AtualizaTarget() {
    Gui, Submit, NoHide
    PegaControles()
    if (Push = 1) {
        if (ChkAbsal) {
            Mais10 := stage+1000
            if (stage - Edit1 > 200) {
                Mais10 := Mais10+500
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
            }
            else {
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
            }
        }
        else {
            Mais10 := stage+50
            if (stage - Edit1 > 50) {
                Mais10 := Mais10+50
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
                return
            }
            else {
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
            }
        }
    }
    if (Push = 2) {
        Mais10 := stage + 20000
        GeraLog("Novo Target: " Mais10)
        GuiControl, , Edit1, %Mais10%
    }
}

DeuErro() {
    ImageSearch, X, Y, 859, 570, 1010, 620, *60 %a_scriptdir%\k.png
    if (ErrorLevel = 0) {
        MouseClick, left, X, Y
        Sleep, 500
        ImageSearch, X, Y, 859, 570, 1010, 620, *60 %a_scriptdir%\k.png
        if (ErrorLevel = 0) {
            MouseClick, left, X, Y
            Sleep, 500
        }
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel {
            MouseClick, left, OutX, OutY
            Sleep, 300
        }
        ClicaPrimeiraAba()
        GeraLog("Deu erro - WTF", true)
        return true
    }
    return false
}
;ok
VaiProBoss() {
    if (RetornaCorPixel(967, 68) = "0x1160ED") {
        ClicaRandom(967, 68, 4)
        ;MouseClick, left, X, Y
        Gui, Submit, NoHide
        if (Push <> 3) {
            GeraLog("Novo Target, por que estava travado: " stage)
            Novo := stage - 1
            GuiControl, , Edit1, %Novo%
        }
        else {
            If (StageProgess >= 99) {
                GeraLog("forca prestige, por que estava travado: " stage)
                forcaprestige := true
            }
            else {
                GeraLog("travado fora do boss, mas não estava mais que 99%")
            }
        }
    }
}

VaiClicaSkill(X, Y) {
    ClicaRandom(X, Y, 5)
    ;MouseClick, left, X, Y
    Sleep, 170
    ClicaRandom(X-130, Y, 2)
    ;MouseClick, left, X-122, Y
    Sleep, 170
    ComprouSkill++
}

ProcuraEClicaSkillRapido() {
    Inicio := A_TickCount
    loop, 50
    {
        PixelSearch, OutX, OutY, 959, 390, 963, 820, 0x0698F6, 30, Fast
        if !ErrorLevel {
            MouseClick, left, OutX+15, OutY
            loop, 10 {
                PixelSearch, OutX, OutY, 862, 389, 865, 810, 0x2929C3, 5, Fast
                if !ErrorLevel {
                    ComprouSkill++
                    MouseClick, left, OutX-5, OutY
                    Sleep, 100
                    Break
                }
            }
        }
        FechaXgrande1()
        if (ComprouSkill >= 6)
            Break
    }
    GeraLog("ProcuraEClicaSkillRapido: " A_TickCount - Inicio)
}

ProcuraEClicaSkill() {
    loop, 5
    {
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel {
            ClicaRandom(OutX, OutY, 5)
            ;MouseClick, left, OutX, OutY
            Sleep, 300
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\spell.png
        if !ErrorLevel {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\upgr.png
        if !ErrorLevel {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\spell2.png
        if !ErrorLevel {
            VaiClicaSkill(OutX, OutY)
        }
    }
}

SobeTudo() {
    AbreSkill()
    ImageSearch, OutX, OutY, 702, 842, 780, 880, *40 %a_scriptdir%\espada.png
    if (ErrorLevel = 0) {
        while (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500)) {
            if (A_Index > 40) {
                return
            }
            SobeUmaPagina()
        }
    } else {
        FechaColetaRapida()
        AbreSkill()
        SobeTudo()
    }
    FechaSkill()
    FechaAllRapido()
}
;ok
CompraSkills() {
    Inicio := A_TickCount
    ComprouSkill := 0
    PrimeiraiCount := 0
    SegundaiCount := 0
    TerceiraiCount := 0
    QuartaiCount := 0
    QuintaiCount := 0
    SextaiCount := 0
    Gui, submit, NoHide
    PegaControles()
    if (ChkAbsal and Estilo = 3) {
        loop, 5 {
            Send, {a up}
            Sleep, 20
            Send, a
            Sleep, 20
        }
    }
    FechaAllRapido()
    AbreSkill()
    if (RetornaCorPixel(594, 836) = "0xC5B696") {
        Sleep, 100
        ClicaRandom(941, 159, 5)
        ProcuraEClicaSkillRapido()
        if (A_TickCount - Boost > MinToMili(10)) {
            DesceUmaPagina()
            loop, 15 {
                if (ProcuraAteAchar(872, 607, 1014, 826, 60, "fr", 300)) {
                    Sleep, 300
                    ClicaRandom(AchouOutX+50, AchouOutY+10, 5)
                    Boost := A_TickCount
                    ;MouseClick, left, OutX, OutY
                    Sleep, 300
                    ClicaRandom(774, 643, 5)
                    ;MouseClick, left, 939, 664
                    Sleep, 30
                    break
                }
            }
            SobeUmaPagina()
            SobeUmaPagina()
        }
    } else {
        GeraLog("CompraSkills: " A_TickCount - Inicio)
        CompraSkills()
    }
    FechaAllRapido()
    GeraLog("CompraSkills: " A_TickCount - Inicio)
    return
}
;ok
AbreSkill() {
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(594, 836) = "0xC5B696") {
        return
    } else {
        ClicaPrimeiraAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(985, 45, "0x2C2C2D", 700)) {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbreSkill()
        }
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        return
    }
}

EquipaMelhorItem() {
    AbreEquip()
    Inicio := A_TickCount
    Loop, parse, TipoHeroi, `,
    {
        FechaColetaRapida()
        ImageSearch, OutX, OutY, 647, 171, 959, 188, *140 *Transblack %a_scriptdir%\%A_LoopField%.png
        if !ErrorLevel {
            ;GeraLog("Achou o : " A_LoopField)
            ;if (ItemEquipado != A_LoopField) {
            if (ItemEquipado != "a") {
                ;ImageSearch, OutX, OutY, 770, 221, 1047, 846, *90 *Transblack %a_scriptdir%\%A_LoopField%texto.png
                if (ProcuraAteAchar(683, 214, 756, 825, 150, A_LoopField . "texto", 1000)) {

                    GeraLog("Trocou o item para " A_LoopField)
                    loop, 3
                    {
                        FechaColetaRapida()
                        ;MouseMove, AchouOutX, AchouOutY
                        ;Sleep, 1000
                        ;MouseMove, AchouOutX+270, AchouOutY-20
                        ClicaRandom(AchouOutX+270, AchouOutY-20, 5)

                    }
                    Sleep, 100
                    ;1106, 251
                    ItemEquipado := A_LoopField
                    break
                }
                if (ItemEquipado != A_LoopField) {
                    GeraLog("Não conseguiu equipar o item.")
                    ItemEquipado := "deu ruim"
                }
            }
            break
        }
        else {
            ;GeraLog("Não achou o : "A_LoopField)
        }
    }
    ;GeraLog("EquipaMelhorItem: " A_TickCount - Inicio)
    ;FechaAllRapido()
}
;ok
AbreEquip() {
    Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(747, 840) = "0xA56B95") {
        if !(ProcuraPixelAteAchar(660, 142, "0x444042", 700)) {
            ClicaRandom(660, 111, 5)
            Sleep, 150
        }
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        return
    } else {
        ClicaTerceiraAba()
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(747, 840, "0xA56B95", 700)) {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbreEquip()
        }
        if !(ProcuraPixelAteAchar(660, 142, "0x444042", 700)) {
            ClicaRandom(660, 111, 5)
            Sleep, 150
        }
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        return
    }
}
;ok
AbreSkillDiretoProPresitigo() {
    Inicio := A_TickCount
    ; Procura aba aberta da Espada
    if (RetornaCorPixel(594, 836) = "0xC5B696") {
        ; Espera abrir o icone, e vai clicando
        while (!ProcuraPixelAteAchar(777, 304,"0xFFFFFF", 3)) {
            Cima()
            ;Protecao pra não ficar aqui muito tempo, 6.0.
            if (RetornaCorPixel(943, 252) = "0x494949")  
                return
            ClicaRandom(945, 260, 5)
            if (A_Index > 30) {
                SobeUmaPagina()
                return
            }
        }
        ;GeraLog("AbreSkill já estava aberta: " A_TickCount - Inicio)
        return
    } else {
        ClicaPrimeiraAba()
        ; Espera abrir a aba aberta da Espada
        if (ProcuraPixelAteAchar(594, 836, "0xC5B696", 1000)) {
            ;GeraLog("AbreSkill abriu: " A_TickCount - Inicio)
            ; Espera abrir o icone, e vai clicando
            while (!ProcuraPixelAteAchar(777, 304,"0xFFFFFF", 15)) {
                ;Protecao pra não ficar aqui muito tempo, 6.0.
                if (RetornaCorPixel(943, 252) = "0x494949")  
                    return
                Cima()
                FechaColetaRapida()
                ClicaRandom(945, 260, 5)
                if (A_Index > 30) {
                    SobeUmaPagina()
                    return
                }
            }
            ;GeraLog("AbreSkill abriu2: " A_TickCount - Inicio)
        }
        else {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbreSkillDiretoProPresitigo()
        }
        ;GeraLog("AbreSkill final: " A_TickCount - Inicio)
        return
    }

}

FechaXzin() {
    ImageSearch, OutX, OutY, 1112, 50, 1166, 75, *23 %a_scriptdir%\xzin.png
    if (ErrorLevel = 0) {
        ClicaRandom(OutX, OutY, 5)
        ;MouseClick, left, OutX, OutY
        ProcuraAteNaoAchar(1112, 50, 1166, 75, 23, "xzin", 2000)
    }
}

FechaSkill() {
    ImageSearch, OutX, OutY, 702, 842, 780, 880, *40 %a_scriptdir%\espada.png
    if (ErrorLevel = 0) {
        ClicaPrimeiraAba()
        Sleep, 115
        return
    } else {
        return
    }
}

StatusSkill(X, Y, W, H, skill) {
    nome := ""
    tempo := ""
    FechaAllRapido()
    nome := "txt" . skill
    tempo := RegExReplace(RegExReplace(RetornaText(X, Y, W, H), "[íi{[<]",":"), "[^\d:]", "")
    if (StrLen(tempo)> 2) {
        if (RegExMatch(tempo, "^\d{2}:\d{2}$")>0)
            GuiControl, , %nome%, %tempo%
    } else if (tempo="") {
        GuiControl, , %nome%, SIM
    }
}

;ok
FechaColetaRapida() {
    ;Inicio := A_TickCount
    if (RetornaCorPixel(774, 664) = "0xCEA43D") {
        ClicaRandom(774, 664, 5)
        ProcuraPixelAteNaoAchar(774, 664, "0xCEA43D", 2000)
        ;GeraLog("FechaColetaRapida: " A_TickCount - Inicio)
        return true
    }
    ;GeraLog("FechaColetaRapida: " A_TickCount - Inicio)
    return false
}

CompraReliquia() {
    Gui, Submit, NoHide
    if (Qual = 1) {
        BoS()
    } else if (Qual = 2) {
        All()
    } else if (Qual = 3) {
        if (alternado) {
            BoS()
            alternado := false
            qntVezesAll++
        }
        else {
            All()
            alternado := true
            qntVezesAll := 0
        }
    }
}

BoS() {
    ClicaQuintaAba()
    Sleep, 500
    Cima()
    while (!ProcuraAteAchar(553, 148, 629, 473, 60, "BoS", 700)) {
        if (A_Index > 10) {
            return
        }
        SobeUmaPagina()
    }
    ProcuraAteAchar(553, 148, 629, 473, 60, "BoS", 700)
    loop, 10
    {
        ClicaRandom(AchouOutX+351, AchouOutY-3, 5)
        Sleep, 150
    }
    ClicaQuintaAba()
}

All() {
    ClicaQuintaAba()
    Sleep, 500
    Cima()
    while (!ProcuraAteAchar(872, 84, 1012, 252, 60, "all", 700)) {
        if (A_Index > 10) {
            return
        }
        SobeUmaPagina()
    }
    Sleep, 150
    ProcuraAteAchar(872, 84, 1012, 252, 60, "all", 700)
    loop, 10
    {
        ClicaRandom(AchouOutX, AchouOutY, 3)
        Sleep, 150
    }
    Sleep, 500
    ClicaQuintaAba()
    Sleep, 500
}

GuiSize:
If (A_EventInfo == 1) {
    Return
}

Return

GuiClose:
ExitApp

Pause::Pause,,1

Ativa() {
    WinActivate BlueStacks
    Click, 784 49 Right
}

SobeUmaPagina() {
    MouseMove, 892, 600
    Send {LButton down}
    MouseMove, 901, 846, 10
    Sleep, 50
    Send {LButton up}
}

SobePaginaRapido() {
    MouseMove, 782, 625
    Loop, 3
    {
        loop, 30 {
            Click, WU
            Sleep, 20
        }
    }
}

DesceUmaPaginaRapido() {
    MouseMove, 745, 819
    loop, 1
    {
        Click, WD
        Sleep, 20
    }
}

DesceUmaPagina() {
    MouseMove, 745, 819-30
    Send {LButton down}
    MouseMove, 752, 602-90, 10
    Sleep, 25
    Send {LButton up}
}

DesceUmaPaginaGrande() {
    MouseMove, 745, 819
    Send {LButton down}
    MouseMove, 776, 109, 10
    Sleep, 25
    Send {LButton up}
}

TempoPassado() {
    millisec := A_Tickcount - TickPrestigio
    ; Calcula o número total de segundos
    totalSec := Floor(millisec / 1000)

    ; Calcula o número de minutos
    minutes := Floor(totalSec / 60)

    ; Calcula o número de segundos restantes
    seconds := Mod(totalSec, 60)

    ; Retorna o resultado formatado como minutos:segundos
    return minutes ":" Format("{:02d}", seconds)

}

FormataMilisegundos(millisec) {
    totalSec := Floor(millisec / 1000)

    ; Calcula o número de minutos
    minutes := Floor(totalSec / 60)

    ; Calcula o número de segundos restantes
    seconds := Mod(totalSec, 60)

    ; Retorna o resultado formatado como minutos:segundos
    return minutes ":" Format("{:02d}", seconds)
}
;ok
ClanRaid() {
    ;ImageSearch, OutX, OutY, 600, 38, 648, 79, *60 %a_scriptdir%\raid.png
    if (RetornaCorPixel(625, 54) != "0x2A4BC5") {
        Random, randVerificaClan, MinToMili(1), MinToMili(1)
        GeraLog("Entrou no Raid")
        MouseClick, left, 621, 53
        loop, 5 {
            SoundBeep, 300, 300
        }
        if (!ProcuraPixelAteAchar(893, 86, "0x76787F", 3000)) {
            GeraLog("Nao conseguiu abrir o raid, sai fora")
            FechaAllRapido()
            return
        }
        ImageSearch, OutX, OutY, 576, 91, 993, 503, *60 %a_scriptdir%\fundoazul.png
        if (ErrorLevel = 0) {
            MouseClick, left, OutX, OutY
            Sleep, 1500
        }
        ImageSearch, OutX, OutY, 553, 86, 699, 180, *60 %a_scriptdir%\abaraid.png
        if ErrorLevel {
            GeraLog("Não estava na aba raid, clicou pra ir")
            MouseClick, left, 631, 120
            if (!ProcuraPixelAteAchar(948, 396, "0xAC9220", 10000)) {
                GeraLog("Nao conseguiu abrir a aba raid, sai fora")
                FechaAllRapido()
                return
            }
        }
        if (!ProcuraPixelAteAchar(948, 396, "0xAC9220", 10000)) {
            GeraLog("Nao conseguiu abrir a aba raid, sai fora")
            FechaAllRapido()
            return
        }
        GeraLog("Procurando qual parte precisa atacar")
        parte := "nenhuma"
        Loop, parse, listaPartes, `,
        {
            if (AlvoEmQualParte(A_LoopField, "alvo")) {
                if (ParteTemVida(A_LoopField)) {
                    parte := A_LoopField
                    break
                }
            }
        }
        if (parte = "nenhuma") {
            Loop, parse, listaPartes, `,
            {
                if (ParteTemVida(A_LoopField)) {
                    if (!AlvoEmQualParte(A_LoopField, "x"))
                    {
                        parte := A_LoopField
                        break
                    }
                }
            }
        }
        GeraLog("Vai atacar a parte : " parte)
        CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/raid/" parte "-" A_now ".png")
        if (parte = "nenhuma") {
            GeraLog("Aborta!!! Nao achou nenhuma parte", true)
            loop, 2
            {
                FechaAllRapido()
            }
            return
        }
        ImageSearch, OutX, OutY, 821, 758, 935, 805, *60 %a_scriptdir%\fig.png
        if !ErrorLevel {
            MouseClick, left, OutX, OutY
            Sleep, 1500
            while (TrocaAba()) {
                Sleep, 500
                ImageSearch, OutX, OutY, 819, 575, 913, 612, *60 %a_scriptdir%\fig2.png
                if (ErrorLevel = 0) {
                    MouseClick, left, OutX, OutY
                    Sleep, 300
                    AtacarParte(parte)
                    break
                }
            }
        }
        loop, 2 {
            FechaAllRapido()
        }
    } else {
        Aviso := true
        GeraLog("Não precisava entrar na raid.")
        Random, randVerificaClan, MinToMili(randClanMin), MinToMili(randClanMax)
    }
}

AttPagina() {
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba1.png
    if (ErrorLevel = 0) {
        Pagina := 1
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba2.png
    if (ErrorLevel = 0) {
        Pagina := 2
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba3.png
    if (ErrorLevel = 0) {
        Pagina := 3
    }
}

TrocaPagina() {

    if (Pagina = 3) {
        MouseMove, 798, 389
        Sleep, 20
        Send {LButton down}
        MouseMove, 1078, 391, 25
        Sleep, 200
        Send {LButton up}
        indo := false
    }
    if (Pagina = 1) {
        MouseMove, 1078, 391
        Sleep, 20
        Send {LButton down}
        MouseMove, 798, 389, 25
        Sleep, 200
        Send {LButton up}
        indo := true
    }
    if (Pagina = 2 and indo) {
        MouseMove, 1078, 391
        Sleep, 20
        Send {LButton down}
        MouseMove, 798, 389, 25
        Sleep, 200
        Send {LButton up}
    }
    if (Pagina = 2 and !indo) {
        MouseMove, 798, 389
        Sleep, 20
        Send {LButton down}
        MouseMove, 1078, 391, 25
        Sleep, 200
        Send {LButton up}
    }
}

TrocaAba() {
    AttPagina()
    ImageSearch, OutX, OutY, 729, 125, 833, 164, *60 %a_scriptdir%\abaraid.png
    if (ErrorLevel = 0) {
        MouseClick, left, OutX, OutY
        Sleep, 3000
        Aba := 0
    }
    Aba++
    if (Aba = 1)
        MouseClick, left, 622, 368
    Else if (Aba = 2)
        MouseClick, left, 665, 369
    Else if (Aba = 3)
        MouseClick, left, 711, 370
    Else if (Aba = 4)
        MouseClick, left, 761, 372
    Else if (Aba = 5)
        MouseClick, left, 808, 366
    Else if (Aba = 6)
        MouseClick, left, 855, 370
    Else if (Aba = 7)
        MouseClick, left, 898, 368
    Else if (Aba = 8)
        MouseClick, left, 945, 370
    Else {
        Aba := 0
        ;TrocaPagina()
        Sleep, 200
        TrocaAba()
    }
    return Pagina <> 5
}

Fight() {
    Sleep, 3000
    Inicio := A_TickCount
    loop,
    {
        MouseMove, 1084, 350, 3
        Send {LButton down}
        MouseMove, 1049, 350, 3
        MouseMove, 998, 350, 3
        MouseMove, 943, 339, 3
        MouseMove, 887, 327, 3
        MouseMove, 858, 323, 3
        MouseMove, 826, 321, 3
        MouseMove, 800, 328, 3
        MouseMove, 774, 361, 3
        MouseMove, 756, 408, 3
        MouseMove, 749, 460, 3
        MouseMove, 765, 497, 3
        MouseMove, 787, 507, 3
        MouseMove, 828, 512, 3
        MouseMove, 879, 495, 3
        MouseMove, 918, 465, 3
        MouseMove, 935, 453, 3
        MouseMove, 995, 453, 3
        MouseMove, 1068, 492, 3
        MouseMove, 1100, 508, 3
        MouseMove, 1125, 421, 3
        MouseMove, 1113, 363, 3
        MouseMove, 1077, 330, 3
        MouseMove, 997, 319, 3
        MouseMove, 909, 324, 3
        MouseMove, 840, 322, 3
        MouseMove, 798, 324, 3
        MouseMove, 761, 380, 3
        MouseMove, 755, 456, 3
        MouseMove, 761, 521, 3
        MouseMove, 779, 517, 3
        MouseMove, 896, 453, 3
        MouseMove, 969, 458, 3
        MouseMove, 1085, 477, 3
        MouseMove, 1062, 327, 3
        MouseMove, 852, 311, 3
        Send {LButton up}
        ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
        if (ErrorLevel = 0 or (A_TickCount - Inicio) = 40000) {
            Sleep, 300
            MouseClick, left, OutX, OutY
            Sleep, 3000
            return
        }
    }
}

Presente() {
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 942, 168, 1014, 417, *60 %a_scriptdir%\presente.png
    if !ErrorLevel {
        MouseClick, left, OutX, OutY
        Sleep, 300
        MouseClick, left, 775, 559
        Sleep, 300
        MouseClick, left, 952, 796
        Sleep, 300
        MouseClick, left, 786, 146
        Sleep, 300
        GeraLog("Pegou o Login diario.")
    }
    ;GeraLog(A_TickCount - inicio)
}

Ovo() {
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 947, 227, 1019, 447, *60 %a_scriptdir%\ovo.png
    if !ErrorLevel {
        MouseClick, left, OutX, OutY
        Sleep, 1500
        MouseClick, left, 979, 773
        Sleep, 300
        GeraLog("Pegou o ovo de graça.")
    }
    ;GeraLog(A_TickCount - inicio)
}

MoveAleatorioQuadrado(X, Y, H, W) {
    Random, RandomX, X, X + H
    Random, RandomY, Y, Y + W
    MouseMove, RandomX, RandomY, 1
}

AtacarParte(parte) {
    Sleep, 2000
    MouseMove, 827, 312
    Inicio := A_TickCount
    if (parte = "cabeca") {
        ; Coordenadas do quadrado
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(751, 273, 69, 47)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Sleep, 100
                    Send {LButton up}
                    ClicaRandom(OutX, OutY)
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "ombro esquerdo") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(571, 262, 67, 61)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "ombro direito") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(940, 268, 59, 64)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "mao esquerda") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(559, 491, 54, 64)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "mao direita") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(948, 490, 49, 44)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "torso") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(749, 445, 74, 26)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "perna esquerda") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(702, 563, 33, 106)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "perna direita") {
        Send {LButton down}
        loop, {
            MoveAleatorioQuadrado(843, 575, 31, 108)
            if ((A_TickCount - Inicio) >= 30000) {
                ImageSearch, OutX, OutY, 559, 634, 1020, 728, *60 %a_scriptdir%\continue.png
                if !ErrorLevel {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }
}

AlvoEmQualParte(parte, tipo) {
    if (parte="cabeca") {
        SetaVariaveisEntrada(769, 252, 793, 275)
        ;EntradaX = 920
        ;EntradaY = 268
        ;EntradaH = 945
        ;EntradaW = 294
    }
    if (parte="torso") {
        SetaVariaveisEntrada(770, 323, 792, 340)
    }
    if (parte="ombro esquerdo") {
        SetaVariaveisEntrada(686, 268, 709, 290)
    }
    if (parte="ombro direito") {
        SetaVariaveisEntrada(847, 268, 873, 291)
    }
    if (parte="mao esquerda") {
        SetaVariaveisEntrada(686, 352, 709, 376)
    }
    if (parte="mao direita") {
        SetaVariaveisEntrada(846, 351, 873, 376)
    }
    if (parte="perna esquerda") {
        SetaVariaveisEntrada(734, 401, 758, 423)
    }
    if (parte="perna direita") {
        SetaVariaveisEntrada(809, 399, 834, 424)
    }
    loop, 4
    {
        ImageSearch, OutX, OutY, EntradaX, EntradaY, EntradaH, EntradaW, *40 %a_scriptdir%\%tipo%%A_Index%.png
        if !ErrorLevel {
            MouseMove, OutX, OutY
            return true
        }
    }
    ;ImageSearch, OutX, OutY, EntradaX, EntradaY, EntradaH, EntradaW, *40 %a_scriptdir%\%tipo%2.png
    ;if !ErrorLevel
    ;{
    ;    MouseMove, OutX, OutY
    ;    return true
    ;}
}

SetaVariaveisEntrada(X, Y, H, W) {
    EntradaX := X
    EntradaY := Y
    EntradaH := H
    EntradaW := W
}

ParteTemVida(parte) {
    loop, 10
    {
        if (parte="cabeca") {
            loop, 5 {
                ; Cabeca armor
                ImageSearch, OutX, OutY, 730, 205, 828, 285, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro esquerdo") {
            loop, 5 {
                ; ombro esquerdo armor
                ImageSearch, OutX, OutY, 654, 241, 738, 297, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro direito") {
            loop, 5 {
                ; ombro direito armor
                ImageSearch, OutX, OutY, 824, 218, 901, 306, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="torso") {
            loop, 5 {
                ; torso armor
                ImageSearch, OutX, OutY, 735, 294, 824, 353, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="mao esquerda") {
            loop, 5 {
                ; mao esquerda armor
                ImageSearch, OutX, OutY, 648, 317, 731, 377, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="mao direita") {
            loop, 5 {
                ; mao direita armor
                ImageSearch, OutX, OutY, 814, 309, 913, 376, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna esquerda") {
            loop, 5 {
                ; perna esquerda armor
                ImageSearch, OutX, OutY, 703, 376, 780, 440, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna direita") {
            loop, 5 {
                ; perna direita armor
                ImageSearch, OutX, OutY, 777, 371, 846, 443, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
    }
    return false
}

ClicaRandomRapido(X, Y, var) {

}

ClicaRandom(X, Y, var := 3, velo := 5) {
    if (velo < 5)
        velo := 5
    Random, rand, -var, var
    Random, rand2, -var, var
    SendMouse_LeftClick(X+rand, Y+rand2, velo)
    ;MouseClick, left, X+rand, Y+rand2
}

randSleep(mili) {
    Random, rand, mili-(mili//5), mili
    return rand
}

ClicaRandomDois(X, Y, var, var2) {
    Random, rand, -var, var
    Random, rand2, -var2, var2
    MouseClick, left, X+rand, Y-rand2
}

ClicaRandomComFecha(X, Y, var) {
    FechaColetaRapida()
    Random, rand, -var, var
    Random, rand2, -var, var
    MouseClick, left, X+rand, Y+rand2
    FechaColetaRapida()
    MouseClick, left, X+rand, Y+rand2
}
;ok
Cima() {
    ;Inicio2 := A_TickCount
    ;ImageSearch, OutX, OutY, 1039, 496, 1109, 524, *40 %a_scriptdir%\cima.png
    if (RetornaCorPixel(922, 490) = "0x2B2C2E") {
        GeraLog("Cima")
        ClicaRandom(922, 490, 3)
        Sleep, 150
    }
    ;GeraLog("Cima:" A_TickCount - Inicio2)
}

lua() {
    ImageSearch, OutX, OutY, 1031, 53, 1168, 130, *60 %a_scriptdir%\lua.png
    if (ErrorLevel = 0) {
        MouseClick left, 742, 56
        Sleep, 400
        MouseClick left, 1034, 384
        Sleep, 400
        MouseClick left, 995, 754
        Sleep, 60000
        MouseClick left, 1087, 744
        Sleep, 400
        MouseClick left, 930, 89
        Sleep, 400
        MouseClick left, 930, 89
        Sleep, 400
    }
}

FechaSeta() {
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 558, 91, 609, 429, *90 *Transblack %a_scriptdir%\seta.png
    if !ErrorLevel
    {
        GeraLog("Clicou seta")
        ClicaRandom(OutX+2, OutY+10, 1)
        ProcuraAteNaoAchar(558, 91, 609, 429, 90, "seta", 600)
        ProcuraAteNaoAchar(558, 91, 609, 429, 90, "seta", 600)
    }
    ;GeraLog(A_TickCount - Inicio)
}

FechaJogoEAbre() {
    GeraLog("Fechou o jogo")
    qntAchou := 0
    MouseClick, left, 1889, 856
    Sleep, 5000
    MouseClick, left, 1256, 114
    Sleep, 5000
    GeraLog("Abriu o jogo")
    MouseClick, left, 1057, 288
    Sleep, 60000
    GeraLog("Terminou de abrir")
}
;ok
FechaBluestacksEAbre() {
    FechaBluestacks()
    AbreBluestacks()
}
;ok
FechaBluestacks() {
    PegaControles()
    if (ChkAbsal) {
        Pause
    }
    qntAchou := 0
    MouseClick, left, 1550, 12
    loop, 2 {
        loop, 3 {
        if (ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 70, "fecharbluestacks" A_index, 3000))
            ClicaRandom(AchouOutX+15, AchouOutY+5)
        }
    }
    GeraLog("Fechou o bluestacks")
    Sleep, 300
    return
}

;ok
AbreBluestacks() {
    ; Comando que você deseja executar
    comando := "for /f ""tokens=2"" %A in ('tasklist ^| findstr /i ""HD-Player.exe"" 2^>NUL') do ECHO %A"
    ; Executa o comando e obtém o resultado
    resultado := ExecutarComando(comando)
    resultado := StrReplace(StrReplace(resultado, "`r`n")," ")
    if (resultado != "") {
        GeraLog("Jogo estava aberto, fecha.")
        GeraLog(resultado)
        Run, taskkill /PID %resultado% /F, , Hide
        Sleep, 1500
    }
    Run, "C:\Program Files\BlueStacks_nxt\HD-Player.exe" --instance Nougat64 --cmd launchApp --package "com.gamehivecorp.taptitans2"
    GeraLog("Abriu o bluestacks no jogo")
    ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "max", 30000)
    MouseClick, left, AchouOutX+5, AchouOutY+5
    GeraLog("Maximizou o bluestacks")
    GeraLog("Esperando Carregar")
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < MinToMili(3)) {
        if(ProcuraPixelAteAchar(978, 835, "0x3F4423", 300)) {
            Ativa()
            GeraLog("Carregou tudo...")
            Sleep, 1000
            return
        }
        if(ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "app", 300)) {
            MouseClick, left, AchouOutX, AchouOutY
            GeraLog("Clicou no app...")
            Sleep, 3000
        }
        if(ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "okay", 300)) {
            MouseClick, left, AchouOutX, AchouOutY
            GeraLog("Falha no carregamento, clicou no okay.")
            Sleep, 3000
            ; Comando que você deseja executar
            comando := "for /f ""tokens=2"" %A in ('tasklist ^| findstr /i ""HD-Player.exe"" 2^>NUL') do ECHO %A"
            ; Executa o comando e obtém o resultado
            resultado := ExecutarComando(comando)
            resultado := StrReplace(StrReplace(resultado, "`r`n")," ")
            if (resultado != "") {
                GeraLog("Jogo estava aberto, fecha.")
                GeraLog(resultado)
                Run, taskkill /PID %resultado% /F, , Hide
                Sleep, 1500
            }
            AbreBluestacks()
        }
    }
    GeraLog("Não carregou.")
    ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "max", 1000)
    MouseClick, left, AchouOutX, AchouOutY
    Sleep, 1000
    FechaBluestacks()
    GeraLog("Fechou o bluestacks")
    AbreBluestacks()
    return
}
;ok
JogoAberto() {
    ; Procura Bau, ultimo icone da direita
    ;ImageSearch, OutX, OutY, 1104, 849, 1157, 879, *90 %a_scriptdir%\baudireita.png
    if (RetornaCorPixel(978, 835) = "0x3F4423" or RetornaCorPixel(631, 111) = "0x000000") {
        ;GeraLog("Jogo Estava aberto")
        return true
    }
    loop,
    {
        FechaAllRapido()
        if (RetornaCorPixel(978, 835) = "0x3F4423" or RetornaCorPixel(631, 111) = "0x000000") {
            return true
        }
        ClicaRandom(783, 59, 5)
        if (A_Index > 10) {
            CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/erros/" A_now ".png")
            GeraLog("Jogo não estava aberto")
            return false
        }
    }
}
;ok
FechaXzinRapido() {
    ;Inicio := A_TickCount
    if (RetornaCorPixel(985, 45) = "0x2C2C2D") {
        ClicaRandom(985, 45, 2)
        ProcuraPixelAteNaoAchar(985, 45, "0x2C2C2D", 2000)
    }
    ;GeraLog("FechaXzinRapido: " A_TickCount - Inicio)
}
;ok?
FechaAllRapido() {
    ;Inicio := A_TickCount
    if (RetornaCorPixel(576, 683) != "0x537EFA") {
        ;GeraLog("Não achou o relic")
        loop, 5 {
            FechaColetaRapida()
            FechaXzinRapido()
            FechaXgrande3()
            FechaXgrande2()
            FechaXgrande1()
            ;Não sei oque é isso
            FechaXgrande4()
        }
    }
    PegaControles()
    if (!ChkAbsal) {
        If (qntAchou > 400) {
            GeraLog("Estava com lag, fechou e abriu: " qntAchou)
            FechaBluestacksEAbre()
        }
    }
    ;GeraLog("FechaAll: " A_TickCount - Inicio)
}
;ok
FechaXgrande1() {
    if (RetornaCorPixel(960, 192) = "0x343436") {
        ClicaRandom(960, 192+5, 1)
        ProcuraPixelAteNaoAchar(960, 192, "0x343436", 500)
    }
}

FechaXgrande2() {
    ;Procura o X do Prestige e janelas parecidas
    ; 0x393A3B = Prestige
    ; 0x39393B = Hero info
    ; Não sei o quarto em diante.
    PixelGetColor, OutputVar, 969, 92
    if (OutputVar = "0x393A3B"
        or OutputVar = "0x39393B"
        or OutputVar = "0x64666C"
        or OutputVar = "0x7A7C83"
        or OutputVar = "0x75777E"
        or OutputVar = "0x505257"
        or OutputVar = "0x38393B") {
        ClicaRandom(969, 92, 1)
        ProcuraPixelAteNaoAchar(969, 92, OutputVar, 500)
    }
}

;ok
FechaXgrande3() {
    ; Procura o X do botão prestigio info (dentro do prestigio, aonde tem as informações de advanced start)
    ;tambem procura o Solo Raid
    corFechaxGrande3 := RetornaCorPixel(956, 128)
    if (corFechaxGrande3 = "0x38383A" or corFechaxGrande3 = "0x33383A") {
        ClicaRandom(956, 128+5, 1)
        ProcuraPixelAteNaoAchar(956, 128, "0x38383A", 500)
    }
}
;não sei oque é isso
FechaXgrande4() {
    if (RetornaCorPixel(967, 161) = "0x38383A") {
        ClicaRandom(967, 161)
        ProcuraPixelAteNaoAchar(967, 161, "0x38383A", 500)
    }
}

SendSMS(txt) {
    Body := """Body=" . txt . """"
    RunWait, curl -X POST "https://api.twilio.com/2010-04-01/Accounts/AC913aa069bbfadb06c4b20a9b326c6f14/Messages.json" --data-urlencode %Body% --data-urlencode "From=+13613664986" --data-urlencode "To=+5511985245602" -u AC913aa069bbfadb06c4b20a9b326c6f14:7923dc5a2a33b1e6399061f97ac7e465, ,Hide
    return
}

MinToMili(min) {
    return min * 60000
}

RetornaCorPixel(X, Y) {
    PixelGetColor, OutputVar, X, Y
    return OutputVar
}

AtivaAA() {
    Inicio := A_TickCount
    FechaSeta()
    loop, 10
    {
        ImageSearch, OutX, OutY, 867, 114, 1017, 479, *18 %a_scriptdir%\seilamano.png
        if !ErrorLevel {
            GeraLog("Achou2 " A_TickCount - Inicio)
            ClicaRandom(OutX+5, OutY+5, 5)
        }
        ImageSearch, OutX, OutY, 552, 197, 693, 483, *18 %a_scriptdir%\seilamano.png
        if !ErrorLevel {
            GeraLog("Achou1 " A_TickCount - Inicio)
            ClicaRandom(OutX+5, OutY+5, 5)
        }
    }
    ;GeraLog("Terminou " A_TickCount - Inicio)
}

AtivaAAv2() {
    Inicio := A_TickCount
    FechaSeta()
    ;FindClick()
    loop, 1
    {
        ;GeraLog(1280-A_ScreenWidth " " 302-A_ScreenHeight)
        Options = a549,196,142,283 o29 e0 t-1 Stay1
        FindClick("\seilamano.png", Options)
        Options = a874,93,141,385 o29 e0 t-1 Stay1
        FindClick("\seilamano.png", Options)
    }
    ;GeraLog("Terminou " A_TickCount - Inicio)
}

VerificaNaoEssenciais(rand := 600000) {
    if (rand > MinToMili(9)) {
        Ovo()
        Presente()
        loop, 60 {
            ClanRaid()
            Sleep, 1000
        }
        DailyChest()
        DailyRaid()
        QuestPet()
        ClanEmail()
        DailyQuest()
        TempoResete()
    } else
        ClanRaid()
}
;OK
QuestPet() {
    AbrePet()
    ClicaRandom(890, 123)
    if (ProcuraPixelAteAchar(887, 162, "0x76787F", 1000)) {
        loop, 30 {
            PixelSearch, OutX, OutY, 918, 245, 930, 688, 0x00C47D, 10, Fast
            if !ErrorLevel {
                ClicaRandom(OutX, OutY)
                if (ProcuraAteAcharTransBlack(894, 760, 1019, 837, 80, "skip", 5000)) {
                    Sleep, 300
                    ClicaRandom(AchouOutX, AchouOutY)
                    GeraLog("Usou power de pet")
                }
            }
        }
        if (!fezreroll) {
            loop, 30 {
                PixelSearch, OutX, OutY, 936, 277, 946, 687, 0x795B00, 10, Fast
                if !ErrorLevel {
                    ClicaRandom(OutX, OutY+15)
                    GeraLog("Achou uma missao pro pet")
                    if (ProcuraPixelAteAchar(894, 96, "0x777980", 1000)) {
                        ProcuraAteAchar(612, 399, 960, 499, 60, "maispet", 600)
                        ClicaRandom(AchouOutX, AchouOutY)
                        ultimoXX := AchouOutX
                        ultimoXY := AchouOutY
                        subiuPet := 0, arrayPetY := 0, arrayPetX := 0
                        ProcuraPixelAteAchar(846, 555, "0xFFFFFF", 600)
                        DesceUmaPagina()
                        while (SelecionarPet())
                        {
                            if (ProcuraPixelAteAchar(780, 646, "0xD7AF00", 500)) {
                                GeraLog("Escolheu os pets em " A_Index " tentativas")
                                ClicaRandom(780, 646)
                                Sleep, 500
                                break
                            }
                            if (ProcuraPixelAteAchar(789, 717, "0x3B3BBF", 500)) {
                                ClicaRandom(ultimoXX, ultimoXY)
                                Sleep, 50
                            }
                            if (A_index > 420) {
                                GeraLog("Porra de missao que não da pra fazer, reroll")
                                ClicaRandom(947, 88)
                                if (!ProcuraPixelAteNaoAchar(947, 88, "0x2B2F30", 1000)) {
                                    ClicaRandom(947, 88)
                                    ProcuraPixelAteNaoAchar(947, 88, "0x2B2F30", 1000)
                                }
                                GeraLog("Voltou uma pra fazer reroll")
                                if (!fezreroll) {
                                    ClicaRandom(933, 214)
                                    if (ProcuraPixelAteAchar(821, 483, "0xCFA429", 1000)) {
                                        ClicaRandom(821, 483)
                                        GeraLog("Fez reroll")
                                        Sleep, 1000
                                        fezreroll := true
                                    }
                                }
                                else {
                                    FechaAllRapido()
                                    break 2
                                }
                                break
                            }
                        }
                    }
                }
            }
        }
        FechaAllRapido()
    }
}
;OK
SelecionarPet() {
    ProcuraPixelAteAchar(846, 555, "0xFFFFFF", 600)
    arrayPetX++
    if (arrayPetX < 6 and !(arrayPetX < 5 and arrayPetY = 3)) {
        ClicaRandom(994-(arrayPetX*70), 787-(arrayPetY*85))
    } else {
        arrayPetX := 1
        arrayPetY++
        if (arrayPetY = 3) {
            if (subiuPet = 1) {
                subiuPet := 0
                arrayPetY := 0
                arrayPetX := 1
                DesceUmaPagina()
                DesceUmaPagina()
                Sleep, 300
                ClicaRandom(994-(arrayPetX*70), 787-(arrayPetY*85))
                return true
            }
            arrayPetY := 0
            SobeUmaPagina()
            SobeUmaPagina()
            Sleep, 300
            subiuPet++
        }
        ClicaRandom(994-(arrayPetX*70), 787-(arrayPetY*85))
    }
    return true
}
;ok
AbrePet() {
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(823, 836) = "0x00B2FD") {
        return
    } else {
        ClicaQuartaAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(807, 73, "0x505256", 700)) {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbrePet()
        }
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        return
    }
}

EntraTorneio() {

}
;OK
ClanEmail() {
    Ativa()
    FechaAllRapido()
    ImageSearch, OutX, OutY, 947, 227, 1019, 447, *60 %a_scriptdir%\email.png
    if !ErrorLevel {
        ClicaRandom(OutX, OutY)
        if (ProcuraPixelAteAchar(867, 85, "0x787A81", 1000)) {
            ClicaRandom(881, 141)
            if (ProcuraPixelAteAchar(728, 799, "0x1C9D68", 1000)) {
                ClicaRandom(728, 799)
                if (ProcuraAteAcharTransBlack(894, 760, 1019, 837, 80, "skip", 10000)) {
                    Sleep, 300
                    ClicaRandom(AchouOutX, AchouOutY)
                    GeraLog("Pegou qualquer email que tinha")
                }
            }
            Else {
                FechaAllRapido()
            }
        }
        FechaAllRapido()
    }
}

TempoResete() {
    ano := SubStr(dataQueTerminou, 1, 4)
    mes := SubStr(dataQueTerminou, 5, 2)
    dia := SubStr(dataQueTerminou, 7, 2)
    ; Construir o timestamp da próxima ocorrência
    horaResete := ano . mes . dia . horaFixa . minutoFixo . segundoFixo
    ;verifica se precisa colocar um dia a mais.
    if (horaQueTerminou > horaFixa || (horaQueTerminou = horaFixa && minutoQueTerminou >= minutoFixo)) {
        horaResete += 1, days
    }
    EnvSub, horaResete, %A_Now%, seconds
    if (horaResete != "")
        GeraLog("Faltam " horaResete " segundos pra resetar")
    ; Verificar se o horário atual é posterior ao horário de resete
    if (horaResete < 0 and paraPrestigioDia) {
        GeraLog("Deu o tempo do resete. Bora fazer uns prestigios.")
        paraPrestigioDia := false
        QntPrestigioDia := 0
        TickPrestigio := A_TickCount
        fezreroll := false
        SetTimer ClicaEAtualiza, 500, ON, 3
    } else {
        GeraLog("Não deu o resete do dia ainda.")
    }
}

ProximaOcorrencia() {
    ; Obter a data e hora atuais
    dataAtual := A_Now
    horaAtual := A_Hour
    minutoAtual := A_Min

    ; Definir a próxima ocorrência de 19:00
    proximaOcorrencia := dataAtual
    proximaOcorrencia.Hour := 19
    proximaOcorrencia.Min := 0
    proximaOcorrencia.Sec := 0

    ; Verificar se a hora atual é menor que 19:00
    if (horaAtual < 19 || (horaAtual = 19 && minutoAtual < 0)) {
        ; Mantém a próxima ocorrência no mesmo dia
    } else {
        ; Avança para o próximo dia
        proximaOcorrencia += 1*(24 * 60 * 60 * 1000) ; Adiciona 1 dia em milissegundos (24 * 60 * 60 * 1000)
    }

    ; Retornar a próxima ocorrência
    return proximaOcorrencia
}
;OK
DailyRaid() {
    Ativa()
    FechaAllRapido()
    achoudailyraid := false
    loop, 250 {
        ImageSearch, OutX, OutY, 638, 35, 690, 82, *120 %a_scriptdir%\dailyraid.png
        if !ErrorLevel {
            achoudailyraid := true
        }
    }
    if (achoudailyraid) {
        GeraLog("Entrou na Daily Raid")
        ClicaRandom(661, 59)
        if (ProcuraPixelAteAchar(893, 94, "0x77797F", 10000)) {
            ClicaRandom(858, 652)
            If (ProcuraPixelAteAchar(895, 138, "0x76787F", 3000)) {
                Sleep, 300
                ClicaRandom(889, 697)
                if (ProcuraPixelAteAchar(907, 340, "0x76787F", 3000)) {
                    While (TrocaAbaDaily()) {
                        Sleep, 500
                        ImageSearch, OutX, OutY,707, 554, 866, 618, *30 %a_scriptdir%\startdaily.png
                        if (ErrorLevel = 0) {
                            MouseClick, left, OutX, OutY
                            Sleep, 300
                            AtacarTudo()
                            if (ProcuraAteAchar(813, 676, 977, 753, 60, "attackdaily", 10000)) {
                                ClicaRandom(889, 697)
                            }
                            Else
                                break
                        }
                    }
                }
            }
        } else {
            FechaAllRapido()
            DailyRaid()
        }
    } else {
        GeraLog("Não precisava da DailyRaid")
    }
    FechaAllRapido()
}

TrocaAbaDaily() {
    AbaDaily++
    if (AbaDaily = 1) {
        MouseClick, left, 647, 382
        return true
    } else if (AbaDaily = 2) {
        MouseClick, left, 688, 384
        return true
    } else if (AbaDaily = 3) {
        MouseClick, left, 737, 384
        return true
    } else if (AbaDaily = 4) {
        MouseClick, left, 783, 388
        return true
    } else if (AbaDaily = 5) {
        MouseClick, left, 828, 390
        return true
    } else if (AbaDaily = 6) {
        MouseClick, left, 872, 389
        return true
    } else if (AbaDaily = 7) {
        MouseClick, left, 918, 387
        return true
    } else {
        AbaDaily := 0
        return false
    }
}

AtacarTudo() {
    Sleep, 2000
    MouseMove, 827, 312
    Inicio3 := A_TickCount
    Send {LButton down}
    loop,
    {
        MoveAleatorioQuadrado(600, 311, 350, 306)
        if ((A_TickCount - Inicio3) >= 5000) {
            ImageSearch, OutX, OutY, 669, 634, 903, 728, *70 %a_scriptdir%\continuedaily.png
            if !ErrorLevel {
                Sleep, 100
                Send {LButton up}
                ClicaRandom(OutX, OutY)
                Sleep, 3000
                return
            }
        }
    }
}
;nOK?
DailyQuest() {
    Ativa()
    FechaAllRapido()
    AbreSkill()
    notificacao := ProcuraPixelAteAchar(757, 96, "0x033CE7", 1000)
    novo := ProcuraPixelAteAchar(729, 89, "0x0742ED", 1000)
    if (novo or notificacao) {
        ClicaRandom(729, 89, 2)
        ProcuraPixelAteAchar(781, 64, "0x7A7C83", 3000)
        loop, 50 {
            PixelSearch, OutX, OutY, 954, 264, 971, 799, 0x00A758, 30, Fast
            if !ErrorLevel {
                ClicaRandom(OutX, OutY)
                Sleep, 300
                GeraLog("Pegou recomepnsa diaria")
            }
        }
        ClicaRandom(962, 83)
    } else {
        GeraLog("Não tinha nenhuma recompensa diaria")
    }
    FechaAllRapido()
}
;OK
DailyChest() {
    Ativa()
    FechaAllRapido()
    para := false
    AbreLoja()
    Cima()
    SobePaginaRapido()
    DesceUmaPaginaRapido()
    DesceUmaPaginaRapido()
    loop,
    {
        if (A_Index > 6)
            return
        loop, 3 {
            ImageSearch, OutX, OutY, 553, 81, 1012, 821, *135 %a_scriptdir%\chest%A_index%.png
            if !ErrorLevel {
                break 2
            }
        }
        DesceUmaPaginaGrande()
        Sleep, 50
    }
    loop, 10 {
        loop, 3
        {
            GeraLog(A_index)
            ImageSearch, OutX, OutY, 553, 81, 1012, 821, *120 %a_scriptdir%\chest%A_index%.png
            if !ErrorLevel {
                ClicaRandom(OutX, OutY)
                if (ProcuraPixelAteAchar(909, 140, "0x2417C3", 1000)) {
                    ClicaRandom(783, 734)
                    if (ProcuraAteAcharTransBlack(894, 760, 1019, 837, 70, "skip", 10000)) {
                        Sleep, 1000
                        ClicaRandom(AchouOutX, AchouOutY)
                    }
                    GeraLog("Pegou o bau diario: " A_index)
                    Sleep, 3000
                }
            }
        }
    }
    FechaAllRapido()
}
;ok
AbreLoja() {
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(979, 833) = "0x3154CB") {
        return
    } else {
        ClicaSextaAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(789, 71, "0x515256", 700)) {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                AbreBluestacks()
            AbreLoja()
        }
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        return
    }
}

F1::
;parte := "nenhuma"
GeraLog("--------------COM ALVOS-------------------")
Loop, parse, listaPartes, `,
{
    if (AlvoEmQualParte(A_LoopField, "alvo")) {
        GeraLog("Alvo na " A_LoopField)
        if (ParteTemVida(A_LoopField)) {
            GeraLog("Com vida e alvo: " A_LoopField)
            parte := A_LoopField
            ;break
        }
    }
}
GeraLog("--------------COM ALVOS-------------------")
GeraLog("--------------SEM ALVOS-------------------")
Loop, parse, listaPartes, `,
{
    if (ParteTemVida(A_LoopField)) {
        if (!AlvoEmQualParte(A_LoopField, "x")) {
            GeraLog("Com vida, sem X: " A_LoopField)
            parte := A_LoopField
            ;break
        }
        else {
            GeraLog("X na " A_LoopField)
        }
    }
}
GeraLog("--------------SEM ALVOS-------------------")
CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/raid/" A_now ".png")
return

F2::
forcaprestige := true
FazPrestige()
return

F3::
loop, {
    VerificaClanRaid()
    randVerificaClan := 1
}
return

F4::
SetTimer, NaoEssenciais, off
Random, randVerificaNaoEssenciais, MinToMili(0), MinToMili(0)
setTimer NaoEssenciais, %randVerificaNaoEssenciais%, ON, 3
return

F11::
PegaControles()
coord := StrSplit(Edit1, ",")
GeraLog(RetornaCorPixel(coord[1], coord[2]))
return

F6::
CompraHeroiRapido()
return

F7::
Loop,
{
    ;stagetemp := RetornaText(720, 21, 123, 84)
    stagetemp := RetornaText(591, 656, 210, 94)
    stagetemp := RegExReplace(stagetemp, "\D", "")
    if (stage = "")
        stage := stagetemp
    aumento_percentual := ((stagetemp - stage) / stage) * 100
    if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp < 180000 and aumento_percentual >= 0 and aumento_percentual < 1) {
        if (stageanterior != stagetemp)
            GeraLog(stagetemp)
        stageanterior := stagetemp
    }
}
return

F8::
FechaBluestacks()
return



F9::
JogoAberto()
return

;---------------------------------------------------------------------------
SendMouse_LeftClick(X, Y, velo) { ; send fast left mouse clicks
    ;---------------------------------------------------------------------------
    SendMouse_AbsoluteMove(X, Y)
    Sleep, randSleep(velo)
    DllCall("mouse_event", "UInt", 0x02) ; left button down
    Sleep, randSleep(velo)
    DllCall("mouse_event", "UInt", 0x04) ; left button up
    Sleep, randSleep(velo)
}

;---------------------------------------------------------------------------
SendMouse_RightClick() { ; send fast right mouse clicks
    ;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x08) ; right button down
    DllCall("mouse_event", "UInt", 0x10) ; right button up
}

;---------------------------------------------------------------------------
SendMouse_MiddleClick() { ; send fast middle mouse clicks
    ;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x20) ; middle button down
    DllCall("mouse_event", "UInt", 0x40) ; middle button up
}

;---------------------------------------------------------------------------
SendMouse_RelativeMove(x, y) { ; send fast relative mouse moves
    ;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y) ; move
}

;---------------------------------------------------------------------------
SendMouse_AbsoluteMove(x, y) { ; send fast absolute mouse moves
    ;---------------------------------------------------------------------------
    ; Absolute coords go from 0..65535 so we have to change to pixel coords
    ;-----------------------------------------------------------------------
    static SysX, SysY
    If (SysX = "")
        SysX := 65535/A_ScreenWidth, SysY := 65535/A_ScreenHeight
    DllCall("mouse_event", "UInt", 0x8001, "UInt", (x+1)*SysX, "UInt", (y+1)*SysY)
}

;---------------------------------------------------------------------------
SendMouse_Wheel(w) { ; send mouse wheel movement, pos=forwards neg=backwards
    ;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x800, "UInt", 0, "UInt", 0, "UInt", w)
}

ClicaPrimeiraAba(){
    ClicaRandom(591, 837, 3)
}
ClicaSegundaAba(){
    ClicaRandom(668, 837, 3)
}
ClicaTerceiraAba(){
    ClicaRandom(745, 838, 3)
}
ClicaQuartaAba(){
    ClicaRandom(822, 835, 3)
}
ClicaQuintaAba(){
    ClicaRandom(900, 834, 3)
}
ClicaSextaAba(){
    ClicaRandom(976, 833, 3)
}

; Executa o comando no CMD e captura a saída
ExecutarComando(cmd) {
    ; Cria um objeto de fluxo para capturar a saída do comando
    stdout := "", stderr := ""
    Run, %ComSpec% /C %cmd% > %A_ScriptDir%\output.txt,, UseErrorLevel, pid
    
    ; Aguarda até que o comando termine
    Sleep 10000
    ; Lê a saída do comando a partir do objeto de fluxo
    FileRead, stdout, %A_ScriptDir%\output.txt
    
    ; Apaga o arquivo de saída
    FileDelete, %A_ScriptDir%\output.txt
    
    ; Retorna a saída do comando
    return stdout
}