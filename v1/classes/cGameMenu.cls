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

Dim exDummyLookAt    As New exMesh

Dim exStarGlimmer    As New exMesh

Dim exUnderGround    As New exMesh

Dim exSky            As New exMesh
Dim exRepHolder      As New exMesh
Dim exRepton         As New exMesh
Dim exReturns        As New exMesh
Dim exReturnsHL      As New exMesh




Private Type Boulder_T
    exLog As New exMesh
    
    meshID As Integer
End Type


Sub Init()
    exUnderGround.InitXFile App.Path & "\data\menu\intro\underground.x", App.Path & "\data\themes\origonal\textures\wall.bmp"
    exUnderGround.position 26, -5, 0, True
    
    exSky.InitXFile App.Path & "\data\menu\intro\sky.x", App.Path & "\data\menu\intro\sky.bmp"
    exRepHolder.InitXFile App.Path & "\data\menu\intro\repholder.x", App.Path & "\data\menu\intro\repholder.bmp"
    exRepton.InitXFile App.Path & "\data\menu\intro\repton.x", App.Path & "\data\menu\intro\repton.bmp"
    
    exReturns.InitXFile App.Path & "\data\menu\intro\returns.x"
    exReturnsHL.InitXFile App.Path & "\data\menu\intro\returns_hl.x"

End Sub

Sub NewPlayer()

    Dim blnLoop As Boolean
    Dim bExist  As Boolean
    Dim sTemp   As String
    
    ' Do not continue until dependent keys are de-pressed
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return)
    
    frmMain.txtName.Text = ""
    frmMain.txtName.Visible = True
    frmMain.txtName.SetFocus
    
    blnLoop = True
    
    ExFader.ResetMatrix
    ExFader.position 100, 0.01, -200, True
    
    Do
    
        If ExInp.exInput(ex_Return) Then
        
            frmMain.txtName.Text = UCase(frmMain.txtName.Text)
            
            ' Check if not already exist
            bExist = False
            sTemp = ""
            Open App.Path & "\data\players\names.dat" For Input As #1
                Do While Not (EOF(1)) And Not (bExist)
                    Input #1, sTemp
                    If sTemp = frmMain.txtName.Text Then bExist = True
                Loop
            Close #1
            If bExist = False Then
                 ' Create new store for this player
                 CreateFolder App.Path & "\data\players\" & frmMain.txtName.Text
                 CreateFolder App.Path & "\data\players\" & frmMain.txtName.Text & "\Home"
                 CreateFolder App.Path & "\data\players\" & frmMain.txtName.Text & "\Home\old"
                 
                 CopyFile App.Path & "\data\players\new\" & "options.dat", App.Path & "\data\players\" & frmMain.txtName.Text & "\options.dat"
                 CopyFile App.Path & "\data\players\new\" & "stats.dat", App.Path & "\data\players\" & frmMain.txtName.Text & "\stats.dat"
                 
                 CopyFile App.Path & "\data\players\new\Home\" & "Home.rre", App.Path & "\data\players\" & frmMain.txtName.Text & "\Home\Home.rre"
                 CopyFile App.Path & "\data\players\new\Home\" & "Home.rre", App.Path & "\data\players\" & frmMain.txtName.Text & "\Home\old\Home.rre"
                 
                 CopyFile App.Path & "\data\players\new\Home\" & "start.rrl", App.Path & "\data\players\" & frmMain.txtName.Text & "\Home\start.rrl"
                 CopyFile App.Path & "\data\players\new\Home\" & "start.rrl", App.Path & "\data\players\" & frmMain.txtName.Text & "\Home\old\start.rrl"
                 
                 'on error reume next
                 Open App.Path & "\data\players\names.dat" For Append As #1
                     Print #1, frmMain.txtName.Text
                 Close #1
            Else
                MsgBox "Player with same name already exists", , "Repton Returns"
            End If
            
            frmMain.txtName.Visible = False
            blnLoop = False
        End If
        
        If ExInp.exInput(ex_ESCAPE) Then
            frmMain.txtName.Visible = False
            blnLoop = False
        End If
        
    
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...

        exSky.Render
        
        exUnderGround.Render
        
        exRepHolder.Render
        exRepton.Render
                                
        exReturnsHL.Render
        
        'RenderFader
        ExFader.Render
        ExFader.RotateVecs 0.01, 0, 0
        
        
        ' The menu
        ExTxtGUI.Colour &HFF00A000
        ExTxtGUI.Text "ENTER NEW PLAYER'S NAME (ESC TO CANCEL):"
        ExTxtGUI.position 40, 200
        ExTxtGUI.Render
       
        
        ExTxtGUI.Text "NAME:"
        ExTxtGUI.position 300, 260
        ExTxtGUI.Render
        
        
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False
End Sub

