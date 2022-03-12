#SingleInstance Force
Process, Priority, , High

#Include FindClick.ahk

DefaultDirs = a_scriptdir


SendMode Event
SetKeyDelay 40, 50
CoordMode, Pixel, Window
CoordMode, Mouse, Window
Janelas := "Space Crypto"
cont := 0

global menosDe15 := false
global tempo := 5
global qntFasesPassadas := 0
global listaQntNaves := "14/15,13/15,12/15,11/15,10/15,9/15,8/15,7/15,6/15,5/15,4/15,3/15,2/15,1/15,0/15"
global MuitoBurroVelho := "16/15,15/15"
global UltimaRecompensa := A_TickCount
global bossAtual := 1
global noTrabalha := false
global noVerifica := false
global ColocouNessaFase := false

end_time := A_TickCount + 180000

^F11::
GeraLog("Iniciou o macro")
gosub, luta
SetTimer, Verifica, 2000
return

^F9::
GeraLog("Iniciou o macro sem o trabalha")
InputBox, OutputVar, Loop, Quantos minutos a cada verificada`?
tempo := OutputVar
SetTimer, VerificaPraComecar, Off
gosub, VerificaPraComecar
AtualizaLoop()
SetTimer, Verifica, 2000
return

luta:
Loop, parse, Janelas, `,
{
    SetTimer, VerificaPraComecar, Off
    WinActivate %A_LoopField%
    WinGetPos, X, Y, W, H,  %A_LoopField%
    gosub, Verifica
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
    if (ErrorLevel = 0)
    {
        if (!TrocaNewest(W, H, 0))
        {
            TrocaNewest(W, H, 0)
        }
        EsperaProcessing(W, H)
        TrabalhaBurro(W, H)
    }
}
AtualizaLoop()
return


