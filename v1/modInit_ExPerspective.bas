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

Public Ex3DP(32) As New exMesh

Public Ex3DGround(15) As New exMesh      ' Visual Ground
                                         '  10 = 4-6
                                         '  11 = 8-2
                                         '  12 = 4-6-8
                                         '  13 = 8-2-6
                                         '  14 = 4-6-2
                                         '  15 = 8-2-4
                                         

Public Ex3DWallSides(3) As New exMesh    ' Visual Wall sides (large stones)

Public ExSnds(5) As New exSound


Public ExMsgBoard As New exMesh


' GUI stuff - make into class object?
Public ExTxtGUI As New ex2DText
Public ExTxtMsg As New ex2DText

''Public ExSnd As exSound




Function Ret3DPos(intMapPos As Integer) As Single
    Ret3DPos = -((intMapPos - 1) * 95.5)
End Function
