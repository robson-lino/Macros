#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1

#Include, ocr.ahk

DefaultDirs = a_scriptdirs

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
global X, Y, W, H, FSColor := "0x00ADFD", DSColor := "0x353535", SCColor := "0x00ADFE", HMColor := "0x00ADFD", WCColor := "0x1C8ECE", TFColor := "0x00AEFF", stage, stageanterior
global listStage = []
global DSPixelX = 741
global DSPixelY = 772
global FSPixelX = 815
global FSPixelY = 772
global WCPixelX = 895
global WCPixelY = 771
global TFPixelX = 1049
global TFPixelY = 773
global SCPixelX = 1127
global SCPixelY = 772
global HMPixelX = 971
global HMPixelY = 771
global StageProgess := 0
global CheckMir := false
global iUltimaAtualizada = A_TickCount
global TickPrestigio := A_TickCount
global TempoTotal := 0
global QntPrestigio := 0

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
	}
}

Gui -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Add, Text, hWndhTxtStage vTxtStage x40 y8 w78 h23 +0x200, Stage
Gui Add, Text, hWndhtxtDSTempo vtxtDSTempo x8 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhTxtFSTempo vtxtFSTempo x56 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtWCTempo vtxtWCTempo x104 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtHMTempo vtxtHMTempo x152 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtTFTempo vtxtTFTempo x200 y120 w42 h23 +0x200, SIM
Gui Add, Text, hWndhtxtSCTempo vtxtSCTempo x248 y120 w42 h23 +0x200, SIM
GuiControl, Hide, txtDSTempo
GuiControl, Hide, txtFSTempo
GuiControl, Hide, txtWCTempo
GuiControl, Hide, txtHMTempo
GuiControl, Hide, txtTFTempo
GuiControl, Hide, txtSCTempo
Gui Add, Text, hWndhtxtTempoStage vtxtTempoStage x140 y8 w30 h23 +0x200, 0
Gui Add, Text, x170 y8 w39 h23 +0x200, Med:
Gui Add, Text, hWndhtxtMediana vtxtMediana x205 y8 w42 h23 +0x200, 0
Gui Add, Progress, vPrgStage x176 y40 w120 h20 -Smooth, 10
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 103400
Gui Add, Text, x8 y40 w36 h23 +0x200, Target
Gui Add, Progress, vPrgMana x8 y96 w120 h20 -Smooth, 100
Gui Add, CheckBox, vChkMiR x8 y144 w63 h23, MiR
Gui Add, CheckBox, vChkPrestige x8 y168 w63 h23 +Checked, Prestige
Gui Add, CheckBox, vChkFairy x8 y192 w63 h23 +Checked, Fairy
Gui Add, Button, vPrestige gPrestige x96 y272 w80 h23, Prestige
Gui Add, Button, vBtnIniciar gIniciar x8 y272 w80 h23, Iniciar
Gui Add, Radio, hWndhRadBos vQual x8 y216 w63 h23, BoS
Gui Add, Radio, hWndhRadAll x80 y216 w63 h23 +Checked, All
Gui Add, Text, x8 y8 w30 h23 +0x200, Atual:
Gui Add, Text, vtxtPode x90 y8 w39 h23 +0x200, NAO
Gui Add, Radio, hWndhRadPush vRadPush x8 y64 w49 h23, Push
Gui Add, Radio, hWndhRadFarm vRadFarm x64 y64 w49 h23 +Checked, Farm
Gui Add, Text, vtxtMana x128 y96 w57 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gDeuErro x216 y272 w80 h23, Atualizar
Gui Add, Button, vBtnCalibrar gCalibrar x216 y300 w80 h23, Calibrar

Gui Add, Text, x8 y300 w42 h23 +0x200, Media:
Gui Add, Text, hWndhtxtMediaStage vtxtMediaStage x45 y300 w30 h23 +0x200, 0
Gui Add, Text, x8 y320 w42 h23 +0x200, Qnt:
Gui Add, Text, hWndhtxtQntPres vtxtQntPres x45 y320 w30 h23 +0x200, 0



Gui Show, x1243 y271 w303 h420, TapMacro
Ativa()
Return

Prestige:
Return


Iniciar:
SetTimer Atualizar, 2500, On, 3
SetTimer Clica, 200, On, 1
GuiControlGet, ChkMiR
if (ChkMiR)
{
    CheckMir := true
}
else
{
    Settimer CompraHeroi, 60000, On, 4
}
Return

F10::
MouseGetPos, OutputVarX, OutputVarY
GeraLog(OutputVarX ", " OutputVarY)
return

