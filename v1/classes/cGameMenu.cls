VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGameMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

' Intro and menu


Option Explicit


Private ExDlogo_E As New exMesh
Private ExDlogo_x As New exMesh
Private ExDlogo_D As New exMesh
Private ExDlogo_text As New exMesh

' Sounds...
Private sndExDlogo   As New exSound



Private blnLoop               As Boolean            ' Controls the rendering loops



Sub Init()

    Dim intN As Integer
    Dim strTexFile As String
    
    
    ' Initalize Ex-Perspective™, giving a handel
    '  that is to be used to display the output.

    prj3D.Init frmMain.pic3D.hWnd
    
          
    'Load sounds
    sndExDlogo.InitSound App.Path & "\..\ex-d mono.wav"


    ' Load the 3D discriptions...
    
    ExDlogo_E.InitXFile App.Path & "\data\menu\ex-d\ex-d_logo\E.x", App.Path & "\data\menu\ex-d\ex-d_logo\e.bmp"
    ExDlogo_x.InitXFile App.Path & "\data\menu\ex-d\ex-d_logo\x.x", App.Path & "\data\menu\ex-d\ex-d_logo\x.bmp"
    ExDlogo_D.InitXFile App.Path & "\data\menu\ex-d\ex-d_logo\-d.x", App.Path & "\data\menu\ex-d\ex-d_logo\d.bmp"
    ExDlogo_text.InitXFile App.Path & "\data\menu\ex-d\ex-d_logo\text.x", App.Path & "\data\menu\ex-d\ex-d_logo\text.bmp"

       
    
End Sub

Sub ExDlogoLoop()

    Dim intN As Integer
    
    Dim timControl As New exTools_Timer

    
    blnLoop = True
    
    prj3D.BackColour &H0
    
    cam3D.Position 1, 1, 450, True
    
    
    timControl.ReSet

    ' Set Animations
    ExDlogo_E.AnimatedTransform.TransformTo Rotation3D, prj3D.exReturn3DVec(90, 180, 1), prj3D.exReturn3DVec(90, 180, 90), 3
    ExDlogo_E.AnimatedTransform.TransformTo Translation3D, prj3D.exReturn3DVec(1, 1, 1), prj3D.exReturn3DVec(600, 1, 1), 3
    
    ExDlogo_x.AnimatedTransform.TransformTo Rotation3D, prj3D.exReturn3DVec(90, 180, 1), prj3D.exReturn3DVec(-270, 180, 1), 2
    ExDlogo_x.AnimatedTransform.TransformTo Translation3D, prj3D.exReturn3DVec(1, 1, 1), prj3D.exReturn3DVec(1, 1, -5500), 2
    
    ExDlogo_D.AnimatedTransform.TransformTo Rotation3D, prj3D.exReturn3DVec(90, 180, 1), prj3D.exReturn3DVec(90, 180, -90), 3
    ExDlogo_D.AnimatedTransform.TransformTo Translation3D, prj3D.exReturn3DVec(1, 1, 1), prj3D.exReturn3DVec(-600, 1, 1), 3
    
    ExDlogo_text.AnimatedTransform.TransformTo Rotation3D, prj3D.exReturn3DVec(90, 180, 1), prj3D.exReturn3DVec(270, 180, 1), 3
    ExDlogo_text.AnimatedTransform.TransformTo Translation3D, prj3D.exReturn3DVec(1, 1, 1), prj3D.exReturn3DVec(1, 1, -700), 3

    ExDlogo_E.Position 1, 1, 1, True
    
    sndExDlogo.PlaySound False
    
    intN = 1
    
    ' The main loop. Each loop represents one frame.
    Do
        
        ' Animation Control
        Select Case intN
        
            Case 1
            
                If timControl.LocalTime > 5 Then
                   
                    ExDlogo_x.AnimatedTransform.TransformTo Rotation3D, prj3D.exReturn3DVec(290, 250, 150), prj3D.exReturn3DVec(90, 180, 1), 3
                    ExDlogo_x.AnimatedTransform.TransformTo Translation3D, prj3D.exReturn3DVec(1, 1, 700), prj3D.exReturn3DVec(1, 1, 1), 3
                    
                    intN = 2
                End If
            
            Case 2
                ExDlogo_x.Render
                
                ExDlogo_E.Position ExDlogo_x.Position().x, ExDlogo_x.Position().y, ExDlogo_x.Position().Z, True
                ExDlogo_D.Position ExDlogo_x.Position().x, ExDlogo_x.Position().y, ExDlogo_x.Position().Z, True
                ExDlogo_text.Position ExDlogo_x.Position().x, ExDlogo_x.Position().y, ExDlogo_x.Position().Z, True
                
                ExDlogo_E.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().Z, True
                ExDlogo_D.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().Z, True
                ExDlogo_text.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().Z, True
                
            
            
                If timControl.LocalTime > 7 Then
                    intN = 3
                End If
                
            Case 3
            
                blnLoop = False
            
        End Select
        
        ' Start of Rendering process...
        prj3D.Render

        
        ' Render the discriptions...
        ExDlogo_E.Render
        ExDlogo_x.Render
        ExDlogo_D.Render
        ExDlogo_text.Render
        

        ' Finally flip the buffers, completing the rendering process.
        prj3D.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False

    ' Not needed again, so unload now
    Set ExDlogo_E = Nothing
    Set ExDlogo_x = Nothing
    Set ExDlogo_D = Nothing
    Set ExDlogo_text = Nothing

'    Set sndExDlogo = Nothing
    

End Sub