AntAkf:
if (!noTrabalha and !noVerifica and tempo > 3)
{
    Loop, parse, Janelas, `,
    {
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%
        end_time := A_TickCount + 180000
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
        if (ErrorLevel = 0)
        {
            MouseMove, W/2, H/2
            Loop, 39
            {
                Click, WD
                Sleep, 50
            }
            Click, WU, 1000
            GeraLog("AntiAKF")
            gosub, VaiBaseVolta
        }
    }
}
return

Verifica:
Loop, parse, Janelas, `,
{
    if (!noTrabalha)
    {
        Thread, NoTimers, False
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\logo.png
        while (ErrorLevel = 0)
        {
            if (A_Index > 120)
            {
                GeraLog("Travado no logo inicial")
                Send, ^r
                Sleep, 7000
                goto, login
            }
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\logo.png
        }
        gosub, Recompensa
        gosub, login
        if ((A_TickCount - UltimaRecompensa) > 1800000)
        {
            UltimaRecompensa := A_TickCount
            GeraLog("Provavelmente estava travado: " UltimaRecompensa " tick atual: " A_TickCount)
            Send, ^t
            Sleep, 1000
            ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\pagina.png
            if (ErrorLevel = 0)
            {
                MouseClick, Middle, X, Y
                Sleep, 1000
                Send, ^w
                Sleep, 2000
                Send, ^w
                Sleep, 1000
            }
            reload()
            gosub, login
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\okwin.png
        if (ErrorLevel = 0)
        {
            MouseClick, Left, X, Y
            Sleep, randSleep()
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\sairpagina.png
        if (ErrorLevel = 0)
        {
            GeraLog("Provavelmente estava travado no sair da pagina")
            Send, ^t
            Sleep, 1000
            ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\pagina.png
            if (ErrorLevel = 0)
            {
                MouseClick, Middle, X, Y
                Sleep, 1000
                Send, ^w
                Sleep, 2000
                Send, ^w
            }
            reload()
            gosub, login
        }
        WinActivate play
        WinGetPos, X, Y, W, H,  play
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\semnet.png
        if (ErrorLevel = 0)
        {
            GeraLog("sem net")
            reload()
            gosub, login
        }
        WinActivate %A_LoopField%
        WinGetPos, X, Y, W, H,  %A_LoopField%
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
        if (ErrorLevel = 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\00.png
            if (ErrorLevel != 0)
            {
                ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\boss1.png
                if (ErrorLevel != 0)
                {
                    if (!TrocaNewest(W, H, 0))
                    {
                        TrocaNewest(W, H, 0)
                    }
                    GeraLog("Tava no boss acima do 1, coloca novas naves e inicia o boss.")
                    TrabalhaBurro(W, H)
                    Return
                }
                else
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\remove.png
                    if (ErrorLevel = 0)
                    {
                        GeraLog("Tira tudo pra descansar")
                        TiraTudo(W, H)
                        AtualizaLoop()
                    }
                }
            }
            else
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\remove.png
                if (ErrorLevel = 0)
                {
                    GeraLog("Tira tudo pra descansar")
                    TiraTudo(W, H)
                    AtualizaLoop()
                }
            }
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\close.png
        if (ErrorLevel = 0)
        {
            GeraLog("error popup")
            Clica(X, Y)
            reload()
            gosub, login
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ok.png
        if (ErrorLevel = 0)
        {
            GeraLog("error title")
            Clica(X, Y)
            reload()
            gosub, login
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\telapreta.png
        if (ErrorLevel = 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\telapreta.png
            while (ErrorLevel = 0)
            {
                if (A_Index > 200)
                {
                    GeraLog("erro tela preta")
                    Clica(X, Y)
                    reload()
                    gosub, login
                }
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\telapreta.png
            }
        }

        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\lose.png
        if (ErrorLevel = 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\confirm.png
            if (ErrorLevel = 0)
            {
                Clica(X, Y)
                Sleep, 3000
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\volta.png
                if (ErrorLevel = 0)
                {
                    GeraLog("Perdeu no boss " bossAtual)
                    Clica(X, Y)
                    EsperaProcessing(W, H)
                    TiraTudo(W, H)
                    end_time := A_TickCount + 180000
                }
            }
            AtualizaLoop()
        }
        if (!menosDe15 or qntFasesPassadas >= 2)
        {
            if (VoltaPraColocaMais())
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\volta.png
                if (ErrorLevel = 0)
                {
                    GeraLog("Voltou durante a batalha")
                    Clica(X, Y)
                    EsperaProcessing(W, H)
                }
            }
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
        if (ErrorLevel != 0)
        {
            Clica(W/2, H/2)
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
            if (ErrorLevel = 0)
            {
                Clica(X, Y)
                EsperaProcessing(W, H)
                Sleep, randSleep()
            }
            if bossAtual in 4,9,14,19
            {
                if (!ColocouNessaFase)
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\volta.png
                    if (ErrorLevel = 0)
                    {
                        GeraLog("Voltou pra colocar na base")
                        Clica(X, Y)
                        EsperaProcessing(W, H)
                    }
                    ColocaBase("addbase", 7)
                }
            }
        }
        if (A_tickcount > end_time)
        {
            Gosub, AntAkf
        }
    }
    else
    {
        GeraLog("Rodou o verifica dentro do trabalha.")
    }
}
return

login:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\logo.png
while (ErrorLevel = 0)
{    
    if (A_Index > 120)
    {
        GeraLog("Travado no logo inicial")
        Send, ^r
        Sleep, 7000
        goto, login
    }
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\logo.png
}
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
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\play.png
        while (ErrorLevel != 0)
        {
            ImageSearch, X2, Y2, 0, 0, W, H, *40 %a_scriptdir%\close.png
            if (ErrorLevel = 0)
            {
                reload()
                goto, login
            }
            if (A_Index > 100)
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
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\play.png
        }
        Clica(X, Y)
        EsperaProcessing(W, H)
        Sleep, 3000
        MouseMove, W/2, H/2
        Loop, 39
        {
            Click, WD
            Sleep, 50
        }
        GeraLog("Fez o login")
        end_time := A_TickCount + 180000
        AtualizaLoop()
    }

}
return

Pause::Pause

TrocaNewest(W, H, bypass)
{
    if (bossAtual <= 10 and bypass = 0 or bypass = 1)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\newest.png
        if (ErrorLevel = 0)
        {
            Sleep, randSleep()
            MouseClick, left, X, Y
            Sleep, randSleep()
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\minammo.png
            if (ErrorLevel = 0)
            {
                MouseClick, left, X, Y
                Sleep, randSleep()
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\minammo2.png
            if (ErrorLevel != 0)
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\maxammo2.png
                if (ErrorLevel = 0)
                {
                    Sleep, randSleep()
                    MouseClick, left, X, Y
                    Sleep, randSleep()
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\minammo.png
                    if (ErrorLevel = 0)
                    {
                        MouseClick, left, X, Y
                        Sleep, randSleep()
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\minammo2.png
                    if (ErrorLevel != 0)
                    {
                        Return false
                    }
                    return true
                }
                Return false
            }
            return true
        }
    }
    if (bossAtual > 10 and bypass = 0 or bypass = 2)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\newest.png
        if (ErrorLevel = 0)
        {
            Sleep, randSleep()
            MouseClick, left, X, Y
            Sleep, randSleep()
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\maxammo.png
            if (ErrorLevel = 0)
            {
                MouseClick, left, X, Y
                Sleep, randSleep()
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\maxammo2.png
            if (ErrorLevel != 0)
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\minammo2.png
                if (ErrorLevel = 0)
                {
                    Sleep, randSleep()
                    MouseClick, left, X, Y
                    Sleep, randSleep()
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\maxammo.png
                    if (ErrorLevel = 0)
                    {
                        MouseClick, left, X, Y
                        Sleep, randSleep()
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                else
                {
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\maxammo2.png
                    if (ErrorLevel != 0)
                    {
                        Return false
                    }
                    return true
                }
                Return false
            }
            return true
        }
    }
   
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

VaiBaseVolta:
WinActivate Space Crypto
WinGetPos, X, Y, W, H,  Space Crypto   
Thread, NoTimers 
GeraLog("Entrou no VaiBaseVolta")
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\base.png
if (ErrorLevel = 0)
{
    Clica(X, Y)
    EsperaProcessing(W, H)
    Sleep, 2000
    loop, 20
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            EsperaProcessing(W, H)
        }
    }
    Sleep, 2000
    end_time := A_TickCount + 180000
}
Thread, NoTimers, False
gosub, Verifica
return

EsperaProcessing(W, H)
{
    Thread, NoTimers
    Loop, 10
    {
        ImageSearch, X, Y, 0, 0, W, H, *100 %a_scriptdir%\processing.png
        while (ErrorLevel = 0)
        {
            MouseMove, X, Y
            if (A_Index > 50)
            {
                Break
            }
            ImageSearch, X, Y, 0, 0, W, H, *100 %a_scriptdir%\processing.png
        }
    }
    Thread, NoTimers, False
}
return

TrabalhaBurro(W, H)
{
    Thread, NoTimers
    GeraLog("Entrou no trabalha")
    noTrabalha := true
    DesceuSeguidas := 0
    Desceu := 0
    end_time := A_TickCount + 180000
    menosDe15 := false
    colocou1 := 0
    primeiraVez15menos := false
    AcabouOs80 := false
    EsperaProcessing(W, H)
    voltou:
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
    if (ErrorLevel = 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\15.png
        if (ErrorLevel != 0)
        {
            ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\anterior.png
            if (ErrorLevel = 0)
            {
                DesceuSeguidas := 0
                MouseClick, left, X, Y
                Sleep, randSleep()
                ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\anterior.png
                if (ErrorLevel = 0)
                {
                    MouseClick, left, X, Y
                    Sleep, randSleep()
                }
                MouseMove, W/2, H/2
                Loop, 4
                {
                    Click, WD
                    Sleep, 50
                }
                Loop, 1
                {
                    Click, WU, 300
                    Sleep, 150
                }
                Sleep, randSleep()
            }
            MouseMove, W/2, H/2
            Loop, 10
            {
                Click, WD
                Sleep, 50
            }
            Loop, 4
            {
                Click, WU, 300
                Sleep, 150
            }
        }
        else
        {
            GeraLog("Time full")
        }
        ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\10percent.png
        while (ErrorLevel = 0)
        {
            FindClick("/10percent.png", "x+92 y-10 o20 Stay1")
            Sleep, 650
            GeraLog("Tirou nave com Menos de 10% de ammo")
            ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\10percent.png
        }
        TrocaNewest(W, H, 0)
        Sleep, randSleep()
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\15.png
        while (ErrorLevel != 0)
        {
            Sleep, 150
            if (!AcabouOs80)
            {
                print := "80"
                Xscale := 210
                Yscale := 50
            }
            else
            {
                print := "fight"
                Xscale := 1
                Yscale := 1
            }
            if bossAtual in 10,15,20
            {
                print := "fight"
                Xscale := 1
                Yscale := 1
            }
            naves := FindClick("/" print ".png", "r Space Crypto a+400,+200,-300 Count1 n o80")
            if (naves > 0)
            {
                colocou1 += 1
                GeraLog("Colocou 1 nave pra trabalhar - " print)
                FindClick("/" print ".png", "r Space Crypto x" Xscale " y" Yscale " a+400,+200,-300 o80 Stay1")
            }
            else
            {
                if (DesceuSeguidas > 10)
                {
                    ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\proxima.png
                    if (ErrorLevel = 0)
                    {
                        DesceuSeguidas := 0
                        MouseClick, left, X, Y
                        Sleep, randSleep()
                        MouseMove, W/2, H/2
                        Loop, 4
                        {
                            Click, WD
                            Sleep, 50
                        }
                        Sleep, randSleep()
                        Loop, 2
                        {
                            Click, WU, 300
                            Sleep, 150
                        }
                        Sleep, 500
                    }
                    else
                    {
                        if (AcabouOs80)
                        {
                            ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\00.png
                            if (ErrorLevel != 0)
                            {
                                ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\boss1.png
                                if (ErrorLevel = 0)
                                {

                                    TiraTudo(W, H)
                                    noTrabalha := false
                                    Thread, NoTimers, False
                                    Return
                                }
                                else
                                {
                                    Thread, NoTimers, False
                                    GeraLog("Menos de 15.")
                                    menosDe15 := true
                                    break
                                }
                            }    
                            else
                            {
                                Thread, NoTimers, False
                                TiraTudo(W, H)
                                noTrabalha := false
                                Return
                            }
                        }
                        else
                        {
                            AcabouOs80 := true
                            goto, voltou
                        }
                    }
                }
                else
                {
                    MouseMove, W/2, H/2
                    Click, WD, 37
                    Desceu += 1
                    if (mod(Desceu, 2) = 0)
                    {
                        Click, WD, 2
                    } 
                    Sleep, 70
                    DesceuSeguidas += 1
                }
            }
            If (colocou1 > 16)
            {
                colocou1 := 0
                DesceuSeguidas := 0
                MouseClick, left, X, Y
                Sleep, randSleep()
                MouseMove, W/2, H/2
                Loop, 4
                {
                    Click, WD
                    Sleep, 50
                }
                Sleep, randSleep()
                Loop, 2
                {
                    Click, WU, 300
                    Sleep, 150
                }
                Sleep, 250
            }
            
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\15.png
        }
        Sleep, randSleep()
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\boss.png
        {
            Clica(X, Y)
            GeraLog("Clicou pra lutar")
            Sleep, 3000
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\confirm.png
            if (ErrorLevel = 0)
            {
                Clica(X, Y)
            }
        }
        noTrabalha := false
        Thread, NoTimers, False
    }
    noTrabalha := false
    Thread, NoTimers, False
}
noTrabalha := false
return

TiraTudo(W, H)
{
    Thread, NoTimers
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\remove.png
    while (ErrorLevel = 0)
    {
        FindClick("/remove.png", "r Space Crypto o40 Stay1 Sleep700")
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\remove.png
    }
    Thread, NoTimers, False
    bossAtual = 1
    AtualizaLoop()
    end_time := A_TickCount + 180000
    Sleep, 500
    TiraTudoBase(W, H)
    ColocaBase("l", 1)
    ColocaBase("sr", 6)
    ColocaBase("r", 7)
}



VerificaPraComecar:
if (!noTrabalha)
{
    Thread, NoTimers
    noVerifica := true
    cont := 0
    end_time := A_TickCount + 180000
    gosub, Verifica
    DesceuVerifica := 0
    GeraLog("VerificaPraComecar")
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
    if (ErrorLevel = 0)
    {

        gosub, VaiBaseVolta
        Sleep, 2000
        if (!TrocaNewest(W, H, 2))
        {
            GeraLog("Não conseguiu trocar o newest")
            TrocaNewest(W, H, 2)
        } 
        MouseMove, W/2, H/2
        Loop, 10
        {
            Click, WD
            Sleep, 50
        }
        Loop, 7
        {
            Click, WU, 300
            Sleep, 150
        }
        Sleep, 300
        cont := 0
        loop,
        {
            ImageSearch, X, Y, 0, 0, W, H, *80 %a_scriptdir%\reparar.png
            if (ErrorLevel = 0)
            {
                MouseClick, left, X, Y
                Sleep, 1000
                ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\yes.png
                if (ErrorLevel = 0)
                {
                    cont += 1
                    GeraLog("Reparou uma nave")
                    MouseClick, left, X, Y
                    FormatTime, DataFormatada, D1 T0
	                FileAppend, 00:00:00 01/01/9999`,REPARO`,X`,-10`n, %a_scriptdir%\recompensas.csv
                    Sleep, 3000
                }
            }
            cont := cont + FindClick("/80.png", "Count1 n o40")
            if (cont >= 15)
            {
                GeraLog("Tinha " cont ", bota pra trabalhar")
                Thread, NoTimers, False
                noVerifica := false
                goto, luta
            }
            MouseMove, W/2, H/2
            Click, WD, 38
            if A_Index in 3,6,9,12,15
            {
                Click, WD, 2
            }
            DesceuVerifica += 1
            if (DesceuVerifica > 9)
            {
                ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\proxima.png
                if (ErrorLevel = 0)
                {
                    DesceuVerifica := 0
                    MouseClick, left, X, Y
                    Sleep, randSleep()
                    MouseClick, left, X, Y
                    Sleep, 2000
                    MouseMove, W/2, H/2
                    Loop, 10
                    {
                        Click, WD
                        Sleep, 50
                    }
                    Sleep, 200
                    Loop, 4
                    {
                        Click, WU, 300
                        Sleep, 150
                    }   
                    Sleep, 500
                }
                else
                {
                    break
                }
            }
            Sleep, 1000
        }
        Thread, NoTimers, False
        GeraLog("Só tinha " cont " não coloca pra trabalhar.")
    
    }
    Thread, NoTimers, False
    noVerifica := false
    AtualizaLoop()
}
return


AtualizaLoop()
{
    SetTimer, VerificaPraComecar, Off
    var1 := ""
    var1 += %tempo%, Minutes
    FormatTime, DataFormatada, %var1%, time
    GeraLog("Loop trabalho está agora em " tempo " minutos`, e o proximo loop será às " DataFormatada)
    SetTimer, VerificaPraComecar, % tempo*60000
}


Recompensa:
ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\victory.png
if (ErrorLevel = 0)
{
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\reward.png
    while (ErrorLevel != 0)
    {
        If (A_index > 200)
            return
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\reward.png
    }
    Sleep, 5000
    jack := FindClick("/quebrada.png", "Count1 n o40")
    if (jack = 0)
        jack := "0.5x"
    if (jack = 1)
        jack := "1x"
    if (jack = 2)
        jack := "2x"
    if (jack = 3)
    jack := "100x"
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    Sleep, randSleep()
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\reward.png
    X2 := X+140
    Y2 := Y+40
    X := X-60
    Y := Y-40
    MouseClick, left, X, Y
    MouseClick, left, X2, Y2
    MouseMove, W/2, H/2
    mantem := clipboard
    clipboard := ""
    RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --whitelist 0123456789./ --clipboard, , Hide
    recompensa := subStr(StrReplace(StrReplace(Clipboard, "`r`n"), ":"), 1, InStr(StrReplace(StrReplace(Clipboard, "`r`n"), ":"), " ")-1)
    if (recompensa = "<Error>")
    {
        MouseClick, left, W/2, H/2
        RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --whitelist 0123456789./ --clipboard, , Hide
        recompensa := subStr(StrReplace(StrReplace(Clipboard, "`r`n"), ":"),1, InStr(StrReplace(StrReplace(Clipboard, "`r`n"), ":"), " ")-1)
    }
    clipboard := mantem
    CoordMode, Pixel, Window
    CoordMode, Mouse, Window
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada%`,%jack%`,%bossAtual%`,%recompensa%`n, %a_scriptdir%\recompensas.csv
	if ErrorLevel
	{
		FileAppend, %DataFormatada%`,%jack%`,%bossAtual%`,%recompensa%`n, %a_scriptdir%\recompensas.csv
	}
    Sleep, randSleep()
    ImageSearch, X, Y, 0, 0, W, H, *20 %a_scriptdir%\azul.png
    Clica(X, Y)
    qntFasesPassadas += 1
    ColocouNessaFase := false
    bossAtual += 1
    SetTimer, VerificaPraComecar, Off
    UltimaRecompensa := A_TickCount
    end_time := A_TickCount + 180000
    Sleep, 6000
}
return

Clica(X, Y)
{
    Random, rand, 1, 20
    Random, rand2, 1, 20
    MouseClick, Left, X+rand, Y+rand2
}

randSleep()
{
    Random, rand, 230, 300
    return rand
}

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\spacelog.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\spacelog.log
	}
}
return

