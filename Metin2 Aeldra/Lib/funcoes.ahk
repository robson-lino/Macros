#SingleInstance Force
#include Lib\AutoHotInterception.ahk
#Include ocr.ahk
SetKeyDelay, 50, 50
SendMode Input

global AHI := new AutoHotInterception()
global keyboard1Id := AHI.GetKeyboardId(0x413C, 0x301D)
global mouse2Id := AHI.GetMouseId(0x09DA, 0x718C)

ClicaRandom(X, Y, var := 3, velo := 20)
{
    if (velo < 20)
        velo := 20
    Random, rand, -var, var
    Random, rand2, -var, var
    ClicaViaSendMouse(X+rand, Y+rand2, 0, velo)
}

ClicaRandomDireito(X, Y, var)
{
    if (velo < 20)
        velo := 20
    Random, rand, -var, var
    Random, rand2, -var, var
    ClicaViaSendMouse(X+rand, Y+rand2, 1, velo)
}

ClicaViaSendMouse(X, Y, code, velo)
{
    AHI.MoveCursor(X, Y, "Window", mouse2Id)
    Sleep, randSleep(velo)
    AHI.SendMouseButtonEvent(mouse2Id, code, 1)
    Sleep, randSleep(velo)
    AHI.SendMouseButtonEvent(mouse2Id, code, 0)
    Sleep, randSleep(velo)
}

Tecla(key, velo := 20)
{
    if (velo < 20)
        velo := 20
    Sleep, randSleep(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 1)
    Sleep, randSleep(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 0)
    Sleep, randSleep(velo)
}

SeguraTecla(key, velo := 20)
{
    if (velo < 20)
        velo := 20
    Sleep, randSleep(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 1)
    Sleep, randSleep(velo)
}

SoltaTecla(key, velo := 20)
{
    if (velo < 20)
        velo := 20
    Sleep, randSleep(velo)
    AHI.SendKeyEvent(Keyboard1Id, GetKeySC(key), 0)
    Sleep, randSleep(velo)
}

randSleep(mili)
{
    Random, rand, mili-(mili//2), mili
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

