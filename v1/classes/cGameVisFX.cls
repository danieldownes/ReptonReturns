VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGameVisFX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Private Ex3D As New exMesh

Private Type FXinstence_T
    sngXpos As Single
    sngYpos As Single
    sngAniPos As Single                 ' = -1 when instence not in use
    timAniCont As New exTools_Timer
End Type
Private usrFXinstence(10) As FXinstence_T

Private sngAniSpeed As Single
Private Const sngAniLen = 100#

Private Enum FX_Type
    InternalAni = 0
    Diamond
End Enum

Private iFXtype As FX_Type


' Class (this FX, and all instences) specific

Function Init(strMeshFile As String, strTexFile As String, Optional sAniSpeed As Single = -1)
    
    Dim n As Integer
    
    
    Select Case strMeshFile
        Case "Diamond"
            iFXtype = Diamond
            Ex3D.InitXFile App.Path &
            
        Case Else
            iFXtype = InternalAni
            Ex3D.InitXFile strMeshFile, strTexFile
    
    End Select
    
    Ex3D.Rotate 90, 0, 0, True
    
    For n = 0 To UBound(usrFXinstence)
        With usrFXinstence
            .sngAniPos = -1
        End With
    Next n
        
    sngAniSpeed = sAniSpeed
End Function

Function DeInit()
    Set Ex3D = Nothing
End Function

Function RenderInstences()
    Dim n As Integer
    Dim b As Integer
    
    For n = 0 To UBound(usrFXinstence)
        If usrFXinstence(n).sngAniPos <> -1 Then
        
            Select Case iFXtype
                Case InternalAni
                    
                
                Case Diamond
                    For b = 1 To Rnd(Timer()) * 10 - 2
                        Ex3D.position usrFXinstence(n).sngXpos + Rnd(Timer()) * 40 - 20, 20 + Rnd(Timer()) * 40 - 20, usrFXinstence(n).sngYpos + Rnd(Timer()) * 40 - 20, True
                        Ex3D.Render
                    Next b
            End Select
        
        End If
    Next n
End Function

' Instence specific ...

Function StartFX(sX As Single, sY As Single) As Integer
    
    ' Find free instence
    StartFX = 0
    Do
        If StartFX > UBound(usrFXinstence) Then Exit Function
        StartFX = n + 1
    Loop While usrFXinstence(StartFX).sngAniPos <> -1
    
    usrFXinstence(StartFX).timAniCont.ReSet
        
    Select Case iFXtype
        Case InternalAni
            
        
        Case Diamond
    
    End Select
End Function