^q::
WinActivate Space Crypto
WinGetPos, X, Y, W, H,  Space Crypto
TiraTudo(W, H)
return

^o::
WinActivate Space Crypto
WinGetPos, X, Y, W, H,  Space Crypto
loop,
{
    ImageSearch, X, Y, W/2, 0, W, H, *100 %a_scriptdir%\remove2.png
    if (ErrorLevel = 0)
    {
        MouseMove, X, Y
    }
}
return 

TiraTudoBase(W, H)
{
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
    if (ErrorLevel = 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\base.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            EsperaProcessing(W, H)
            Sleep, 2000
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
            if (ErrorLevel = 0)
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\base.png
                if (ErrorLevel = 0)
                {
                    Clica(X, Y)
                    EsperaProcessing(W, H)
                    Sleep, 2000
                }
            }
        }
        Thread, NoTimers
        ImageSearch, X, Y, W/2, 0, W, H, *100 %a_scriptdir%\remove2.png
        if (ErrorLevel = 0)
        {
            while (ErrorLevel = 0)
            {
                MouseClick, Left, X, Y
                Sleep, 1500
                ImageSearch, X, Y, W/2, 0, W, H, *100 %a_scriptdir%\remove2.png
            }
            MouseMove, 1500, 300
            Sleep, 50
            Click, WD, 50
            Sleep, 700
            ImageSearch, X, Y, W/2, 0, W, H, *100 %a_scriptdir%\remove2.png
            while (ErrorLevel = 0)
            {
                MouseClick, Left, X, Y
                Sleep, 1500
                ImageSearch, X, Y, W/2, 0, W, H, *100 %a_scriptdir%\remove2.png
            }
        }
        Thread, NoTimers, False
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            EsperaProcessing(W, H)
        }
        Sleep, 2000
    }
}