Function SelectPlayerMenu(Optional iContext As Integer = 0) As Integer
' iContext::
'   0 = for start game
'   1 = for player's options


    Dim sPlayers() As String
    
    Dim blnLoop  As Boolean
    Dim n As Integer
    Dim iLastMove        As Integer
    
    
    Dim b As Integer
    
    Dim iTopList  As Integer

    ReDim Preserve sPlayers(0)
    SelectPlayerMenu = 0
    
    ' Read names from file
    If FileExists(App.Path & "\data\players\names.dat") Then
        Open App.Path & "\data\players\names.dat" For Input As #1
            n = 0
            Do While Not EOF(1)
                n = n + 1
                ReDim Preserve sPlayers(n)
                Input #1, sPlayers(n)
            Loop
        Close #1
        If n > 0 Then SelectPlayerMenu = 1
    End If
    
    ExFader.ResetMatrix
    ExFader.Rotate 0, 0, 0, True
    ExFader.position 0.01, 0.01, -1150, True
    
    
    iTopList = 1
    
    blnLoop = True
    iLastMove = 0
    
    ' Do not continue until dependent keys are de-pressed
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return)
    
    StartFader 2

    Do
    
        If iLastMove <> 0 And Not (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Down_arrow) _
          Or ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Up_arrow)) And blnLoop Then
            
            iLastMove = 0
           
        End If
            
        If iLastMove = 0 And (ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Down_arrow)) Then
                    
        
            iLastMove = 1
            SelectPlayerMenu = SelectPlayerMenu + 1
            If SelectPlayerMenu > UBound(sPlayers) Then SelectPlayerMenu = -1: iTopList = 1
            
            If SelectPlayerMenu <= UBound(sPlayers) And SelectPlayerMenu > (iTopList + 6) Then iTopList = iTopList + 1
            
        ElseIf (iLastMove = 0 And (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Up_arrow))) Then
            iLastMove = -1
            
            
            SelectPlayerMenu = SelectPlayerMenu - 1
            
            ' Wrap menu nav
            If SelectPlayerMenu < -1 Then SelectPlayerMenu = UBound(sPlayers): iTopList = UBound(sPlayers) - 6
            
            If SelectPlayerMenu > 0 And SelectPlayerMenu < iTopList Then iTopList = iTopList - 1
            
        End If
        
        If ExInp.exInput(ex_Return) Then
            

            blnLoop = False
        End If
        
        If ExInp.exInput(ex_ESCAPE) Then
            

            SelectPlayerMenu = -1
            
            
            blnLoop = False
        
        End If
    
    
    
    
    
    
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...

        exSky.Render
        
        exUnderGround.Render
        
        exRepHolder.Render
        exRepton.Render
                                
        exReturnsHL.Render
        
        
        RenderFader
        
        
        ' The menu
        ExTxtGUI.Colour &HFF00A000
        Select Case iContext
            Case 0
                ExTxtGUI.Text "PLAY GAME -- SELECT PLAYER:"
            Case 1
                ExTxtGUI.Text "OPTIONS FOR SELECTED PLAYER:"
        End Select
        ExTxtGUI.position 40, 200
        ExTxtGUI.Render
        
        If SelectPlayerMenu = 0 Then
            ExTxtGUI.Colour &HFF99FF99
        Else
            ExTxtGUI.Colour &HFF00A000
        End If
        ExTxtGUI.Text "NEW PLAYER"
        ExTxtGUI.position 200, 240
        ExTxtGUI.Render
        
        
        If UBound(sPlayers) > 0 Then
            For n = iTopList To UBound(sPlayers)
            
                If n - iTopList > 6 Then Exit For
                If n < 1 Then n = n + 5
            
                If SelectPlayerMenu = n Then
                    ExTxtGUI.Colour &HFF99FF99
                Else
                    ExTxtGUI.Colour &HFF00A000
                End If
            
                ExTxtGUI.Text sPlayers(n)
                ExTxtGUI.position 300, 280 + (40 * (n - iTopList))
                ExTxtGUI.Render
                
            Next n
        Else
            n = 0
        End If
        
        
        
        If SelectPlayerMenu = -1 Then
            ExTxtGUI.Colour &HFF99FF99
        Else
            ExTxtGUI.Colour &HFF00A000
        End If
        ExTxtGUI.Text "BACK"
        ExTxtGUI.position 200, 600
        ExTxtGUI.Render

        
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False ' And exMenuItems(0).AnimatedTransform.active = False And exMenuItems(1).AnimatedTransform.active = False

