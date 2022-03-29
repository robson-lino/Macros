#SingleInstance Force
Process, Priority, , Highs

#Include FindClick.ahk

DefaultDirs = a_scriptdir

SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Bombcrypto - Perfil 1,Bombcrypto - Perfil 2,Bombcrypto - Perfil 3"
global recompensaAnteriores := {"Bombcrypto - Perfil 1": 0,"Bombcrypto - Perfil 2": 0,"Bombcrypto - Perfil 3": 0}


^b::
GeraLog("Iniciou o macro")
gosub, TrabalhaDescansaSmart
NoAkf:
SetTimer, Verifica, Off
WinGetActiveTitle, JanelaAtivaAntes
MouseGetPos, MousePosX, MousePosY
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    gosub, volta
    recompensa(A_LoopField)
    gosub, hunt
    Sleep, randSleep()
}
Random, esperaloop, ((5*60)*1000), ((10*60)*1000)
WinActivate %JanelaAtivaAntes%
MouseMove, MousePosX, MousePosY
SetTimer, Verifica, 120000
Sleep, esperaloop
goto, NoAkf
return

Verifica:
WinGetActiveTitle, JanelaAtivaAntes
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    gosub, msgerro
    gosub, login
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\newmap.png
    if (ErrorLevel = 0)
    {
        Random, rand, 1, 20
        Random, rand2, 1, 10
        MouseClick, Left, X+rand, Y+rand2
        Sleep, randSleep()
        GeraLog("Novo mapa, sorte em! - " A_LoopField)
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hero.png
    if (ErrorLevel = 0)
    {
        Random, rand, -130, 130
        Random, rand2, -130, 130
        MouseClick, Left, (W/2)+rand, (H/2)+rand2
        Sleep, randSleep()
        GeraLog("Estava com a seleção aberta - " A_LoopField)
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x.png
    if (ErrorLevel = 0)
    {
        Random, rand, 1, 10
        Random, rand2, 1, 10
        MouseClick, Left, X+rand, Y+rand2
        Sleep, randSleep()+200
        Random, rand, -130, 130
        Random, rand2, -130, 130
        MouseClick, Left, (W/2)+rand, (H/2)+rand2
        GeraLog("Estava com o Heroes aberto - " A_LoopField)
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x2.png
    if (ErrorLevel = 0)
    {
        Random, rand, 1, 10
        Random, rand2, 1, 10
        MouseClick, Left, X+rand, Y+rand2
        Sleep, randSleep()+200
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
    if (ErrorLevel = 0)
    {
        Random, rand, 1, 20
        Random, rand2, 1, 20
        MouseClick, Left, X+rand, Y+rand2
        GeraLog("Tava na tela do TresureHunt - " A_LoopField)
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\percent.png
    if (ErrorLevel = 0)
    {
        GeraLog("Tava travado no login - " A_LoopField)
        Send, ^{F5}
        Sleep, 15000
        gosub, login
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\okwin.png
    if (ErrorLevel = 0)
    {
        GeraLog("deu erro no bomb - " A_LoopField)
        Random, rand, 1, 20
        Random, rand2, 1, 20
        MouseClick, Left, X+rand, Y+rand2
        Sleep, randSleep()
        Send, ^{F5}
        Sleep, 15000
        gosub, login
    }
    WinActivate app
    WinGetPos, X, Y, W, H,  app
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\semnet.png
    if (ErrorLevel = 0)
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%  
        GeraLog("tava sem net - " A_LoopField)
        Send, ^{F5}
        Sleep, 15000
        gosub, login
    }
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%    
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\aceito.png
    if (ErrorLevel = 0)
    {
        MouseClick, Left, X, Y
        Sleep, randSleep()
        Sleep, randSleep()
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\aceito2.png
        if (ErrorLevel = 0)
        {
            MouseClick, Left, X, Y
            Sleep, randSleep()
        }
    }

}
WinActivate %JanelaAtivaAntes%
return

Pause::Pause

abreSelecao:
PixelSearch, X, Y, 0, 0, W, H, 0xC2E0F7, 1, Fast
if (ErrorLevel = 0)
{
    Random, rand, -133, 133
    Random, rand2, 0, 1
    If (rand2)
        X += rand
    else
        X -= rand
    X := X + 133
    MouseClick, Left, X, Y
    Sleep, randSleep()
}
return

abreHero:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hero.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
    Sleep, 500
    ImageSearch, X, Y, 0, 0, W, H, *1 %a_scriptdir%\coin.png
    While (ErrorLevel != 0)
    {
        if (A_Index > 1000)
        {
            Break
        }
        ImageSearch, X, Y, 0, 0, W, H, *1 %a_scriptdir%\coin.png
    }
    Sleep, randSleep()
}
return

fechaHero:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 10
    Random, rand2, 1, 10
    MouseClick, Left, X+rand, Y+rand2
    Sleep, randSleep()+200
    Random, rand, -130, 130
    Random, rand2, -130, 130
    MouseClick, Left, (W/2)+rand, (H/2)+rand2
}
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 10
    Random, rand2, 1, 10
    MouseClick, Left, X+rand, Y+rand2
    Sleep, randSleep()+200
    Random, rand, -130, 130
    Random, rand2, -130, 130
    MouseClick, Left, (W/2)+rand, (H/2)+rand2
}
return

randSleep()
{
    Random, rand, 230, 300
    return rand
}


TrabalhaDescansaAll:
Loop, parse, Janelas, `,
{    
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    gosub, Verifica
    gosub, abreSelecao
    Sleep, randSleep()
    gosub, abreHero
    if !AbriuHero(W, H)
    {
        goto, TrabalhaDescansaAll
    }
    Sleep, randSleep()
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\all.png
    if (ErrorLevel = 0)
    {
        Random, rand, -5, 10
        Random, rand2, -5, 10
        MouseClick, Left, X+rand, Y+rand2
        Sleep, randSleep()
        GeraLog("Colocou para trabalhar na janela " A_LoopField)
    }
    Sleep, randSleep()
    gosub, fechahero
}
SetTimer, TrabalhaDescansaAll, Off
Random, looptrabalha, ((55*60)*1000), ((65*60)*1000)    
var1 := ""  
redondo := Round((looptrabalha/1000)/60)
var1 += %redondo%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("Loop trabalho está agora em " redondo " minutos `, e o proximo loop será às " DataFormatada)
SetTimer, TrabalhaDescansaAll, %looptrabalha%
return

TrabalhaDescansaSmart:
Loop, parse, Janelas, `,
{    
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    gosub, Verifica
    gosub, abreSelecao
    Sleep, randSleep()
    gosub, abreHero
    if !AbriuHero(W, H)
    {
        goto, TrabalhaDescansaSmart
    }
    Loop, 3
    {
        Sleep := randSleep()-200
        Random, rand, 0, 25
        Random, rand2, 0, 8
        rand := rand + 90

        Random, randv, 0, 25
        Random, randv2, 0, 8
        randv := randv + 130
        CoordMode, Mouse, Screen
        FindClick("\vermelho.png", "e x+" randv " y-" randv2 " Sleep" Sleep)
        FindClick("\verde.png", "e x+" rand " y-" rand2 " Sleep" Sleep)
        CoordMode, Mouse, Window
        loop, 16
        {
            MouseMove, W/2, H/2
            Click, WD 
            Sleep, 100
        }
	    Sleep, randSleep()
        if (A_Index >= 3)
        {
            Sleep, randSleep()
            CoordMode, Mouse, Screen
            FindClick(a_scriptdir "\vermelho.png", "e x+" randv " y-" randv2 " Sleep" Sleep)
            FindClick(a_scriptdir "\verde.png", "e x+" rand " y-" rand2 " Sleep" Sleep)
            CoordMode, Mouse, Window
        }
        Sleep, randSleep()
    }
    GeraLog("Colocou para trabalhar na janela " A_LoopField)
    gosub, fechahero
}
SetTimer, TrabalhaDescansaSmart, Off
Random, looptrabalha, ((10*60)*1000), ((25*60)*1000)    
var1 := ""  
redondo := Round((looptrabalha/1000)/60)
var1 += %redondo%, Minutes
FormatTime, DataFormatada, %var1%, time
GeraLog("Loop trabalho está agora em " redondo " minutos `, e o proximo loop será às " DataFormatada)
SetTimer, TrabalhaDescansaSmart, %looptrabalha%
return


AbriuHero(W, H)
{
    Sleep, randSleep()
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x.png
    if (ErrorLevel = 0)
    {
        return true
    }
    else
    {
        return false
    }
}

hunt:
Sleep, randSleep()
Sleep, randSleep()
Sleep, randSleep()
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
    Sleep, randSleep()
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}
return

login:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
if (ErrorLevel = 0)
{
    Send, ^{F5}
    Sleep, 7000
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
    while (ErrorLevel != 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect.png
        if (A_Index > 500)
        {
            return
        }
    }
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect2.png
    while (ErrorLevel != 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\connect2.png
        if (A_Index > 500)
        {
            return
        }
    }
    MouseClick, Left, X+rand, Y+rand2
    WinWait, MetaMask Notification,, 60
    if ErrorLevel
    {
        Send, ^{F5}
        Sleep, 15000
        gosub, login
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
        Random, rand, 1, 20
        Random, rand2, 1, 20
        MouseClick, Left, X+rand, Y+rand2
    }
    GeraLog("Realizado o login - " A_LoopField)
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
    while (ErrorLevel != 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
        if (ErrorLevel = 0)
        {
            Random, rand, 1, 20
            Random, rand2, 1, 20
            MouseClick, Left, X+rand, Y+rand2
            Send, ^{F5}
            Sleep, 5000
            gosub, login
        }        
        if (A_Index > 500)
        {
            Break
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\hunt.png
    }
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}
return


msgerro:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}
Sleep, randSleep()
gosub, login
return

volta:
Sleep, randSleep()
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\volta.png
if (ErrorLevel = 0)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}
return

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\logbomb.log
	if ErrorLevel
	{
		MsgBox, Falha na criação do log.
		ExitApp
	}
}
return


