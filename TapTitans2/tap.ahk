; 0.1.0
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
global FSiCount := 0
global DSiCount := 0
global SCiCount := 0
global HMiCount := 0
global WCiCount := 0
global TFiCount := 0
global StageProgess := 0
global CheckMir := false
global iUltimaAtualizada = A_TickCount
global TickPrestigio := A_TickCount
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
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 105000
Gui Add, Text, x8 y40 w36 h23 +0x200, Target
Gui Add, Progress, vPrgMana x8 y96 w120 h20 -Smooth, 100
Gui Add, CheckBox, vChkMiR x8 y144 w63 h23, MiR
Gui Add, CheckBox, vChkPrestige x8 y168 w63 h23 +Checked, Prestige
Gui Add, CheckBox, vChkFairy x8 y192 w63 h23 +Checked, Fairy
Gui Add, Button, vPrestige gFazPrestige x96 y272 w80 h23, Prestige
Gui Add, Button, vBtnIniciar gIniciar x8 y272 w80 h23, Iniciar

Gui Add, Radio, vQual x8 y216 w37 h23, BoS
Gui Add, Radio, x50 y216 w37 h23, All
Gui Add, Radio, x90 y216 w70 h23 +Checked, Alternado
Gui Add, Radio, x160 y216 w70 h23, Nenhum

Gui Add, Text, x8 y8 w30 h23 +0x200, Atual:
Gui Add, Text, vtxtPode x90 y8 w39 h23 +0x200, NAO
Gui Add, Radio, hWndhRadPush vPush x8 y64 w49 h23, Push
Gui Add, Radio, hWndhRadFarm x60 y64 w49 h23 +Checked, Farm
Gui Add, CheckBox, hWndhRadFarm vChkAbsal x120 y64 w49 h23, Absal

Gui Add, Text, vtxtMana x128 y96 w57 h19 +0x200, 0/0
Gui Add, Button, hWndhBtnAtualizar vBtnAtualizar gCompraSkills x216 y272 w80 h23, Teste
Gui Add, Button, vBtnCalibrar gPause x216 y300 w80 h23, Pause

Gui Add, Text, x8 y300 w42 h23 +0x200, Media:
Gui Add, Text, hWndhtxtMediaStage vtxtMediaStage x45 y300 w30 h23 +0x200, 0
Gui Add, Text, x8 y320 w42 h23 +0x200, Qnt:
Gui Add, Text, hWndhtxtQntPres vtxtQntPres x45 y320 w30 h23 +0x200, 0

Gui Show, x1243 y271 w303 h420, TapMacro

Return

Prestige:
Return


Iniciar:
Ativa()
;SetTimer Atualizar, 3000, On, 3
GuiControlGet, ChkMiR
if (ChkMiR)
{
    CheckMir := true
}
else
{
    Settimer CompraHeroi, 60000, On, 4
}
ClicaEAtualiza()
Return

ClicaEAtualiza()
{
    SetTimer ClicaEAtualiza, off
    Inicio := A_TickCount
    Clica()
    Clica()
    Clica()
    Clica()
    Atualizar()
    SetTimer ClicaEAtualiza, 500, ON, 3

}
F10::
MouseGetPos, OutputVarX, OutputVarY
GeraLog(OutputVarX ", " OutputVarY)
return