End Function

Function ReptonReturnsMenu() As Integer
' Return:
'   1 = Play
'   2 =
'
'   0 = Exit

    Dim blnLoop As Boolean

    Dim exMenuItems(4)      As New exMesh

    
    Dim iLastMove        As Integer
    
    Dim n As Integer
    
    Dim bStarted As Boolean
    
    exMenuItems(1).InitXFile App.Path & "\data\menu\play.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exMenuItems(2).InitXFile App.Path & "\data\menu\options.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exMenuItems(3).InitXFile App.Path & "\data\menu\help.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exMenuItems(4).InitXFile App.Path & "\data\menu\about.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exMenuItems(0).InitXFile App.Path & "\data\menu\exit.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    
    
    ExCam.position 0.001, -150, -1300, True
    exDummyLookAt.position 0.001, -200, -999, True
    
    
    exRepton.ResetMatrix
    exRepHolder.ResetMatrix
    exRepton.position 0.001, -200, -309, True
    exRepHolder.position 0.001, -200, -306, True
    exRepton.Rotate -45, 0.1, 0.1, True
    exRepHolder.Rotate -45, 0.1, 0.1, True
    
    exReturnsHL.position 10, -250, -120, True
    exReturnsHL.Rotate -45, 0.001, 0.001, True
    
    exSky.position 1, -400, 100, True
    
    ExCam.LookAt exDummyLookAt.position.x, exDummyLookAt.position.y, exDummyLookAt.position.z
    
    ExTxtMsg.Colour &HFF888888
    ExTxtMsg.position 100, frmMain.iYsize - 50
    ExTxtMsg.Text "Repton Returns v1.00      ©2003 Ex-D Software Development™."
    
    ReptonReturnsMenu = 0
    iLastMove = 0
    
    blnLoop = True
    
    bStarted = True
    
    ' Do not continue until dependent keys are de-pressed
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return)
    
    Do
    
        If iLastMove <> 0 And Not (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Down_arrow) _
          Or ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Up_arrow)) And blnLoop Then
            
            iLastMove = 0
           
        End If
            
        If (iLastMove = 0 And (ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Down_arrow))) Or bStarted Then
        
            If Not (bStarted) Then
                exMenuItems(ReptonReturnsMenu).ResetMatrix
                exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(200, -1000, 600), ExPrj.exReturn3DVec(0.1, -420, -500), 0.45
                exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(270, 0.01, 0.01), ExPrj.exReturn3DVec(-80, 0.01, 0.01), 0.45
            Else
                bStarted = False
            End If
        
            iLastMove = 1
            ReptonReturnsMenu = ReptonReturnsMenu + 1
            If ReptonReturnsMenu > 4 Then ReptonReturnsMenu = 0
        
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.1, -420, -500), ExPrj.exReturn3DVec(-200, -520, 600), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-80, 0.01, 0.01), ExPrj.exReturn3DVec(270, 0.01, 0.01), 0.45
            
        ElseIf (iLastMove = 0 And (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Up_arrow))) Then
            iLastMove = -1
            
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(-200, -1000, 600), ExPrj.exReturn3DVec(0.1, -420, -500), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(270, 0.01, 0.01), ExPrj.exReturn3DVec(-80, 0.01, 0.01), 0.45
            
            ReptonReturnsMenu = ReptonReturnsMenu - 1
            If ReptonReturnsMenu < 0 Then ReptonReturnsMenu = 4
        
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.1, -420, -500), ExPrj.exReturn3DVec(200, -520, 600), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-80, 0.01, 0.01), ExPrj.exReturn3DVec(270, 0.01, 0.01), 0.45
            
        End If
        
        If ExInp.exInput(ex_Return) And blnLoop Then
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -150, -1300), ExPrj.exReturn3DVec(0.1, -420, -500), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-80, 100, 0.01), ExPrj.exReturn3DVec(-80, 0.01, 0.01), 0.45
            
            VolumeFMOD 55

            blnLoop = False
        End If
        
        If ExInp.exInput(ex_ESCAPE) And blnLoop Then
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(-200, -1000, 600), ExPrj.exReturn3DVec(0.1, -420, -500), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(270, 0.01, 0.01), ExPrj.exReturn3DVec(-80, 0.01, 0.01), 0.45

            ReptonReturnsMenu = 0
                    
            exMenuItems(ReptonReturnsMenu).ResetMatrix
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.1, -420, -500), ExPrj.exReturn3DVec(200, -520, 600), 0.45
            exMenuItems(ReptonReturnsMenu).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-80, 0.01, 0.01), ExPrj.exReturn3DVec(270, 0.01, 0.01), 0.45
            
            blnLoop = False
        
        End If

    
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...

        exSky.Render
        
        exUnderGround.Render
        
        exRepHolder.Render
        exRepton.Render
        
        ExTxtMsg.Render
                                
        ' Render the menu items
        For n = 0 To 4
            If exMenuItems(n).AnimatedTransform.active(Translation3D) Or ReptonReturnsMenu = n Then
                exMenuItems(n).Render
            End If
        Next n

        exReturnsHL.Render
        
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False And exMenuItems(0).AnimatedTransform.active(Translation3D) = False And exMenuItems(1).AnimatedTransform.active(Translation3D) = False _
                               And exMenuItems(2).AnimatedTransform.active(Translation3D) = False And exMenuItems(3).AnimatedTransform.active(Translation3D) = False _
                               And exMenuItems(4).AnimatedTransform.active(Translation3D) = False
    

