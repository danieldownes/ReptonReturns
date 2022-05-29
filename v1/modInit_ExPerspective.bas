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

Public Ex3DP(24) As New exMesh

Public Ex3DGround(15) As New exMesh      ' Visual Ground

Public Ex3DWallSides(3) As New exMesh    ' Visual Wall sides (large stones)

Public ExSnds(5) As New exSound


' GUI stuff - make into class object?
Public txt2D As New ex2DText
Public txtScore2D As New ex2DText

''Public ExSnd As exSound




Function Ret3DPos(intMapPos As Integer) As Single
    Ret3DPos = -((intMapPos - 1) * 95.5)
End Function
