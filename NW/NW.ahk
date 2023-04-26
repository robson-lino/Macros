#SingleInstance Force
Process, Priority, , High
SetWorkingDir %A_ScriptDir%
#MaxThreads 1

DefaultDirs = a_scriptdir

Janelas := "New World"
SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window

global qnt := 0
global qntInicial := 0
global distancia := 0

global total := 0
global raros := 0

global TickInicial := A_TickCount
global peixeseg := 0

Pause::Pause


F6::
GeraLog("Distancia alterada para " distancia)
distancia += 30
return

F7::
GeraLog("Distancia alterada para " distancia)
distancia -= 30
return

^F5::
SoundBeep, 300, 100
Loop, parse, Janelas, `,
{
    loop,
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H, %A_LoopField%
        loop, 4
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
    GeraLog(A_index)
    if (indice = 1)
    {
        esquerda := Xlinha-30
        direita := Xlinha+40
    }
    if (indice = 2)
    {
        esquerda := Xlinha-40
        direita := Xlinha+55
    }
    if (indice = 4)
    {
        esquerda := Xlinha-20
        direita := Xlinha+45
    }
    if (false)
    {
        MouseClick, Left, esquerda, Ylinha
        Sleep, 50
        MouseClick, Left, direita, Ylinha+175
    }
    loop,
    {
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\a.png
            if (ErrorLevel = 0)
            {
                Send, a
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\s.png
            if (ErrorLevel = 0)
            {
                Send, s
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\d.png
            if (ErrorLevel = 0)
            {
                Send, d
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\clique.png
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
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\w.png
            if (ErrorLevel = 0)
            {
                Send, w
                break
            }
        }
        loop, 1
        {
            ImageSearch, Xnota, Ynota, esquerda, Ylinha, direita, Ylinha+175, *50, *TransBlack %a_scriptdir%\espaco.png
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
Gui Add, Button, gParar x104 y72 w80 h23, Parar
Gui Add, Button, gIniciar x24 y72 w80 h23, Iniciar
Gui Add, Slider, vforca x0 y0 w28 h221 +Vertical Invert Range1-1950, 50
Gui Add, Text, vTxtTotal x32 y8 w121 h23 +0x200, Total:
Gui Add, Text, vTxtPeixeseg x32 y40 w120 h23 +0x200, Peixes/s:
Gui Add, Button, gSalvar x64 y160 w80 h23, Salvar

Gui Show, w197 h225, Macro NW
WinActivate Macro NW
return

Salvar:
Gui, Submit, NoHide
distancia := forca
Return

Parar:
Reload
Return

Iniciar:
Gui, Submit, NoHide
if (forca = "")
{
    MsgBox, "Preencha"
}
else
{
    distancia := forca
    GuiControl, , TxtTotal, Total: 0
    GuiControl, , TxtRaros, Raros: 0
    global TickInicial := A_TickCount
    global peixeseg := 0
    Goto, inicio
}
Return

inicio:
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H, %A_LoopField%
    Verfica(W, H)
    Sleep, 100
    Send, {ESC}
    Sleep, 100
    MouseMove, W/2, H/2, 10
    Sleep, 100
    Send, {ESC}
    Sleep, 500
    MouseMove, 0, 200, 100, R
    Sleep, 100
    procura:
    Verfica(W, H)
    if (!Mira(W, H, "point", 4, "tacerto"))
    {
        GeraLog("Deu erro a procura")
        MouseMove, -30, 30, 100, R
        Goto, procura
    }
    qntIncial := qnt
    loop,
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H, %A_LoopField%
        Verfica(W, H)
        loop, 3
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\afk%A_index%.png
            if (ErrorLevel = 0)
            {
                teste := randSleep()-50
                GeraLog("Achou afk")
                send, {a down}
                sleep, teste
                send, {a up}
                Sleep, randSleep()
                send, {d down}
                sleep, teste
                send, {d up}
                GeraLog("Fez afk")
                reparar(W, H)
            }
        }
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *40 %a_scriptdir%\mouse.png
        if (ErrorLevel = 0)
        {
            GeraLog("Vai encher")
            Send, {LButton down}
            Sleep, randSleep()
            Sleep, distancia
            GeraLog("Encheu")
            Send, {LButton up}
            if (esperaFisgar(W, H, 112))
            {
                puxaCorda(W, H)
            }
        }
        GeraLog("Terminou")
        if (!Mira(W, H, "point", 4, "tacerto"))
        {
            GeraLog("Deu erro a procura")
            MouseMove, -30, 30, 100, R
            Goto, procura
        }
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
        loop, 7
        {
            ImageSearch, Xlinha, Ylinha, 0, 100, W, H/2, *%variacao%, *TransBlack %a_scriptdir%\peixe%A_Index%.png
            if (ErrorLevel = 0)
            {
                GeraLog("Fisgou peixe"A_index)
                return true
            }
        }
        if (A_index > 100)
        {
            GeraLog("Não fisgou")
            return false
        }
    }
}


puxaCorda(W, H)
{
    Send, {LButton down}
    qntvezes := 0
    while (true)
    {
        loop, 4
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H/2, *70 %a_scriptdir%\vermelho%A_Index%.png
            if (ErrorLevel = 0)
            {
                Send, {LButton up}
                qntvezes += 1
                while (true)
                {
                    loop, 4
                    {
                        ImageSearch, Xlinha, Ylinha, 0, 0, W, H/2, *90, *TransBlack %a_scriptdir%\verde%A_index%.png
                        if (ErrorLevel = 0)
                        {
                            Send, {LButton down}
                            break 2
                        }
                        if (qntvezes > 2)
                        {
                            if (isso(W, H))
                                return
                        }
                    }
                    if (A_index > 50)
                    {
                        GeraLog("Algo deu errado no verde")
                        return
                    }
                }
            }
            if (qntvezes > 2 or A_index > 30)
            {
                if (isso(W, H))
                    return
            }
        }
        if (A_index > 130)
        {
            GeraLog("Algo deu errado no geral")
            Send, {LButton up}
            return
        }
    }
}

Isso(W, H)
{

    loop, 3
    {
        ImageSearch, Xlinha, Ylinha, (W/2)-100, H/2, W-300, H-150, *82 %a_scriptdir%\isso%A_index%.png
        if (ErrorLevel = 0)
        {
            Send, {LButton up}
            Click, 2
            total += 1
            GuiControl, , TxtTotal, Total: %total%
            GeraLog("Isso"A_index)
            return true
        }
    }
    return false
}

reparar(W, H)
{
    Send, i
    sleep, 1000
    MouseClick, left, 413, 800
    Sleep, 500
    MouseClick, left, 736, 511
    Sleep, 500
    Send, i
    Sleep, 1000
    Send, {F3}
    GeraLog("Reparou")
    Sleep, 500
    MouseMove, 0, 70, 100, R
}

^J::
Loop, parse, Janelas, `,
{  
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H, %A_LoopField%
    MouseMove, (W/2)-150, H/2+150
    Sleep, 1000
    MouseMove, W-500, H-150
}
return

