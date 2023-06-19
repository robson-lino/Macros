; 0.2.4
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 25, 25
#MaxThreads 1

#Include, ocr.ahk
#Include edge.ahk

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
global PrimeiraColor := "0x00AEFF"
global SegundaColor := "0x00AEFF"
global TerceiraColor := "0x00AEFF"
global QuartaColor := "0x00AEFF"
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
global PrimeiraPixelX = 739
global PrimeiraPixelY = 773
global SegundaPixelX = 817
global SegundaPixelY = 773
global TerceiraPixelX = 895
global TerceiraPixelY = 773
global QuartaPixelX = 972
global QuartaPixelY = 773
global QuintaPixelX = 1050
global QuintaPixelY = 773
global SextaPixelX = 1128
global SextaPixelY = 773
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
global Push
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
global listaPartes := "cabeça,torso,ombro esquerdo,ombro direito,mão esquerda,mão direita,perna direita,perna esquerda"
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
	PageInst.Disconnect()
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
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 118000
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
Gui Add, CheckBox, hWndhRadFarm vChkHS x210 y64 w49 h23, HS

Gui Add, Text, vtxtMana x128 y96 w300 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gCompraSkills x216 y272 w80 h23, Teste
Gui Add, Button, vBtnCalibrar gCalibrar x216 y300 w80 h23, Calibrar

Gui Add, Text, x8 y300 w42 h23 +0x200, Media:
Gui Add, Text, hWndhtxtMediaStage vtxtMediaStage x45 y300 w30 h23 +0x200, 0
Gui Add, Text, x8 y320 w42 h23 +0x200, Qnt:
Gui Add, Text, hWndhtxtQntPres vtxtQntPres x45 y320 w30 h23 +0x200, 0

Gui Show, x1243 y271 w303 h420, TapMacro

Return

Prestige:
Return