End Function


Sub ReptonReturnsIntroLoop()
    
    Dim tBoulders(30) As Boulder_T
    

    Dim intN As Integer
    Dim n As Integer
    
        
    Dim timControl As New exTools_Timer
    
    Dim exGroundBack        As New exMesh
    Dim exGroundFront       As New exMesh
    

    Dim exGrass(10)         As New exMesh
    Dim exBoulder(2)        As New exMesh
    
    
    Dim blnLoop               As Boolean
          


    ' Load the 3D discriptions...
    
    exGroundBack.InitXFile App.Path & "\data\menu\intro\ground_back.x", App.Path & "\data\menu\intro\ground.bmp"
    exGroundFront.InitXFile App.Path & "\data\menu\intro\ground_front.x", App.Path & "\data\menu\intro\ground.bmp"
    
    exBoulder(0).InitXFile App.Path & "\data\menu\intro\rock1.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exBoulder(1).InitXFile App.Path & "\data\menu\intro\rock2.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    exBoulder(2).InitXFile App.Path & "\data\menu\intro\rock3.x", App.Path & "\data\themes\origonal\textures\rock.bmp"
    For n = 0 To 10
        exGrass(n).InitXFile App.Path & "\data\menu\intro\grass.x"  '', App.Path & "\data\themes\origonal\textures\rock.bmp"
        exGrass(n).position Rnd() * 1000 - 500, 0.01, Rnd * 1000 - 500, True
    Next n
    
    exDummyLookAt.InitXFile ""

    blnLoop = True
    
    ExPrj.BackColour &H0
    
    ExCam.position 0.001, 500, 500, True
    
    exReturns.position 0, -300, 0, True
    
    
    ExFader.ResetMatrix
    ExFader.Rotate 0, 0, 0, True
    ExFader.position 0.01, 0.01, 550, True
    
    
    timControl.ReSet
    
    PlayFMOD
    
    
    ' Set Animations
    
    exDummyLookAt.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.0001, -15000, 50000), ExPrj.exReturn3DVec(0.0001, 10000, 30000), 10
    
    
    intN = 1
    
    StartFader 2
       
    ' The main loop. Each loop represents one frame.
    Do
        
        ' Animation Control
        Select Case intN
        
            Case 1
            
                If timControl.LocalTime > 5 Then
                   ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, 500, -400), ExPrj.exReturn3DVec(0.001, 500, 500), 7
                    
                    intN = 2
                End If
            
            Case 2
               
                If timControl.LocalTime > 12 Then
                    ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, 500, -650), ExPrj.exReturn3DVec(0.001, 500, -400), 8
                    exDummyLookAt.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.0001, -15000, 20000), ExPrj.exReturn3DVec(0.0001, -15000, 50000), 8
                
                    intN = 3
                End If
                
            Case 3          ' "Returns" seeping though ground
                If timControl.LocalTime > 20 Then
                    ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, 480, -680), ExPrj.exReturn3DVec(0.001, 500, -650), 4
                    
                    exReturns.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0, -220, 0), ExPrj.exReturn3DVec(0, -300, 0), 4
                    
                    intN = 4
                End If
                
            Case 4          ' Boulder explostion
                If timControl.LocalTime > 24 Then
                    ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, 400, -1000), ExPrj.exReturn3DVec(0.001, 480, -680), 1
                    exDummyLookAt.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.0001, -10000, 20000), ExPrj.exReturn3DVec(0.0001, -15000, 20000), 1
                    
                    exReturns.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0, 0.001, 0), ExPrj.exReturn3DVec(0, -220, 0), 1
                    
                    ' Boulders
                    For n = 0 To 10
                        tBoulders(n).exLog.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Rnd * 4000 - 2000, 1500, Rnd * 4000 - 2000), ExPrj.exReturn3DVec(Rnd * 1000 - 500, -100, exGroundFront.position.z - 100), 5
                        tBoulders(n).exLog.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(Rnd * 1000 - 500, Rnd * 1000 - 500, Rnd * 1000 - 500), ExPrj.exReturn3DVec(Rnd * 1000 - 500, Rnd * 1000 - 500, Rnd * 1000 - 500), 20
                        tBoulders(n).meshID = Rnd * 2
                    Next n
                    
                    ' Move ground
                    exGroundFront.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, 0.001, -1500), ExPrj.exReturn3DVec(0.001, 0.001, 0.001), 2.5
                    
                    ' Move grass on moving ground too
                    For n = 0 To 10
                        If exGrass(n).position.z < 0.001 Then
                            exGrass(n).AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(exGrass(n).position.x, 0.001, exGrass(n).position.z - 1500), ExPrj.exReturn3DVec(exGrass(n).position.x, 0.001, exGrass(n).position.z), 2.5
                        End If
                    Next n
                
                    intN = 5
                End If
                
            Case 5
                If timControl.LocalTime > 27 Then
                    ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -150, -1300), ExPrj.exReturn3DVec(0.001, 400, -1000), 3
                    exDummyLookAt.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -0.01, -5), ExPrj.exReturn3DVec(0.0001, -10000, 20000), 1.5
                    
                    exRepton.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -200, -300), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3
                    exRepton.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-45, 0.1, 0.1), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3
                    
                    exRepHolder.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -200, -300), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3
                    exRepHolder.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-45, 0.1, 0.1), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3

                    exReturns.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(10, -250, -120), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3
                    exReturns.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-45, 0.1, 0.1), ExPrj.exReturn3DVec(0.01, 0.01, 0.01), 3
                
                    