Clica()
{
    FechaAll()
    Random, rand, 1, 10
    Random, rand2, 1, 10
    if (!CheckMir)
    {
        MouseClick, left, 931+rand, 225+rand2
        MouseClick, left, 947+rand, 234+rand2
        MouseClick, left, 906+rand, 241+rand2
        MouseClick, left, 877+rand, 253+rand2
        MouseClick, left, 851+rand, 279+rand2
        MouseClick, left, 836+rand, 304+rand2
        MouseClick, left, 828+rand, 335+rand2
        MouseClick, left, 821+rand, 372+rand2
        MouseClick, left, 825+rand, 414+rand2
        MouseClick, left, 839+rand, 451+rand2
        MouseClick, left, 867+rand, 490+rand2
        MouseClick, left, 911+rand, 497+rand2
        MouseClick, left, 952+rand, 497+rand2
        MouseClick, left, 1071+rand, 381+rand2
        MouseClick, left, 1068+rand, 329+rand2
        MouseClick, left, 1043+rand, 278+rand2
        MouseClick, left, 1007+rand, 247+rand2
        MouseClick, left, 954+rand, 234+rand2
        MouseClick, left, 933+rand, 231+rand2
    }
    else
    {
        MouseMove, 931+rand, 225+rand2
        Send {LButton down}
        MouseMove, 947+rand, 234+rand2
        MouseMove, 906+rand, 241+rand2
        MouseMove, 877+rand, 253+rand2
        MouseMove, 851+rand, 279+rand2
        MouseMove, 836+rand, 304+rand2
        MouseMove, 828+rand, 335+rand2
        MouseMove, 821+rand, 372+rand2
        MouseMove, 825+rand, 414+rand2
        MouseMove, 839+rand, 451+rand2
        MouseMove, 867+rand, 490+rand2
        MouseMove, 911+rand, 497+rand2
        MouseMove, 952+rand, 497+rand2
        MouseMove, 1000+rand, 496+rand2
        MouseMove, 1035+rand, 471+rand2
        MouseMove, 1054+rand, 438+rand2
        MouseMove, 1071+rand, 381+rand2
        MouseMove, 1068+rand, 329+rand2
        MouseMove, 1043+rand, 278+rand2
        MouseMove, 1007+rand, 247+rand2
        MouseMove, 954+rand, 234+rand2
        MouseMove, 933+rand, 231+rand2
        Send {LButton up}
    }
}

AbreHeroi()
{
    ImageSearch, OutX, OutY, 714, 545, 780, 600, *60 %a_scriptdir%\weapon.png
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
    ImageSearch, OutX, OutY, 714, 545, 780, 600, *60 %a_scriptdir%\weapon.png
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
        ImageSearch, OutX, OutY, 1013, 591, 1167, 847, *60 %a_scriptdir%\c1.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 70
        }
        ImageSearch, OutX, OutY, 1013, 591, 1167, 847, *60 %a_scriptdir%\c2.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 70
        }
        loop, 2
        {
            ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
            if !ErrorLevel
            {
                MouseClick, left, OutX, OutY
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
    CLicaCompraHeroi()
    Fechaheroi()
    ;GeraLog("ComprouHerois: " A_TickCount - Inicio)

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
            Break
        }
    }
    Sleep, 30
    MouseClick left, 727, 99
}

AtualizaStageViaAba()
{
    Inicio := A_TickCount
    AbreSkill()
    Sleep, 500
    ImageSearch, X, Y, 1027, 703, 1159, 764, *90 %a_scriptdir%\prest.png
    if (!ErrorLevel)
    {
        MouseClick, left, X, Y
        Sleep, 500
        loop, 10
        {
            stagetemp := RetornaText(765, 692, 146, 52)
            stagetemp := RegExReplace(stagetemp, "\D", "")
            if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
            {
                stageanterior := stage
                stage := stagetemp
                GuiControl, , TxtStage, %stage%
                loop, 4
                {
                    FechaAll()
                    Sleep, 20
                }
                AttBarraStage()
                FazPrestige()
                iUltimaAtualizada := A_TickCount
                break
            }
        }
        loop, 4
        {
            FechaAll()
            Sleep, 20
        }
    }
    else
    {
        SobeUmaPagina()
        FechaXzin()
        Sleep, 500
    }
    ;GeraLog("Atualiza: " A_TickCount - Inicio)
}

Atualizar()
{
    Inicio := A_TickCount
    TempoPassado := TempoPassado()
    FechaAll()
    Fechaheroi()
    GuiControl, , txtTempoStage, %TempoPassado%
    GuiControlGet, ChkAbsal
    if (!ChkAbsal)
    {
        AtualizaStage()
        if (A_TickCount-iUltimaAtualizada)>20000
        {
            AtualizaStageViaConfig()
        }
    }
    else
    {
        AtualizaStageViaAba()
    }
    AttMana()
    lua()
    VaiProBoss()
    Travado()
    AtualizaStatusSkillAtiva()
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
    if (qntStage >= 0 and qntStage <= 10)
    {
        totalStage += stage
        qntStage++
        mediaStage := (totalStage/qntStage)
    }
    else
    {
        totalStage := 0
        qntStage := 0
    }
    GuiControlGet, Edit1
    listStage.Push(stage)
    StageProgess := (stage / Edit1) * 100
    GuiControl, , PrgStage, %StageProgess%
}

