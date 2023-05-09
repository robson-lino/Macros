; 0.1.4
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1

#Include, ocr.ahk

DefaultDirs = a_scriptdirs

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
global X, Y, W, H, 
global FSColor := "0x00ACFD"
global DSColor := "0x363636"
global SCColor := "0x00ADFE"
global HMColor := "0x00ADFE"
global WCColor := "0x00ADFE"
global TFColor := "0x00AEFF"
global stage
global stageanterior
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
global Push
global Teste2 := 0
global Pagina := 1
global Aba := 0
global indo := true
global AchouOutX := ""
global AchouOutY := ""



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
Gui Add, Edit, x48 y40 w120 h21 +Number vEdit1, 108830
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
Ativa()
;SetTimer Atualizar, 3000, On, 3
GuiControlGet, ChkMiR
if (ChkMiR)
{
    CheckMir := true
}
else
{
    SetTimer CompraHeroi, 120000, On, 4
}
ClicaEAtualiza()
Return

ClicaEAtualiza()
{
    SetTimer ClicaEAtualiza, off
    Inicio := A_TickCount
    Clica()
    Clica()
    AtualizaStageViaAba()
    CompraHeroiRapido()
    ;AtualizaStage()
    ;if (A_TickCount-iUltimaAtualizada)>5000
    ;{
    ;    AtualizaStageViaConfig()
    ;}
    Clica()
    Clica()
    Atualizar()
    CompraHeroiRapido()
    SetTimer ClicaEAtualiza, 500, ON, 3

}

Clica()
{
    GuiControlGet, ChkHS
    if (!ChkHS)
    {
        FechaAll()
        AttMana()
        Random, rand, 1, 3
        Random, rand2, 1, 3
        if (!CheckMir)
        {
            loop, 2
            {
                FechaColetaRapida()
                MouseClick, Left, 940+rand, 218+rand2
                MouseClick, Left, 925+rand, 254+rand2
                MouseClick, Left, 845+rand, 258+rand2
                MouseClick, Left, 875+rand, 281+rand2
                MouseClick, Left, 818+rand, 298+rand2
                MouseClick, Left, 845+rand, 317+rand2
                MouseClick, Left, 806+rand, 353+rand2
                MouseClick, Left, 842+rand, 374+rand2
                MouseClick, Left, 830+rand, 439+rand2
                MouseClick, Left, 879+rand, 421+rand2
                MouseClick, Left, 903+rand, 477+rand2
                MouseClick, Left, 958+rand, 456+rand2
                MouseClick, Left, 995+rand, 409+rand2
                MouseClick, Left, 1037+rand, 411+rand2
                MouseClick, Left, 1011+rand, 393+rand2
                MouseClick, Left, 1055+rand, 361+rand2
                MouseClick, Left, 1044+rand, 325+rand2
                MouseClick, Left, 1024+rand, 284+rand2
                MouseClick, Left, 1028+rand, 223+rand2
                MouseClick, Left, 945+rand, 251+rand2
                MouseClick, Left, 894+rand, 267+rand2
                FechaColetaRapida()
            }
            
        }
        else
        {
            MouseMove, 940+rand, 218+rand2
            Click, 2
            Click, 2
            Sleep, 30
            Send {LButton down}
            MouseMove, 925+rand, 254+rand2
            MouseMove, 845+rand, 258+rand2
            MouseMove, 875+rand, 281+rand2
            MouseMove, 818+rand, 298+rand2
            MouseMove, 845+rand, 317+rand2
            MouseMove, 806+rand, 353+rand2
            MouseMove, 842+rand, 374+rand2
            MouseMove, 830+rand, 439+rand2
            MouseMove, 879+rand, 421+rand2
            MouseMove, 903+rand, 477+rand2
            MouseMove, 958+rand, 456+rand2
            MouseMove, 995+rand, 409+rand2
            MouseMove, 1037+rand, 411+rand2
            MouseMove, 1011+rand, 393+rand2
            MouseMove, 1055+rand, 361+rand2
            MouseMove, 1044+rand, 325+rand2
            MouseMove, 1024+rand, 284+rand2
            MouseMove, 1028+rand, 223+rand2
            MouseMove, 945+rand, 251+rand2
            MouseMove, 894+rand, 267+rand2
            Send {LButton up}
        }
    }
    else
    {
        
        MouseMove, 1146, 242
        Click, 2
        MouseClick, left, 1146, 242
        loop, 5
        {
            Sleep, 150
            Click, 2
        }
        Sleep, 300
        Send, {LButton down}
        Sleep, 300
        loop, 30
        {
            MouseMove, 735, 222
            MouseMove, 1146, 242
            ImageSearch, OutX, OutY, 857, 681, 888, 712, *30 %a_scriptdir%\azul.png
            if (ErrorLevel = 0)
            {
                MouseClick, left, 932, 695
                VaiProBoss()
                Send, {LButton up}
                Sleep, 150
                MouseClick, left, 932, 695
                MouseMove, 1146, 242
                Click, 2
                MouseClick, left, 1146, 242
                Sleep, 300
                Click, 2
                Sleep, 300
                Send, {LButton down}
                Sleep, 300
            }
        }
        Sleep, 300
        Send, {LButton up}
        Click, 2
        Sleep, 300
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
        Sleep, 150
    }
    else
    {
        return
    }
}


