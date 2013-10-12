;==================================================
; Recommended settings for all new scripts
;==================================================
#NoEnv
#SingleInstance force 
SendMode Input
SetWorkingDir %A_ScriptDir%

;======================================================================
; Script info
;======================================================================
Menu, Tray, Tip, Press CTRL+V to paste images into chat windows!

;==================================================
; If the window is a console, capture CTRL+V!
;==================================================
#IfWinActive ahk_class ConsoleWindowClass
	^v::Send !{Space}EP
	^c::Send !{Space}EY
#IfWinActive

#IfWinActive ahk_class Console_2_Main
  ^v::Send {Raw}%clipboard%
#IfWinActive