AtualizaStatusSkillAtiva()
{
    EstaAtiva(SCPixelX, SCPixelY, "SC")
    EstaAtiva(TFPixelX, TFPixelY, "TF")
    EstaAtiva(DSPixelX, DSPixelY, "DS")
    EstaAtiva(FSPixelX, FSPixelY, "FS")
    EstaAtiva(WCPixelX, WCPixelY, "WC")
    EstaAtiva(HMPixelX, HMPixelY, "HM")
}

EstaAtiva(X, Y, skill)
{
    PixelGetColor, OutputVar, X, Y
    if (OutputVar=%skill%Color)
    {
        sulfixo := "iCount"
        nomeContadorVariavel := skill . sulfixo 
        %nomeContadorVariavel% := 0
        GuiControl, show, txt%skill%Tempo
    }
    Else
    {
        Sleep, 50
        GuiControl, Hide, txt%skill%Tempo
        if (skill = "DS")
        {
            Send, Q
            Sleep, 10
            DSiCount++
        }
        if (skill = "FS")
        {
            Send, W
            Sleep, 10
            FSiCount++
        }
        if (skill = "WC")
        {
            Send, E
            Sleep, 10
            WCiCount++
        }
        if (skill = "HM")
        {
            Send, R
            Sleep, 10
            HMiCount++
        }
        if (skill = "TF")
        {
            Send, T
            Sleep, 10
            TFiCount++
        }
        if (skill = "SC")
        {
            Send, Y
            Sleep, 10
            SCiCount++
        }
    }
    If (FSiCount > 3 OR DSiCount > 3 OR SCiCount > 3 OR HMiCount > 3 OR WCiCount > 3 OR TFiCount > 3)
    {
        CompraSkills()
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

Travado()
{
    if (A_Tickcount - TickPrestigio > 1800000)
    {
        if (TravadoCount > 0)
        {
            CheckMir := false
            Settimer CompraHeroi, 60000, On, 4
        }
        GeraLog("Estava mais de 30 minutos e fez o prestige")
        forcaprestige := true
        FazPrestige()
        TravadoCount++
        
    }
}

FazPrestige()
{
    Inicio := A_TickCount
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100
    GuiControlGet, Edit1
    GuiControlGet, ChkAbsal
    GuiControlGet, ChkPrestige
    if ((StageProgess > 100 and stage > Edit1 and aumento_percentual >= 0 and aumento_percentual <= 0.5 and aumento_percentual_media < 0.7 and ChkPrestige) 
    or (ChkAbsal StageProgess > 100 and stage > Edit1 and ChkPrestige)
    or (forcaprestige))
    {
        TravadoCount := 0
        forcaprestige := false
        loop, 5
        {
            ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
            if !ErrorLevel
            {
                MouseClick, left, OutX, OutY
                Sleep, 300
            }
        }
        FechaAll()
        Sleep, 300
        AbreSkill()
        Sleep, 300
        ImageSearch, X, Y, 1027, 703, 1159, 764, *80 %a_scriptdir%\prest.png
        while (ErrorLevel)
        {
            SobeUmaPagina()
            ImageSearch, X, Y, 1027, 703, 1159, 764, *80 %a_scriptdir%\prest.png
        }
        Sleep, 500
        stagetemp := RetornaText(765, 692, 146, 52)
        stagetemp := RegExReplace(stagetemp, "\D", "")
        if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
        {
            stageanterior := stage
            stage := stagetemp
            GuiControl, , TxtStage, %stage%
        }
        GeraLog(TempoPassado() " no Stage: " stage " - " stageanterior ", config: " Edit1)
        AtualizaTarget()
        MouseClick, left, X, Y
        Sleep, 300
        MouseClick, left, 931, 769
        Sleep, 300
        if (DeuErro())
            return
        auxcomprou := false
        QntPrestigio++
        AtualizaMedias()
        TickPrestigio := A_TickCount
        totalStage := 0
        qntStage := 0
        Sleep, 20000
        if (!ChkAbsal)
            AtualizaStageViaConfig()
        else 
            AtualizaStageViaAba()
        CompraSkills()
        CompraReliquia()
        ;GeraLog("Tempo do FazPrestige(): " A_TickCount - Inicio)
        return
    }
}

AtualizaMedias()
{
    TempoTotal += A_Tickcount - TickPrestigio
    Media := TempoTotal/QntPrestigio
    Formatado := FormataMilisegundos(Media)
    GuiControl, , txtMediaStage, %Formatado%
    GuiControl, , txtQntPres, %QntPrestigio%

}

AtualizaTarget()
{
    GuiControlGet, Push
    GuiControlGet, Edit1
    if (Push)
    {
        GuiControlGet, ChkAbsal
        if (ChkAbsal)
        {
            Mais10 := ((stage - Edit1))+Edit1
            if (Edit1 < Mais10)
            {
                if (Mais10 - Edit1 > 300)
                {
                    Mais10 := Mais10+1000
                    GeraLog("Novo Target: " Mais10)
                    GuiControl, , Edit1, %Mais10%
                }
                else
                {
                    Mais10 := Mais10+200
                    GeraLog("Novo Target: " Mais10)
                    GuiControl, , Edit1, %Mais10%
                }
            }
        }
        else
        {
            Mais10 := ((stage - Edit1)/5)+Edit1
            if (Mais10 - Edit1 < 50)
            {
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
                return
            }
            else
            {
                GeraLog("Novo Target: " Mais10)
                Mais10 := Edit1+50
                GuiControl, , Edit1, %Mais10%
            }
        }
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
        Sleep, 300
        GeraLog("Tava travado fora do boss")
        Sleep, 300
    }
}

VaiClicaSkill(X, Y)
{
    MouseClick, left, X, Y-20
    Sleep, 100
    MouseClick, left, X-122, Y-20
    Sleep, 20
}


ProcuraEClicaSkill()
{
    loop, 5
    {
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 300
        }
        ImageSearch, OutX, OutY, 1021, 555, 1168, 881, *85 %a_scriptdir%\spell.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1021, 555, 1168, 881, *85 %a_scriptdir%\spell2.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1026, 601, 1170, 848, *85 %a_scriptdir%\fr.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 300
            MouseClick, left, 939, 664
            Sleep, 30
            break
        }
    }
}