Iniciar:
WinActivate, taptitans.log
Sleep, 300
TickPrestigio := A_TickCount
Ativa()
Random, randVerificaClan, MinToMili(1), MinToMili(2)
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
    AtualizaStageViaAba()
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        if (!CheckMir)
        {
            if(!ContratoAtivo())
            {
                ;GeraLog("Contrato não ativo")
                ;loop, 4
                ;{
                ;    Random, grand, -4, 4
                ;    Random, grand2, -4, 4
                ;    ;AtualizaStage()
                ;    ClicaRandomRapido(934, 242)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(1011, 278)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(1035, 350)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(1015, 425)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(951, 462)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(884, 454)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(838, 401)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(824, 336)
                ;    ;Sleep, 20
                ;    ClicaRandomRapido(859, 266)
                ;    ;Sleep, 20
                ;    if (FechaColetaRapida())
                ;    {
                ;        loop, 3
                ;        {
                ;            ClicaRandomRapido(934, 242)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(1011, 278)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(1035, 350)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(1015, 425)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(951, 462)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(884, 454)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(838, 401)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(846, 355)
                ;            ;Sleep, 20
                ;            ClicaRandomRapido(859, 266)
                ;            ;Sleep, 20
                ;        }
                ;        break
                ;    }
                ;}
                AtivaContratoViaBS()
            }
            else
            {
                loop, 1
                {
                    Send, l
                    Sleep, 20
                    Send, a
                    Sleep, 20
                    Send, 7
                    Sleep, 20
                    Send, 8
                    Sleep, 20
                    ;Random, grand, -4, 4
                    ;Random, grand2, -4, 4
                    ;ClicaRandomRapido(934, 411)
                    ;ClicaRandomRapido(774, 237)
                    ;ClicaRandomRapido(932, 242)
                    ;ClicaRandomRapido(1119, 240)
                    ;ClicaRandomRapido(769, 254)
                    ;ClicaRandomRapido(939, 426)
                    ;loop, 5
                    ;{
                    ;    Send, a
                    ;    Sleep, 20
                    ;    Send, b
                    ;    Sleep, 20
                    ;    Send, i
                    ;}
                }
            }
        }
        else
        {
            Send, k
            ProcuraPixelAteAchar(1046, 17, "0x381E1B", 300)
            ProcuraPixelAteNaoAcharSI(1046, 17, "0x381E1B", 5000)
            ;Random, grand, -4, 4
            ;Random, grand2, -4, 4
            ;MouseMove, 940+grand, 218+grand2
            ;MouseClick, left, 1146, 242
            ;Send {LButton down}
            ;Sleep, 20
            ;Send {LButton down}
            ;MouseMove, 925+grand, 254+grand2
            ;MouseMove, 845+grand, 258+grand2
            ;MouseMove, 875+grand, 281+grand2
            ;MouseMove, 818+grand, 298+grand2
            ;MouseMove, 845+grand, 317+grand2
            ;MouseMove, 806+grand, 353+grand2
            ;MouseMove, 842+grand, 374+grand2
            ;MouseMove, 830+grand, 439+grand2
            ;MouseMove, 879+grand, 421+grand2
            ;MouseMove, 903+grand, 477+grand2
            ;MouseMove, 958+grand, 456+grand2
            ;MouseMove, 995+grand, 409+grand2
            ;MouseMove, 1037+grand, 411+grand2
            ;MouseMove, 1011+grand, 393+grand2
            ;MouseMove, 1055+grand, 361+grand2
            ;MouseMove, 1044+grand, 325+grand2
            ;MouseMove, 1024+grand, 284+grand2
            ;MouseMove, 1028+grand, 223+grand2
            ;MouseMove, 945+grand, 251+grand2
            ;MouseMove, 894+grand, 267+grand2
            ;MouseMove, 757+grand, 220+grand2
            ;MouseMove, 1135+grand, 239+grand2
            ;Send {LButton up}
            ;Sleep, 20
            ;Send {LButton up}
        }
    }
    else
    {
        ;if(!ContratoAtivo())
        ;{
        ;    loop, 3
        ;    {
        ;        AttMana()
        ;        loop, 4
        ;        {
        ;            ;AtualizaStage()
        ;            Send, a
        ;            Sleep, 20
        ;            Send, b
        ;            Sleep, 20
        ;            Send, c
        ;            Sleep, 20
        ;            Send, d
        ;            Sleep, 20
        ;            Send, o
        ;            Sleep, 20
        ;            Send, f
        ;            Sleep, 20
        ;            Send, g
        ;            Sleep, 20
        ;            Send, h
        ;            Sleep, 20
        ;            Send, i
        ;            Sleep, 20
        ;            if (FechaColetaRapida())
        ;            {
        ;                loop, 3
        ;                {
        ;                    Send, a
        ;                    Sleep, 20
        ;                    Send, b
        ;                    Sleep, 20
        ;                    Send, c
        ;                    Sleep, 20
        ;                    Send, d
        ;                    Sleep, 20
        ;                    Send, o
        ;                    Sleep, 20
        ;                    Send, f
        ;                    Sleep, 20
        ;                    Send, g
        ;                    Sleep, 20
        ;                    Send, h
        ;                    Sleep, 20
        ;                    Send, i
        ;                    Sleep, 20
        ;                }
        ;                break
        ;            }
        ;        }
        ;    }
        ;}
        Send, {L up}
        AttMana()
        Send, {L down}
        ClicaRandom(1142, 250, 2)
        ClicaRandom(1051, 246, 2)
        ClicaRandom(935, 242, 2)
        ClicaRandom(827, 245, 2)
        ClicaRandom(769, 254, 2)
        ClicaRandom(939, 426, 2)
        Send, {L down}
        Sleep, 20
        Send, {L down}
        Sleep, 20
        Send, {L down}
        ;MouseMove, 940+rand, 218+rand2
        ;Click, 2
        ;Click, 2
        ;Sleep, 30
        ;MouseMove, 1146, 242
        ;Click, 2
        ;Sleep, 30
        ;Send {LButton down}
        ;Loop, 3
        ;{
        ;    MouseMove, 943+rand, 198+rand2
        ;    MouseMove, 899+rand, 199+rand2
        ;    MouseMove, 804+rand, 207+rand2
        ;    MouseMove, 731+rand, 252+rand2
        ;    MouseMove, 717+rand, 328+rand2
        ;    MouseMove, 717+rand, 399+rand2
        ;    MouseMove, 718+rand, 476+rand2
        ;    MouseMove, 720+rand, 529+rand2
        ;    MouseMove, 877+rand, 552+rand2
        ;    MouseMove, 1008+rand, 562+rand2
        ;    MouseMove, 1102+rand, 562+rand2
        ;    MouseMove, 1135+rand, 494+rand2
        ;    MouseMove, 1139+rand, 431+rand2
        ;    MouseMove, 1144+rand, 347+rand2
        ;    MouseMove, 1138+rand, 270+rand2
        ;    MouseMove, 1136+rand, 221+rand2
        ;    MouseMove, 1130+rand, 214+rand2
        ;    MouseMove, 1018+rand, 204+rand2
        ;    MouseMove, 934+rand, 523+rand2
        ;}
        ;Send {LButton up}
        
        FechaColetaRapida()
        Send, {L down}
        Sleep, 20
        AttMana()
        Send, {L down}
        Sleep, 20
        AtualizaStageViaAba()
        Send, {L down}
        Sleep, 20

        ;MouseMove, 1146, 242
        ;Click, 2
        ;MouseClick, left, 1146, 242
        ;loop, 5
        ;{
        ;    Sleep, 150
        ;    Click, 2
        ;}
        ;Sleep, 300
        ;Send, {LButton down}
        ;Sleep, 300
        ;loop, 30
        ;{
        ;    MouseMove, 735, 222
        ;    MouseMove, 1146, 242
        ;    ImageSearch, OutX, OutY, 857, 681, 888, 712, *30 %a_scriptdir%\azul.png
        ;    if (ErrorLevel = 0)
        ;    {
        ;        MouseClick, left, 932, 695
        ;        VaiProBoss()
        ;        Send, {LButton up}
        ;        Sleep, 150
        ;        MouseClick, left, 932, 695
        ;        MouseMove, 1146, 242
        ;        Click, 2
        ;        MouseClick, left, 1146, 242
        ;        Sleep, 300
        ;        Click, 2
        ;        Sleep, 300
        ;        Send, {LButton down}
        ;        Sleep, 300
        ;    }
        ;}
        ;Sleep, 300
        ;Send, {LButton up}
        ;Click, 2
        ;Sleep, 300
    }
}