Mira(W, H, imgProcura, qnt, imgCerto)
{
    Loop, 10
    {
        ImageSearch, Xmira, Ymira, 0, 0, W, 250, *25, *TransBlack %a_scriptdir%\mira.png
        loop, %qnt%
        {
            ImageSearch, Xpoint, Ypoint, 0, 0, W, 250, *70 %a_scriptdir%\%imgProcura%%A_index%.png
            if (ErrorLevel = 0)
            {
                break
            }
        }
        mover := Xpoint-Xmira
        if (mover > 0)
            mover -= 2
        MouseMove, (mover/2), 0, 25, R
        Sleep, 30
        ImageSearch, Xpoint, Ypoint, 0, 0, W, 250, *30 %a_scriptdir%\%imgCerto%.png
        if (ErrorLevel = 0)
        {
            GeraLog("Mirou")
            Send, {NumpadAdd down}
            MouseMove, 0, 30, 100, R
            Send, {NumpadAdd up}
            return true
        }
    }
    return false
}

^R::
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H, %A_LoopField%
    GeraLog("Começou")
    Loop, 
    {
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *53, *TransBlack %a_scriptdir%\simbolo.png
        if (ErrorLevel = 0)
        {
            GeraLog("Achou")
            Sleep, 1000
        }
    }
}
return



procuraEVira(W, H, cor)
{
    if (qnt > 100)
    {
        Sleep, 100
        Send, {ESC}
        Sleep, 100
        MouseMove, W/2, H/2, 10
        Sleep, 100
        Send, {ESC}
        Sleep, 1000
        qnt := 0
    }
    loop, 3
    {
        ImageSearch, Xlinha, Ylinha, 0, 0, W, 150, *85 %a_scriptdir%\pointcerto%A_index%.png
        if (ErrorLevel = 0)
        {
            GeraLog("Já está certo.")
            return true
        }
    }
    Loop, 10
    {
        loop, 2
        {
            ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *80 %a_scriptdir%\point%A_index%.png
            if (ErrorLevel = 0)
            {
                GeraLog("Achou o point"A_index)
                loop,
                {
                    MouseMove, 10, 0, 100, R
                    loop, 3
                    {
                        ImageSearch, Xlinha, Ylinha, 0, 0, W, 150, *85 %a_scriptdir%\pointcerto%A_index%.png
                        if (ErrorLevel = 0)
                        {
                            GeraLog("Mirou certo")
                            raros += 1
                            GuiControl, , TxtRaros, Raros: %raros%
                            MouseMove, 0, 30, 100, R
                            return true
                        }
                    }
                    MouseMove, 1, 0, 100, R
                    qnt += 1
                    if (A_index > 300)
                    {
                        GeraLog("Algo deu errado")
                        return false
                    }
                }
            }
        }
        MouseMove, -1, 0, 100, R
    }
}

Verfica(W, H)
{
    SegundosAtual := (A_TickCount - TickInicial)/1000.0
    PeixesPorSegundos := Format("{:.2f}", SegundosAtual/total)
    GuiControl, , TxtPeixeseg, Peixes/s: %PeixesPorSegundos%.
    loop, 4
    {
        ImageSearch, Xlinha, Ylinha, 0, 0, W, H/2, *90, *TransBlack %a_scriptdir%\verde%A_index%.png
        if (ErrorLevel = 0)
        {
            puxaCorda(W, H)
            return
        }
    }
    ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\menu.png
    if (ErrorLevel = 0)
    {
        Send, {ESC}
        GeraLog("Tava com o ESC")
        Sleep, 1000
    }
    ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *70 %a_scriptdir%\inventario.png
    if (ErrorLevel = 0)
    {
        Sleep, 500
        Send, i
        GeraLog("Tava com inventario aberto")
        Send, {F3}
        Sleep, 1000
    }
    ImageSearch, Xlinha, Ylinha, 0, 0, W, H, *40 %a_scriptdir%\mouse.png
    if (ErrorLevel != 0)
    {
        Send, {F3}
        GeraLog("Não tava com a vara")
        Sleep, 1000
    }
}


Clica(X, Y)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}