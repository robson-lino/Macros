#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1

#Include, ocr.ahk

DefaultDirs = a_scriptdirs

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
global X, Y, W, H, FSColor := "0x00ADFD", DSColor := "0x353535", SCColor := "0x00ADFE", HMColor := "0x00ADFD", WCColor := "0x1C8ECE", TFColor := "0x00AEFF", stage
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
global iUltimaAtualizada = A_TickCount
global TickPrestigio := A_TickCount

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
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 102450
Gui Add, Text, x8 y40 w36 h23 +0x200, Target
Gui Add, Progress, vPrgMana x8 y96 w120 h20 -Smooth, 100
Gui Add, CheckBox, vChkPrestige x8 y168 w63 h23 +Checked, Prestige
Gui Add, CheckBox, vChkFairy x8 y192 w63 h23 +Checked, Fairy
Gui Add, Button, vPrestige gPrestige x96 y272 w80 h23, Prestige
Gui Add, Button, vBtnIniciar gIniciar x8 y272 w80 h23, Iniciar
Gui Add, Radio, hWndhRadBos vRadBos x8 y216 w63 h23 +Checked, BoS
Gui Add, Radio, hWndhRadAll vRadAll x80 y216 w63 h23, All
Gui Add, Text, x8 y8 w30 h23 +0x200, Atual:
Gui Add, Text, vtxtPode x90 y8 w39 h23 +0x200, NAO
Gui Add, Radio, hWndhRadPush vRadPush x8 y64 w49 h23, Push
Gui Add, Radio, hWndhRadFarm vRadFarm x64 y64 w49 h23 +Checked, Farm
Gui Add, Text, vtxtMana x128 y96 w57 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gCompraSkills2 x216 y272 w80 h23, Atualizar
Gui Add, Button, vBtnCalibrar gCalibrar x216 y300 w80 h23, Calibrar

Gui Show, x1243 y271 w303 h420, TapMacro
Ativa()
Return

Prestige:
Return

Iniciar:

SetTimer Atualizar, 2500, On, 3
SetTimer Clica, 200, On, 1
Settimer CompraHeroi, 60000, On, 4
Return

