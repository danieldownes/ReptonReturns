Attribute VB_Name = "modInit_ExPerspective"
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.


' This module contains general visual asspects of
'  the game using the Ex-Perspective interface

Option Explicit

Public ExPrj As New exD3Dprj
Public ExCam As New exCamera
Public ExInp As New exInput

Public ExFader          As New exMesh

Public Ex3DP(33) As New exMesh

Public Ex3DGround(0) As New exMesh      ' Visual Ground
                                         '  10 = 4-6
                                         '  11 = 8-2
                                         '  12 = 4-6-8
                                         '  13 = 8-2-6
                                         '  14 = 4-6-2
                                         '  15 = 8-2-4
                                         

Public Ex3DWallSides(3) As New exMesh    ' Visual Wall sides (large stones)

Public Ex3DParticles(0) As New exMesh    ' Load the different types of particle
    
Public ExSnds(20) As New exSound
' 0 - Dimond1
' 1 - Dimond2
' 2 - Dimond3
' 3 - Dimond4
' 4 - Rock Falling
' 5 - Rock Crash
' 6 - Crown collected
' 7 - egg_cracking
' 8 - egg_crunch
' 9 - spirit caught
'10 - spirit near
'11 - time_cap
'12 - transporter
'13 - level-trans
'14 - key
'15 - fungus
'16 - dig
'17 - monster awake
'18 - monster die
'19 - rep die
'20 - bomb explosion

Public ExMsgBoard As New exMesh

Public ExScenery() As New exMesh


' GUI stuff - make into class object?
Public ExTxtGUI As New ex2DText
Public ExTxtMsg As New ex2DText

''Public ExSnd As exSound

Dim TimFaderCont    As New exTools_Timer
Dim sngFadeTime     As Single



Function InitExperspectiveObjects()
    ExPrj.Init frmMain.hwnd, "timeomatic"
    ExPrj.BackColour &H0

    ExInp.InitKeyboardInput


    ExTxtGUI.InitText "", frmMain.lblGUIRef.Font
    ExTxtGUI.Colour &HFF00A000
    
    ExTxtMsg.InitText "", frmMain.lblMsgRef.Font
    ExTxtMsg.Colour &HFF00A000
    
    ExFader.InitXFile pckGenFiles.GetPackedFile("fader.x")
    
End Function

Function StartFader(sngTime As Single)
    TimFaderCont.ReSet
    sngFadeTime = sngTime
End Function

Function RenderFader(Optional bIn As Boolean = False)
    Dim n As Integer
    
    If bIn Then
        ' Fade in
        If sngFadeTime > 0 Then
            For n = 1 To Int((25 / sngFadeTime) * (sngFadeTime - TimFaderCont.LocalTime))
                ExFader.Render
            Next n
        End If
    Else
        ' Fade out
        If sngFadeTime > 0 Then
            For n = 1 To Int((25 / sngFadeTime) * TimFaderCont.LocalTime)
                ExFader.Render
            Next n
        ElseIf sngFadeTime = -1 Then
            For n = 1 To 25
                ExFader.Render
            Next n
        End If
    End If
    
    If TimFaderCont.LocalTime > sngFadeTime Then sngFadeTime = -1
End Function

Function Ret3DPos(intMapPos As Integer) As Single
    Ret3DPos = -((intMapPos - 1) * 95.5)
End Function
