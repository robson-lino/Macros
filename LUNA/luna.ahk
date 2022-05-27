#SingleInstance Force
Process, Priority, , High

#Include FindClick.ahk

DefaultDirs = a_scriptdir


SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Luna Rush - Perfil 1,Luna Rush - Perfil 2"
JanelasNovaGuia := "Nova guia - Perfil 1,Nova guia - Perfil 2"
cont := 0
global comeco := 0
global ultimaVez := 0
global rodouUltimaVez := 0
global tempo := 270
global JanelaAtivaAntes := ""
global recompensaAnterior := ""
global qntNaoCarregou := 0
global Xarmacao := 0
global Yarmacao := 0

PrintScreen::Pause

SecToHHMMSS(Sec) {
	OldFormat := A_FormatFloat
	SetFormat, Float, 02.0
	Hrs  := Sec//3600/1
	Min := Mod(Sec//60, 60)/1
	Sec := Mod(Sec,60)/1
	SetFormat, Float, %OldFormat%
	Return (Hrs ? Hrs ":" : "") Min ":" Sec
}

^F11::
rodouUltimaVez -= ((10*60)*1000)
goto, EsperaTempo
return

^F12::
rodouUltimaVez += ((10*60)*1000)
goto, EsperaTempo
return

^F10::
tempo := 60
rodouUltimaVez := A_TickCount
SetTimer EsperaTempo, 300000
goto, EsperaTempo
return

loading:
while (Espera(1.5, 150))
{
    ImageSearch, X, Y, Xarmacao-100, Yarmacao-100, Xarmacao, Yarmacao, *40 %a_scriptdir%\loading.png
    if (ErrorLevel = 0)
    {
        nachou := 0
        while (true)
        {
            Sleep, 10
            ImageSearch, X, Y, Xarmacao-100, Yarmacao-100, Xarmacao, Yarmacao, *40 %a_scriptdir%\loading.png
            if (ErrorLevel = 0)
            {
                nachou := 0
            }
            else
            {
                nachou += 1
                if (A_Index > 150)
                    return
            }
            if (nachou = 10)
            {
                return
            }
        }
    }
}
return

EsperaTempo:
if (A_TickCount - rodouUltimaVez > (tempo*60)*1000)
{
    GeraLog("Iniciou")
    Goto, start
}
var1 := ""
minutos := (((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000/60
var1 += %minutos%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("Espera " SecToHHMMSS((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000) " que será em " DataFormatada)
return


^l::
start:
qntNaoCarregou := 0
SetTimer EsperaTempo, off
Send, {Pause}
WinGetActiveTitle, JanelaQueEstavaAntes
Loop, parse, JanelasNovaGuia, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    GeraLog("Abrindo a pagina do " A_LoopField)
    Sleep, 2000
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\luna.png
    if (ErrorLevel = 0)
    {
        MouseClick, left, X, Y
        Sleep, 5000
    }
}
Loop, parse, Janelas, `,
{
    recompensaAnterior := ""
    GeraLog("Iniciou o macro " A_LoopField)
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    JanelaQueEstaNaPassada := A_LoopField
    Sleep, 30000
    Gosub, login
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\armacao.png
    if (ErrorLevel = 0)
    {
        Xarmacao := X
        Yarmacao := Y
    }
    else
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\armacao2.png
        if (ErrorLevel = 0)
        {
            Xarmacao := X
            Yarmacao := Y
        }
    }
    MouseMove, Xarmacao, Yarmacao
    while (true)
    {
        WinActivate %JanelaQueEstaNaPassada%
        WinGetPos, X, Y, W, H,  %JanelaQueEstaNaPassada%
        SoundBeep, 200, 200
        GeraLog("EntraBoss do " JanelaQueEstaNaPassada)
        if (EntraBoss(W, H))
            break
        if (A_index > 50)
            Goto, start
    }
    while (true)
    {
        WinActivate %JanelaQueEstaNaPassada%
        WinGetPos, X, Y, W, H,  %JanelaQueEstaNaPassada%
        SoundBeep, 200, 200
        GeraLog("IniciaBoss do " JanelaQueEstaNaPassada)
        if (!IniciaBoss(W, H, JanelaQueEstaNaPassada))
            break
        if (A_index > 50)
            Goto, start
    }
}
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    GeraLog("Fecha a pagina do " A_LoopField)
    Sleep, 3000
    Send, ^t
    Sleep, 3000
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\lunarush.png
    if (ErrorLevel = 0)
    {
        MouseClick, m, X, Y
    }
    Sleep, 3000
}
rodouUltimaVez := A_TickCount
tempo := 60
var1 += %tempo%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("O proximo loop será às " DataFormatada)
WinActivate %JanelaQueEstavaAntes%
Sleep, 2000
Send, {Pause}
SetTimer EsperaTempo, 300000
return

Verifica:
GeraLog("Verifica")
Gosub, login
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
if (ErrorLevel = 0)
{
    Send, {Esc}
    Sleep, 2000
}
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x.png
if (ErrorLevel = 0)
{
    Send, {Esc}
    Sleep, 500
}
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\defeat.png
if (ErrorLevel = 0)
{
    GeraLog("Perdeu...")
    Sleep, 3000
    Clica(X, Y)
    Sleep, 3000
    return
}
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\victory.png
if (ErrorLevel = 0)
{
    GeraLog("Venceu...")
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\tap.png
    if (ErrorLevel = 0)
    {
        Clica(X, Y)
    }
    while (Espera(10, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mlus.png
        if (ErrorLevel = 0)
        {
            Sleep, 500
            Clica(X, Y)
            Sleep, 3000
            return
        }
    }
}
ImageSearch, X, Y, 0, 0, W, H, *15 %a_scriptdir%\carregamento.png
if (ErrorLevel = 0)
{
    carregou := false
    while (Espera(60, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *15 %a_scriptdir%\carregamento.png
        if (ErrorLevel = 0)
        {
            if (mod(A_Index, 20) = 0)
                GeraLog("Carregando...")
        }
        else
        {
            carregou := true
            break
        }
    }
    if (!carregou)
    {
        Send, {F5}
        Sleep, 5000
        qntNaoCarregou += 1
        GeraLog("Não carregou, tentativa: " qntNaoCarregou)
        if (qntNaoCarregou > 2)
        {
            tempo := 30
            Goto, EsperaTempo
        }
    }
}
return

EsperaMorrer:
Gosub, login
GeraLog("Espera morrer")
Sleep, 4000
ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\vs.png
if (ErrorLevel = 0)
{
    while (Espera(120, 1000))
    {
        ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\vs.png
        if (ErrorLevel = 0)
        {
            if (mod(A_index, 40) = 0)
            {
                GeraLog("Lutando...")
            }
        }
        else
        {
            entra := false
            break
        }
        entra := true
    }
    if (entra)
    {
        GeraLog("Travou no lutando")
        Send, {F5}
        Sleep, 5000
    }
}
Sleep, 2000
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\defeat.png
if (ErrorLevel = 0)
{
    GeraLog("Perdeu...")
    Sleep, 3000
    Clica(X, Y)
    Sleep, 3000
    return
}
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\victory.png
if (ErrorLevel = 0)
{
    GeraLog("Venceu...")
    Sleep, 1000
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\tap.png
    if (ErrorLevel = 0)
    {
        Clica(X, Y)
    }
    while (Espera(10, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mlus.png
        if (ErrorLevel = 0)
        {
            Sleep, 500
            Clica(X, Y)
            Sleep, 3000
            return
        }
    }
}
return

IniciaBoss(W, H, janela)
{
    Gosub, Verifica
    GeraLog("Entrou no inicia boss")
    Sleep, 500
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
    if (ErrorLevel = 0)
    {
        Send, {Esc}
        Sleep, 200
        while (true)
        {
            if (EntraBoss(W, H))
                break
        }
        Sleep, 2000
    }
    ImageSearch, X2, Y2, 0, 0, W, H, *40 %a_scriptdir%\warrior2.png
    ImageSearch, Xx, Yy, 0, 0, W, H, *40 %a_scriptdir%\warrior.png
    if (ErrorLevel = 0 or X2 != "")
    {
        recompensa(W, H, janela)
        ImageSearch, X, Y, 0, 0, W, H, *80 %a_scriptdir%\abre.png
        while (ErrorLevel = 0)
        {
            Clica(X, Y)
            Sleep, 200
            ImageSearch, X, Y, 0, 0, W, H, *80 %a_scriptdir%\abre.png
        }
        if (X2 = "")
        {
            MouseMove, Xx, Yy+50
            Loop, 20
            {
                Click, WD
                Sleep, 50
            }
        }
        Else
        {
            Xx := X2
            Yy := Y2
            MouseMove, X2, Y2+50
            Loop, 20
            {
                Click, WD
                Sleep, 50
            }
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
        while (ErrorLevel = 0)
        {
            energias3 := FindClick("/energia3.png", "r a" Xx-50 "," Yy ",-" W/2 ",-150 e n o100")
            Sort, energias3, F ReverseDirection D
            if energias3 != 0
            {
                Loop, parse, energias3, `n, `r
                {
                    if A_index > 3
                        break
                    GeraLog("Energia 3")
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                    if (ErrorLevel != 0)
                        break
                    X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                    Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                    Random, rand, 1, 25
                    Random, rand2, 0, 1
                    if (rand2 = 0)
                    {
                        MouseClick, left, X+rand, Y
                    }
                    Else
                    {
                        MouseClick, left, X-rand, Y
                    }
                    Gosub, loading
                }
            }
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
            if (energias3 = 0 or (energias3 != 0 and ErrorLevel = 0))
            {
                energias2 := FindClick("/energia2.png", "r a" Xx-50 "," Yy ",-" W/2 ",-150 e n o100")
                Sort, energias2, F ReverseDirection D
                if energias2 != 0
                {
                    Loop, parse, energias2, `n, `r
                    {
                        if A_index > 3
                            break
                        GeraLog("Energia 2")
                        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                        if (ErrorLevel != 0)
                            break
                        X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                        Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                        Random, rand, 1, 25
                        Random, rand2, 0, 1
                        if (rand2 = 0)
                        {
                            MouseClick, left, X+rand, Y
                        }
                        Else
                        {
                            MouseClick, left, X-rand, Y
                        }
                        Gosub, loading
                    }
                }
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                if (energias2 = 0 (energias2 != 0 and ErrorLevel = 0))
                {
                    energias1 := FindClick("/energia1.png", "r a" Xx-50 "," Yy ",-" W/2 ",-150 e n o100")
                    Sort, energias1, F ReverseDirection D
                    if energias1 != 0
                    {
                        Loop, parse, energias1, `n, `r
                        {
                            if A_index > 3
                                break
                            GeraLog("Energia 1")
                            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                            if (ErrorLevel != 0)
                                break
                            X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                            Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                            Random, rand, 1, 25
                            Random, rand2, 0, 1
                            if (rand2 = 0)
                            {
                                MouseClick, left, X+rand, Y
                            }
                            Else
                            {
                                MouseClick, left, X-rand, Y
                            }
                            Gosub, loading
                        }
                    }
                }
            }
            if (energias3 >= 1 or energias2 >= 1 or energias1 >= 1)
                break
            if (A_Index > 10)
            {
                GeraLog("Acabou as energias")
                return false
            }
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
        }
        Sleep 1000
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
        if (ErrorLevel = 0)
        {
            GeraLog("Entrou no boss")
            Clica(X, Y)
            rodouUltimaVez := A_TickCount
            while (Espera(3, 300))
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\msgEnergia.png
                if (ErrorLevel = 0)
                {
                    GeraLog("Deu errado, sem energia")
                    Send, {Esc}
                    Sleep, 200
                    MouseMove, Xx, Yy+50
                    Loop, 20
                    {
                        Click, WD
                        Sleep, 50
                    }
                    Sleep, 200
                    GeraLog("Vai tirar os selecionados")
                    selecionados := FindClick("/selecionado.png", "r a" Xx-50 "," Yy ",-" W/2 ",-150 e n o55")
                    if selecionados != 0
                    {
                        Loop, parse, selecionados, `n, `r
                        {
                            GeraLog("Selecionado 1")
                            X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                            Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)+7
                            Random, rand, 1, 25
                            Random, rand2, 0, 1
                            if (rand2 = 0)
                            {
                                MouseClick, left, X+rand, Y
                            }
                            Else
                            {
                                MouseClick, left, X-rand, Y
                            }
                            gosub, loading
                        }
                    }
                    return true
                }
            }
            gosub, EsperaMorrer
        }
    }
    else
    {
        GeraLog("Não encontrou o warrior.")
        while (true)
        {
            if (EntraBoss(W, H))
                break
        }
    }
    return true
}



EntraBoss(W, H)
{
    GeraLog("Entrou no entra boss")
    Gosub, Verifica
    ImageSearch, X, Y, 0, 0, W, H, *5 %a_scriptdir%\volta.png
    while (ErrorLevel = 0)
    {
        Clica(X, Y)
        Sleep, 1000
        ImageSearch, X, Y, 0, 0, W, H, *5 %a_scriptdir%\volta.png
    }
    while (Espera(3, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            while (Espera(5, 500))
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
                if (ErrorLevel = 0)
                {
                    Clica(X, Y)
                }
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\caraBoss.png
                if (ErrorLevel = 0)
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\verde.png
                    if (ErrorLevel = 0)
                    {
                        Clica(X, Y)
                        Sleep, 1000
                        return true
                    }
                }
            }
            break
        }
    }
    return false
}

login:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
if (ErrorLevel = 0)
{
    Clica(X, Y)
    WinWait, MetaMask Notification,, 5
    WinActivate, MetaMask Notification
    if ErrorLevel
    {
        reload()
        goto, login
    }
    else
    {
        while (true)
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\assinar.png
            if (ErrorLevel = 0)
                break
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\assinar2.png
            if (ErrorLevel = 0)
                break
            if (A_Index > 500)
                Break
        }
        Clica(X, Y)
        Sleep, 6000
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
        while (ErrorLevel != 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
            if (A_Index > 100 or ErrorLevel = 0)
            {
                Send, ^{F5}
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
                While (ErrorLevel != 0)
                {
                    if (A_Index > 100)
                        break
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
                }
                goto, login
            }
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
        }
        Sleep, 200
        GeraLog("Fez o login")
    }
}
return

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\logluna.log
}
return

Clica(X, Y)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}

reload()
{
    Send, ^{F5}
    Sleep, 1000
    Send, ^r
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
    While (ErrorLevel != 0)
    {
        if (A_Index > 150)
            break
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
    }
}
return

Espera(seg, margem)
{
    if (comeco = 0 or (A_TickCount-ultimaVez) > margem)
        comeco := A_TickCount
    ultimaVez := A_TickCount
    if (A_TickCount-comeco > (seg*1000))
    {
        comeco := 0
        return false
    }
    return true
}


^F7::
GeraLog("Iniciou somente o recompensa")
recompensaAnterior := ""
Loop, 
{
    WinGetActiveTitle, JanelaAtivaAntes
    WinGetPos, X, Y, W, H, %JanelaAtivaAntes%
    recompensa(W, H, JanelaAtivaAntes)
    Sleep, 1000
}

recompensa(W, H, janela)
{
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\rmlus.png
    if (ErrorLevel = 0)
    {
        X2 := X+80
        Y2 := Y+15
        X := X+24
        Y := Y-0
        mantem := clipboard
        clipboard := ""
        RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --whitelist 0123456789. --clipboard, , Hide
        recompensa := StrReplace(Clipboard, "`r`n")
        if (recompensa = "<Error>")
        {
            RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --whitelist 0123456789. --clipboard, , Hide
            recompensa := StrReplace(Clipboard, "`r`n")
        }
        clipboard := mantem
        CoordMode, Pixel, Window
        CoordMode, Mouse, Window
        FormatTime, DataFormatada, D1 T0
        if (recompensaAnterior = "")
        {
            recompensaAnterior := recompensa
        }
        else
        {
            recompensaAtual := round(recompensa - recompensaAnterior, 2)
            GeraLog(recompensaAtual)
            if (recompensaAtual > 0)
            {
                FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
                if ErrorLevel
                {
                    FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
                }
            }
            recompensaAnterior := recompensa
        }
    }
}

ReverseDirection(a1, a2, offset)
{
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}