Clica()
{
    Random, rand, 1, 10
    Random, rand2, 1, 10
    MouseClick, Left, 931+rand, 225+rand2
    MouseClick, Left, 811+rand, 349+rand2
    MouseClick, Left, 1045+rand, 337+rand2
    MouseClick, Left, 933+rand, 486+rand2
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

CompraHeroi()
{
    AbreHeroi()
    if (SubStr(RetornaText(835, 662, 207, 56), 1, 3)="Col")
    {
        MouseClick, left, 932, 695
    }
    Sleep, 100
    Loop, 10
    {
        if (SubStr(RetornaText(835, 662, 207, 56), 1, 3)="Col")
        {
            MouseClick, left, 932, 695
        }
        Click, 910 694 WheelDown 4
        Loop, 4
        {
            ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *60 %a_scriptdir%\c1.png
            if !ErrorLevel
            {
                Sleep, 70
                MouseClick, left, Xlinha, Ylinha
            }
            else
            {
                ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *60 %a_scriptdir%\c2.png
                if !ErrorLevel
                {
                    Sleep, 70
                    MouseClick, left, Xlinha, Ylinha
                    
                }
            }
            loop, 2
            {
                ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
                if !ErrorLevel
                {
                    MouseClick, left, Xlinha, Ylinha
                    Sleep, 500
                }
                Sleep, 30
            }
        }
        Sleep, 200
    }
    Loop, 20
    {
        Click, 910 694 WheelUP 4
        Loop, 4
        {
            ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *60 %a_scriptdir%\c1.png
            if !ErrorLevel
            {
                Sleep, 70
                MouseClick, left, Xlinha, Ylinha
            }
            else
            {
                ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *60 %a_scriptdir%\c2.png
                if !ErrorLevel
                {
                    Sleep, 70
                    MouseClick, left, Xlinha, Ylinha
                }
            }
            loop, 2
            {
                ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
                if !ErrorLevel
                {
                    MouseClick, left, Xlinha, Ylinha
                    Sleep, 500
                }
                Sleep, 30
            }
        }
        Sleep, 200
    }
    Fechaheroi()
    ;903A00
    ;A32700
}

Atualizar()
{
    ;Ativa()
    Inicio := A_TickCount
    FechaColeta()
    Fechaheroi()
    AtualizaStatusSkillAtiva()
    TempoPassado := TempoPassado()
    GuiControl, , txtTempoStage, %TempoPassado%
    stage := RetornaText(887, 35, 105, 70)
    stage := RegExReplace(stage, "\D", "")
    if ((StrLen(stage)=5 or StrLen(stage)=6) and stage is digit and stage > 80000 and stage < 180000)
    {
        AttBarraStage()
        FazPrestige()
        iUltimaAtualizada := A_TickCount
        GuiControl, , TxtStage, %stage%
    }
    if (A_TickCount-iUltimaAtualizada)>20000
    {
        MouseClick left, 727, 99
        while (A_TickCount-iUltimaAtualizada)>20000
        {
            Sleep, 50
            stage := RetornaText(887, 35, 105, 70)
            stage := RegExReplace(stage, "\D", "")
            if ((StrLen(stage)=5 or StrLen(stage)=6) and stage is digit and stage > 80000 and stage < 180000)
            {
                AttBarraStage()
                FazPrestige()
                iUltimaAtualizada := A_TickCount
                GuiControl, , TxtStage, %stage%
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
        
    }
    AttMana()
    AtualizaStatusSkillAtiva()
    FechaColeta()
    Fechaheroi()
    lua()
    tempo := A_TickCount - Inicio
    ;GuiControl, , txtTempoStage, %tempo%
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
    GuiControlGet, Edit1
    if (StageProgess > 100 and stage > Edit1)
    {
        GeraLog("Faz prestige em : " TempoPassado() " no Stage: " stage)
        TickPrestigio := A_TickCount
        FechaColeta()
        Sleep, 300
        AbreSkill()
        Sleep, 300
        loop, 30
        {
            Click, 910 694 WheelUP 4
            Sleep, 200
        }
        Sleep, 2000
        GeraLog("Subiu")
        MouseClick, left, 1101, 726
        Sleep, 300
        MouseClick, left, 931, 769
        stage := 80000
        Sleep, 20000
        CompraSkills()
        CompraSkills()
        All()
        GeraLog("Faz Prestige: " A_TickCount - Inicio)
        return
    }
}

CompraSkills2()
{
    Inicio := A_TickCount
    Sleep, 300
    AbreSkill()
    Sleep, 300
    ImageSearch, Xlinha, Ylinha, 709, 524, 778, 599, *60 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        loop, 5
        {
            Click, 910 694 WheelUP 4
            Sleep, 200
        }
        Loop, 10
        {
            Click, 910 694 WheelDown 4
            Loop, 4
            {
                ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *85 %a_scriptdir%\spell.png
                if !ErrorLevel
                {
                    MouseClick, left, Xlinha, Ylinha
                    Sleep, 200
                    ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
                    if !ErrorLevel
                    {
                        MouseClick, left, Xlinha, Ylinha
                        Sleep, 1000
                    }
                    ImageSearch, Xlinha, Ylinha, 936, 603, 1026, 821, *60 %a_scriptdir%\c3.png
                    if !ErrorLevel
                    {
                        MouseClick, left, Xlinha, Ylinha
                    }
                }
                Sleep, 500
            }
            Sleep, 200
        }
        Loop, 20
        {
            Click, 910 694 WheelDown 4
            Loop, 4
            {
                ImageSearch, Xlinha, Ylinha, 1017, 605, 1164, 782, *85 %a_scriptdir%\spell.png
                if !ErrorLevel
                {
                    MouseClick, left, Xlinha, Ylinha
                    Sleep, 200
                    ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
                    if !ErrorLevel
                    {
                        MouseClick, left, Xlinha, Ylinha
                        Sleep, 1000
                    }
                    ImageSearch, Xlinha, Ylinha, 936, 603, 1026, 821, *60 %a_scriptdir%\c3.png
                    if !ErrorLevel
                    {
                        MouseClick, left, Xlinha, Ylinha
                    }
                }
                Sleep, 500
            }
            Sleep, 200
        }
    }
}


VaiClicaSkill(X, Y)
{
    MouseClick, left, X, Y
    Sleep, 500
    ImageSearch, Xlinha, Ylinha, 873, 532, 1083, 847, *60 %a_scriptdir%\c3.png
    if !ErrorLevel
    {
        MouseClick, left, Xlinha, Ylinha
        Sleep, 200
    }
    Sleep, 500
}

^F8::
DescUmaPagina()
Return


ProcuraEClicaSkill()
{
    ImageSearch, Xlinha, Ylinha, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
    if !ErrorLevel
    {
        MouseClick, left, Xlinha, Ylinha
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




CompraSkills()
{
    Inicio := A_TickCount
    Sleep, 300
    AbreSkill()
    Sleep, 300
    ImageSearch, Xlinha, Ylinha, 709, 524, 778, 599, *60 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        loop, 5
        {
            SobeUmaPagina()
        }
        loop, 2
        {
            ProcuraEClicaSkill()
        }
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
    Sleep, 200
}

DescUmaPagina()
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
