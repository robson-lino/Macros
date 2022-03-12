'::
MouseGetPos, OutputVarX, OutputVarY
PixelGetColor, OutputVar, OutputVarX, OutputVarY
FileAppend, %OutputVar%`n, %a_scriptdir%\cores.txt