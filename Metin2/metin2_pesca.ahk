#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#MaxThreads 1
SetKeyDelay, 25, 25

DefaultDirs = a_scriptdir

CoordMode, Pixel, Window
CoordMode, Mouse, Window

#Include, ocr.ahk
