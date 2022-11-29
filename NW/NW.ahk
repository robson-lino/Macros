#SingleInstance Force
Process, Priority, , High

#Include FindClick.ahk

DefaultDirs = a_scriptdir

Janelas := "New World"
SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window

Pause::Pause



^F5::
SoundBeep, 300, 100
Loop, parse, Janelas, `,
{
    loop,
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H, %A_LoopField%
        loop, 3
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *15 %a_scriptdir%\linha%A_index%.png
            if (ErrorLevel = 0)
            {
                toca(Xlinha, Ylinha, A_index)
            }
        }
    }
}
return


toca(Xlinha, Ylinha, indice)
{
    SoundBeep, 300, 100
    if (indice = 1)
    {
        esquerda := Xlinha-30
        direita := Xlinha+40
    }
    if (indice = 2)
    {
        esquerda := Xlinha-25
        direita := Xlinha+35
    }
    if (false)
    {
        MouseClick, Left, esquerda, Ylinha
        Sleep, 50
        MouseClick, Left, direita, Ylinha+120
    }
    loop,
    {
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\a%A_index%.png
            if (ErrorLevel = 0)
            {
                Send, a
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\s%A_index%.png
            if (ErrorLevel = 0)
            {
                Send, s
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\d%A_index%.png
            if (ErrorLevel = 0)
            {
                Send, d
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\clique%A_index%.png
            if (ErrorLevel = 0)
            {
                Send {LButton down}
                Send {RButton down}
                Send {LButton up}
                Send {RButton up}
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\w%A_index%.png
            if (ErrorLevel = 0)
            {
                Send, w
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+120, *98 %a_scriptdir%\espaco%A_index%.png
            if (ErrorLevel = 0)
            {
                Send, {Space}
                break
            }
        }
    }
}
return


^F3::
SoundBeep, 200, 100
InputBox, distancia, Distancia em ms
InputBox, variacao, variacao do peixe
inicio:
Loop, parse, Janelas, `,
{
    loop,
    {
        Sleep, 300
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H, %A_LoopField%
        loop, 2
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\afk%A_index%.png
            if (ErrorLevel = 0)
            {
                teste := randSleep()-50
                send, {a down}
                sleep, teste
                send, {a up}
                Sleep, randSleep()
                send, {d down}
                sleep, teste
                send, {d up}
                reparar(W, H)
            }
        }
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *40 %a_scriptdir%\mouse.png
        if (ErrorLevel = 0)
        {
            Send, {LButton down}
            Sleep, randSleep()
            Sleep, distancia
            GeraLog("Encheu")
            Send, {LButton up}
            if (esperaFisgar(W, H, variacao))
            {
                puxaCorda(W, H)
            }
        }
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\reparar%A_index%.png
        if (ErrorLevel = 0)
        {
            Send, i
            Sleep, 1000
            Send, {F3}
            GeraLog("Tava com o inv aberto")
            reparar(W, H)
        }
        GeraLog("Terminou")
    }
}
return

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\nwlog.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\nwlog.log
	}
}
return

randSleep()
{
    Random, rand, 60, 140
    return rand
}



esperaFisgar(W, H, variacao)
{
    Sleep, 4000
    while (true)
    {
        loop, 6
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *%variacao% %a_scriptdir%\peixe%A_Index%.png
            if (ErrorLevel = 0)
            {
                GeraLog("Fisgou peixe"A_index)
                return true
            }
        }
        if (A_index > 200)
        {
            GeraLog("Não fisgou")
            return false
        }
    }
}


puxaCorda(W, H)
{
    Send, {LButton down}
    while (true)
    {
        loop, 5
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\vermelho%A_Index%.png
            if (ErrorLevel = 0)
            {
                Send, {LButton up}
                while (true)
                {
                    loop, 3
                    {
                        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *75 %a_scriptdir%\verde%A_index%.png
                        if (ErrorLevel = 0)
                        {
                            Send, {LButton down}
                            break 2
                        }
                        if (isso(W, H))
                            return
                    }
                    if (A_index > 100)
                    {
                        GeraLog("Algo deu errado")
                        return
                    }
                }
            }
            if (isso(W, H))
                return
        }
        if (A_index > 300)
        {
            GeraLog("Algo deu errado")
            return
        }
    }
}

isso(W, H)
{
    loop, 2
    {
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *80 %a_scriptdir%\isso%A_index%.png
        if (ErrorLevel = 0)
        {
            Click, 2
            GeraLog("Isso"A_index)
            return true
        }
        
    }
    ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *40 %a_scriptdir%\f3.png
    if (ErrorLevel = 0)
    {
        Click, 2
        GeraLog("Mouse... que merda"A_index)
        return true
    }
    return false
}

reparar(W, H)
{
    Send, i
    sleep, 1000
    loop, 10
    {
        loop, 3
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\reparar%A_index%.png
            if (ErrorLevel = 0)
            {
                MouseClick, Left, Xlinha, Ylinha
            }
        }
    }
    Sleep, 500
    ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\sim.png
    if (ErrorLevel = 0)
    {
        MouseClick, Left, Xlinha, Ylinha
    }
    Sleep, 500
    Send, i
    Sleep, 1000
    Send, {F3}
    GeraLog("Reparou")
}