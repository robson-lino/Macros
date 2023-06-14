#Include edge.ahk

global ChromeInst,ChromeProfile,PageInst
FileCreateDir, ChromeProfile
ChromeInst := new Edge(A_ScriptDir "\EdgeProfile",, "--no-first-run")

; --- Connect to the page ---

if !(PageInst := ChromeInst.GetPage())
{
	MsgBox, Could not retrieve page!
	ChromeInst.Kill()
}
else
{
    PageInst.Call("Page.navigate", {"url": "https://dontpad.com/robsonlino/taptitans.log"})
	PageInst.WaitForLoad()
    Sleep, 3000
}

GeraLog(msg, sms=false)
{
    FormatTime, DataFormatada, D1 T0
	FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
    CARALHOOO := DataFormatada . " - " . msg . "\r\n"
    Mensagem := "document.getElementById(""text"").value = document.getElementById(""text"").value + """ . CARALHOOO . """"
    Result := PageInst.Evaluate(Mensagem)
	if ErrorLevel
	{
	    FileAppend, %DataFormatada% - %msg%`n, %a_scriptdir%\taptitans.log
	}
    If (sms)
    {
        ;SendSMS("`n" DataFormatada " - " msg)
    }
}



F8::
GeraLog("Vamos ver")
return