CLicaCompraHeroi()
{
    Loop, 3
    {
        ImageSearch, OutX, OutY, 1021, 602, 1163, 842, *60 %a_scriptdir%\c1.png
        if !ErrorLevel
        {
            MouseClick, left, OutX+1, OutY+3
            Sleep, 100
        }
        ImageSearch, OutX, OutY, 1021, 602, 1163, 842, *60 %a_scriptdir%\c2.png
        if !ErrorLevel
        {
            MouseClick, left, OutX+1, OutY+3
            Sleep, 100
        }
        loop, 2
        {
            ImageSearch, OutX, OutY, 1069, 56, 1171, 242, *60 %a_scriptdir%\fecha.png
            if !ErrorLevel
            {
                MouseClick, left, OutX, OutY
                Sleep, 150
            }
            Sleep, 30
        }
    }
}


CompraHeroiRapido()
{
    Inicio := A_TickCount
    AbreHeroi()
    Sleep, 150
    CLicaCompraHeroi()
    Fechaheroi()
}

CompraHeroi()
{
    Inicio := A_TickCount
    AbreHeroi()
    Sleep, 150
    Loop, 2
    {
        FechaColetaRapida()
        CLicaCompraHeroi()
        DesceUmaPagina()
        CLicaCompraHeroi()
    }
    Fechaheroi()
    Clica()
    Clica()
    Loop, 3
    {
        FechaColetaRapida()
        AbreHeroi()
        CLicaCompraHeroi()
        SobeUmaPagina()
    }
    CLicaCompraHeroi()
    Fechaheroi()
    ;GeraLog("ComprouHerois: " A_TickCount - Inicio)

}

AtualizaStage()
{
    ;Inicio := A_TickCount
    loop, 5
    {
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
    }
    return false
}

^F7::
MsgBox % ProcuraAteAchar(1012, 659, 1165, 817, 100, "prest", 10000)
return

AtualizaStageViaAba()
{
    Inicio := A_TickCount
    Fechou := false
    Achou := false
    AbreSkill()
    FechaColetaRapida()
    if (ProcuraAteAchar(1031, 706, 1155, 758, 100, "prest", 1000))
    {
        MouseClick, left, AchouOutX, AchouOutY
        loop, 10
        {
            FechaColetaRapida()
            stagetemp := RetornaText(765, 692, 146, 52)
            stagetemp := RegExReplace(stagetemp, "\D", "")
            if ((StrLen(stagetemp)=5 or StrLen(stagetemp)=6) and stagetemp is digit)
            {
                stageanterior := stage
                stage := stagetemp
                GuiControl, , TxtStage, %stage%
                loop, 2
                {
                    FechaAll()
                    Sleep, 40
                }
                Fechou := true
                Achou := true
                ;GeraLog("Atualizou via Aba: " A_TickCount - Inicio)
                AttBarraStage()
                FazPrestige()
                iUltimaAtualizada := A_TickCount
                break
            }
        }
        if (!Achou)
        {
            MouseClick, left, 840, 720
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
                    loop, 2
                    {
                        FechaAll()
                        Sleep, 40
                    }
                    Fechou := true
                    ;GeraLog("Atualizou via Info: " A_TickCount - Inicio)
                    AttBarraStage()
                    FazPrestige()
                    iUltimaAtualizada := A_TickCount
                    break
                }
            }
        }
        if (!fechou)
        {
            loop, 4
            {
                FechaAll()
                Sleep, 40
            }
        }
    }
    else
    {
        ;GeraLog("Não achou prest")
        ImageSearch, OutX, OutY, 1014, 53, 1164, 284, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, OutX+15, OutY+25
            Sleep, 200
        }
        SobeUmaPagina()
        AtualizaStageViaAba()
    }
}