Clica()
{
    Random, rand, 1, 10
    Random, rand2, 1, 10
    if (!CheckMir)
    {
        MouseClick, Left, 931+rand, 225+rand2
        MouseClick, Left, 811+rand, 349+rand2
        MouseClick, Left, 1045+rand, 337+rand2
        MouseClick, Left, 933+rand, 486+rand2
    }
    else
    {
        MouseMove, 931+rand, 225+rand2
        Send {LButton down}
        MouseMove, 947, 234
        MouseMove, 906, 241
        MouseMove, 877, 253
        MouseMove, 851, 279
        MouseMove, 836, 304
        MouseMove, 828, 335
        MouseMove, 821, 372
        MouseMove, 825, 414
        MouseMove, 839, 451
        MouseMove, 867, 490
        MouseMove, 911, 497
        MouseMove, 952, 497
        MouseMove, 1000, 496
        MouseMove, 1035, 471
        MouseMove, 1054, 438
        MouseMove, 1071, 381
        MouseMove, 1068, 329
        MouseMove, 1043, 278
        MouseMove, 1007, 247
        MouseMove, 954, 234
        MouseMove, 933, 231
        Send {LButton up}
    }
}

AbreHeroi()
{
    ImageSearch, Xlinha, Ylinha, 714, 545, 780, 600, *60 %a_scriptdir%\weapon.png
    if (ErrorLevel = 0)
    {
        return
    }
    else
    {
        Send, 2
    }
}
Fechaheroi()
{
    ImageSearch, Xlinha, Ylinha, 714, 545, 780, 600, *60 %a_scriptdir%\weapon.png
    if (ErrorLevel = 0)
    {
        Send, 2
    }
    else
    {
        return
    }
}


CLicaCompraHeroi()
{
    Loop, 4
    {
        ImageSearch, Xlinha, Ylinha, 1013, 591, 1167, 847, *60 %a_scriptdir%\c1.png
        if !ErrorLevel
        {
            MouseClick, left, Xlinha, Ylinha
            Sleep, 70
        }
        ImageSearch, Xlinha, Ylinha, 1013, 591, 1167, 847, *60 %a_scriptdir%\c2.png
        if !ErrorLevel
        {
            MouseClick, left, Xlinha, Ylinha
            Sleep, 70
        }
        loop, 2
        {
            ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
            if !ErrorLevel
            {
                MouseClick, left, Xlinha, Ylinha
                Sleep, 300
            }
            Sleep, 30
        }
    }
}

CompraHeroi()
{
    Inicio := A_TickCount
    AbreHeroi()
    Sleep, 100
    Loop, 2
    {
        CLicaCompraHeroi()
        DesceUmaPagina()
    }
    Loop, 4
    {
        CLicaCompraHeroi()
        SobeUmaPagina()
    }
    Fechaheroi()
    GeraLog("ComprouHerois: " A_TickCount - Inicio)

}

AtualizaStage()
{
    stagetemp := RetornaText(887, 35, 105, 70)
    stagetemp := RegExReplace(stagetemp, "\D", "")
    if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit and stagetemp > 80000 and stagetemp < 180000)
    {
        stageanterior := stage
        stage := stagetemp
        AttBarraStage()
        FazPrestige()
        GuiControl, , TxtStage, %stage%
        iUltimaAtualizada := A_TickCount
    }
}
AtualizaStageViaConfig()
{
    MouseClick left, 727, 99
    while (A_TickCount-iUltimaAtualizada)>20000
    {
        Sleep, 50
        stagetemp := RetornaText(887, 35, 105, 70)
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
            stage := 80000
            Break
        }
    }
    Sleep, 30
    MouseClick left, 727, 99
}

Atualizar()
{
    Inicio := A_TickCount
    FechaColeta()
    Fechaheroi()
    AtualizaStatusSkillAtiva()
    TempoPassado := TempoPassado()
    GuiControl, , txtTempoStage, %TempoPassado%
    AtualizaStage()
    if (A_TickCount-iUltimaAtualizada)>20000
    {
        AtualizaStageViaConfig()
    }
    AttMana()
    AtualizaStatusSkillAtiva()
    FechaColeta()
    Fechaheroi()
    lua()
    VaiProBoss()
    tempo := A_TickCount - Inicio
}

RetornaText(X, Y, W, H)
{
    hBitmap := HBitmapFromScreen(X, Y, W, H)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    text := StrReplace(ocr(pIRandomAccessStream), "`n","")
    return text 
}

