#SingleInstance Force
#include Lib\AutoHotInterception.ahk
#Include ocr.ahk

CoordMode, Pixel, Window
CoordMode, Mouse, Window

SetKeyDelay, 50, 50
SendMode Input

global AHI := new AutoHotInterception()
global ultimoXmeu
global ultimoYmeu
global ultimoX
global ultimoY
DeviceList := AHI.GetDeviceList()
for k, v in DeviceList {
    if (v.IsMouse and mouse2Id = "") {
        global mouse2Id := v.ID
    }
    if (!v.IsMouse and keyboard1Id = "") {
        global keyboard1Id := v.ID
    }
}
;global keyboard1Id := AHI.GetKeyboardId(0x413C, 0x301D)
;global mouse2Id := AHI.GetMouseId(0x09DA, 0x718C)


ClicaRandom(X, Y, var := 3, velo := 50)
{
    Random, rand, -var, var
    Random, rand2, -var, var
    XCalculado := X+rand
    YCalculado := Y+rand2
    if (XCalculado < Xjanela or XCalculado > Wjanela or X = "" or YCalculado < Yjanela or YCalculado > Hjanela or Y = "") {
        GeraLog("Erro evitado.")
        return
    }
    ClicaViaSendMouse(X+rand, Y+rand2, 0, velo)
}

ClicaRandomDireito(X, Y, var := 3, velo := 30)
{
    Random, rand, -var, var
    Random, rand2, -var, var
    ClicaViaSendMouse(X+rand, Y+rand2, 1, velo)
}

ClicaViaSendMouse(Xmeu, Ymeu, code, velo)
{
    ultimoX := X
    ultimoY := Y
    ultimoXmeu := Xmeu
    ultimoYmeu := Ymeu
    EsperaRandom(velo)
    ;AHI.MoveCursor(Xmeu, Ymeu, "Window", mouse2Id)
    MouseMove, Xmeu, Ymeu, 15   
    EsperaRandom(velo+100)
    AHI.SendMouseButtonEvent(mouse2Id, code, 1)
    EsperaRandom(velo)
    AHI.SendMouseButtonEvent(mouse2Id, code, 0)
}

Tecla(key, velo := 40)
{
    EsperaRandom(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 1)
    EsperaRandom(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 0)
    ;GeraLog("Aperto : " key)
}

SeguraTecla(key, velo := 40)
{
    EsperaRandom(velo+50)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 1)
    EsperaRandom(velo)
    ;GeraLog("Segurou : " key)
}

SoltaTecla(key, velo := 40)
{
    EsperaRandom(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 0)
    EsperaRandom(velo)
    ;GeraLog("Soltou : " key)
}

randSleep(mili)
{
    Random, rand, mili-(mili//3), mili
    return rand
}

MinToMili(min)
{
    return min * 60000
}

RetornaText(X, Y, W, H)
{
    hBitmap := HBitmapFromScreen(X, Y, W, H)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    text := StrReplace(ocr(pIRandomAccessStream), "`n","")
    return text 
}

RetornaCorPixel(X, Y)
{
    PixelGetColor, OutputVar, X, Y
    return OutputVar
}

ProcuraAteAchar(X, Y, H, W, var, img, mili) {
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% *TransRed %a_scriptdir%\%img%.png
        if (!ErrorLevel)
        {
            AchouOutX := OutX
            AchouOutY := OutY
            return true
        }
    }
    return false
}

ProcuraAteAcharSemTrans(X, Y, H, W, var, img, mili) {
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


ProcuraAteAcharSemLogar(X, Y, H, W, var, img, mili) {   
    ;Inicio := A_TickCount
    ;Ativa()
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

ProcuraAteNaoAchar(X, Y, H, W, var, img, mili) {   
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        ImageSearch, OutX, OutY, X, Y, H, W, *%var% %a_scriptdir%\%img%.png
        if (ErrorLevel)
        {
            return true
        }
    }
    return false
}

ProcuraPixelAteNaoAchar(X, Y, color, mili) {   
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili)
    {
        if (RetornaCorPixel(X, Y) != color)
        {
            return true
        }
    }
    return false
}


ProcuraPixelAteAchar(X, Y, color, mili) {
    Comeco := A_TickCount
    while ((A_TickCount - Comeco) < mili) {
        if (RetornaCorPixel(X, Y) = color) {
            AchouOutX := X
            AchouOutY := Y
            return true
        }
    }
    return false
}

EsperaRandom(rand) {
    Sleep, randSleep(rand)
}

GetDeviceList() {
    
    DeviceList := AHI.GetDeviceList()
    for k, v in DeviceList {
        if (v.IsMouse and mouse2Id = "") {
            mouse2Id := v.ID
        }
        if (!v.IsMouse and keyboard1Id = "") {
            keyboard1Id := v.ID
        }
    }
}

MoveMouse(X, Y, velo := 40)
{
    EsperaRandom(velo)
    ;AHI.MoveCursor(X, Y, "Window", mouse2Id)
    Mousemove, X, Y, 15
    EsperaRandom(velo)
}

FormataMilisegundos(millisec) {
    totalSec := Floor(millisec / 1000)

    ; Calcula o número de minutos
    minutes := Floor(totalSec / 60)

    ; Calcula o número de segundos restantes
    seconds := Mod(totalSec, 60)

    ; Retorna o resultado formatado como minutos:segundos
    return minutes ":" Format("{:02d}", seconds)
}

; Função para calcular a distância euclidiana entre dois pontos
EuclideanDistance(x1, y1, x2, y2) {
	return Sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
}


; Função para encontrar a coordenada mais próxima do centro (800, 450)
EncontrarCoordenadaMaisProxima(coordenadas) {
	centro_x := Wjanela//2
	centro_y := Hjanela//2
	menor_distancia := 9999999 ; Defina um valor grande para garantir que a primeira distância seja menor
	coordenada_proxima := ""
	;for i, coord in listaCordPedras
	Loop, parse, coordenadas, `n, `r
	{
        ;GeraLog(A_LoopField)
		coord := StrSplit(A_LoopField, ",")
		x := coord[1]
		y := coord[2]
		distancia := EuclideanDistance(x, y, centro_x, centro_y)
		if (distancia < menor_distancia) {
			menor_distancia := distancia
			coordenada_proxima := coord
		}
	}
	return coordenada_proxima
}