AtivaContratoViaBS()
{
    loop, 3
    {
        ;AtualizaStage()
        Send, a
        Sleep, 20
        Send, b
        Sleep, 20
        Send, c
        Sleep, 20
        Send, d
        Sleep, 20
        Send, o
        Sleep, 20
        Send, f
        Sleep, 20
        Send, g
        Sleep, 20
        Send, h
        Sleep, 20
        Send, i
        Sleep, 20
        if (FechaColetaRapida())
        {
            loop, 2
            {
                Send, a
                Sleep, 20
                Send, b
                Sleep, 20
                Send, c
                Sleep, 20
                Send, d
                Sleep, 20
                Send, o
                Sleep, 20
                Send, f
                Sleep, 20
                Send, g
                Sleep, 20
                Send, h
                Sleep, 20
                Send, i
                Sleep, 20
            }
            break
        }
    }
}

AbreHeroi()
{
    ;Inicio := A_TickCount
    Cima()
    if (RetornaCorPixel(817, 865) = "0xB6A565")
    {
        return
    }
    else
    {
        Send, 2
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(817, 865, "0xB6A565", 700))
        {
            Ativa()
            FechaAllRapido()
            if (!JogoAberto())
                FechaBluestacksEAbre()
            AbreHeroi()
        }
        ProcuraPixelAteAchar(971, 206, "0x303030", 700)
        ;GeraLog("AbreHeroi: " A_TickCount - Inicio)
        return
    }
}


Fechaheroi()
{
    ImageSearch, OutX, OutY, 780, 841, 857, 880, *60 %a_scriptdir%\heroes.png
    if (ErrorLevel = 0)
    {
        Send, 2
        Sleep, 120
    }
    else
    {
        return
    }
}


CLicaCompraHeroi()
{
    ;Inicio := A_TickCount
    PixelSearch, OutputVarX, OutputVarY, 1111, 145, 1120, 849, 0x0786EC, 20, fast
    if !ErrorLevel
    {
        Random, grand, -4, 4
        Random, grand2, -4, 4
        ClicaRandomRapido(1098, 189)
        ClicaRandomRapido(1096, 260)
        ClicaRandomRapido(1090, 334)
        ClicaRandomRapido(1083, 401)
    }
    ;Loop, 3
    ;{
    ;    PixelSearch, OutputVarX, OutputVarY, 1111, 145, 1120, 849, 0x0786EC, 20, fast
    ;    if !ErrorLevel
    ;    {
    ;        ClicaRandomDois(OutputVarX, OutputVarY+5, 25, 2)
    ;        Sleep, 90
    ;    }
    ;    ;FechaColetaRapida()
    ;    ;ImageSearch, OutX, OutY, 1115, 144, 1133, 852, *30 %a_scriptdir%\c7.png
    ;    ;if !ErrorLevel
    ;    ;{
    ;    ;    ClicaRandomDois(OutX, OutY+5, 25, 2)
    ;    ;}
    ;}
    ;GeraLog("ClicaCompraHeroi: " A_TickCount - Inicio)
}