SkillNivel()
{
    loop,
    {
        ImageSearch, X2, Y2, 708, 757, 471, 79, *120 %a_scriptdir%\skillnivel.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, X2, Y2
        }
        Sleep, 5
    }
}

AttMana()
{
    mana := RegExReplace(RetornaText(677, 714, 175, 74), "[a-zA-Z({[]", "")
    atual := SubStr(mana, 1, InStr(mana, "/")-1)
    total := SubStr(mana, InStr(mana, "/")+1, 4)
    porcentagem := (atual / total) * 100
    if (porcentagem > 0 and porcentagem <= 100)
    {
        GuiControl, , PrgMana, %porcentagem%
        GuiControl, , TxtMana, %mana%
    }
    if (porcentagem >= 100)
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
}

AttBarraStage()
{
    GuiControlGet, Edit1
    listStage.Push(stage)
    StageProgess := (stage / Edit1) * 100
    GuiControl, , PrgStage, %StageProgess%
}

AtualizaStatusSkillAtiva()
{
    EstaAtiva(DSPixelX, DSPixelY, "DS")
    EstaAtiva(FSPixelX, FSPixelY, "FS")
    EstaAtiva(WCPixelX, WCPixelY, "WC")
    EstaAtiva(HMPixelX, HMPixelY, "HM")
    EstaAtiva(TFPixelX, TFPixelY, "TF")
    EstaAtiva(SCPixelX, SCPixelY, "SC")
}

EstaAtiva(X, Y, skill)
{
    PixelGetColor, OutputVar, X, Y
    if (OutputVar=%skill%Color)
    {
        GuiControl, show, txt%skill%Tempo
    }
    Else
    {
        GuiControl, Hide, txt%skill%Tempo
        if (skill = "DS")
        {
            Send, Q
            Sleep, 10
        }
        if (skill = "FS")
        {
            Send, W
            Sleep, 10
        }
        if (skill = "WC")
        {
            Send, E
            Sleep, 10
        }
        if (skill = "HM")
        {
            Send, R
            Sleep, 10
        }
        if (skill = "TF")
        {
            Send, T
            Sleep, 10
        }
        if (skill = "SC")
        {
            Send, Y
            Sleep, 10
        }
    }
}

Calibrar()
{
    ; DS
    PixelGetColor, DSColor, DSPixelX, DSPixelY
    ; FS
    PixelGetColor, FSColor, FSPixelX, FSPixelY
    ; WC
    PixelGetColor, WCColor, WCPixelX, WCPixelY
    ; TF
    PixelGetColor, TFColor, TFPixelX, TFPixelY
    ; SC
    PixelGetColor, SCColor, SCPixelX, SCPixelY
    ; HM
    PixelGetColor, HMColor, HMPixelX, HMPixelY
}

FazPrestige()
{
    Inicio := A_TickCount
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    GuiControlGet, Edit1
    if (StageProgess > 100 and stage > Edit1 and aumento_percentual >= 0 and aumento_percentual <= 5)
    {
        GeraLog("Fez o prestigio em " TempoPassado() " no Stage: " stage ", estava configurado para: " Edit1)
        
        FechaColeta()
        Sleep, 300
        AbreSkill()
        Sleep, 300
        loop, 5
        {
            SobeUmaPagina()
        }
        Sleep, 500
        GeraLog("Subiu")
        MouseClick, left, 1101, 726
        Sleep, 300
        MouseClick, left, 931, 769
        Sleep, 300
        if (DeuErro())
            return
        GeraLog("Fez prestige")
        AtualizaMedias()
        TickPrestigio := A_TickCount
        Sleep, 20000
        AtualizaStageViaConfig()
        if (stage > 100000 and stage < 180000)
            FazPrestige()
        CompraSkills()
        CompraReliquia()
        GuiControlGet, Edit1
        Mais10 := stage - 60
        GuiControl, , Edit1, % Mais10
        GeraLog("Tempo do faz Prestige: " A_TickCount - Inicio)
        return
    }
}

AtualizaMedias()
{
    TempoTotal =+ A_Tickcount - TickPrestigio
    QntPrestigio++
    Media := TempoTotal/QntPrestigio
    GuiControl, , txtMediaStage, %Media%
    GuiControl, , QntPres, %QntPrestigio%

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
        ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, Xlinha, Ylinha
            Sleep, 300
        }
        Send, 1
        GeraLog("Deu erro - WTF")
        return true
    }
    return false
}


VaiProBoss()
{
    ImageSearch, X, Y, 1052, 65, 1163, 108, *60 %a_scriptdir%\g.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, X, Y
        GeraLog("Tava travado fora do boss")
    }
}