^o::
Loop, parse, Janelas, `,
{
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    recompensa(A_LoopField)
}
For key, value in recompensaAnteriores
    MsgBox %key% = %value%
return

recompensa(janela)
{
    GeraLog("Verifica recompensa.")
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    WinGetPos, XJ, YJ, W, H, %janela%
    Sleep, 1000
    ImageSearch, X, Y, XJ, YJ, XJ+W, YJ+H, *40 %a_scriptdir%\bau.png
    if (ErrorLevel = 0)
    {
        Random, rand, 1, 20
        Random, rand2, 1, 20
        MouseClick, Left, X+rand, Y+rand2
        Sleep, 500
        ImageSearch, X, Y, XJ, YJ, XJ+W, YJ+H, *40 %a_scriptdir%\balance.png
        if (ErrorLevel = 0)
        {
            Sleep, 1000
            X2 := X+105
            Y2 := Y+60
            X := X-15
            Y := Y+20
            MouseMove, X2, Y2
            Sleep, 200
            mantem := clipboard
            clipboard := ""
            RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --scale-factor 0.8 --whitelist 0123456789`, --clipboard, , Hide
            recompensa := StrReplace(StrReplace(Clipboard, "`r`n"), ",",".")
            if (recompensa = "<Error>")
            {
                Sleep, 1000
                RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --scale-factor 0.8 --whitelist 0123456789`,  --clipboard , , Hide
                recompensa := StrReplace(StrReplace(Clipboard, "`r`n"), ",",".")
            }
            clipboard := mantem
            CoordMode, Pixel, Window
            CoordMode, Mouse, Window
            FormatTime, DataFormatada, D1 T0
            recompensaAnterior := recompensaAnteriores[(janela)]
            if (recompensaAnterior = 0)
            {
                recompensaAnteriores[(janela)] := recompensa
            }
            else
            {
                recompensaAtual := Round(recompensa - recompensaAnterior, 4)
                if recompensaAtual > 0
                {
                    FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
                    if ErrorLevel
                    {
                        FileAppend, %DataFormatada%`,%janela%`,%recompensaAtual%`n, %a_scriptdir%\recompensas.csv
                    }
                    recompensaAnteriores[(janela)] := recompensa
                }
            }
        }
        Sleep, 500
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\x2.png
        if (ErrorLevel = 0)
        {
            Random, rand, 1, 10
            Random, rand2, 1, 10
            MouseClick, Left, X+rand, Y+rand2
        }
    }
}