'
'                    exSky.position 1, -400, 100, True
                                    
                                    
                    intN = 6
                End If
            Case 6
                If timControl.LocalTime > 28.5 Then
                    exDummyLookAt.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(0.001, -200, -999), ExPrj.exReturn3DVec(0.001, -0.01, -5), 1.5
                    
                    intN = 7
                End If
                
            Case 7
                If timControl.LocalTime > 30 Then
                    blnLoop = False
                End If
            
        End Select
        
        ExCam.UpDate
        exDummyLookAt.Render
        ExCam.LookAt exDummyLookAt.position.x, exDummyLookAt.position.y, exDummyLookAt.position.z
        
        exSky.position 1, -(ExCam.position.y * 0.2 - 100), ExCam.position.z + 400, True
        
        
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...
        exGroundBack.Render
        exGroundFront.Render
        exUnderGround.Render
        exSky.Render
        exRepHolder.Render
        exRepton.Render
        exReturns.Render
        For n = 0 To 10
            exGrass(n).Render
        Next n
        
        
        If intN >= 5 And intN < 8 Then
            For n = 0 To 10
                tBoulders(n).exLog.Render
                exBoulder(tBoulders(n).meshID).ResetMatrix
                exBoulder(tBoulders(n).meshID).position tBoulders(n).exLog.position.x, tBoulders(n).exLog.position.y, tBoulders(n).exLog.position.z, True
                exBoulder(tBoulders(n).meshID).Rotate tBoulders(n).exLog.Rotate.x, tBoulders(n).exLog.Rotate.y, tBoulders(n).exLog.Rotate.z, True
                exBoulder(tBoulders(n).meshID).Render
            Next n
        End If

        If intN = 1 Then RenderFader True
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False Or ExInp.exInput(ex_ESCAPE)
    
    ' Do not continue until esc is released
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE)

    ' Not needed again, so unload now
    Set exGroundBack = Nothing
    

End Sub





