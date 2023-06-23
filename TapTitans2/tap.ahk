; 0.3
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 25, 25
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
#MaxThreads 1

#Include, ocr.ahk
#Include, edge.ahk
#Include, CaptureScreen.ahk

if (false)
{
    global ChromeInst,ChromeProfile,PageInst
    FileCreateDir, ChromeProfile
    ChromeInst := new Edge(A_ScriptDir "\EdgeProfile",, "--no-first-run")

    ; --- Connect to the page ---

    if !(PageInst := ChromeInst.GetPage())
    {
        MsgBox, Could not retrieve page!
        ChromeInst.Kill()
    }
    else
    {
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
global CheckMir := false
global iUltimaAtualizada = A_TickCount
global TickPrestigio
global TempoTotal := 0
global QntPrestigio := 0
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
global Push, Estilo
global Teste2 := 0
global Pagina := 1
global Aba := 0
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

GeraLog(msg, sms=false)
{
    FormatTime, DataFormatada, D1 T0
    FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
    CARALHOOO := DataFormatada . " - " . msg . "\r\n"
    Mensagem := "document.getElementById(""text"").value = document.getElementById(""text"").value + """ . CARALHOOO . """"
    Result := PageInst.Evaluate(Mensagem)
    Result := PageInst.Evaluate("if (document.getElementsByClassName(""btn"")[1]) document.getElementsByClassName(""btn"")[1].click()")
    if ErrorLevel
    {
        FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
    }
    If (sms)
    {
        SendSMS("`n" DataFormatada " - " msg)
    }
}

OnExit("ExitFunc")

ExitFunc()
{
    try
    PageInst.Call("Browser.close") ; Fails when running headless
    catch
        ChromeInst.Kill()
    ExitApp
    ExitApp
    ExitFunc()
}

GeraLogTempoPrest(msg)
{
    FormatTime, DataFormatada, D1 T0
    FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitanstemp.log
    if ErrorLevel
    {
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
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 118600
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

Gui Add, Text, vtxtMana x128 y96 w300 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gCompraSkills x216 y272 w80 h23, Teste
Gui Add, Button, vBtnCalibrar gCalibrar x216 y300 w80 h23, Calibrar

Gui Add, Text, x8 y300 w42 h23 +0x200, Media:
Gui Add, Text, hWndhtxtMediaStage vtxtMediaStage x45 y300 w30 h23 +0x200, 0
Gui Add, Text, x8 y320 w42 h23 +0x200, Qnt:
Gui Add, Text, hWndhtxtQntPres vtxtQntPres x45 y320 w30 h23 +0x200, 0
; ------------ Linha para estilo de jogo
Gui, Add, Text, x5 y350 w298 0x10 ;Horizontal Line > Etched Gray
Gui Add, Radio, hWndhRadEstilo vEstilo x8 y360 w60 h23 +Checked, Clanship
Gui Add, Radio, hWndhRadEstilo x70 y360 w49 h23, HS
Gui Add, Radio, hWndhRadEstilo x110 y360 w60 h23 +, Dagger

Gui Show, x35 y35 w303 h420, TapMacro

Return

Prestige:
Return

Iniciar:
    WinActivate, taptitans.log
    Sleep, 300
    TickPrestigio := A_TickCount
    Ativa()
    Random, randVerificaClan, MinToMili(0), MinToMili(0)
    GuiControlGet, ChkMiR
    if (ChkMiR)
        CheckMir := true
    if (!JogoAberto())
        FechaBluestacksEAbre()
    FechaAllRapido()
    ClicaEAtualiza()
Return

ClicaEAtualiza()
{
    SetTimer ClicaEAtualiza, off
    Ativa()
    Clica()
    Clica()
    Atualizar()
    SetTimer ClicaEAtualiza, 500, ON, 3

}

Clica()
{
    TempoPassado := TempoPassado()
    GuiControl, , txtTempoStage, %TempoPassado%
    FechaAllRapido()
    FechaSeta()
    AtualizaStageViaAba()
    GuiControlGet, ChkAbsal
    ;CC
    Gui, Submit, NoHide
    if (Estilo = 1)
    {

    }
}

CliqueClanShip()
{
    if (!ChkAbsal)
    {
        if (!CheckMir)
        {
            if(!ContratoAtivo())
            {
                AtivaContratoViaBS()
                ;AtivaContratoViaClique()
            }
            else
            {
                loop, 1
                {
                    ClicaRandom(995, 214, 3)
                    ClicaRandom(596, 218, 3)
                    ClicaRandom(786, 343, 3)
                    ClicaRandom(778, 408, 3)
                    ClicaRandom(734, 459, 3)
                    ClicaRandom(785, 223, 3)
                    AtivaAA()
                }
            }
        }
        else
        {
            Send, k
            ProcuraPixelAteAchar(1046, 17, "0x381E1B", 300)
            ProcuraPixelAteNaoAcharSI(1046, 17, "0x381E1B", 5000)
        }
    }
    FechaSeta()
}

AtivaContratoViaBS()
{
    AtivaAA()
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
        if (FechaColetaRapida())
        {
            loop, 2
            {
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

AtivaContratoViaClique()
{
    AtivaAA()
    loop, 3
    {
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
        ClicaRandom(609, 241, 5)
        ClicaRandom(980, 229, 5)
    }
}

;ok
AbreHeroi()
{
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(670, 846) = "0xAE9E60")
    {
        return
    }
    else
    {
        ClicaSegundaAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(670, 846, "0xAE9E60", 700))
        {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                FechaBluestacksEAbre()
            AbreHeroi()
        }
        ProcuraPixelAteAchar(770, 66, "0x505155", 700)
        ;GeraLog("AbreHeroi: " A_TickCount - Inicio)
        return
    }
}

Fechaheroi()
{
    ImageSearch, OutX, OutY, 780, 841, 857, 880, *60 %a_scriptdir%\heroes.png
    if (ErrorLevel = 0)
    {
        ClicaSegundaAba()
        Sleep, 120
    }
    else
    {
        return
    }
}
;ok
CLicaCompraHeroi()
{
    ;Inicio := A_TickCount
    ;PixelSearch, OutputVarX, OutputVarY, 1111, 145, 1120, 849, 0x0786EC, 20, fast
    PixelSearch, OutputVarX, OutputVarY, 944, 143, 948, 489, 0x0786EC, 20, fast
    if !ErrorLevel
    {
        ;GeraLog("Teste")
        ClicaRandom(937, 166, 4, 35)
        ClicaRandom(940, 249, 4, 35)
        ClicaRandom(950, 319, 4, 35)
        ClicaRandom(933, 387, 4, 35)
    }
}
;ok
CompraHeroiRapido()
{
    Inicio := A_TickCount
    contrato := ContratoAtivo()
    AbreHeroi()
    CLicaCompraHeroi()
    ImageSearch, OutX, OutY, 622, 134, 748, 207, *90 %a_scriptdir%\lv0.png
    if ErrorLevel
    {
        SobeUmaPagina()
    }
    EquipaMelhorItem()
    ;FechaAllRapido()
    ;GeraLog("CompraHeroiRapido: " A_TickCount - Inicio)
}

CompraHeroi()
{
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

AtualizaStage()
{
    ;Inicio := A_TickCount
    loop, 5
    {
        stagetemp := RetornaText(888, 60, 99, 66)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp > 80000 and stagetemp < 180000)
        {
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
AtualizaStageViaConfig()
{
    ;Inicio := A_TickCount
    MouseClick left, 727, 99
    while (A_TickCount-iUltimaAtualizada)>5000
    {
        Sleep, 50
        stagetemp := RetornaText(903, 57, 73, 62)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp > 80000 and stagetemp < 180000)
        {
            stageanterior := stage
            stage := stagetemp
            AttBarraStage()
            FazPrestige()
            GuiControl, , TxtStage, %stage%
            iUltimaAtualizada := A_TickCount
            Sleep, 300
        }
        if (A_Index>50)
        {
            iUltimaAtualizada := A_TickCount
            Break
        }
    }
    Sleep, 30
    MouseClick left, 727, 99
    ;GeraLog("AtualizaStageViaConfig(): " A_TickCount - Inicio)
}

ProcuraAteAchar(X, Y, H, W, var, img, mili)
{
    ;Inicio := A_TickCount
    ;Ativa()
    ;GeraLog("Ativa(): " A_TickCount - Inicio)
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
        FechaColetaRapida()
    }
return false
}

ProcuraPixelAteAchar(X, Y, color, mili)
{
    ;Inicio := A_TickCount
    ;Ativa()
    ;GeraLog("Ativa(): " A_TickCount - Inicio)
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        if (RetornaCorPixel(X, Y) = color)
        {
            AchouOutX := X
            AchouOutY := Y
            return true
        }
        FechaColetaRapida()
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
        IncrementaAchou()
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
        IncrementaAchou()
    }
return false
}

ProcuraPixelAteNaoAcharSI(X, Y, color, mili)
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

IncrementaAchou()
{
    if (A_TickCount - InicioAchou > 60000)
    {
        GeraLog("Estava com " qntAchou)
        qntAchou := 0
        InicioAchou := A_TickCount
    }
    Else
    {
        qntAchou++
        ;GeraLog("Estava com " qntAchou)
    }
}
;ok
ContratoAtivo()
{
    if (PodeContratoStage and PodeContratoMana)
    {
        ;Inicio := A_TickCount
        PixelSearch, OutputVarX, OutputVarY, 651, 472, 861, 479, 0xFF01FF, 5, Fast
        if (!ErrorLevel)
        {
            ;GeraLog("Contrato ativo " A_TickCount - Inicio)
            return true
        }
        else
        {
            ;GeraLog("Contrato não ativo " A_TickCount - Inicio)
            return false
        }
    }
    Else
        return true
}
;ok
AtualizaStageViaAba()
{
    Inicio := A_TickCount
    Achou := false
    CompraHeroiRapido()
    AbreSkillDiretoProPresitigo()
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < prestmili)
    {
        FechaColetaRapida()
        stagetemp := RetornaText(583, 655, 226, 94)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
        {
            stageanterior := stage
            stage := stagetemp
            GuiControl, , TxtStage, %stage%
            AttBarraStage()
            aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
            GeraLog("TempoAtt: " FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " stage " - %" StageProgess " - %" aumento_percentual)
            FazPrestige()
            GuiControlGet, ChkPrestige
            If (StageProgess >= 99.98 and contrato and ChkPrestige and PodeContratoMana)
                prestmili := 10000
            else
                prestmili := 1000
            Achou := true
            ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
            iUltimaAtualizada := A_TickCount
            if (prestmili < 1010)
                break
        }
    }
    if (!Achou)
    {
        ClicaRandom(782, 696, 4)
        ;MouseClick, left, 840, 720
        loop, 5
        {
            FechaColetaRapida()
            stagetemp := RetornaText(826, 235, 144, 84)
            stagetemp := RegExReplace(stagetemp, "\D", "")
            if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
            {
                stageanterior := stage
                stage := stagetemp
                GuiControl, , TxtStage, %stage%
                AttBarraStage()
                GeraLog("TempoAtt por dentro: " FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " stage " - %" StageProgess)
                ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
                FazPrestige()
                iUltimaAtualizada := A_TickCount
                Achou := true
            }
        }
    }
    if (!Achou)
    {
        GeraLog("Não subiu a pagina, precisa fazer de novo.")
        loop, 3
        {
            FechaAllRapido()
        }
        AbreSkill()
        SobeUmaPagina()
        SobeUmaPagina()
    }
    FechaAllRapido()
    ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
    AttMana()
}

Atualizar()
{
    FechaAllRapido()
    VaiProBoss()
    VerificaClanRaid()
    Presente()
    Ovo()
    ;lua()
    FechaSeta()
    tempo := A_TickCount - Inicio
}

SoloRaid()
{
    ImageSearch, OutX, OutY, 787, 54, 841, 101, *90 *TransBlack %a_scriptdir%\soloraid.png
    if !ErrorLevel
    {
        GeraLog("Achou")
        Sleep, 3000
        ClicaRandom(1017, 673, 5)
        Sleep, 1000
        ClicaRandom(1032, 739, 5)
    }
}

VerificaClanRaid()
{
    if ((A_tickcount - ultimaVerificadaClan) > randVerificaClan)
    {
        GeraLog("Entrou no verifica clan")
        ;GeraLog(A_tickcount - ultimaVerificadaClan " > " randVerificaClan)
        ultimaVerificadaClan := A_tickcount
        ClanRaid()
    }
    else
    {
        GeraLog(A_tickcount - ultimaVerificadaClan " > " randVerificaClan)
        if (randVerificaClan-((A_tickcount - ultimaVerificadaClan)) < MinToMili(10) and randVerificaClan > 120001 and Aviso)
        {
            ImageSearch, OutX, OutY, 745, 55, 801, 100, *60 %a_scriptdir%\raid.png
            if (ErrorLevel = 0)
            {
                GeraLog("Faltam menos de 10 minutos para atacar a Raid.", true)
                Aviso := false
            }
        }
    }
}

RetornaText(X, Y, W, H)
{
    hBitmap := HBitmapFromScreen(X, Y, W, H)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    text := StrReplace(ocr(pIRandomAccessStream), "`n","")
return text
}
;ok
AttMana()
{
    ;Inicio := A_Tickcount
    FechaAllRapido()
    AtualizaStatusSkillAtiva()
    ;mana := RegExReplace(RetornaText(677, 714, 175, 74), "\D(?<!\/)", "")
    mana := RegExReplace(RetornaText(555, 708, 116, 50), "\D(?<!\/)", "")
    atual := SubStr(mana, 1, InStr(mana, "/")-1)
    total := SubStr(mana, InStr(mana, "/")+1, 4)
    porcentagem := (atual / total) * 100
    if (porcentagem > 0 and porcentagem <= 100)
    {
        GuiControl, , PrgMana, %porcentagem%
        GuiControl, , TxtMana, %mana%
    }
    if (porcentagem >= 30 and PrimeiraAtiva AND SegundaAtiva AND TerceiraAtiva AND QuartaAtiva AND QuintaAtiva AND SextaAtiva)
    {
        GuiControlGet, ChkAbsal
        if (!ChkAbsal)
        {
            ;ImageSearch, OutX, OutY, 1093, 799, 1118, 835, *3 %a_scriptdir%\fullSC.png
            if (RetornaCorPixel(640, 788) != "0x27D6F8")
            {
                Loop, 4
                {
                    ;Send, W
                    ;Sleep, 30
                    ClicaSegundaSkill()
                    SegundaFull := false
                }
                ;GeraLog("Comprou WC")
            }
            else
            {
                SegundaFull := true
                ;ImageSearch, OutX, OutY, 1015, 803, 1039, 834, *3 %a_scriptdir%\fullTF.png
                ;if (RetornaCorPixel(1027, 809) != "0xE8E263")
                if (RetornaCorPixel(875, 787) != "0x27D6F8")
                {
                    Loop, 4
                    {
                        ;Send, T
                        ;Sleep, 30
                        ClicaQuintaSkill()
                        QuintaFull := false
                    }
                    ;GeraLog("Comprou TF")
                }
                else
                {
                    QuintaFull := true
                    ;ImageSearch, OutX, OutY, 935, 804, 963, 835, *3 %a_scriptdir%\fullHM.png
                    if (RetornaCorPixel(798, 792) != "0xF861AC")
                    {
                        Loop, 4
                        {
                            ;Send, R
                            ;Sleep, 30
                            ClicaQuartaSkill()
                            QuartaFull := false
                        }
                        ;GeraLog("Comprou HM")
                    }
                    else
                        QuartaFull := true
                    ;ImageSearch, OutX, OutY, 858, 808, 886, 836, *3 %a_scriptdir%\fullDS.png
                    if (RetornaCorPixel(721, 798) != "0x1BD0AC")
                    {
                        Loop, 4
                        {
                            ;Send, E
                            ;Sleep, 30
                            ClicaTerceiraSkill()
                            TerceiraFull := false
                        }
                        ;GeraLog("Comprou DS")
                    }
                    else
                        TerceiraFull := true
                    if (RetornaCorPixel(1105, 808) != "0x72A8E1" and RetornaCorPixel(961, 791) != "0x727680")
                    {
                        Loop, 4
                        {
                            ;Send, Y
                            ;Sleep, 30
                            ClicaSextaSkill()
                            SextaFull := false
                        }
                        ;GeraLog("Comprou SC")
                    }
                    else
                        SextaFull := true
                    if (RetornaCorPixel(716, 817) != "0x2651F8" and RetornaCorPixel(572, 791) != "0x0054DD")
                    {
                        Loop, 4
                        {
                            ;Send, Q
                            ;Sleep, 30
                            ClicaPrimeiraSkill()
                            PrimeiraFull := false
                        }
                        ;GeraLog("Comprou FS")
                    }
                    else
                        PrimeiraFull := true
                }
            }
            if (PrimeiraFull AND SegundaFull AND TerceiraFull AND QuartaFull AND QuintaFull AND SextaFull)
                PodeContratoMana := true
            else
                PodeContratoMana := false
        }
        else
        {
            Loop, 2
            {
                Send, {L up}
                Sleep, 20
                Send, {L down}
                Sleep, 30
                Send, {L up}
                Sleep, 20
                Send, L
            }
            Loop, 5
            {
                ClicaPrimeiraSkill()
                ClicaSegundaSkill()
                ClicaTerceiraSkill()
                ClicaQuartaSkill()
                ClicaQuintaSkill()
                ClicaSextaSkill()

            }
            Send, {L down}
        }
    }
    ;GeraLog("AttMana: " A_TickCount - Inicio)
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

AttBarraStage()
{
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

    GuiControlGet, Edit1
    StageProgess := (stage / Edit1) * 100
    if (stage > 1)
        PodeContratoStage := true
    else
        PodeContratoStage := false
    GuiControl, , PrgStage, %StageProgess%
}

AtualizaStatusSkillAtiva()
{
    ;FechaAllRapido()
    ;Inicio := A_TickCount
    EstaAtiva("Sexta")
    EstaAtiva("Quinta")
    EstaAtiva("Quarta")
    EstaAtiva("Terceira")
    EstaAtiva("Segunda")
    EstaAtiva("Primeira")
    ;GeraLog("AtualizaStatusSkillAtiva: " A_TickCount - Inicio)
}

EstaAtiva(skill)
{
    X := %skill%PixelX
    Y := %skill%PixelY
    ;Inicio := A_TickCount
    FechaAllRapido()
    if (RetornaCorPixel(X, Y)=%skill%Color)
    {
        sulfixo := "iCount"
        nomeContadorVariavel := skill . sulfixo
        %nomeContadorVariavel% := 0
        %skill%Ativa := true
        GuiControl, show, txt%skill%
    }
    Else
    {
        PodeContratoMana := false
        GuiControl, Hide, txt%skill%
        if (skill = "Primeira")
        {
            ;Send, Q
            ;Sleep, 20
            ;Send, Q
            ClicaRandom(591, 779, 2)
            %skill%Ativa := false
            PrimeiraiCount++
        }
        if (skill = "Segunda")
        {
            ;Send, W
            ;Sleep, 20
            ;Send, W
            ClicaRandom(668, 781, 2)
            %skill%Ativa := false
            SegundaiCount++
        }
        if (skill = "Terceira")
        {
            ;Send, E
            ;Sleep, 20
            ;Send, E
            ClicaRandom(749, 780, 2)
            %skill%Ativa := false
            TerceiraiCount++
        }
        if (skill = "Quarta")
        {
            ;Send, R
            ;Sleep, 20
            ;Send, R
            ClicaRandom(822, 779, 2)
            %skill%Ativa := false
            QuartaiCount++
        }
        if (skill = "Quinta")
        {
            ;Send, T
            ;Sleep, 20
            ;Send, T
            ClicaRandom(899, 781, 2)
            %skill%Ativa := false
            QuintaiCount++
        }
        if (skill = "Sexta")
        {
            ;Send, Y
            ;Sleep, 20
            ;Send, Y
            ClicaRandom(980, 780, 2)
            %skill%Ativa := false
            SextaiCount++
        }
    }
    ;GeraLog("EstaAtiva(): " A_TickCount - Inicio)
    If (PrimeiraiCount >= 15 OR SegundaiCount >= 15 OR TerceiraiCount >= 15 OR QuartaiCount >= 15 OR QuintaiCount >= 15 OR SextaiCount >= 15)
    {
        GeraLog("Não comprou uma : " PrimeiraiCount SegundaiCount TerceiraiCount QuartaiCount QuintaiCount SextaiCount)
        CompraSkills()
    }
}

Calibrar()
{
    PixelGetColor, PrimeiraColor, PrimeiraPixelX, PrimeiraPixelY
    PixelGetColor, SegundaColor, SegundaPixelX, SegundaPixelY
    PixelGetColor, TerceiraColor, TerceiraPixelX, TerceiraPixelY
    PixelGetColor, QuartaColor, QuartaPixelX, QuartaPixelY
    PixelGetColor, QuintaColor, QuintaPixelX, QuintaPixelY
    PixelGetColor, SextaColor, SextaPixelX, SextaPixelY

}

Travado()
{
    if (A_Tickcount - TickPrestigio > 1800000)
    {
        if (TravadoCount > 0)
        {
            CheckMir := false
            SetTimer CompraHeroi, 60000, On, 4
        }
        GeraLog("Estava mais de 30 minutos e fez o prestige")
        forcaprestige := true
        FazPrestige()
        TravadoCount++

    }
}

TempoDePrestigio()
{
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        if (A_Tickcount - TickPrestigio > MinToMili(10))
        {
            Gui, Submit, NoHide
            if (Push = 3)
            {
                ;CheckMir := false
                GeraLog("Estava mais de 10 minutos em um unico prestigio, desmarca o MiR, e forca")
                forcaprestige := true
            }
            Else
            {
                ;CheckMir := false
                GeraLog("Estava mais de 10 minutos em um unico prestigio, desmarca o MiR, e forca")
                forcaprestige := true
            }
        }
    }
    else
        if (A_Tickcount - TickPrestigio > MinToMili(10))
    {
        Gui, Submit, NoHide
        if (Push = 3 OR Push = 1)
        {
            ;CheckMir := false
            GeraLog("Estava mais de 10 minutos em um unico prestigio, desmarca o MiR, e forca")
            forcaprestige := true
        }
    }
}

FazPrestige()
{
    ;Inicio := A_TickCount
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100
    TempoDePrestigio()
    GuiControlGet, Edit1
    GuiControlGet, ChkAbsal
    GuiControlGet, ChkPrestige
    ;if ((StageProgess > 100 and stage > Edit1 and aumento_percentual >= 0 and aumento_percentual <= 0.2 and aumento_percentual_media < 0.5 and ChkPrestige)
    if ((StageProgess >= 100 and stage > Edit1 and ChkPrestige and Stage < 180000 and aumento_percentual < 2)
        or (forcaprestige and ChkPrestige))
    {
        GeraLog("FazPrestige: " TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        GeraLogTempoPrest(TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        TravadoCount := 0
        forcaprestige := false
        if (!ProcuraAteAchar(573, 60, 635, 113, 60, "icone", 300))
        {
            if (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500))
            {
                while (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500))
                {
                    if (A_Index > 40)
                    {
                        return
                    }
                    FechaAllRapido()
                    AbreSkill()
                    SobeUmaPagina()
                }
            }
            ClicaRandom(AchouOutX, AchouOutY, 4)
            ;MouseClick, left, AchouOutX, AchouOutY
            Sleep, 300
        }
        ClicaRandom(780, 754, 4)
        ;MouseClick, left, 931, 769
        if (DeuErro())
            return
        Sleep, 5000
        AtualizaInfosPrest()
        CompraSkills()
        FechaAllRapido()
        AtualizaStatusSkillAtiva()
        Sleep, 300
        AtualizaStatusSkillAtiva()
        CompraReliquia()
        ;SobeTudo()
        ;GeraLog("Tempo do FazPrestige(): " A_TickCount - Inicio)
        return
    }
return
}

AtualizaInfosPrest()
{
    10ultimos := []
    prestmili := 1000
    aumento_percentual_media := 0
    StageProgess := 0
    totalStage := 0
    qntStage := 0
    if (A_Tickcount - TickPrestigio > 120000)
    {
        QntPrestigio++
        TempoTotal += A_Tickcount - TickPrestigio
        Media := TempoTotal/QntPrestigio
        Formatado := FormataMilisegundos(Media)
        GuiControl, , txtMediaStage, %Formatado%
        GuiControl, , txtQntPres, %QntPrestigio%
    }
    TickPrestigio := A_TickCount
    AtualizaTarget()
    stage := 0
}

AtualizaTarget()
{
    Gui, Submit, NoHide
    GuiControlGet, Edit1
    if (Push = 1)
    {
        GuiControlGet, ChkAbsal
        if (ChkAbsal)
        {
            Mais10 := stage+1000
            if (stage - Edit1 > 200)
            {
                Mais10 := Mais10+500
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
            }
            else
            {
                GeraLog("Novo Target: " stage)
                GuiControl, , Edit1, %Mais10%
            }
        }
        else
        {
            Mais10 := stage+50
            if (stage - Edit1 > 50)
            {
                Mais10 := Mais10+50
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
                return
            }
            else
            {
                GeraLog("Novo Target: " stage)
                GuiControl, , Edit1, %Mais10%
            }
        }
    }
    if (Push = 2)
    {
        Mais10 := stage + 20000
        GeraLog("Novo Target: " Mais10)
        GuiControl, , Edit1, %Mais10%
    }
}

DeuErro()
{
    ImageSearch, X, Y, 859, 570, 1010, 620, *60 %a_scriptdir%\k.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, X, Y
        Sleep, 500
        ImageSearch, X, Y, 859, 570, 1010, 620, *60 %a_scriptdir%\k.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, X, Y
            Sleep, 500
        }
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
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
VaiProBoss()
{
    if (RetornaCorPixel(967, 68) = "0x1160ED")
    {
        ClicaRandom(967, 68, 4)
        ;MouseClick, left, X, Y
        Gui, Submit, NoHide
        if (Push <> 3)
        {
            GeraLog("Novo Target, por que estava travado: " stage)
            Novo := stage - 1
            GuiControl, , Edit1, %Novo%
        }
        else
        {
            If (StageProgess >= 99)
            {
                GeraLog("forca prestige, por que estava travado: " stage)
                forcaprestige := true
            }
            else
            {
                GeraLog("travado fora do boss, mas não estava mais que 99%")
            }
        }
    }
}

VaiClicaSkill(X, Y)
{
    ClicaRandom(X, Y, 5)
    ;MouseClick, left, X, Y
    Sleep, 170
    ClicaRandom(X-130, Y, 2)
    ;MouseClick, left, X-122, Y
    Sleep, 170
    ComprouSkill++
}

ProcuraEClicaSkillRapido()
{
    Inicio := A_TickCount
    loop, 50
    {
        PixelSearch, OutX, OutY, 959, 390, 963, 820, 0x0698F6, 30, Fast
        if !ErrorLevel
        {
            MouseClick, left, OutX+15, OutY
            loop, 10
            {
                PixelSearch, OutX, OutY, 862, 389, 865, 810, 0x2929C3, 5, Fast
                if !ErrorLevel
                {
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

ProcuraEClicaSkill()
{
    loop, 5
    {
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            ClicaRandom(OutX, OutY, 5)
            ;MouseClick, left, OutX, OutY
            Sleep, 300
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\spell.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\upgr.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *100 %a_scriptdir%\spell2.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
    }
}

SobeTudo()
{
    AbreSkill()
    ImageSearch, OutX, OutY, 702, 842, 780, 880, *40 %a_scriptdir%\espada.png
    if (ErrorLevel = 0)
    {
        while (!ProcuraAteAchar(854, 198, 1018, 330, 100, "prest", 500))
        {
            if (A_Index > 40)
            {
                return
            }
            SobeUmaPagina()
        }
    }
    else
    {
        FechaColetaRapida()
        AbreSkill()
        SobeTudo()
    }
    FechaSkill()
    FechaAllRapido()
}

CompraSkills()
{
    Inicio := A_TickCount
    ComprouSkill := 0
    PrimeiraiCount := 0
    SegundaiCount := 0
    TerceiraiCount := 0
    QuartaiCount := 0
    QuintaiCount := 0
    SextaiCount := 0
    FechaAllRapido()
    AbreSkill()
    if (RetornaCorPixel(594, 836) = "0xC7B89A")
    {
        Sleep, 100
        ClicaRandom(941, 159, 5)
        ProcuraEClicaSkillRapido()
        if (A_TickCount - Boost > MinToMili(10))
        {
            DesceUmaPagina()
            loop, 15
            {
                if (ProcuraAteAchar(872, 137, 1014, 830, 60, "fr", 100)) 
                {
                    ClicaRandom(OutX, OutY, 5)
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
        }
    }
    else
    {
        GeraLog("CompraSkills: " A_TickCount - Inicio)
        CompraSkills()
    }
    FechaAllRapido()
    GeraLog("CompraSkills: " A_TickCount - Inicio)
return
}

AbreSkill()
{
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(594, 836) = "0xC7B89A")
    {
        return
    }
    else
    {
        ClicaPrimeiraAba()
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(985, 45, "0x2D2D2E", 700))
        {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                FechaBluestacksEAbre()
            AbreSkill()
        }
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        return
    }
}
;ok
EquipaMelhorItem()
{
    AbreEquip()
    Inicio := A_TickCount
    Loop, parse, TipoHeroi, `,
    {
        FechaColetaRapida()
        ImageSearch, OutX, OutY, 647, 171, 959, 188, *140 *Transblack %a_scriptdir%\%A_LoopField%.png
        if !ErrorLevel
        {
            ;GeraLog("Achou o : " A_LoopField)
            if (ItemEquipado != A_LoopField)
            {
                ;ImageSearch, OutX, OutY, 770, 221, 1047, 846, *90 *Transblack %a_scriptdir%\%A_LoopField%texto.png
                if (ProcuraAteAchar(683, 214, 756, 825, 170, A_LoopField . "texto", 1000))
                {

                    ;GeraLog("Trocou o item para " A_LoopField)
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
                if (ItemEquipado != A_LoopField)
                {
                    GeraLog("Não conseguiu equipar o item.")
                    ItemEquipado := "deu ruim"
                }
            }
            break
        }
        else
        {
            ;GeraLog("Não achou o : "A_LoopField)
        }
    }
    ;GeraLog("EquipaMelhorItem: " A_TickCount - Inicio)
    ;FechaAllRapido()
}
;ok
AbreEquip()
{
    Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(747, 840) = "0xA46B96")
    {
        if !(ProcuraPixelAteAchar(660, 142, "0x444042", 700))
        {
            ClicaRandom(660, 111, 5)
            Sleep, 150
        }
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        return
    }
    else
    {
        ClicaTerceiraAba()
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(747, 840, "0xA46B96", 700))
        {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                FechaBluestacksEAbre()
            AbreEquip()
        }
        if !(ProcuraPixelAteAchar(660, 142, "0x444042", 700))
        {
            ClicaRandom(660, 111, 5)
            Sleep, 150
        }
        ;GeraLog("AbreEquip: " A_TickCount - Inicio)
        return
    }
}

AbreSkillDiretoProPresitigo()
{
    Inicio := A_TickCount
    ; Procura aba aberta da Espada
    if (RetornaCorPixel(594, 836) = "0xC7B89A")
    {
        ;GeraLog("AbreSkill já estava aberta: " A_TickCount - Inicio)
        ; Espera abrir o icone, e vai clicando
        while (!ProcuraPixelAteAchar(777, 304,"0xFFFFFF", 15))
        {
            Cima()
            FechaColetaRapida()
            ClicaRandom(945, 260, 5)
            if (A_Index > 30)
            {
                SobeUmaPagina()
                return
            }
        }
        return
    }
    else
    {
        ClicaPrimeiraAba()
        ; Espera abrir a aba aberta da Espada
        if (ProcuraPixelAteAchar(594, 836, "0xC7B89A", 1000))
        {
            ;GeraLog("AbreSkill abriu: " A_TickCount - Inicio)
            ; Espera abrir o icone, e vai clicando
            while (!ProcuraPixelAteAchar(777, 304,"0xFFFFFF", 15))
            {
                Cima()
                FechaColetaRapida()
                ClicaRandom(945, 260, 5)
                if (A_Index > 30)
                {
                    SobeUmaPagina()
                    return
                }
            }
        }
        else
        {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                FechaBluestacksEAbre()
            AbreSkillDiretoProPresitigo()
        }
        ;GeraLog("AbreSkill final: " A_TickCount - Inicio)
        return
    }

}

FechaXzin()
{
    ImageSearch, OutX, OutY, 1112, 50, 1166, 75, *23 %a_scriptdir%\xzin.png
    if (ErrorLevel = 0)
    {
        ClicaRandom(OutX, OutY, 5)
        ;MouseClick, left, OutX, OutY
        ProcuraAteNaoAchar(1112, 50, 1166, 75, 23, "xzin", 2000)
    }
}

FechaSkill()
{
    ImageSearch, OutX, OutY, 702, 842, 780, 880, *40 %a_scriptdir%\espada.png
    if (ErrorLevel = 0)
    {
        ClicaPrimeiraAba()
        Sleep, 115
        return
    }
    else
    {
        return
    }
}

StatusSkill(X, Y, W, H, skill)
{
    nome := ""
    tempo := ""
    FechaAllRapido()
    nome := "txt" . skill
    tempo := RegExReplace(RegExReplace(RetornaText(X, Y, W, H), "[íi{[<]",":"), "[^\d:]", "")
    if (StrLen(tempo)> 2)
    {
        if (RegExMatch(tempo, "^\d{2}:\d{2}$")>0)
            GuiControl, , %nome%, %tempo%
    }
    else if (tempo="")
    {
        GuiControl, , %nome%, SIM
    }
}

FechaAll()
{
    Inicio := A_TickCount
    ;ImageSearch, OutX, OutY, 858, 681, 1169, 740, *120 %a_scriptdir%\relic.png
    ImageSearch, OutX, OutY, 706, 689, 743, 733, *120 %a_scriptdir%\attack.png
    if ErrorLevel
    {
        ;GeraLog("Não achou o relic")
        loop, 3
        {
            FechaColetaRapida()
            FechaXzin()
            ImageSearch, OutX, OutY, 1014, 53, 1164, 284, *55 %a_scriptdir%\fecha.png
            if !ErrorLevel
            {
                ClicaRandom(OutX+15, OutY+25, 4)
                ProcuraAteNaoAchar(1014, 53, 1164, 284, 55, "fecha", 2000)
            }
            ImageSearch, OutX, OutY, 1088, 122, 1172, 196, *55 %a_scriptdir%\FechaAzul.png
            if !ErrorLevel
            {
                ClicaRandom(OutX, OutY, 4)
                ;MouseClick, left, OutX, OutY
                Sleep, 300
            }
        }
    }
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        If (qntAchou > 350)
        {
            GeraLog("Estava com lag, fechou e abriu")
            FechaBluestacksEAbre()
        }
    }
    GeraLog("FechaAll: " A_TickCount - Inicio)
}

;ok
FechaColetaRapida()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(774, 664) = "0xCEA43D")
    {
        ClicaRandom(774, 664, 5)
        ProcuraPixelAteNaoAchar(774, 664, "0xCEA43D", 2000)
        ;GeraLog("FechaColetaRapida: " A_TickCount - Inicio)
        return true
    }
    ;GeraLog("FechaColetaRapida: " A_TickCount - Inicio)
return false
}

CompraReliquia()
{
    Gui, Submit, NoHide
    if (Qual = 1)
    {
        BoS()
    }
    else if (Qual = 2)
    {
        All()
    }
    else if (Qual = 3)
    {
        if (alternado)
        {
            All()
            alternado := false
            qntVezesAll++
        }
        else
        {
            BoS()
            alternado := true
            qntVezesAll := 0
        }
    }
}

BoS()
{
    ClicaQuintaAba()
    Sleep, 500
    Cima()
    while (!ProcuraAteAchar(551, 148, 629, 366, 40, "BoS", 500))
    {
        if (A_Index > 10)
        {
            return
        }
        SobeUmaPagina()
    }
    Sleep, 150
    ProcuraAteAchar(551, 148, 629, 366, 40, "BoS", 300)
    loop, 10
    {
        ClicaRandom(AchouOutX+351, AchouOutY+5, 5)
        Sleep, 150
    }
    Sleep, 500
    ClicaQuintaAba()
    Sleep, 500
}

All()
{
    Sleep, 500
    ClicaQuintaAba()
    Cima()
    ProcuraAteAchar(854, 84, 1023, 261, 40, "all", 700)
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
    If (A_EventInfo == 1)
    {
        Return
    }

Return

GuiClose:
ExitApp

Pause::Pause,,1

Ativa()
{
    WinActivate BlueStacks
    Click, 784 49 Right
}
;ok
SobeUmaPagina()
{
    MouseMove, 892, 600
    Send {LButton down}
    MouseMove, 901, 846, 10
    Sleep, 50
    Send {LButton up}
}

DesceUmaPagina()
{
    MouseMove, 745, 819
    Send {LButton down}
    MouseMove, 752, 602, 10
    Sleep, 25
    Send {LButton up}
}

TempoPassado()
{
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

FormataMilisegundos(millisec)
{
    totalSec := Floor(millisec / 1000)

    ; Calcula o número de minutos
    minutes := Floor(totalSec / 60)

    ; Calcula o número de segundos restantes
    seconds := Mod(totalSec, 60)

    ; Retorna o resultado formatado como minutos:segundos
return minutes ":" Format("{:02d}", seconds)
}

ClanRaid()
{
    ;ImageSearch, OutX, OutY, 600, 38, 648, 79, *60 %a_scriptdir%\raid.png
    if (RetornaCorPixel(621, 53) = "0x42487C")
    {
        loop, 5
        {
            SoundBeep, 300, 300
        }
        Random, randVerificaClan, MinToMili(1), MinToMili(1)
        GeraLog("Entrou no Raid")
        MouseClick, left, 621, 53
        Sleep, 3000
        ImageSearch, OutX, OutY, 576, 91, 993, 503, *60 %a_scriptdir%\fundoazul.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, OutX, OutY
            Sleep, 1500
        }
        ImageSearch, OutX, OutY, 553, 86, 699, 180, *60 %a_scriptdir%\abaraid.png
        if ErrorLevel
        {
            MouseClick, left, 631, 120
            Sleep, 3000
        }
        parte := "nenhuma"
        Loop, parse, listaPartes, `,
        {
            if (AlvoEmQualParte(A_LoopField, "alvo"))
            {
                if (ParteTemVida(A_LoopField))
                {
                    parte := A_LoopField
                    break
                }
            }
        }
        if (parte = "nenhuma")
        {
            Loop, parse, listaPartes, `,
            {
                if (ParteTemVida(A_LoopField))
                {
                    if (!AlvoEmQualParte(A_LoopField, "x"))
                    {
                        parte := A_LoopField
                        break
                    }
                }
            }
        }
        GeraLog(parte)
        if (parte = "nenhuma")
        {
            GeraLog("Aborta!!! Não achou nenhuma parte", true)
            loop, 2
            {
                FechaAllRapido()
            }
            return
        }
        CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/raid/" parte "-" A_now ".png")
        ImageSearch, OutX, OutY, 821, 758, 935, 805, *60 %a_scriptdir%\fig.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 1500
            while (TrocaAba())
            {
                Sleep, 500
                ImageSearch, OutX, OutY, 819, 575, 913, 612, *60 %a_scriptdir%\fig2.png
                if (ErrorLevel = 0)
                {
                    MouseClick, left, OutX, OutY
                    Sleep, 300
                    AtacarParte(parte)
                    break
                }
            }
        }
        loop, 2
        {
            FechaAllRapido()
        }
        Sleep, 3000
    }
    else
    {
        Aviso := true
        Random, randVerificaClan, MinToMili(30), MinToMili(60)
    }
}

AttPagina()
{
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba1.png
    if (ErrorLevel = 0)
    {
        Pagina := 1
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba2.png
    if (ErrorLevel = 0)
    {
        Pagina := 2
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba3.png
    if (ErrorLevel = 0)
    {
        Pagina := 3
    }
}

TrocaPagina()
{

    if (Pagina = 3)
    {
        MouseMove, 798, 389
        Sleep, 20
        Send {LButton down}
        MouseMove, 1078, 391, 25
        Sleep, 200
        Send {LButton up}
        indo := false
    }
    if (Pagina = 1)
    {
        MouseMove, 1078, 391
        Sleep, 20
        Send {LButton down}
        MouseMove, 798, 389, 25
        Sleep, 200
        Send {LButton up}
        indo := true
    }
    if (Pagina = 2 and indo)
    {
        MouseMove, 1078, 391
        Sleep, 20
        Send {LButton down}
        MouseMove, 798, 389, 25
        Sleep, 200
        Send {LButton up}
    }
    if (Pagina = 2 and !indo)
    {
        MouseMove, 798, 389
        Sleep, 20
        Send {LButton down}
        MouseMove, 1078, 391, 25
        Sleep, 200
        Send {LButton up}
    }
}

TrocaAba()
{
    AttPagina()
    ImageSearch, OutX, OutY, 729, 125, 833, 164, *60 %a_scriptdir%\abaraid.png
    if (ErrorLevel = 0)
    {
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
    Else
    {
        Aba := 0
        ;TrocaPagina()
        Sleep, 200
        TrocaAba()
    }
return Pagina <> 5
}

Fight()
{
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
        ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
        if (ErrorLevel = 0 or (A_TickCount - Inicio) = 40000)
        {
            Sleep, 300
            MouseClick, left, OutX, OutY
            Sleep, 3000
            return
        }
    }
}

Presente()
{
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 942, 168, 1014, 417, *60 %a_scriptdir%\presente.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 300
        MouseClick, left, 775, 559
        Sleep, 300
        MouseClick, left, 952, 796
        Sleep, 300
        MouseClick, left, 786, 146
        Sleep, 300
    }
    ;GeraLog(A_TickCount - inicio)
}

Ovo()
{
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 947, 227, 1019, 447, *60 %a_scriptdir%\ovo.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 1500
        MouseClick, left, 979, 773
        Sleep, 300
    }
    ;GeraLog(A_TickCount - inicio)
}

MoveAleatorioQuadrado(X, Y, H, W)
{
    Random, RandomX, X, X + H
    Random, RandomY, Y, Y + W
    MouseMove, RandomX, RandomY, 1
}

AtacarParte(parte)
{
    Sleep, 2000
    MouseMove, 827, 312
    Inicio := A_TickCount
    if (parte = "cabeca")
    {
        ; Coordenadas do quadrado
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(751, 273, 69, 47)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "ombro esquerdo")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(571, 262, 67, 61)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "ombro direito")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(940, 268, 59, 64)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "mao esquerda")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(559, 491, 54, 64)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "mao direita")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(948, 490, 49, 44)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "torso")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(749, 445, 74, 26)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "perna esquerda")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(702, 563, 33, 106)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 600, 639, 744, 716, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }

    if (parte = "perna direita")
    {
        Send {LButton down}
        loop,
        {
            MoveAleatorioQuadrado(843, 575, 31, 108)
            if ((A_TickCount - Inicio) >= 40000)
            {
                ImageSearch, OutX, OutY, 772, 679, 893, 718, *60 %a_scriptdir%\continue.png
                if !ErrorLevel
                {
                    Send {LButton up}
                    MouseClick, left, OutX, OutY
                    Sleep, 3000
                    return
                }
            }
        }
    }
}

AlvoEmQualParte(parte, tipo)
{
    if (parte="cabeca")
    {
        SetaVariaveisEntrada(769, 252, 793, 275)
        ;EntradaX = 920
        ;EntradaY = 268
        ;EntradaH = 945
        ;EntradaW = 294
    }
    if (parte="torso")
    {
        SetaVariaveisEntrada(770, 323, 792, 340)
    }
    if (parte="ombro esquerdo")
    { 
        SetaVariaveisEntrada(686, 268, 709, 290)
    }
    if (parte="ombro direito")
    { 
        SetaVariaveisEntrada(847, 268, 873, 291)
    }
    if (parte="mao esquerda")
    {
        SetaVariaveisEntrada(686, 352, 709, 376)
    }
    if (parte="mao direita")
    {
        SetaVariaveisEntrada(846, 351, 873, 376)
    }
    if (parte="perna esquerda")
    {
        SetaVariaveisEntrada(734, 401, 758, 423)
    }
    if (parte="perna direita")
    {
        SetaVariaveisEntrada(809, 399, 834, 424)
    }
    loop, 4
    {
        ImageSearch, OutX, OutY, EntradaX, EntradaY, EntradaH, EntradaW, *40 %a_scriptdir%\%tipo%%A_Index%.png
        if !ErrorLevel
        {
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

SetaVariaveisEntrada(X, Y, H, W)
{
    EntradaX := X
    EntradaY := Y
    EntradaH := H
    EntradaW := W
}

ParteTemVida(parte)
{
    loop, 10
    {
        if (parte="cabeca")
        {
            loop, 5
            {
                ; Cabeca armor
                ImageSearch, OutX, OutY, 730, 205, 828, 285, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro esquerdo")
        {
            loop, 5
            {
                ; ombro esquerdo armor
                ImageSearch, OutX, OutY, 654, 241, 738, 297, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro direito")
        {
            loop, 5
            {
                ; ombro direito armor
                ImageSearch, OutX, OutY, 824, 218, 901, 306, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="torso")
        {
            loop, 5
            {
                ; torso armor
                ImageSearch, OutX, OutY, 735, 294, 824, 353, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="mao esquerda")
        {
            loop, 5
            {
                ; mao esquerda armor
                ImageSearch, OutX, OutY, 648, 317, 731, 377, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="mao direita")
        {
            loop, 5
            {
                ; mao direita armor
                ImageSearch, OutX, OutY, 814, 309, 913, 376, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna esquerda")
        {
            loop, 5
            {
                ; perna esquerda armor
                ImageSearch, OutX, OutY, 703, 376, 780, 440, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna direita")
        {
            loop, 5
            {
                ; perna direita armor
                ImageSearch, OutX, OutY, 777, 371, 846, 443, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
    }
return false
}

ClicaRandomRapido(X, Y, var)
{

}

ClicaRandom(X, Y, var, velo := 5)
{
    if (velo < 5)
        velo := 5
    Random, rand, -var, var
    Random, rand2, -var, var
    SendMouse_LeftClick(X+rand, Y+rand2, velo)
    ;MouseClick, left, X+rand, Y+rand2
}

randSleep(mili)
{
    Random, rand, mili-(mili//5), mili
return rand
}

ClicaRandomDois(X, Y, var, var2)
{
    Random, rand, -var, var
    Random, rand2, -var2, var2
    MouseClick, left, X+rand, Y-rand2
}

ClicaRandomComFecha(X, Y, var)
{
    FechaColetaRapida()
    Random, rand, -var, var
    Random, rand2, -var, var
    MouseClick, left, X+rand, Y+rand2
    FechaColetaRapida()
    MouseClick, left, X+rand, Y+rand2
}
;ok
Cima()
{
    ;Inicio2 := A_TickCount
    ;ImageSearch, OutX, OutY, 1039, 496, 1109, 524, *40 %a_scriptdir%\cima.png
    if (RetornaCorPixel(922, 490) = "0x2B2C2E")
    {
        GeraLog("Cima")
        ClicaRandom(922, 490, 3)
        Sleep, 150
    }
    ;GeraLog("Cima:" A_TickCount - Inicio2)
}

lua()
{
    ImageSearch, OutX, OutY, 1031, 53, 1168, 130, *60 %a_scriptdir%\lua.png
    if (ErrorLevel = 0)
    {
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

FechaSeta()
{
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 558, 91, 609, 429, *65 *Transblack %a_scriptdir%\seta.png
    if !ErrorLevel
    {
        GeraLog("Clicou seta")
        ClicaRandom(OutX+2, OutY+10, 1)
        ProcuraAteNaoAchar(558, 91, 609, 429, 65, "seta", 600)
        ProcuraAteNaoAchar(558, 91, 609, 429, 65, "seta", 600)
    }
    ;GeraLog(A_TickCount - Inicio)
}

FechaJogoEAbre()
{
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
FechaBluestacksEAbre()
{
    qntAchou := 0
    MouseClick, left, 1548, 18
    Sleep, 1000
    MouseClick, left, 906, 467
    Sleep, 1000
    GeraLog("Fechou o bluestacks")
    Run, "C:\Program Files\BlueStacks_nxt\HD-Player.exe" --instance Nougat64 --cmd launchApp --package "com.gamehivecorp.taptitans2"
    GeraLog("Abriu o bluestacks no jogo")
    ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "max", 30000)
    MouseClick, left, AchouOutX, AchouOutY
    GeraLog("Maximizou o bluestacks")
    GeraLog("Esperando Carregar")
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < MinToMili(3))
    {
        if(ProcuraPixelAteAchar(1009, 849, "0x848339", 300))
        {
            Ativa()
            GeraLog("Carregou tudo...")
            return
        }
        if(ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "app", 300))
        {
            MouseClick, left, AchouOutX, AchouOutY
            GeraLog("Clicou no app...")
        }
    }
    GeraLog("Não carregou.")
    MouseClick, left, 1548, 18
    Sleep, 1000
    MouseClick, left, 906, 467
    Sleep, 1000
    GeraLog("Fechou o bluestacks")
return

}

JogoAberto()
{
    ; Procura Bau, ultimo icone da direita
    ;ImageSearch, OutX, OutY, 1104, 849, 1157, 879, *90 %a_scriptdir%\baudireita.png
    if (RetornaCorPixel(1009, 849) = "0x848339")
    {
        ;GeraLog("Jogo Estava aberto")
        return true
    }
    loop,
    {
        FechaAllRapido()
        if (RetornaCorPixel(1009, 849) = "0x848339")
        {
            return true
        }
        ClicaRandom(783, 59, 5)
        if (A_Index > 20)
        {
            CaptureScreen("0, 0, " A_ScreenWidth ", " A_ScreenHeight,,"prints/erros/" A_now ".png")
            GeraLog("Jogo não estava aberto")
            return false
        }
    }
}
;ok
FechaXzinRapido()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(985, 45) = "0x2D2D2E")
    {
        ClicaRandom(985, 45, 2)
        ProcuraPixelAteNaoAchar(985, 45, "0x2D2D2E", 2000)
    }
    ;GeraLog("FechaXzinRapido: " A_TickCount - Inicio)
}

FechaAllRapido()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(576, 683) != "0x547DFB")
    {
        ;GeraLog("Não achou o relic")
        loop, 5
        {
            FechaColetaRapida()
            FechaXzinRapido()
            FechaXgrande3()
            FechaXgrande2()
            FechaXgrande1()
            ;Não sei oque é isso
            FechaXgrande4()
        }
    }
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        If (qntAchou > 400)
        {
            GeraLog("Estava com lag, fechou e abriu: " qntAchou)
            FechaBluestacksEAbre()
        }
    }
    ;GeraLog("FechaAll: " A_TickCount - Inicio)
}
;ok
FechaXgrande1()
{
    if (RetornaCorPixel(960, 192) = "0x333436")
    {
        ClicaRandom(960, 192+5, 1)
        ProcuraPixelAteNaoAchar(960, 192, "0x333436", 500)
    }
}
;ok
FechaXgrande2()
{
    ;Procura o X do Prestige e janelas parecidas
    ; 0x383A3C = Prestige
    ; 0x37393C = Hero info
    ; Não sei o Terceiro
    PixelGetColor, OutputVar, 969, 92
    if (OutputVar = "0x383A3C" or OutputVar = "0x37393C" or OutputVar = "0x65676D" or OutputVar = "0x7A7C83" or OutputVar = "0x75777E")
    {
        ClicaRandom(969, 92, 1)
        ProcuraPixelAteNaoAchar(969, 92, OutputVar, 500)
    }
}
;ok
FechaXgrande3()
{
    ; Procura o X do botão prestigio info (dentro do prestigio, aonde tem as informações de advanced start)
    if (RetornaCorPixel(956, 128) = "0x38383A")
    {
        ClicaRandom(956, 128+5, 1)
        ProcuraPixelAteNaoAchar(956, 128, "0x38383A", 500)
    }
}
;não sei oque é isso
FechaXgrande4()
{
    if (RetornaCorPixel(1112, 112) = "0x373C3E")
    {
        ClicaRandom(1112+3, 112+5, 1)
        ProcuraPixelAteNaoAchar(1112, 112, "0x373C3E", 500)
    }
}

SendSMS(txt)
{
    Body := """Body=" . txt . """"
    RunWait, curl -X POST "https://api.twilio.com/2010-04-01/Accounts/AC913aa069bbfadb06c4b20a9b326c6f14/Messages.json" --data-urlencode %Body% --data-urlencode "From=+13613664986" --data-urlencode "To=+5511985245602" -u AC913aa069bbfadb06c4b20a9b326c6f14:7923dc5a2a33b1e6399061f97ac7e465, ,Hide
return
}

MinToMili(min)
{
return min * 60000
}

RetornaCorPixel(X, Y)
{
    PixelGetColor, OutputVar, X, Y
return OutputVar
}

AtivaCO()
{
    Inicio := A_TickCount
    loop, 10
    {
        if (RetornaCorPixel(882, 454) = "0xFFFFFF" or RetornaCorPixel(872, 453) = "0xFFFFFF")
        {
            GeraLog("Não estava ativa " A_TickCount - Inicio)
            ClicaRandom(882, 454, 3)
            return
        }
        else
        {
            GeraLog("Estava ativa " A_TickCount - Inicio)
        }
    }
}

AtivaAA()
{
    ;Inicio := A_TickCount
    FechaSeta()
    loop, 1
    {
        ImageSearch, OutX, OutY, 552, 197, 693, 483, *29 %a_scriptdir%\seilamano.png
        if !ErrorLevel
        {
            ;GeraLog("Achou1 " A_TickCount - Inicio)
            ClicaRandom(OutX, OutY, 5)
            return
        }
        ImageSearch, OutX, OutY, 867, 114, 1017, 479, *29 %a_scriptdir%\seilamano.png
        if !ErrorLevel
        {
            ;GeraLog("Achou2 " A_TickCount - Inicio)
            ClicaRandom(OutX, OutY, 5)
            return
        }
    }
    ;GeraLog("Terminou " A_TickCount - Inicio)
}

F11::
    CompraSkills()
return

F6::
    Gui, Submit, NoHide
    GeraLog(Estilo)
return

F7::
    PixelGetColor, OutputVar, 969, 92
    GeraLog(OutputVar)
return

F1::
    ;parte := "nenhuma"
    GeraLog("--------------COM ALVOS-------------------")
    Loop, parse, listaPartes, `,
    {
        if (AlvoEmQualParte(A_LoopField, "alvo"))
        {
            GeraLog("Alvo na " A_LoopField)
            if (ParteTemVida(A_LoopField))
            {
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
        if (ParteTemVida(A_LoopField))
        {
            if (!AlvoEmQualParte(A_LoopField, "x"))
            {
                GeraLog("Com vida, sem X: " A_LoopField)
                parte := A_LoopField
                ;break
            }
            else
            {
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
    CompraSkills()
return

F4::
    AtivaContratoViaBS()
return

F5::
    loop,
    {
        VerificaClanRaid()
        randVerificaClan := 1
    }
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