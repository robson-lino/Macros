#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1
SetKeyDelay, 25, 25

global vezes := false
global X1,Y1,X2,Y2,PixelColor1,PixelColor2

CoordMode, Pixel, Window
CoordMode, Mouse, Window


F10::
if (vezes)
{
    vezes := false
    MouseGetPos, X2, Y2
    PixelGetColor, PixelColor2, X2, Y2
    W1 := X2 - X1, H1 := Y2 - Y1
    GeraLog(X2 ", " Y2 " - " PixelColor2)
    GeraLog(X1 ", " Y1 ", " X2 ", " Y2)
}
else
{
    vezes := true
    MouseGetPos, X1, Y1
    PixelGetColor, PixelColor1, X1, Y2
    GeraLog(X1 ", " Y1 " - " PixelColor1)
}

GeraLog(msg)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	if ErrorLevel
	{
		FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\metin2.log
	}
}
return