Sub ExDlogoLoop()

    Dim intN As Integer
    
    Dim intTxtCon As Integer
    
    Dim timControl As New exTools_Timer
    
    Dim ExDlogo_E As New exMesh
    Dim ExDlogo_x As New exMesh
    Dim ExDlogo_D As New exMesh
    Dim ExDlogo_text As New exMesh
    
    'Dim ExTxtPres As New ex2DText
    
    ' Sounds...
    Dim sndExDlogo   As New exSound
    
    
    
    Dim blnLoop               As Boolean
          
    'Load sounds
    sndExDlogo.InitSound App.Path & "\..\ex-d mono.wav"


    ' Load the 3D discriptions...
    
    ExDlogo_E.InitXFile App.Path & "\data\menu\ex-d_logo\E.x", App.Path & "\data\menu\ex-d_logo\e.bmp"
    ExDlogo_x.InitXFile App.Path & "\data\menu\ex-d_logo\x.x", App.Path & "\data\menu\ex-d_logo\x.bmp"
    ExDlogo_D.InitXFile App.Path & "\data\menu\ex-d_logo\-d.x", App.Path & "\data\menu\ex-d_logo\d.bmp"
    ExDlogo_text.InitXFile App.Path & "\data\menu\ex-d_logo\text.x", App.Path & "\data\menu\ex-d_logo\text.bmp"

   
    intTxtCon = 0
    
    ExTxtGUI.position (frmMain.ScaleWidth / 2) - (frmMain.ScaleWidth / 10), frmMain.ScaleHeight / 2
    
    
    blnLoop = True
    
    ExPrj.BackColour &H0
    
    ExCam.position 1, 1, 450, True
    
    
    
    timControl.ReSet

    ' Set Animations
    ExDlogo_E.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(90, 180, 1), ExPrj.exReturn3DVec(90, 180, 90), 3
    ExDlogo_E.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(1, 1, 1), ExPrj.exReturn3DVec(600, 1, 1), 3
    
    ExDlogo_x.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(90, 180, 1), ExPrj.exReturn3DVec(-270, 180, 1), 2
    ExDlogo_x.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(1, 1, 1), ExPrj.exReturn3DVec(1, 1, -5500), 2
    
    ExDlogo_D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(90, 180, 1), ExPrj.exReturn3DVec(90, 180, -90), 3
    ExDlogo_D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(1, 1, 1), ExPrj.exReturn3DVec(-600, 1, 1), 3
    
    ExDlogo_text.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(90, 180, 1), ExPrj.exReturn3DVec(270, 180, 1), 3
    ExDlogo_text.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(1, 1, 1), ExPrj.exReturn3DVec(1, 1, -700), 3

    ExDlogo_E.position 1, 1, 1, True
    
    sndExDlogo.PlaySound False
    
    intN = 1
    
    
    ' The main loop. Each loop represents one frame.
    Do
        
        ' Animation Control
        Select Case intN
        
            Case 1
            
                If timControl.LocalTime > 5 Then
                   
                    ExDlogo_x.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(290, 250, 150), ExPrj.exReturn3DVec(90, 180, 1), 3
                    ExDlogo_x.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(1, 1, -7000), ExPrj.exReturn3DVec(1, 1, 1), 3
                    
                    intN = 2
                End If
            
            Case 2
                ExDlogo_x.Render
                
                ExDlogo_E.position ExDlogo_x.position().x, ExDlogo_x.position().y, ExDlogo_x.position().z, True
                ExDlogo_D.position ExDlogo_x.position().x, ExDlogo_x.position().y, ExDlogo_x.position().z, True
                ExDlogo_text.position ExDlogo_x.position().x, ExDlogo_x.position().y, ExDlogo_x.position().z, True
                
                ExDlogo_E.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().z, True
                ExDlogo_D.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().z, True
                ExDlogo_text.Rotate ExDlogo_x.Rotate().x, ExDlogo_x.Rotate().y, ExDlogo_x.Rotate().z, True
                
            
            
                If timControl.LocalTime > 7 Then
                    'intN = 3
                    'ExPrj.BackColour &HFFFFFF
                    blnLoop = False
                End If
                
            Case 3
                
'                'Debug.Print Str(((timControl.LocalTime - 7) / 0.15) * 16)
'
'
'            '    ExTxtGUI.Colour (CLng(Val(Trim(Str(((timControl.LocalTime - 7) / 0.15) * 16)))) ^ 2) + lTxtCol
'
'                If timControl.LocalTime > 7 + (intTxtCon * 0.25) Then
'                    intTxtCon = intTxtCon + 1
'                End If
'                If timControl.LocalTime > 9 Then
'                    intTxtCon = 8
'                    blnLoop = False
'                End If
            
        End Select
        
        ' Start of Rendering process...
        ExPrj.Render

        
        ' Render the discriptions...
        If intN <> 3 Then
            ExDlogo_E.Render
            ExDlogo_x.Render
            ExDlogo_D.Render
            ExDlogo_text.Render
        Else
            ExTxtGUI.Text Mid("PRESENTS", 1, intTxtCon)
            ExTxtGUI.Render
        End If
        

        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False Or ExInp.exInput(ex_ESCAPE)
    
    ' Do not continue until esc is released
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE)

    ' Not needed again, so unload now
    Set ExDlogo_E = Nothing
    Set ExDlogo_x = Nothing
    Set ExDlogo_D = Nothing
    Set ExDlogo_text = Nothing
    Set sndExDlogo = Nothing