ColocaBase(raridade, qnt)
{
    WinActivate Space Crypto
    WinGetPos, X, Y, W, H,  Space Crypto
    WinGet, PID, PID, Space Crypto
    GeraLog("Entrou no Coloca nave na base")
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
    if (ErrorLevel = 0)
    {
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\base.png
        if (ErrorLevel = 0)
        {
            Clica(X, Y)
            EsperaProcessing(W, H)
            Sleep, 2000
            ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\ouro.png
            if (ErrorLevel = 0)
            {
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\base.png
                if (ErrorLevel = 0)
                {
                    Clica(X, Y)
                    EsperaProcessing(W, H)
                    Sleep, 2000
                }
            }
        }
        colocou := 0
        DesceuSeguidas := 0
        Desceu := 0
        noTrabalha := true
        NaoDesceu = true
        ColocouNessaFase := true
        AtualizaLoop()
        MouseMove, W/2, H/2
        Loop, 10
        {
            Click, WD
            Sleep, 50
        }
        Sleep, randSleep()
        Loop, 3
        {
            Click, WU, 300
            Sleep, 150
        }
        Sleep, 1500
        while (colocou < qnt)
        {
            ImageSearch, X, Y, 0, 0, W, H, *30 %a_scriptdir%\addbasedark.png
            if (ErrorLevel = 0)
            {
                noTrabalha := false
                ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
                if (ErrorLevel = 0)
                {
                    Clica(X, Y)
                    EsperaProcessing(W, H)
                }
                Sleep, 2000
                GeraLog("Entrou para colocar as naves " raridade " mas não tinha mais espaço.")
                return false
            }
            if (!TrocaNewest(W, H, 1))
            {
                TrocaNewest(W, H, 1)
            }  
            naves := 0
            cords := FindClick("/" raridade ".png", "r Space Crypto a+400,+200,-300 n o80")
            Process, Priority, %PID%, High     
            while cords != 0
            {
                ImageSearch, X, Y, 0, 0, W, H, *30 %a_scriptdir%\addbasedark.png
                if (ErrorLevel = 0)
                {
                    noTrabalha := false
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
                    if (ErrorLevel = 0)
                    {
                        Clica(X, Y)
                        EsperaProcessing(W, H)
                    }
                    Sleep, 2000
                    GeraLog("Entrou para colocar as naves " raridade " mas não tinha mais espaço.")
                    return false
                }
                Loop, parse, cords, `n, `r
                {
                    NaoDesceu := true
                    X := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)
                    Y := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)
                    MouseMove, X, Y
                    X2 := SubStr(A_LoopField, 1, InStr(A_LoopField, ",")-1)+501
                    Y2 := SubStr(A_LoopField, InStr(A_LoopField, ",")+1, 90)+100
                    if raridade in l,sr,c,r
                    {
                        MouseClick, left, X+435, Y
                    }
                    else
                    {
                        MouseClick, left, X, Y
                    }
                    ;FindClick("/addbase.png", "r Space Crypto a" X "," Y "," X2 "," Y2 " o40")
                    Sleep, randSleep()
                    MouseMove, 1500, 300
                    Sleep, 50
                    Click, WD, 50
                    Sleep, 700
                    if (raridade = "l")
                    {
                        imgProcura := "beta3"
                        ColocaX := 211
                        ColocaY := 53
                    }
                    else
                    {
                        imgProcura := "mais"
                        ColocaX := 13
                        ColocaY := 4
                    }
                    ImageSearch, X, Y, W/2, 0, W, H, *40 %a_scriptdir%\%imgProcura%.png
                    if (ErrorLevel = 0)
                    {
                        MouseClick, left, X+ColocaX, Y+ColocaY
                        GeraLog("Colocou nave " raridade " em uma base")
                        colocou += 1
                        naves += 1
                        Sleep, 1500
                    }
                    else
                    {
                        ImageSearch, X, Y, W/2, 0, W, H, *40 %a_scriptdir%\%imgProcura%.png
                        while (ErrorLevel != 0)
                        {
                            if (A_Index > 5)
                                break
                            ImageSearch, X, Y, W/2, 0, W, H, *40 %a_scriptdir%\%imgProcura%.png
                        }
                        if (ErrorLevel = 0)
                        {
                            MouseClick, left, X+ColocaX, Y+ColocaY
                            GeraLog("Colocou nave " raridade " em uma base")
                            colocou += 1
                            naves += 1
                            Sleep, 1500
                        }
                        else if (NaoDesceu)
                        {
                            MouseMove, 1500, 300
                            Sleep, 50
                            Click, WU, 50
                            Sleep, 700
                            NaoDesceu := false
                            ImageSearch, X, Y, W/2, 0, W, H, *40 %a_scriptdir%\%imgProcura%.png
                            if (ErrorLevel = 0)
                            {
                                MouseClick, left, X+ColocaX, Y+ColocaY
                                GeraLog("Colocou nave " raridade " em uma base")
                                colocou += 1
                                naves += 1
                                Sleep, 1500
                            }
                        }  
                    }
                }
                if (A_Index > 5)
                    break
                cords := FindClick("/" raridade ".png", "r Space Crypto a+400,+200,-300 n o80")
            }
            Process, Priority, %PID%, Low
            if (DesceuSeguidas > 10)
            {
                ImageSearch, X, Y, 0, 0, W, H, *60 %a_scriptdir%\proxima.png
                if (ErrorLevel = 0)
                {
                    DesceuSeguidas := 0
                    MouseClick, left, X, Y
                    Sleep, randSleep()
                    MouseMove, W/2, H/2
                    Loop, 10
                    {
                        Click, WD
                        Sleep, 50
                    }
                    Sleep, randSleep()
                    Loop, 3
                    {
                        Click, WU, 300
                        Sleep, 150
                    }
                    Sleep, 600
                }
                else
                {
                    noTrabalha := false
                    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
                    if (ErrorLevel = 0)
                    {
                        Clica(X, Y)
                        EsperaProcessing(W, H)
                    }
                    Sleep, 2000
                    return false
                }
            }
            else
            {
                MouseMove, W/2, H/2
                Click, WD, 37
                Desceu += 1
                if (mod(Desceu, 2) = 0)
                {
                    Click, WD, 3
                } 
                Sleep, 300
                DesceuSeguidas += 1
            }
        }
        ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\spaceship.png
        if (ErrorLevel = 0)
        {
            GeraLog("Voltou")
            Clica(X, Y)
            EsperaProcessing(W, H)
        }
        Sleep, 2000
        noTrabalha := false
        return true
    }
    else
    {
        GeraLog("Não estava no spaceship")
        return false
    }
}