CompraHeroiRapido()
{
    ;Inicio := A_TickCount
    AbreHeroi()
    CLicaCompraHeroi()
    ImageSearch, OutX, OutY, 763, 154, 840, 218, *80 %a_scriptdir%\lv0.png
    if ErrorLevel
    {
        SobeUmaPagina()
    }
    FechaAllRapido()
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


ContratoAtivo()
{
    ;Inicio := A_TickCount
    PixelSearch, OutputVarX, OutputVarY, 884, 488, 932, 499, 0xFF02F5, 5, Fast
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

AtualizaStageViaAba()
{
    Inicio := A_TickCount
    Achou := false
    CompraHeroiRapido()
    contrato := ContratoAtivo()
    AbreSkillDiretoProPresitigo()
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < prestmili)
    {
        FechaColetaRapida()
        stagetemp := RetornaText(765, 692, 146, 52)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
        {
            stageanterior := stage
            stage := stagetemp
            GuiControl, , TxtStage, %stage%
            AttBarraStage()
            GeraLog("TempoAtt: " FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " stage " - %" StageProgess)
            FazPrestige()
            GuiControlGet, ChkPrestige
            If (StageProgess >= 99.98 and contrato and ChkPrestige)
                prestmili := 5000
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
        ClicaRandom(938, 713, 4)
        ;MouseClick, left, 840, 720
        loop, 5
        {
            FechaColetaRapida()
            stagetemp := RetornaText(963, 223, 166, 148)
            stagetemp := RegExReplace(stagetemp, "\D", "")
            if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
            {
                stageanterior := stage
                stage := stagetemp
                GuiControl, , TxtStage, %stage%
                AttBarraStage()
                GeraLog("TempoAtt: " FormataMilisegundos(A_TickCount - iUltimaAtualizada) " - " stage " - %" StageProgess)
                ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
                FazPrestige()
                iUltimaAtualizada := A_TickCount
            }
        }
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
    lua()
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

AttMana()
{
    ;Inicio := A_Tickcount
    FechaAllRapido()
    AtualizaStatusSkillAtiva()
    ;mana := RegExReplace(RetornaText(677, 714, 175, 74), "\D(?<!\/)", "")
    mana := RegExReplace(RetornaText(696, 727, 108, 43), "\D(?<!\/)", "")
    atual := SubStr(mana, 1, InStr(mana, "/")-1)
    total := SubStr(mana, InStr(mana, "/")+1, 4)
    porcentagem := (atual / total) * 100
    if (porcentagem > 0 and porcentagem <= 100)
    {
        GuiControl, , PrgMana, %porcentagem%
        GuiControl, , TxtMana, %mana%
    }
    if (porcentagem >= 60 and PrimeiraAtiva AND SegundaAtiva AND TerceiraAtiva AND QuartaAtiva AND QuintaAtiva AND SextaAtiva)
    {
        GuiControlGet, ChkAbsal
        if (!ChkAbsal)
        {
            ;ImageSearch, OutX, OutY, 1093, 799, 1118, 835, *3 %a_scriptdir%\fullSC.png
            if (RetornaCorPixel(1105, 808) != "0x72A8E1")
            {
                Loop, 4
                {
                    Send, Y
                    Sleep, 30
                }
                ;GeraLog("Comprou SC")
            }
            else
            {
                ;ImageSearch, OutX, OutY, 1015, 803, 1039, 834, *3 %a_scriptdir%\fullTF.png
                if (RetornaCorPixel(1027, 809) != "0xE8E263")
                {
                    Loop, 4
                    {
                        Send, T
                        Sleep, 30
                    }
                    ;GeraLog("Comprou TF")
                }
                else
                {
                    ;ImageSearch, OutX, OutY, 935, 804, 963, 835, *3 %a_scriptdir%\fullHM.png
                    if (RetornaCorPixel(949, 811) != "0xF861AC")
                    {
                        Loop, 4
                        {
                            Send, R
                            Sleep, 30
                        }
                        ;GeraLog("Comprou HM")
                    }
                    ;ImageSearch, OutX, OutY, 858, 808, 886, 836, *3 %a_scriptdir%\fullDS.png
                    if (RetornaCorPixel(873, 818) != "0x1BD0AC")
                    {
                        Loop, 4
                        {
                            Send, E
                            Sleep, 30
                        }
                        ;GeraLog("Comprou DS")
                    }
                    ;ImageSearch, OutX, OutY, 782, 808, 807, 834, *3 %a_scriptdir%\fullWC.png
                    if (RetornaCorPixel(794, 817) != "0x27D6F8")
                    {
                        Loop, 4
                        {
                            Send, W
                            Sleep, 30
                        }
                        ;GeraLog("Comprou WC")
                    }
                    ;ImageSearch, OutX, OutY, 703, 806, 730, 834, *3 %a_scriptdir%\fullFS.png
                    if (RetornaCorPixel(716, 817) != "0x2651F8")
                    {
                        Loop, 4
                        {
                            Send, Q
                            Sleep, 30
                        }
                        ;GeraLog("Comprou FS")
                    }
                }
            }
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
                Send, Y
                Sleep, 30
                Send, T
                Sleep, 30
                Send, R
                Sleep, 30
                Send, E
                Sleep, 30
                Send, W
                Sleep, 30
                Send, Q
                Sleep, 30
            }
            Send, {L down}
        }
    }
    ;GeraLog("AttMana: " A_TickCount - Inicio)
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
    ;FechaAllRapido()
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
        GuiControl, Hide, txt%skill%
        if (skill = "Primeira")
        {
            Send, Q
            Sleep, 20
            Send, Q
            %skill%Ativa := false
            PrimeiraiCount++
        }
        if (skill = "Segunda")
        {
            Send, W
            Sleep, 20
            Send, W
            %skill%Ativa := false
            SegundaiCount++
        }
        if (skill = "Terceira")
        {
            Send, E
            Sleep, 20
            Send, E
            %skill%Ativa := false
            TerceiraiCount++
        }
        if (skill = "Quarta")
        {
            Send, R
            Sleep, 20
            Send, R
            %skill%Ativa := false
            QuartaiCount++
        }
        if (skill = "Quinta")
        {
            Send, T
            Sleep, 20
            Send, T
            %skill%Ativa := false
            QuintaiCount++
        }
        if (skill = "Sexta")
        {
            Send, Y
            Sleep, 20
            Send, Y
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
        if (A_Tickcount - TickPrestigio > MinToMili(7))
        {
            Gui, Submit, NoHide
            if (Push = 3)
            {
                ;CheckMir := false
                GeraLog("Estava mais de 7 minutos em um unico prestigio, desmarca o MiR, e força")
                forcaprestige := true
            }
            Else
            {
                ;CheckMir := false
                GeraLog("Estava mais de 7 minutos em um unico prestigio, desmarca o MiR, e força")
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
            GeraLog("Estava mais de 10 minutos em um unico prestigio, desmarca o MiR, e força")
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
    if ((StageProgess >= 100 and stage > Edit1 and ChkPrestige)
    or (forcaprestige and ChkPrestige))
    {
        GeraLog("FazPrestige: " TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        GeraLogTempoPrest(TempoPassado() " : " stage " - " stageanterior " - " Edit1)
        TravadoCount := 0
        forcaprestige := false
        if (!ProcuraAteAchar(726, 80, 782, 129, 60, "icone", 300))
        {
            if (!ProcuraAteAchar(1022, 250, 1164, 322, 100, "prest", 500))
            {
                while (!ProcuraAteAchar(1022, 250, 1164, 322, 100, "prest", 500))
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
        ClicaRandom(931, 769, 4)
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
        Send, 1
        GeraLog("Deu erro - WTF", true)
        return true
    }
    return false
}


VaiProBoss()
{
    ImageSearch, X, Y, 1069, 68, 1115, 87, *2 %a_scriptdir%\g.png
    if (ErrorLevel = 0)
    {
        ClicaRandom(X, Y, 4)
        ;MouseClick, left, X, Y
        Sleep, 300
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
                GeraLog("força prestige, por que estava travado: " stage)
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
        PixelSearch, OutX, OutY, 1035, 429, 1039, 835, 0x0698F6, 30, Fast
        if !ErrorLevel
        {
            MouseClick, left, OutX+15, OutY
            loop, 10
            {
                PixelSearch, OutX, OutY, 1010, 421, 1016, 837, 0x2929C3, 5, Fast
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
        while (!ProcuraAteAchar(1022, 250, 1164, 322, 100, "prest", 500))
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
    ImageSearch, OutX, OutY, 702, 842, 780, 880, *40 %a_scriptdir%\espada.png
    if (ErrorLevel = 0)
    {
        Sleep, 100
        ClicaRandom(1097, 184, 5)
        ProcuraEClicaSkillRapido()
        if (A_TickCount - Boost > MinToMili(30))
        {
            DesceUmaPagina()
            loop, 15
            {
                ImageSearch, OutX, OutY, 1022, 406, 1165, 834, *120 %a_scriptdir%\fr.png
                if !ErrorLevel
                {
                    Boost := A_TickCount
                    ClicaRandom(OutX, OutY, 5)
                    ;MouseClick, left, OutX, OutY
                    Sleep, 300
                    ClicaRandom(939, 664, 5)
                    ;MouseClick, left, 939, 664
                    Sleep, 30
                    break
                }
            }
            SobeUmaPagina()
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
    if (RetornaCorPixel(743, 855) = "0xDFD2B1")
    {
        return
    }
    else
    {
        Send, 1
        ;GeraLog("AbreSkill: " A_TickCount - Inicio)
        if !(ProcuraPixelAteAchar(1114, 54, "0x4F5054", 700))
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

AbreSkillDiretoProPresitigo()
{
    Inicio := A_TickCount
    ; Procura aba aberta da Espada
    if (RetornaCorPixel(743, 855) = "0xDFD2B1")
    {
        ;GeraLog("AbreSkill já estava aberta: " A_TickCount - Inicio)
        ; Espera abrir o icone, e vai clicando
        while (!ProcuraPixelAteAchar(927, 322,"0xFFFFFF", 15))
        {
            Cima()
            FechaColetaRapida()
            ClicaRandom(1091, 284, 5)
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
        Send, 1
        ; Espera abrir a aba aberta da Espada
        if (ProcuraPixelAteAchar(743, 855, "0xDFD2B1", 1000))
        {
            ;GeraLog("AbreSkill abriu: " A_TickCount - Inicio)
            ; Espera abrir o icone, e vai clicando
            while (!ProcuraPixelAteAchar(927, 322,"0xFFFFFF", 15))
            {
                Cima()
                FechaColetaRapida()
                ClicaRandom(1091, 284, 5)
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
        Send, 1
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

FechaColetaRapida()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(931, 713) = "0xCFA63E")
    {
        ClicaRandom(931, 713, 5)
        ProcuraPixelAteNaoAchar(931, 713, "0xCFA63E", 2000)
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
    Send, 5
    Sleep, 500
    Cima()
    while (!ProcuraAteAchar(705, 165, 771, 378, 40, "BoS", 700))
    {
        if (A_Index > 10)
        {
            return
        }
        SobeUmaPagina()
    }
    loop, 10
    {
        ClicaRandom(AchouOutX+380, AchouOutY+5, 5)
        Sleep, 150
    }
    Sleep, 500
    Send, 5
    Sleep, 500


}

All()
{
    Sleep, 500
    Send, 5
    Cima()
    ProcuraAteAchar(1029, 103, 1165, 265, 40, "all", 700)
    loop, 10
    {
        ClicaRandom(AchouOutX, AchouOutY, 3)
        Sleep, 150
    }
    Sleep, 500
    Send, 5
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
    Click, 931 60 Right
}

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
    MouseMove, 901, 846
    Send {LButton down}
    MouseMove, 892, 600, 10
    Sleep, 50
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
    ImageSearch, OutX, OutY, 745, 55, 801, 100, *60 %a_scriptdir%\raid.png
    if (ErrorLevel = 0)
    {
        loop, 5
        {
            SoundBeep, 300, 300
        }
        Random, randVerificaClan, MinToMili(1), MinToMili(5)
        GeraLog("Entrou no Raid", true)
        MouseClick, left, OutX, OutY
        Sleep, 3000
        ImageSearch, OutX, OutY, 831, 680, 1038, 772, *60 %a_scriptdir%\fundoazul.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, OutX, OutY
            Sleep, 1500
        }
        ImageSearch, OutX, OutY, 729, 125, 833, 164, *60 %a_scriptdir%\abaraid.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, 781, 138
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
        ImageSearch, OutX, OutY, 985, 782, 1083, 820, *60 %a_scriptdir%\fig.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, OutX, OutY
            Sleep, 1500
            ;ImageSearch, OutX, OutY, 964, 589, 1069, 632, *60 %a_scriptdir%\fig2.png
            ;if (ErrorLevel = 0)
            ;{
            ;    MouseClick, left, OutX, OutY
            ;    Sleep, 300
            ;    AtacarParte(parte)
            ;}
            ;else
            ;{
                while (TrocaAba())
                {
                    Sleep, 500
                    ImageSearch, OutX, OutY, 964, 589, 1069, 632, *60 %a_scriptdir%\fig2.png
                    if (ErrorLevel = 0)
                    {
                        MouseClick, left, OutX, OutY
                        Sleep, 300
                        AtacarParte(parte)
                        break
                    }
                }

            ;}
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
        MouseClick, left, 781, 393
    Else if (Aba = 2)
        MouseClick, left, 819, 389
    Else if (Aba = 3)
        MouseClick, left, 863, 391
    Else if (Aba = 4)
        MouseClick, left, 914, 392
    Else if (Aba = 5)
        MouseClick, left, 959, 393
    Else if (Aba = 6)
        MouseClick, left, 1002, 391
    Else if (Aba = 7)
        MouseClick, left, 1054, 389
    Else if (Aba = 8)
        MouseClick, left, 1108, 386
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
        ImageSearch, OutX, OutY, 772, 679, 893, 718, *60 %a_scriptdir%\continue.png
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
    ImageSearch, OutX, OutY, 1107, 204, 1157, 254, *60 %a_scriptdir%\presente.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 300
        MouseClick, left, 928, 580
        Sleep, 300
        MouseClick, left, 1113, 810
        Sleep, 300
        MouseClick, left, 1121, 297
        Sleep, 300
    }
    ;GeraLog(A_TickCount - inicio)
}

Ovo()
{
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 1103, 297, 1163, 364, *60 %a_scriptdir%\ovo.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 3000
        MouseClick, left, 1099, 820
        Sleep, 300
    }
    ;GeraLog(A_TickCount - inicio)
}

AtacarParte(parte)
{
    Sleep, 2000
    Inicio := A_TickCount
    if (parte = "cabeça")
    {
        MouseMove, 937, 309, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 901, 363, 3
            MouseMove, 976, 354, 3
            MouseMove, 937, 309, 3
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

    if (parte = "ombro esquerdo")
    {
        MouseMove, 773, 318, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 749, 348, 3
            MouseMove, 804, 353, 3
            MouseMove, 773, 318, 3
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

    if (parte = "ombro direito")
    {
        MouseMove, 1061, 317, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 1114, 299, 3
            MouseMove, 1061, 317, 3
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

    if (parte = "mão esquerda")
    {
        MouseMove, 723, 506, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 765, 539, 3
            MouseMove, 723, 506, 3
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

    if (parte = "mão direita")
    {
        MouseMove, 1083, 513, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 1132, 514, 3
            MouseMove, 1083, 513, 3
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

    if (parte = "torso")
    {
        MouseMove, 897, 467, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 962, 469, 3
            MouseMove, 897, 467, 3
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

    if (parte = "perna esquerda")
    {
        MouseMove, 866, 559, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 867, 633, 3
            MouseMove, 866, 559, 3
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

    if (parte = "perna direita")
    {
        MouseMove, 1003, 573, 3
        Send {LButton down}
        loop, 
        {
            MouseMove, 1010, 642, 3
            MouseMove, 1003, 573, 3
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
    if (parte="cabeça")
    {
        SetaVariaveisEntrada(920, 268, 945, 294)
        ;EntradaX = 920
        ;EntradaY = 268
        ;EntradaH = 945
        ;EntradaW = 294
    }
    if (parte="torso")
    {
        EntradaX = 920
        EntradaY = 333
        EntradaH = 944
        EntradaW = 359
    }
    if (parte="ombro esquerdo")
    {
        EntradaX = 837
        EntradaY = 285
        EntradaH = 860
        EntradaW = 309
    }
    if (parte="ombro direito")
    {
        EntradaX = 998
        EntradaY = 286
        EntradaH = 1023
        EntradaW = 309
    }
    if (parte="mão esquerda")
    {
        EntradaX = 837
        EntradaY = 370
        EntradaH = 860
        EntradaW = 394
    }
    if (parte="mão direita")
    {
        EntradaX = 998
        EntradaY = 368
        EntradaH = 1024
        EntradaW = 396
    }
    if (parte="perna esquerda")
    {
        EntradaX = 884
        EntradaY = 418
        EntradaH = 908
        EntradaW = 443
    }
    if (parte="perna direita")
    {
        EntradaX = 960
        EntradaY = 418
        EntradaH = 985
        EntradaW = 443
    }
    loop, 3
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
        if (parte="cabeça")
        {
            loop, 3
            {
                ; Cabeça armor
                ImageSearch, OutX, OutY, 884, 212, 974, 300, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro esquerdo")
        {
            loop, 3
            {
                ; ombro esquerdo armor
                ImageSearch, OutX, OutY, 803, 229, 891, 315, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="ombro direito")
        {
            loop, 3
            {
                ; ombro direito armor
                ImageSearch, OutX, OutY, 969, 215, 1074, 316, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="torso")
        {
            loop, 3
            {
                ; torso armor
                ImageSearch, OutX, OutY, 883, 303, 978, 370, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
                }
        }
        if (parte="mão esquerda")
        {
            loop, 3
            {
                ; mão esquerda armor
                ImageSearch, OutX, OutY, 792, 303, 888, 397, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                } 
            }
        }
        if (parte="mão direita")
        {
            loop, 3
            {
                ; mão direita armor
                ImageSearch, OutX, OutY, 977, 309, 1073, 405, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna esquerda")
        { 
            loop, 3
            {
                ; perna esquerda armor
                ImageSearch, OutX, OutY, 849, 393, 931, 453, *10 %a_scriptdir%\vida%A_index%.png
                if !ErrorLevel
                {
                    ;MouseMove, OutX, OutY
                    return true
                }
            }
        }
        if (parte="perna direita")
        {
            loop, 3
            {
                ; perna direita armor
                ImageSearch, OutX, OutY, 927, 372, 1004, 463, *10 %a_scriptdir%\vida%A_index%.png
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




ClicaRandomRapido(X, Y)
{
    X := X+grand
    Y := Y+grand2
    Click, %X% %Y%
}

ClicaRandom(X, Y, var)
{
    Random, rand, -var, var
    Random, rand2, -var, var
    MouseClick, left, X+rand, Y+rand2
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

Cima()
{
    ;Inicio2 := A_TickCount
    ;ImageSearch, OutX, OutY, 1039, 496, 1109, 524, *40 %a_scriptdir%\cima.png
    if (RetornaCorPixel(1076, 510) = "0x29292F")
    {
        GeraLog("Cima")
        ClicaRandom(1076, 510, 3)
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
    ImageSearch, OutX, OutY, 707, 174, 760, 410, *50 %a_scriptdir%\seta.png
    if !ErrorLevel
    {
        ClicaRandom(OutX, OutY+5, 1)
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

FechaBluestacksEAbre()
{
    qntAchou := 0
    ImageSearch, OutX, OutY, 1727, 6, 1915, 45, *90 %a_scriptdir%\xbluestacks.png
    MouseClick, left, OutX, OutY
    Sleep, 1000
    ImageSearch, OutX, OutY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %a_scriptdir%\fechar.png
    MouseClick, left, OutX, OutY
    Sleep, 1000
    GeraLog("Fechou o bluestacks")
    Run, "C:\Program Files\BlueStacks_nxt\HD-Player.exe" --instance Pie64 --cmd launchApp --package "com.gamehivecorp.taptitans2"
    GeraLog("Abriu o bluestacks no jogo")
    ProcuraAteAchar(0, 0, A_ScreenWidth, A_ScreenHeight, 90, "max", 30000)
    MouseClick, left, AchouOutX, AchouOutY
    GeraLog("Maximizou o bluestacks")
    GeraLog("Esperando Carregar")
    ProcuraAteAchar(1104, 849, 1157, 879, 90, "baudireita", 120000)
    GeraLog("Carregou tudo...")
    Ativa()
}

JogoAberto()
{
    ImageSearch, OutX, OutY, 1104, 849, 1157, 879, *90 %a_scriptdir%\baudireita.png
    if !ErrorLevel
    {
        return true
    }
    loop, 
    {
        FechaAllRapido()
        ImageSearch, OutX, OutY, 1104, 849, 1157, 879, *90 %a_scriptdir%\baudireita.png
        if !ErrorLevel
        {
            return true
        }
        if (A_Index > 50)
        {
            GeraLog("Jogo não estava aberto")
            return false
        }
    }    
}
FechaXzinRapido()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(1114, 54) = "0x4F5054")
    {
        ClicaRandom(1114+5, 54+3, 4)
        ProcuraPixelAteNaoAchar(1114, 54, "0x4F5054", 2000)
    }
    ;GeraLog("FechaXzinRapido: " A_TickCount - Inicio)
}

FechaAllRapido()
{
    ;Inicio := A_TickCount
    if (RetornaCorPixel(730, 702) != "0x335CFD")
    {
        ;GeraLog("Não achou o relic")
        loop, 3
        {
            FechaColetaRapida()
            FechaXgrande3()
            FechaXgrande2()
            FechaXgrande1()
            FechaXzinRapido()
            ;ImageSearch, OutX, OutY, 1088, 122, 1172, 196, *55 %a_scriptdir%\FechaAzul.png
            ;if !ErrorLevel
            ;{
            ;    ClicaRandom(OutX, OutY, 4)
            ;    ;MouseClick, left, OutX, OutY
            ;    Sleep, 300
            ;}
        }
    }
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        If (qntAchou > 360)
        {
            GeraLog("Estava com lag, fechou e abriu: " qntAchou)
            FechaBluestacksEAbre()
        }
    }
    ;if (A_TickCount - Inicio > 100)
        ;GeraLog("FechaAll: " A_TickCount - Inicio)
}

FechaXgrande1()
{
    if (RetornaCorPixel(1114, 210) = "0x343436")
    {
        ClicaRandom(1114, 210+5, 1)
        ProcuraPixelAteNaoAchar(1114, 210, "0x343436", 500)
    }
}

FechaXgrande2()
{
    PixelGetColor, OutputVar, 1119, 105
    if (OutputVar = "0x37383A" or OutputVar = "0x393A3B" or  OutputVar = "0x37393C")
    {
        ClicaRandom(1119, 105, 1)
        ProcuraPixelAteNaoAchar(1119, 105, OutputVar, 500)
    }
}

FechaXgrande3()
{
    if (RetornaCorPixel(1108, 144) = "0x37373A")
    {
        ClicaRandom(1108, 144+5, 1)
        ProcuraPixelAteNaoAchar(1114, 210, "0x37373A", 500)
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

F11::
CompraSkills()
return

F6::
CompraHeroiRapido()
return

F7::
CLicaCompraHeroi()
return


F1::
;parte := "nenhuma"
GeraLog("Com alvo")
Loop, parse, listaPartes, `,
{
    if (AlvoEmQualParte(A_LoopField, "alvo"))
    {
        if (ParteTemVida(A_LoopField))
        {
            GeraLog(A_LoopField)
            ;break
        }
    }
}
GeraLog("Sem alvo")
Loop, parse, listaPartes, `,
{
    if (ParteTemVida(A_LoopField))
    {
        if (!AlvoEmQualParte(A_LoopField, "x"))
        {
            GeraLog(A_LoopField)
        }
    }
}
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