Atualizar()
{
    ;Inicio := A_TickCount
    TempoPassado := TempoPassado()
    GuiControl, , txtTempoStage, %TempoPassado%
    FechaAll()
    AtualizaStageViaAba()
    ;AtualizaStage()
    ;if ((A_TickCount-iUltimaAtualizada)>5000)
    ;{
    ;    AtualizaStageViaConfig()
    ;}
    VaiProBoss()
    ClanRaid()
    Presente()
    tempo := A_TickCount - Inicio
    ;GeraLog("Atualizar: " A_TickCount - Inicio)
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
    AtualizaStatusSkillAtiva()
    mana := RegExReplace(RetornaText(677, 714, 175, 74), "\D(?<!\/)", "")
    atual := SubStr(mana, 1, InStr(mana, "/")-1)
    total := SubStr(mana, InStr(mana, "/")+1, 4)
    porcentagem := (atual / total) * 100
    if (porcentagem > 0 and porcentagem <= 100)
    {
        GuiControl, , PrgMana, %porcentagem%
        GuiControl, , TxtMana, %mana%
    }
    if (porcentagem >= 60)
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
    ;GeraLog("AttMana: " A_TickCount - Inicio)
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
    If (FSiCount > 5 OR DSiCount > 5 OR SCiCount > 5 OR HMiCount > 5 OR WCiCount > 5 OR TFiCount > 5)
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
            SetTimer CompraHeroi, 60000, On, 4
        }
        GeraLog("Estava mais de 30 minutos e fez o prestige")
        forcaprestige := true
        FazPrestige()
        TravadoCount++
        
    }
}

RealmenteTacerto()
{
    AtualizaStageViaAba()
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100
    GuiControlGet, Edit1
    GuiControlGet, ChkAbsal
    GuiControlGet, ChkPrestige
    if ((StageProgess > 100 and stage > Edit1 and ChkPrestige)
    or (forcaprestige and ChkPrestige))
    {
        GeraLog("Realmente ta certo")
        return true
    }
    return false
}

FazPrestige()
{
    Inicio := A_TickCount
    aumento_percentual := ((stage - stageanterior) / stageanterior) * 100
    aumento_percentual_media := ((stage - mediaStage) / mediaStage) * 100
    GuiControlGet, Edit1
    GuiControlGet, ChkAbsal
    GuiControlGet, ChkPrestige
    ;if ((StageProgess > 100 and stage > Edit1 and aumento_percentual >= 0 and aumento_percentual <= 0.5 and aumento_percentual_media < 0.7 and ChkPrestige) 
    if ((StageProgess > 100 and stage > Edit1 and ChkPrestige)
    or (forcaprestige and ChkPrestige))
    {
        ;if (!RealmenteTacerto())
        ;    return
        GeraLog(TempoPassado() " no Stage: " stage " - " stageanterior " -config:" Edit1)
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
        Sleep, 500
        ImageSearch, X, Y, 1027, 703, 1159, 764, *90 %a_scriptdir%\prest.png
        while (ErrorLevel)
        {
            if (A_Index > 40)
            {
                return
            }
            SobeUmaPagina()
            Sleep, 1000
            ImageSearch, X, Y, 1027, 703, 1159, 764, *90 %a_scriptdir%\prest.png
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
        CompraSkills()
        CompraReliquia()
        Clica()
        ;GeraLog("Tempo do FazPrestige(): " A_TickCount - Inicio)
        return
    }
    return
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
    Gui, Submit, NoHide
    GuiControlGet, Edit1
    if (Push = 1)
    {
        GuiControlGet, ChkAbsal
        if (ChkAbsal)
        {
            if (stage - Edit1 > 200)
            {
                Mais10 := stage+500
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
            }
            else
            {
                GeraLog("Novo Target: " stage)
                GuiControl, , Edit1, %stage%
            }
        }
        else
        {
            if (stage - Edit1 > 50)
            {
                Mais10 := stage+50
                GeraLog("Novo Target: " Mais10)
                GuiControl, , Edit1, %Mais10%
                return
            }
            else
            {
                GeraLog("Novo Target: " stage)
                GuiControl, , Edit1, %stage%
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
        GeraLog("Deu erro - WTF")
        return true
    }
    return false
}


VaiProBoss()
{
    ImageSearch, X, Y, 1052, 65, 1163, 108, *40 %a_scriptdir%\g.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, X, Y
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
            GeraLog("força prestige, por que estava travado: " stage)         
            forcaprestige := true
        }
    }
}

VaiClicaSkill(X, Y)
{
    MouseClick, left, X, Y
    Sleep, 170
    MouseClick, left, X-122, Y
    Sleep, 170
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
        ImageSearch, OutX, OutY, 1029, 616, 1162, 835, *85 %a_scriptdir%\spell.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1029, 616, 1162, 835, *85 %a_scriptdir%\upgr.png
        if !ErrorLevel
        {
            VaiClicaSkill(OutX, OutY)
        }
        ImageSearch, OutX, OutY, 1029, 616, 1162, 835, *85 %a_scriptdir%\spell2.png
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
    FSiCount := 0
    DSiCount := 0
    SCiCount := 0
    HMiCount := 0
    WCiCount := 0
    TFiCount := 0
    ;Click, 943, 359
    FechaColetaRapida()
    FechaAll()
    Sleep, 300
    AbreSkill()
    Sleep, 300
    ImageSearch, OutX, OutY, 872, 550, 929, 588, *40 %a_scriptdir%\achi.png
    if (ErrorLevel = 0)
    {
        Click, 1098, 626
        loop, 3
        {
            FechaColetaRapida()
            ProcuraEClicaSkill()
            DesceUmaPagina()
        }
        loop, 4
        {
            FechaColetaRapida()
            ProcuraEClicaSkill()
            SobeUmaPagina()
        }
    }
    else
    {
        FechaColetaRapida()
        AbreSkill()
        CompraSkills()
    }
    FechaSkill()
    ;GeraLog("CompraSkills: " A_TickCount - Inicio)
    return
}

AbreSkill()
{
    ImageSearch, OutX, OutY, 872, 550, 929, 588, *40 %a_scriptdir%\achi.png
    if (ErrorLevel = 0)
    {
        return
    }
    else
    {
        Send, 1
        Sleep, 150
        return
    }

}

FechaXzin()
{
    ImageSearch, OutX, OutY, 1111, 501, 1166, 523, *30 %a_scriptdir%\xzin.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, OutX, OutY
    }
}

FechaSkill()
{
    ImageSearch, OutX, OutY, 872, 550, 929, 588, *40 %a_scriptdir%\achi.png
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
    Inicio := A_TickCount
    FechaColetaRapida()
    ImageSearch, OutX, OutY, 857, 681, 888, 712, *30 %a_scriptdir%\azul.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, 932, 695
        Sleep, 200
    }
    ImageSearch, OutX, OutY, 1014, 53, 1164, 284, *60 %a_scriptdir%\fecha.png
    if !ErrorLevel
    {
        MouseClick, left, OutX+15, OutY+25
        Sleep, 200
        ImageSearch, OutX, OutY, 1014, 53, 1164, 284, *60 %a_scriptdir%\fecha.png
        if !ErrorLevel
        {
            MouseClick, left, OutX+15, OutY+25
            Sleep, 200
        }
    }
    ImageSearch, OutX, OutY, 1088, 122, 1172, 196, *60 %a_scriptdir%\FechaAzul.png
    if !ErrorLevel
    {
        MouseClick, left, OutX, OutY
        Sleep, 200
    }
    FechaXzin()
    ;GeraLog("FechaAll: " A_TickCount - Inicio)
}

