#NoEnv
#SingleInstance force
FileEncoding , UTF-8-RAW

; Comment out the next line if compiling to EXE, instead use Ahk2Exe.exe GUI to add custom icon
;Menu, Tray, Icon, icon.ico

; Retrieve API key from Registry
RegRead, apiKey, HKEY_CURRENT_USER, Software\PopupGPT, APIKey

; If blank, set API via user prompt
if apiKey =
    Gosub, SetApi

Gui, Font, s10
Gui, Add, Edit, vInput w400 h200
Gui, Add, Button, gAnswer35, GPT 3.5 (CTRL+Enter)
Gui, Add, Button, gAnswer4, GPT 4 (SHIFT+ENTER)
Gui, Add, Button, gSetApi, Set API Key
Gui, Add, Checkbox, vShortAnswerChecked Checked, Short Answer
Gui, Add, Edit, vOutput w400 h200 ReadOnly
Gui, Add, Button, gCopyOutput, Copy (ALT+C) 

Menu, Tray, NoStandard
Menu, Tray, Add, Show Popup, ShowGPTPopup
Menu, Tray, Add, Exit, ExitSub
Menu, Tray, Default, Show Popup
Return

ShowGPTPopup:
!`::  ; ALT+` Hotkey to show GUI
    GuiControl,, Input,  ; Clear the input field
    GuiControl,, Output,  ; Clear the output field
    Gui, Show, , PopupGPT  ; Show the GUI
    GuiControl, Focus, vInput  ; Focus on the input field
Return

; Hotkeys for executing and copy should only exist if window is active
#IfWinActive, PopupGPT
    ^Enter::Gosub, Answer35
    +Enter::Gosub, Answer4
    !c::Gosub, CopyOutput
    !x::ExitApp
#IfWinActive

Return

SetApi:
    InputBox, apiKey, API Key, Please enter your OpenAI API Key, ,,,,,,,%apiKey%
    RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\PopupGPT, APIKey, %apiKey%
Return

Answer35:
    model := "gpt-3.5-turbo-0125"
    Gosub, Answer
Return

Answer4:
    model := "gpt-4-0125-preview"
    Gosub, Answer
Return

Answer:
Gui, Submit, NoHide

InputPrompt := Input
GuiControlGet, ShortAnswerChecked,, ShortAnswerChecked
if (ShortAnswerChecked = "1")
{
    InputPrompt .= "`nShortest answer"
}
; Escape special characters in user input
InputPrompt := StrReplace(InputPrompt, "`n", "\n")
InputPrompt := StrReplace(InputPrompt, """", "\""") ; Escape double quotes for JSON
If InputPrompt = ; Prompt is empty...
    {
        MsgBox Please type your prompt in the top, big white box
        Return
    }
GuiControl,, Output, Thinking...

; Prepare JSON payload and save to a temporary file
JsonPayload := "{""model"": """ . model . """, ""messages"": [{""role"": ""user"", ""content"": """ . InputPrompt . """}]}"
TempJsonFile := A_Temp . "\PopupGPT_Payload.json"

; Write JSON to the file with UTF-8 encoding
FileDelete, %TempJsonFile% ; Ensure the file does not already exist
FileAppend, %JsonPayload%, %TempJsonFile%, UTF-8-RAW
TempFile := A_Temp . "\PopupGPT_Response.txt"

; Modify the curl command to read from the file
curlCommand := "curl ""https://api.openai.com/v1/chat/completions"" -H ""Content-Type: application/json; charset=utf-8"" -H ""Authorization: Bearer " . apiKey . """ --data-binary @""" . TempJsonFile . """"

; Execute the curl command
RunWait, %ComSpec% /c %curlCommand% > %TempFile%,, Hide UseErrorLevel
if ErrorLevel
    {
        MsgBox, There was an error running the cURL command: %ErrorLevel%
        Return
    }

FileRead, OutputVar, %TempFile%
FileDelete, %TempFile%

if ErrorLevel
{
    MsgBox, There was an error with the response: %ErrorLevel%
    Return
}

; TODO: Upgrade to actual JSON parsing
; Extract response from JSON string
StartPosition := InStr(OutputVar, "content") + 11
EndPosition := InStr(OutputVar, "logprobs") - 18
gptOutput := SubStr(OutputVar, StartPosition, EndPosition - StartPosition)

; Fix up the output
gptOutput := StrReplace(gptOutput, "\n", "`n") ; Convert newlines to AHK newlines
gptOutput := StrReplace(gptOutput, "\""", """") ; Escape (") correctly
gptOutput := StrReplace(gptOutput, "```", "")  ; Remove backticks around code.

GuiControl,, Output, %gptOutput%
Return

CopyOutput:
GuiControlGet, CurrentOutput,, Output
Clipboard := CurrentOutput
Return

GuiClose:
    Gui, Hide  ; Hide the GUI instead of exiting
Return

ExitSub: 
  ExitApp 
Return
