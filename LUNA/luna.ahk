#SingleInstance Force
#MaxThreadsPerHotkey 3
Process, Priority, , High

#Include FindClick.ahk

DefaultDirs = a_scriptdir


SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Luna Rush - Perfil 1,Luna Rush - Perfil 2"
cont := 0
global comeco := 0
global ultimaVez := 0
global rodouUltimaVez := 0
global tempo := 270
global JanelaAtivaAntes := ""
global recompensaAnterior := ""

^F12::Pause

^F10::
rodouUltimaVez -= ((60*60)*1000)
GeraLog("Espera o loop " (((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000)/60)/60)
return

^F11::
rodouUltimaVez += ((60*60)*1000)
GeraLog("Espera o loop " (((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000)/60)/60)
return

^F9::
tempo := 60
rodouUltimaVez := A_TickCount
GeraLog("Espera o loop " (((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000)/60)/60)
SetTimer EsperaTempo, 5000
return



EsperaTempo:
if (A_TickCount - rodouUltimaVez > (tempo*60)*1000)
{
    GeraLog("Iniciou")
    Goto, start
}
GeraLog("Espera o loop " (((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000)/60)/60)
return


^l::
start:
SetTimer EsperaTempo, off
Send, {Pause}
Loop, parse, Janelas, `,
{
    recompensaAnterior := ""
    GeraLog("Iniciou o macro " A_LoopField)
    Sleep, 2000
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    Gosub, login
    while (true)
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%
        SoundBeep, 200, 200
        GeraLog("EntraBoss do " A_LoopField)
        if (EntraBoss(W, H))
            break
    }
    while (true)
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%
        SoundBeep, 200, 200
        GeraLog("IniciaBoss do " A_LoopField)
        if (!IniciaBoss(W, H, A_LoopField))
            break
    }
}
rodouUltimaVez := A_TickCount
var1 += %tempo%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("O proximo loop será às " DataFormatada)
Send, {Pause}
SetTimer EsperaTempo, 60000
return


EsperaMorrer:
Gosub, login
while (!Espera(5, 500))
{
    ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\vs.png
    if (ErrorLevel = 0)
    {
        while (ErrorLevel = 0)
        {
            MouseMove, X, Y
            if (A_index = 3)
            {
                GeraLog("Lutando...")
                Clica(X, Y)
            }
            Sleep, 100
            ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\vs.png
        }
        while (!Espera(5, 500))
        {
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
                while (!Espera(3, 500))
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
        }
    }
}
return


IniciaBoss(W, H, janela)
{
    Gosub, login
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
        Sleep, 1000
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
            energias2 := FindClick("/energia2.png", "r " Xx-50 " " Yy " " W " " H " e n o100")
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
                    MouseClick, left, X, Y
                    Sleep, 2500
                }
            }
            if energias2 >= 1
                break
            if (A_Index > 10)
            {
                GeraLog("Acabou as energias")
                return false
            }
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
        }
        while (!Espera(3, 100))
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
            if (ErrorLevel = 0)
            {
                GeraLog("Entrou no boss")
                Clica(X, Y)
                rodouUltimaVez := A_TickCount
                while (!Espera(3, 100))
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\msgEnergia.png
                    if (ErrorLevel = 0)
                    {
                        GeraLog("Deu errado, sem energia")
                        Send, {Esc}
                        Sleep, 200
                        GeraLog("Vai tirar os selecionados")
                        selecionados := FindClick("/selecionado.png", "r " Xx-50 " " Yy " " W " " H " n e o45")
                        if selecionados != 0
                        {
                            Loop, parse, selecionados, `n, `r
                            {
                                GeraLog("Selecionado 1")
                                X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                                Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)+7
                                MouseClick, left, X, Y
                                Sleep, 2500
                            }
                        }
                        return true
                    }
                }
                gosub, EsperaMorrer
            }
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
    Gosub, login
    GeraLog("Entrou no entra boss")
    ImageSearch, Xx, Yy, 0, 0, W, H, *40 %a_scriptdir%\ok.png
    if (ErrorLevel = 0)
    {
        Send, {Esc}
        Sleep, 2000
    }
    ImageSearch, Xx, Yy, 0, 0, W, H, *40 %a_scriptdir%\x.png
    if (ErrorLevel = 0)
    {
        Send, {Esc}
        Sleep, 500
    }
    ImageSearch, X, Y, 0, 0, W, H, *5 %a_scriptdir%\volta.png
    while (ErrorLevel = 0)
    {
        Clica(X, Y)
        Sleep, 1000
        ImageSearch, X, Y, 0, 0, W, H, *5 %a_scriptdir%\volta.png
    }
    while (!Espera(3, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            while (!Espera(5, 500))
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
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\logluna.txt
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
        return true
    }
    return false
}

recompensa(W, H, janela)
{
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\rmlus.png
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
        recompensaAtual := recompensa - recompensaAnterior
        FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
        if ErrorLevel
        {
            FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
        }
        recompensaAnterior := recompensa
    }
}

ReverseDirection(a1, a2, offset)
{
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}