FechaColetaRapida()
{
    ;Inicio := A_TickCount
    ImageSearch, OutX, OutY, 857, 681, 888, 712, *30 %a_scriptdir%\azul.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, 932, 695
        Sleep, 200
    }
    ;GeraLog("FechaColetaRapida: " A_TickCount - Inicio)
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

F11::Pause,,1

Ativa()
{
    WinActivate BlueStacks
    WinGetPos, X, Y, W, H, BlueStacks
    return
}

Return

SobeUmaPagina()
{
    MouseMove, 892, 600
    Send {LButton down}
    MouseMove, 901, 846, 25
    Sleep, 50
    Send {LButton up}
    Sleep, 50
}

DesceUmaPagina()
{
    MouseMove, 901, 846
    Send {LButton down}
    MouseMove, 892, 600, 25
    Sleep, 50
    Send {LButton up}
    Sleep, 50
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
        ImageSearch, OutX, OutY, 985, 782, 1083, 820, *60 %a_scriptdir%\fig.png
        if (ErrorLevel = 0)
        {
            MouseClick, left, OutX, OutY
            Sleep, 1500
            ImageSearch, OutX, OutY, 964, 589, 1069, 632, *60 %a_scriptdir%\fig2.png
            if (ErrorLevel = 0)
            {
                MouseClick, left, OutX, OutY
                Sleep, 300
                Fight()
            }
            else
            {
                while (TrocaAba())
                {
                    Sleep, 500
                    ImageSearch, OutX, OutY, 964, 589, 1069, 632, *60 %a_scriptdir%\fig2.png
                    if (ErrorLevel = 0)
                    {
                        MouseClick, left, OutX, OutY
                        Sleep, 300
                        Fight()
                        break
                    }
                }

            }
        }
        loop, 2
        {
            FechaAll()
        }
        Sleep, 3000
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
        TrocaPagina()
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


F9::
ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba1.png
    if (ErrorLevel = 0)
    {
        GeraLog("aba1")
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba2.png
    if (ErrorLevel = 0)
    {
        GeraLog("aba2")
    }
    ImageSearch, OutX, OutY, 898, 402, 976, 435, *60 %a_scriptdir%\aba3.png
    if (ErrorLevel = 0)
    {
        GeraLog("aba3")
    }
return