ColocaNave(raridade, qnt)
{
    WinActivate Space Crypto
    WinGetPos, X, Y, W, H,  Space Crypto
    WinGet, PID, PID, Space Crypto
    MouseMove, W/2, H/2
    colocou := 0
    Loop, 10
    {
        Click, WD
        Sleep, 50
    }
    Sleep, randSleep()
    Loop, 7
    {
        Click, WU, 300
        Sleep, 150
    }
    Sleep, 1000
    loop, 
    {
        naves := 0
        cords := FindClick("/" raridade ".png", "r Space Crypto a+400,+200,-300 e n o80")
        Process, Priority, %PID%, Low
        Loop, parse, cords, `n, `r
        {
            X := SubStr(A_LoopField, 1, InStr(cords, ",")-1)
            Y := SubStr(A_LoopField, InStr(cords, ",")+1, 90)
            X2 := SubStr(A_LoopField, 1, InStr(cords, ",")-1)+378
            Y2 := SubStr(A_LoopField, InStr(cords, ",")+1, 90)+86
            maisde80 := FindClick("/80.png", "r Space Crypto a" X "," Y "," X2 "," Y2 " n o40")
            if (maisde80 != 0)
            {
                FindClick("/fight.png", "r Space Crypto a" X "," Y "," X2 "," Y2 " o60")
                colocou += 1
                DesceuSeguidas := 0
                naves += 1
                if (colocou >= qnt)
                {
                    return true
                }
            }
        }
        Process, Priority, %PID%, High
        Sleep, (1250 * naves)
        MouseMove, W/2, H/2
        Click, WD, 38
        Desceu += 1
        if Desceu in 3,6,9,12,15
        {
            Click, WD, 2
        } 
        Sleep, randSleep()
        DesceuSeguidas += 1
        if (DesceuSeguidas >= 16)
        {
            return false
        }
        Sleep, randSleep()
    }
}