'    Set sndExDlogo = Nothing
    

End Sub


Function OptionMenu() As Integer
    
    Dim blnLoop  As Boolean
    Dim n As Integer
    Dim iSelPlayer As Integer
    Dim sFileToRead As String
        
    Dim sPlayers() As String
    
    Dim iSettings(3) As Single
    Dim sTemp As Integer
    
    Dim iSelOption As Integer
    
    Dim iLastMove As Integer
    
    Do
        iSelPlayer = SelectPlayerMenu(1)
        If iSelPlayer = 0 Then NewPlayer
    Loop While iSelPlayer = 0 Or iSelPlayer = -1
    
    
    ' Read names from file
    If FileExists(App.Path & "\data\players\names.dat") Then
        Open App.Path & "\data\players\names.dat" For Input As #1
            n = 0
            Do While Not EOF(1)
                n = n + 1
                ReDim Preserve sPlayers(n)
                Input #1, sPlayers(n)
            Loop
        Close #1
    Else
        ReDim Preserve sPlayers(0)
    End If
    
    ' Read settings from file for selected player
    sFileToRead = App.Path & "\data\players\" & sPlayers(iSelPlayer) & "\options.dat"
    If Not (FileExists(sFileToRead)) Then
        sFileToRead = App.Path & "\data\players\new\options.dat"
    End If
    ' Read file
    Open sFileToRead For Input As #1
        ' game speed(0.25 - 5#)
        Input #1, sTemp
        iSettings(1) = Val(sTemp)
        ' Sound volume / off
        Input #1, sTemp
        iSettings(2) = Val(sTemp)
        ' music volume / off
        Input #1, sTemp
        iSettings(3) = Val(sTemp)
    Close #1
    
        
     ' Do not continue until dependent keys are de-pressed
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return)
    
    
    blnLoop = True
    iSelOption = 1
    iLastMove = 0
    
    Do

        If iLastMove <> 0 And Not (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Down_arrow) _
          Or ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Up_arrow)) And blnLoop Then
            
            iLastMove = 0
           
        End If
            
        If iLastMove = 0 And (ExInp.exInput(ex_Right_arrow) Or ExInp.exInput(ex_Down_arrow)) Then
                    
            iLastMove = 1
                    
            If ExInp.exInput(ex_Down_arrow) Then
            
                iSelOption = iSelOption + 1
                If iSelOption > 3 Then iSelOption = 1
            Else
                ' Change selected option
                Select Case iSelOption
                    Case 1
                        iSettings(1) = iSettings(1) + (iSettings(1) / 5)
                        If iSettings(1) > 5 Then iSettings(1) = 5
                        If iSettings(1) > 0.9 And iSettings(1) < 1.1 Then iSettings(1) = 1
                        iSettings(1) = FormatNumber(iSettings(1), 2)
                        
                    Case 2
                        iSettings(2) = iSettings(2) + 5
                        If iSettings(2) > 100 Then iSettings(2) = 100
                        iSettings(2) = FormatNumber(iSettings(2), 0)
                        
                    Case 3
                        iSettings(3) = iSettings(3) + 5
                        If iSettings(3) > 100 Then iSettings(3) = 100
                        iSettings(3) = FormatNumber(iSettings(3), 0)
                    
                End Select
            End If
            
        ElseIf (iLastMove = 0 And (ExInp.exInput(ex_Left_arrow) Or ExInp.exInput(ex_Up_arrow))) Then
            iLastMove = -1
            
            If ExInp.exInput(ex_Up_arrow) Then
                
                iSelOption = iSelOption - 1
                    
                ' Wrap menu nav
                If iSelOption < 1 Then iSelOption = 3
            Else
                ' Change selected option
                Select Case iSelOption
                    Case 1
                        iSettings(1) = iSettings(1) - (iSettings(1) / 5)
                        If iSettings(1) < 0.25 Then iSettings(1) = 0.25
                        If iSettings(1) > 0.9 And iSettings(1) < 1.1 Then iSettings(1) = 1
                        iSettings(1) = FormatNumber(iSettings(1), 2)
                        
                        
                    Case 2
                        iSettings(2) = iSettings(2) - 5
                        If iSettings(2) < 0 Then iSettings(2) = 0
                        iSettings(2) = FormatNumber(iSettings(2), 0)
                        
                    Case 3
                        iSettings(3) = iSettings(3) - 5
                        If iSettings(3) < 0 Then iSettings(3) = 0
                        iSettings(3) = FormatNumber(iSettings(3), 0)
                    
                End Select
            End If
            
        End If
        
        If ExInp.exInput(ex_Return) Then                        ' Exit with save
                
            ' Save to file
            Open App.Path & "\data\players\" & sPlayers(iSelPlayer) & "\options.dat" For Output As #1
                ' game speed(0.25 - 5#)
                For n = 1 To 3
                    Print #1, Str(iSettings(n))
                Next n
            Close #1

            blnLoop = False
        End If
        
        If ExInp.exInput(ex_ESCAPE) Then blnLoop = False        ' Exit without save
        
        
    
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...

        exSky.Render
        
        exUnderGround.Render
        
        exRepHolder.Render
        exRepton.Render
                                
        exReturnsHL.Render
        
        ' OPTIONS text
        ExTxtGUI.Colour &HFF00A000
        ExTxtGUI.position 350, 200
        ExTxtGUI.Text "- OPTIONS -"
        ExTxtGUI.Render
        
        If iSelOption <> 1 Then ExTxtGUI.Colour &HFF00A000 Else ExTxtGUI.Colour &HFF99FF99
        ExTxtGUI.position 155, 290
        ExTxtGUI.Text "GAME SPEED: X" & Str(iSettings(1))
        ExTxtGUI.Render
                
        If iSelOption <> 2 Then ExTxtGUI.Colour &HFF00A000 Else ExTxtGUI.Colour &HFF99FF99
        ExTxtGUI.position 100, 330
        ExTxtGUI.Text "SOUND VOLUME: " & Str(iSettings(2)) & "%"
        ExTxtGUI.Render
        
        If iSelOption <> 3 Then ExTxtGUI.Colour &HFF00A000 Else ExTxtGUI.Colour &HFF99FF99
        ExTxtGUI.position 110, 370
        ExTxtGUI.Text "MUSIC VOLUME: " & Str(iSettings(3)) & "%"
        ExTxtGUI.Render
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False
    
