Attribute VB_Name = "modFormTopMost"
'
'''''''''''''''''''''''''''''''''''''''''''''''''
' This code is FREEWARE
' You are welcome to copy, and edit it in any way
' to suit your needs
' James Crowley 1998
' email: James@ccrowley.force9.co.uk
'''''''''''''''''''''''''''''''''''''''''''''''''
'
' Only allow declared variables
Option Explicit

Const HWND_TOPMOST = -1
Const HWND_NOTOPMOST = -2
Const SWP_NOMOVE = &H2
Const SWP_NOSIZE = &H1
Const SWP_NOACTIVATE = &H10
Const SWP_SHOWWINDOW = &H40
Const TOPMOST_FLAGS = SWP_NOMOVE Or SWP_NOSIZE
Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, y, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long


Public Sub MakeTopMost(Handle As Long)
    SetWindowPos Handle, HWND_TOPMOST, 0, 0, 0, 0, TOPMOST_FLAGS
End Sub

Public Sub MakeNormal(Handle As Long)
    SetWindowPos Handle, HWND_NOTOPMOST, 0, 0, 0, 0, TOPMOST_FLAGS
End Sub