VoltaPraColocaMais()
{
    WinActivate Space Crypto
    WinGetPos, X, Y, W, H,  Space Crypto
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImageSearch, X, Y, 0, 0, W, H, *40 %a_scriptdir%\frame15.png
    if (ErrorLevel = 0)
    {
        achouUmaVez := false
        vezes := 0
        X2 := X+60
        Y2 := Y-4
        Y := Y-25
        CoordMode, Pixel, Window
        CoordMode, Mouse, Window
        mantem := clipboard
        clipboard := ""
        TentaDeNovo:
        RunWait, %a_scriptdir%\Capture2Text\Capture2Text_CLI.exe --screen-rect "%X% %Y% %X2% %Y2%" --clipboard --whitelist 0123456789./, , Hide
        qntNavesNaBatalha := StrReplace(Clipboard, "`r`n")
        if qntNavesNaBatalha in %MuitoBurroVelho%
        {
            achouUmaVez := false
            clipboard := mantem
            return false
        }
        else
        {
            if qntNavesNaBatalha in %listaQntNaves%
            {
                if (!achouUmaVez)
                {
                    GeraLog("Achou " qntNavesNaBatalha)
                    qntFasesPassadas := 0
                    clipboard := mantem
                    achouUmaVez := true
                    Sleep, 4000
                    goto, TentaDeNovo
                    
                }
                else
                {
                    achouUmaVez := false
                    return true
                }
            }
        }
    }
    achouUmaVez := false
    return false
    CoordMode, Pixel, Window
    CoordMode, Mouse, Window
}

^F8::
Runwait, stats.py