End Function


Function AboutTitles() As Integer

    Dim sLines() As String
    
    Dim blnLoop  As Boolean
    Dim n As Integer
    
    Dim iNumLines  As Integer
    
    Dim exTimer As New exTools_Timer
    Dim sTimeToTake As Single
        
    Dim exMusicTimer As New exTools_Timer
        
    sTimeToTake = 100
        
    OpenFMOD App.Path & "\data\music\Meed.mp3"
    VolumeFMOD 80
    
    ' Read lines from file
    'on error reume next
    Open App.Path & "\data\about.dat" For Input As #1
        iNumLines = 0
        Do
            iNumLines = iNumLines + 1
            ReDim Preserve sLines(iNumLines)
            Input #1, sLines(iNumLines)
        Loop Until EOF(1)
    Close #1
    
    
        
     ' Do not continue until dependent keys are de-pressed
    Do
        DoEvents
    Loop While ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return)
    
    PlayFMOD
    exMusicTimer.ReSet
    
    blnLoop = True
    
    exTimer.ReSet
    
    Do

        
        If ExInp.exInput(ex_ESCAPE) Or ExInp.exInput(ex_Return) Then
            blnLoop = False
        End If
        
        If exTimer.LocalTime > sTimeToTake + 5 Then
            exTimer.ReSet
        End If
        
        If exMusicTimer.LocalTime > 31.5 Then
            PlayFMOD
            exMusicTimer.ReSet
        End If
        
    
        ' Start of Rendering process...
        ExPrj.Render
        
        ' Render the discriptions...

        exSky.Render
        
        exUnderGround.Render
        
        exRepHolder.Render
        exRepton.Render
                                
        exReturnsHL.Render
        
        ' About info
        ExTxtMsg.Colour &HFF00A000

        For n = 1 To iNumLines
            ExTxtGUI.position 40, 200 + (n * 40) - ((exTimer.LocalTime / sTimeToTake) * (sTimeToTake * 15)) + (frmMain.iYsize * 0.7)
            
            ExTxtGUI.Text sLines(n)
            
            ExTxtGUI.Render
        Next n
        
        
        
        ' Finally flip the buffers, completing the rendering process.
        ExPrj.Sync


        ' Allow other VB events to process.
        DoEvents

    Loop Until blnLoop = False
    
End Function

Sub DeInit()
'Dim exDummyLookAt    As New exMesh
'
'Dim exStarGlimmer    As New exMesh
'Dim exFader          As New exMesh
'
'Dim exUnderGround    As New exMesh
'
'Dim exSky            As New exMesh
'Dim exRepHolder      As New exMesh
'Dim exRepton         As New exMesh
'Dim exReturns        As New exMesh
'Dim exReturnsHL      As New exMesh

End Sub