VaiClicaSkill(X, Y)
{
    MouseClick, left, X, Y
    Sleep, 500
    MouseClick, left, X-122, Y
    Sleep, 500
}


ProcuraEClicaSkill()
{
    loop, 15
    {
        ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, Xlinha, Ylinha
            Sleep, 300
        }
        ImageSearch, Xlinha, Ylinha, 1021, 555, 1168, 881, *85 %a_scriptdir%\spell.png
        if !ErrorLevel
        {
            VaiClicaSkill(Xlinha, Ylinha)
        }
        ImageSearch, Xlinha, Ylinha, 1021, 555, 1168, 881, *85 %a_scriptdir%\spell2.png
        if !ErrorLevel
        {
            VaiClicaSkill(Xlinha, Ylinha)
        }
    }
}

CompraSkills()
{
    Inicio := A_TickCount
    Click, 943, 359
    Sleep, 300
    AbreSkill()
    Sleep, 300
    ImageSearch, Xlinha, Ylinha, 709, 524, 778, 599, *60 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        Click, 1098, 626
        loop, 3
        {
            ProcuraEClicaSkill()
            DesceUmaPagina()
        }
        loop, 3
        {
            ProcuraEClicaSkill()
            SobeUmaPagina()
        }
    }
    else
    {
        AbreSkill()
        CompraSkills()
    }
    FechaSkill()
    GeraLog("CompraSkills: " A_TickCount - Inicio)
}

AbreSkill()
{
    ImageSearch, Xlinha, Ylinha, 709, 524, 778, 599, *60 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        return
    }
    else
    {
        Send, 1
    }

}
FechaSkill()
{
    ImageSearch, Xlinha, Ylinha, 709, 524, 778, 599, *60 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        Send, 1
    }
    else
    {
        return
    }
}

StageEstavel()
{
    listStage.Sort()
    if (listStage.Length()>= 5)
    {
        meio := Round(listStage.MaxIndex() / 2)
        If Mod(listStage.MaxIndex(), 2) = 0
        {
            ; Se a lista tiver um número par de elementos, a mediana é a média entre os dois elementos do meio
            mediana := (listStage[meio] + listStage[meio+1]) / 2
        }
        Else
        {
            ; Se a lista tiver um número ímpar de elementos, a mediana é o elemento do meio
            mediana := listStage[meio+1]
        }
    }
    GuiControl, , txtMediana, %mediana%
    if (listStage.Length()>= 20)
        listStage := []
    if ((mediana / stage) * 100 > 60)
    {
        GuiControl, , txtPode, % "Sim"
        return true
    }
    GuiControl, , txtPode, % "Nao"
    return false
}

StatusSkill(X, Y, W, H, skill)
{
    nome := ""
    tempo := ""
    FechaColeta()
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

AtivaSkills(porcentagem)
{
    MouseClick, left, 747, 798
    Sleep, 20
    MouseClick, left, 804, 798
    Sleep, 20
    MouseClick, left, 900, 798
    Sleep, 20
    MouseClick, left, 985, 798
    Sleep, 20
    MouseClick, left, 1061, 798
    Sleep, 20
    MouseClick, left, 1144, 798
    Sleep, 20
    
}

FechaColeta()
{
    if (SubStr(RetornaText(835, 662, 207, 56), 1, 3)="Col")
    {
        MouseClick, left, 932, 695
    }
    Sleep, 30
    if (SubStr(RetornaText(824, 129, 211, 60), 1, 3)="Opt")
    {
        MouseClick left, 742, 56
    }
}

lua()
{
    ImageSearch, Xlinha, Ylinha, 1031, 53, 1168, 130, *60 %a_scriptdir%\lua.png
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
CompraReliquia()
{
    GuiControlGet, Qual
    if Qual
        BoS()
    else
        All()

}


BoS()
{
    Sleep, 500
    Send, 5
    Sleep, 500
    loop, 20
    {
        MouseClick left, 1097, 760
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
    Sleep, 500
    loop, 20
    {
        MouseClick left, 1093, 684
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

Pause::Pause

Ativa()
{
    WinActivate BlueStacks
    WinGetPos, X, Y, W, H, BlueStacks
}

Return

SobeUmaPagina()
{
    MouseMove, 892, 600
    Send {LButton down}
    MouseMove, 901, 846, 25
    Sleep, 200
    Send {LButton up}
    Sleep, 100
}

DesceUmaPagina()
{
    MouseMove, 901, 846
    Send {LButton down}
    MouseMove, 892, 600, 25
    Sleep, 200
    Send {LButton up}
    Sleep, 200
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
