#SingleInstance Force
Process, Priority, , High

#Include FindClick.ahk

DefaultDirs = a_scriptdir


SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Luna"
cont := 0
global comeco := 0
global ultimaVez := 0
global rodouUltimaVez := 0
global tempo := 270
global JanelaAtivaAntes := ""

^F12::Pause

EsperaTempo:
WinGetActiveTitle, JanelaAtivaAntes
WinGetPos, X, Y, W, H,  %JanelaAtivaAntes%
Sleep, 200
Send, ^t
Sleep, 200
MouseMove, 0, 0
Sleep, 1000
ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\pagina.png
if (ErrorLevel = 0)
{
    MouseClick, Middle, X, Y
    Sleep, 1000
    Send, ^w
    Sleep, 2000
    Send, ^w
    Sleep, 15000
    Send, {Pause}
}
loop,
{
    if (A_TickCount - rodouUltimaVez > (tempo*60)*1000)
    {
        GeraLog("Iniciou")
        Goto, start
    }
    GeraLog("Espera o loop " (((((tempo*60)*1000) - (A_TickCount - rodouUltimaVez))/1000)/60)/60)
    Sleep, 300000
}
return

^o::
ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\luna.png


^l::
start:
Send, {Pause}
Sleep, 200
WinGetActiveTitle, JanelaAtivaAntes
WinGetPos, X, Y, W, H,  %JanelaAtivaAntes%
Send, ^t
Sleep, 200
MouseMove, 0, 0
Sleep, 1000
ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\luna.png
if (ErrorLevel = 0)
{
    MouseClick, Middle, X, Y
    Sleep, 1000
    Send, ^w
    Sleep, 2000
    Send, ^w
    Sleep, 15000
}
GeraLog("Iniciou o macro")
rodouUltimaVez := A_TickCount
var1 += %tempo%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("O proximo loop será às " DataFormatada)
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    Gosub, login
    Gosub, EntraBoss
}
return

EsperaMorrer:
Gosub, login
while (!Espera(10, 500))
{
    ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\vs.png
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
        Goto, IniciaBoss
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
                Goto, IniciaBoss
            }
        }
    }
}
goto, EsperaMorrer
return


IniciaBoss:
Gosub, login
GeraLog("Entrou no inicia boss")
Sleep, 500
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
if (ErrorLevel = 0)
{
    Send, {Esc}
    Sleep, 200
    gosub, EntraBoss
    Sleep, 2000
}
ImageSearch, X2, Y2, 0, 0, W, H, *40 %a_scriptdir%\warrior2.png
ImageSearch, Xx, Yy, 0, 0, W, H, *40 %a_scriptdir%\warrior.png
if (ErrorLevel = 0 or X2 != "")
{
    ImageSearch, X, Y, 0, 0, W, H, *80 %a_scriptdir%\abre.png
    while (ErrorLevel = 0)
    {
        Clica(X, Y)
        Sleep, 200
        ImageSearch, X, Y, 0, 0, W, H, *80 %a_scriptdir%\abre.png
        Sleep, 1000
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
        MouseMove, X2, Y2+50
        Loop, 20
        {
            Click, WD
            Sleep, 50
        }
    }

    Sleep, 500
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
    while (ErrorLevel = 0)
    {
        energias := FindClick("/energia.png", "r " Xx-50 " " Yy " " W " " H " e n o100")
        Sort, energias, F ReverseDirection D
        if energias != 0
        {
            Loop, parse, energias, `n, `r
            {
                GeraLog("energia 1")
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                if (A_Index >= 3 or ErrorLevel != 0)
                    break
                X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                Y += 6
                MouseClick, left, X, Y
                Sleep, 2500
                
            }
        }
        energias2 := FindClick("/energia2.png", "r " Xx-50 " " Yy " " W " " H " e n o100")
        Sort, energias2, F ReverseDirection D
        if energias2 != 0
        {
            Loop, parse, energias2, `n, `r
            {
                GeraLog("energia 2")
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
                if (A_Index >= 3 or ErrorLevel != 0)
                    break
                X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                MouseClick, left, X, Y
                Sleep, 2500
            }
        }
        GeraLog("Loop")
        if (A_Index > 10)
        {
            goto, EsperaTempo
            GeraLog("Sem energia todas.")
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\mais.png
    }
    while (!Espera(3, 500))
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
        if (ErrorLevel = 0)
        {
            GeraLog("Entrou no boss")
            Clica(X, Y)
            rodouUltimaVez := A_TickCount
            Sleep, 200
            while (!Espera(3, 500))
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\msgEnergia.png
                if (ErrorLevel = 0)
                {
                    GeraLog("Deu errado, sem energia")
                    Send, {Esc}
                    Sleep, 1000
                    GeraLog("Vai tirar os selecionados")
                    FindClick("/selecionado.png", "r " Xx-50 " " Yy " " W " " H " e o15 Sleep2000")
                    Sleep, 2000
                    FindClick("/selecionado2.png", "r " Xx-50 " " Yy " " W " " H " e o15 Sleep2000")
                    GeraLog("Tirou os selecionados")
                    Sleep, 2000
                    gosub, IniciaBoss
                }
            }
            Goto, EsperaMorrer
        }
    }
}
else
{
    GeraLog("Não encontrou o warrior.")
    goto, EntraBoss
}
return


EntraBoss:
Gosub, login
GeraLog("Entrou no entra boss")
ImageSearch, Xx, Yy, 0, 0, W, H, *40 %a_scriptdir%\ok.png
if (ErrorLevel = 0)
{
    Send, {Esc}
    Sleep, 2000
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
                    goto, IniciaBoss
                }
            }
        }
        break
    }
}
Goto, start
return

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
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\assinar.png
        while (ErrorLevel != 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\assinar.png
            if (A_Index > 500)
            {
                Break
            }
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

ReverseDirection(a1, a2, offset)
{
    return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
}