CompraSkills()
{
    Inicio := A_TickCount
    Ativa()
    FSiCount := 0
    DSiCount := 0
    SCiCount := 0
    HMiCount := 0
    WCiCount := 0
    TFiCount := 0
    Click, 943, 359
    Sleep, 300
    AbreSkill()
    Sleep, 300
    ImageSearch, OutX, OutY, 1026, 546, 1161, 595, *40 %a_scriptdir%\buy.png
    if (ErrorLevel = 0)
    {
        Click, 1098, 626
        loop, 3
        {
            ProcuraEClicaSkill()
            DesceUmaPagina()
        }
        loop, 4
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
    ;GeraLog("CompraSkills: " A_TickCount - Inicio)
}

AbreSkill()
{
    ImageSearch, OutX, OutY, 1026, 546, 1161, 595, *40 %a_scriptdir%\buy.png
    if (ErrorLevel = 0)
    {
        return
    }
    else
    {
        Send, 1
        return
    }

}

FechaXzin()
{
    ImageSearch, OutX, OutY, 1111, 501, 1166, 523, *40 %a_scriptdir%\xzin.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, OutX, OutY,
    }
}

FechaSkill()
{
    ImageSearch, OutX, OutY, 709, 524, 778, 599, *40 %a_scriptdir%\carta.png
    if (ErrorLevel = 0)
    {
        Send, 1
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
    FechaAll()
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

FechaAll()
{
    if (SubStr(RetornaText(835, 662, 207, 56), 1, 3)="Col")
    {
        MouseClick, left, 932, 695
    }
    if (SubStr(RetornaText(824, 129, 211, 60), 1, 3)="Opt")
    {
        MouseClick left, 742, 56
    }
    ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 300
        ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, OutX, OutY
            Sleep, 300
        }
    }
    FechaXzin()
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
        if (qntVezesAll < 2)
        {
            All()
            alternado := false
            qntVezesAll++5
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

Pause::Pause,,1

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
