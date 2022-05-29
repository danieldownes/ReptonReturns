Attribute VB_Name = "modReptonReturns"
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit


Public rrGame            As New cGame       ' Main game flow control (loading/exiting levels, etc)

Public pckGenFiles            As New cFilePackage
Public pckOrigThemeFiles      As New cFilePackage
Public pckLevelsFiles         As New cFilePackage



' ToDo: Put all following in 'cGame'::

Public Type type_Transporter
    iToX As Integer
    iToY As Integer
End Type

Public Type type_LevelTrans
    'tPos        As Corrds2D_T
    sLocalFile  As String
End Type


Public rrMap             As New cMap        ' The loaded level
Public rrRepton          As New cPlayer     ' A human player (Repton)
Public rrPieces()        As New cPiece      ' A piece on the level
Public rrRocksOrEggs()   As New cRockOrEgg  ' A rock or egg; moveable piece
Public rrMonster(4)      As New cMonster
Public rrSpirit(8)       As New cSpirt

Public tTransporters()   As type_Transporter
Public tLevelTrans()     As type_LevelTrans

Public sPrimPlayerName   As String
Public intPlayerLives    As Integer

Public fxParticles(15)   As New cGameFxParticle


'Dim intWallAround_LOOKUP(1, 1, 1, 1) As Integer       ' (2,4,6,8) - wall is there(1) or not(0) for each
                                                      '  Down [2], Left [4], Right [6], Up [8]  (KeyPad)
                                                      '  Used in 'GetWallAroundInfo'

'Dim timRockSndPlaying As New exTools_Timer
'Public bRockSndPlaying As Boolean

Dim iFPScount As Integer
Dim iFPSval As Integer
Dim sLastTime As Single
Dim sngTemp As Single

Dim intLastKeyPress As exInputKeys

Public Enum enmPieceType
    Space = 0
    Wall
    Dimond
    Wall8
    Wall2
    Wall6
    Wall4
    Wall9
    Wall7
    Wall3
    Wall1
    Earth
    Rock
    Safe
    Key
    Egg
    Repton
    Crown
    Cage
    Spirit
    Bomb
    Fungus
    Skull
    Barrier
    Monster
    Transporter
    TimeCapsule
    FilledWall
    FilledWall7
    FilledWall9
    FilledWall1
    FilledWall3
    NavigationalMap
    LevelTransport
End Enum



Function DrawFrame()
    
    Dim intObj As Integer
    
    Dim intX As Integer
    Dim intY As Integer
    
    Dim X As Integer
    Dim Y As Integer
    Dim sT As String
    
    ' Start of Rendering process
    ExPrj.Render
    
    
    ' Only render the pieces that are in view
    For intY = -5 To 4
        For intX = -6 To 6

            If GetPlayerOffsetPiece(intX, intY) <> -1 Then
                rrPieces(rrRepton.GetXPos + intX, rrRepton.GetYPos + intY).Render
            Else
                ' Default to a wall (this is outside the defined map)
                Ex3DP(1).position Ret3DPos(rrRepton.GetXPos + intX), Ret3DPos(rrRepton.GetYPos + intY), -240, True
                Ex3DP(1).Render
            End If


        Next intX
    Next intY
    
    
    ' Render monsters
    If rrMap.intTotMonsters <> 0 Then
        For intX = 1 To rrMap.intTotMonsters
            rrMonster(intX).Render
        Next intX
    End If
    
    ' Render spirits
    If rrMap.intTotSpirits <> 0 Then
        For intX = 0 To rrMap.intTotSpirits
            rrSpirit(intX).Render
        Next intX
    End If
    
    ' Update and Render the visual player
    rrRepton.UpDate
    
    ' Visual FXs
    For intX = 0 To UBound(fxParticles)
        fxParticles(intX).RenderInstences
    Next intX
    
    rrMap.RenderSceneryPieces
    
    
    If rrMap.intShowingMsg <> -1 Or ExMsgBoard.AnimatedTransform.active(Translation3D) = True Then ExMsgBoard.Render
    
    ' Render GUI
    
    ExTxtGUI.position 10, 10
    ExTxtGUI.Text "LEVEL: " & UCase(rrGame.strEpisodeName & " > " & rrGame.LevelOrder(rrGame.iCurGameLevel))
    ExTxtGUI.Render
    
    ExTxtGUI.position 10, 40
    ExTxtGUI.Text "DIAMONDS: " & rrMap.intTotDimonds - rrRepton.intDimondsCollected
    ExTxtGUI.Render
    
    ExTxtGUI.position 600, 10
    If intPlayerLives < 200 Then
        ExTxtGUI.Text "LIVES: " & Str(intPlayerLives)
    Else
        ExTxtGUI.Text "LIVES: UNLIMITED"
    End If
    ExTxtGUI.Render
    
    ' Time remaining
    ExTxtGUI.position 600, 40
    If rrMap.sngTimeBombOut <> -1 Then
        ExTxtGUI.Text "TIME: " & FormatNumber(rrMap.sngTimeLeft)    ' FormatNumber(rrMap.sngTimeBombOut - rrMap.timTimeBomb.LocalTime, 2)
    Else
        ExTxtGUI.Text "NO TIMER"
    End If
    ExTxtGUI.Render
    
    
    ExTxtGUI.position 10, 600
    
    If ExInp.exInput(ex_f) Then
        iFPScount = iFPScount + 1
        
'        ' Force frame limit (screen refresh limiter)
'        Do      ' This is totally wrong:
'            sngTemp = (rrMap.timTimeBomb.LocalTime - sLastTime)
'        Loop Until sngTemp >= (0.5)
        
        
        If rrMap.timTimeBomb.LocalTime - sLastTime >= 1 Then
            On Error Resume Next
              iFPSval = iFPScount / (rrMap.timTimeBomb.LocalTime - sLastTime)
            Resume
            iFPScount = 0
            sLastTime = rrMap.timTimeBomb.LocalTime
        End If
        ExTxtGUI.Text "FPS: " & Str(iFPSval)
    Else
        ExTxtGUI.Text "NAME: " & rrRepton.strName & "                 MONSTERS: " & Str(rrMap.intTotMonstersAlive)
    End If
    ExTxtGUI.Render
    
'    ' Debug helper
'    For y = rrMap.intMapSizeY To 1 Step -1
'        sT = ""
'        For x = 1 To rrMap.intMapSizeX
'            sT = sT & rrMap.GetData(x, y)
'        Next x
'        ExTxtMsg.Text sT
'        ExTxtMsg.position 200, 40 + (20 * y)
'        ExTxtMsg.Render
'    Next y
    
    
    ' Draw any In-Game Messages
    rrMap.MessageUpdate
    
    ' Finally flip the buffers, completing the rendering process.
    ExPrj.Sync



End Function


Function UserInteraction() As Boolean

    
    ' Check movement inputs
    ' If game is not paused then allow movment
    If rrGame.Pause(-2) = False Then
        If ExInp.exInput(ex_Right_arrow) Then rrRepton.Move Right
        If ExInp.exInput(ex_Left_arrow) Then rrRepton.Move Left
        If ExInp.exInput(ex_Down_arrow) Then rrRepton.Move Down
        If ExInp.exInput(ex_Up_arrow) Then rrRepton.Move Up
        If ExInp.exInput(ex_d) Then rrRepton.Die
    End If
    
    If ExInp.exInput(ex_p) Then
        If intLastKeyPress <> ex_p Then
           If rrGame.Pause(-2) = True Then
                rrGame.Pause -1
            Else
                rrGame.Pause 0
            End If
            intLastKeyPress = ex_p
        End If
    Else
        intLastKeyPress = 0
    End If
    
    'If ExInp.exInput(ex_a) Then msgbox(str(Ex3DP(
    
    ' If ExInp.exInput(ex_f2) Then prj.ChangeRenderDevice
    
    
    If ExInp.exInput(ex_ESCAPE) Then UserInteraction = True
    
    
    
End Function

' This may be out of place
Function StartParticleFountian(X As Integer, Y As Integer, sType As String) As Integer
    Dim n As Integer
    
    ' Find an availible emitter
    StartParticleFountian = -1
    Do
        StartParticleFountian = StartParticleFountian + 1
        If StartParticleFountian > UBound(fxParticles) Then StartParticleFountian = -1: Debug.Print "no particles": Exit Function
    Loop While fxParticles(StartParticleFountian).bIsAlive

    Select Case sType
        Case "repton_walk8"     ' Up
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 6.5, _
                                0, -0.2, -0.2, _
                                3 / rrGame.sngGameSpeed
                                            
                                
        Case "repton_walk2"     ' Down
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                0, 0.4, -1, _
                                0.25 / rrGame.sngGameSpeed
                            
        Case "repton_walk4"     ' Left
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                -0.4, 0, -1, _
                                0.25 / rrGame.sngGameSpeed
                                
        Case "repton_walk6"     ' Right
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                0.4, 0, -1, _
                                0.25 / rrGame.sngGameSpeed
                                
        Case "dig8"     ' Up
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                0, -0.4, -1, _
                                0.25 / rrGame.sngGameSpeed
                                
        Case "dig2"     ' Down
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                0, 0.4, -1, _
                                0.25 / rrGame.sngGameSpeed
                            
        Case "dig4"     ' Left
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                -0.4, 0, -1, _
                                0.25 / rrGame.sngGameSpeed
                                
        Case "dig6"     ' Right
            fxParticles(StartParticleFountian).Init Ret3DPos(X), Ret3DPos(Y), -220, _
                                0, 0, 1.5, _
                                0.4, 0, -1, _
                                0.25 / rrGame.sngGameSpeed
        
        
    End Select
    
    'test
    fxParticles(StartParticleFountian).fHzRevsX = 4
    fxParticles(StartParticleFountian).fHzRevsY = 6
    fxParticles(StartParticleFountian).fHzRevsZ = 12
    fxParticles(StartParticleFountian).fHzRevsXoffset = 15
    fxParticles(StartParticleFountian).fHzRevsYoffset = 15
    fxParticles(StartParticleFountian).fHzRevsZoffset = 15
    fxParticles(StartParticleFountian).fEmitBoundBoxRadiusX = 45
    fxParticles(StartParticleFountian).fEmitBoundBoxRadiusY = 45
    fxParticles(StartParticleFountian).fEmitBoundBoxRadiusZ = 45
End Function


Function SetupLevel(Optional bTransporting As Boolean = False) As Integer
' 0 = Okay
' 1 = Error while processing map

    Dim intX As Integer
    Dim intY As Integer
    
    Dim strThemeDir As String
    
    'Dim aVisTheme As New cPackedFile
    
    
    Randomize
    
    ' Get Full Dir Path of theme
    rrGame.strVisualTheme = App.Path & "\data\themes\origonal"
    strThemeDir = App.Path & "\data\themes\origonal"

    ExCam.position 0.001, -150, -1300, True
    ExCam.LookAt 0.001, -200, -999
  StartFader 0.3
  DisplayLoadingScr 1, 17 + rrMap.intMapSizeY
    
    ' Load meshes...   (note that Ex-Perspective horizontaliy flips the screen output and that the
    '                    actual file data does not respect this; NB: walls will use their opposit
    '                    equivalent; e.g wall4 = the image that would normally show wall6)
    
    'Ex3DP(enmPieceType.Space).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\space.bmp"
    
    Ex3DP(enmPieceType.Dimond).InitXFile pckOrigThemeFiles.GetPackedFile("diamond.x")
    'Ex3DP(enmPieceType.Dimond).RotateVecs 180, 3, 0
    
    Ex3DP(enmPieceType.Wall).InitXFile pckOrigThemeFiles.GetPackedFile("w5.x"), pckOrigThemeFiles.GetPackedFile("wall.bmp")
    Ex3DP(enmPieceType.Wall8).InitXFile pckOrigThemeFiles.GetPackedFile("w8.x"), pckOrigThemeFiles.GetPackedFile("wall8.bmp")
    Ex3DP(enmPieceType.Wall2).InitXFile pckOrigThemeFiles.GetPackedFile("w2.x"), pckOrigThemeFiles.GetPackedFile("wall2.bmp")
    Ex3DP(enmPieceType.Wall4).InitXFile pckOrigThemeFiles.GetPackedFile("w6.x"), pckOrigThemeFiles.GetPackedFile("wall6.bmp")
    Ex3DP(enmPieceType.Wall6).InitXFile pckOrigThemeFiles.GetPackedFile("w4.x"), pckOrigThemeFiles.GetPackedFile("wall4.bmp")
    Ex3DP(enmPieceType.Wall9).InitXFile pckOrigThemeFiles.GetPackedFile("w7.x"), pckOrigThemeFiles.GetPackedFile("wall7.bmp")
    Ex3DP(enmPieceType.Wall7).InitXFile pckOrigThemeFiles.GetPackedFile("w9.x"), pckOrigThemeFiles.GetPackedFile("wall9.bmp")
    Ex3DP(enmPieceType.Wall3).InitXFile pckOrigThemeFiles.GetPackedFile("w1.x"), pckOrigThemeFiles.GetPackedFile("wall1.bmp")
    Ex3DP(enmPieceType.Wall1).InitXFile pckOrigThemeFiles.GetPackedFile("w3.x"), pckOrigThemeFiles.GetPackedFile("wall3.bmp")
  
  DisplayLoadingScr 2, 17 + rrMap.intMapSizeY
  
    Ex3DP(11).InitXFile pckOrigThemeFiles.GetPackedFile("earth0.x"), pckOrigThemeFiles.GetPackedFile("earth.bmp")
    Ex3DP(11).Rotate 90, 0, 0, True
    
  DisplayLoadingScr 3, 17 + rrMap.intMapSizeY

    Ex3DP(13).InitXFile pckOrigThemeFiles.GetPackedFile("safe.x")
    Ex3DP(14).InitXFile pckOrigThemeFiles.GetPackedFile("key.x")
    
  DisplayLoadingScr 4, 17 + rrMap.intMapSizeY
  
    Ex3DP(17).InitXFile pckOrigThemeFiles.GetPackedFile("crown.x")
    Ex3DP(18).InitXFile pckOrigThemeFiles.GetPackedFile("cage.x")
    Ex3DP(19).InitXFile pckOrigThemeFiles.GetPackedFile("spirit.x"), pckOrigThemeFiles.GetPackedFile("spirit.bmp")
  DisplayLoadingScr 5, 17 + rrMap.intMapSizeY
    Ex3DP(20).InitXFile pckOrigThemeFiles.GetPackedFile("time-bomb.x"), pckOrigThemeFiles.GetPackedFile("time-bomb.bmp")
    Ex3DP(20).Rotate 90, 0, 0, True
    Ex3DP(21).InitXFile pckOrigThemeFiles.GetPackedFile("fungus.x"), pckOrigThemeFiles.GetPackedFile("fungus.bmp")
    Ex3DP(21).Rotate 90, 180, 0, True
    Ex3DP(22).InitXFile pckOrigThemeFiles.GetPackedFile("skull.x")
    Ex3DP(23).InitXFile pckOrigThemeFiles.GetPackedFile("barrier.x")
    Ex3DP(24).InitXFile pckOrigThemeFiles.GetPackedFile("monster.x"), pckOrigThemeFiles.GetPackedFile("monster.bmp")
    Ex3DP(24).Rotate 90, 0, 0, True
    Ex3DP(25).InitXFile pckOrigThemeFiles.GetPackedFile("transporter.x"), pckOrigThemeFiles.GetPackedFile("transporter.bmp")
    Ex3DP(25).Rotate 90, 0, 0, True
    Ex3DP(26).InitXFile pckOrigThemeFiles.GetPackedFile("time-capsule.x")
    Ex3DP(26).Rotate 90, 0, 0, True
    
  DisplayLoadingScr 6, 17 + rrMap.intMapSizeY
    
    
    Ex3DP(27).InitXFile pckOrigThemeFiles.GetPackedFile("stag5.x"), pckOrigThemeFiles.GetPackedFile("stags.bmp")
    Ex3DP(28).InitXFile pckOrigThemeFiles.GetPackedFile("stag1.x"), pckOrigThemeFiles.GetPackedFile("stags.bmp")
    Ex3DP(29).InitXFile pckOrigThemeFiles.GetPackedFile("stag3.x"), pckOrigThemeFiles.GetPackedFile("stags.bmp")
    Ex3DP(30).InitXFile pckOrigThemeFiles.GetPackedFile("stag7.x"), pckOrigThemeFiles.GetPackedFile("stags.bmp")
    Ex3DP(31).InitXFile pckOrigThemeFiles.GetPackedFile("stag9.x"), pckOrigThemeFiles.GetPackedFile("stags.bmp")
  DisplayLoadingScr 7, 17 + rrMap.intMapSizeY
    For intX = 27 To 31
        Ex3DP(intX).Rotate 90, 0, 0, True
    Next intX
    
    'Ex3DP(32).InitXFile strThemeDir & "\meshes\nav-map.x", strThemeDir & "\textures\nav-map.bmp"
    
    Ex3DP(33).InitXFile pckOrigThemeFiles.GetPackedFile("level-trans.x")
  DisplayLoadingScr 8, 17 + rrMap.intMapSizeY
    ' Ground meshes
    'For intX = 0 To 15
        Ex3DGround(0).InitXFile pckOrigThemeFiles.GetPackedFile("ground.x"), pckOrigThemeFiles.GetPackedFile("grounds.bmp")
        Ex3DGround(0).Rotate 90, 0, 0, True
    'Next intX

  DisplayLoadingScr 9, 17 + rrMap.intMapSizeY
    
    ' Wall sides
    
    Ex3DWallSides(0).InitXFile pckOrigThemeFiles.GetPackedFile("s2.x"), pckOrigThemeFiles.GetPackedFile("stdwall_side.bmp")
    Ex3DWallSides(1).InitXFile pckOrigThemeFiles.GetPackedFile("s4.x"), pckOrigThemeFiles.GetPackedFile("stdwall_side.bmp")
    Ex3DWallSides(2).InitXFile pckOrigThemeFiles.GetPackedFile("s6.x"), pckOrigThemeFiles.GetPackedFile("stdwall_side.bmp")
    Ex3DWallSides(3).InitXFile pckOrigThemeFiles.GetPackedFile("s8.x"), pckOrigThemeFiles.GetPackedFile("stdwall_side.bmp")
    Ex3DWallSides(0).Rotate 90, 180, 0, True
    'Ex3DWallSides(0).RotateVecs 0, 180, 0
    Ex3DWallSides(1).Rotate 90, 180, 0, True
    Ex3DWallSides(2).Rotate 90, 180, 0, True
    Ex3DWallSides(3).Rotate 90, 180, 0, True
    
  DisplayLoadingScr 10, 17 + rrMap.intMapSizeY
    
    ' Load Particle fragments
'    Ex3DParticles(0).InitXFile App.Path & "\part1.x", App.Path & "\green_part.bmp"
'    Ex3DParticles(1).InitXFile App.Path & "\part2.x", App.Path & "\green_part.bmp"
'    Ex3DParticles(2).InitXFile App.Path & "\part3.x", App.Path & "\green_part.bmp"
'    Ex3DParticles(3).InitXFile App.Path & "\part_rubble1.x", pckOrigThemeFiles.GetPackedFile("grounds.bmp")
'    Ex3DParticles(4).InitXFile App.Path & "\part_rubble2.x", pckOrigThemeFiles.GetPackedFile("grounds.bmp")
'    Ex3DParticles(5).InitXFile App.Path & "\part_rubble3.x", pckOrigThemeFiles.GetPackedFile("grounds.bmp")

    ' Egg fragments
    Ex3DParticles(0).InitXFile App.Path & "\part_egg1.x", pckOrigThemeFiles.GetPackedFile("egg.bmp")
    Ex3DParticles(1).InitXFile App.Path & "\part_egg2.x", pckOrigThemeFiles.GetPackedFile("egg.bmp")
    Ex3DParticles(2).InitXFile App.Path & "\part_egg3.x", pckOrigThemeFiles.GetPackedFile("egg.bmp")

    
  
  DisplayLoadingScr 11, 17 + rrMap.intMapSizeY
    
    ' Scenery pieces
    rrMap.LoadSceneryPieces

  DisplayLoadingScr 12, 17 + rrMap.intMapSizeY
    
    rrRepton.Init
    rrRepton.bVisFocus = True
    
    modRR_GameEvents.FungusNewTime
    
  DisplayLoadingScr 13, 17 + rrMap.intMapSizeY
    
    ' Load sounds...
    ExSnds(0).InitSound pckOrigThemeFiles.GetPackedFile("m_dimond.wav")
    ExSnds(1).InitSound pckOrigThemeFiles.GetPackedFile("m_dimond.wav")
    ExSnds(2).InitSound pckOrigThemeFiles.GetPackedFile("m_dimond.wav")
    ExSnds(3).InitSound pckOrigThemeFiles.GetPackedFile("m_dimond.wav")
    ExSnds(4).InitSound pckOrigThemeFiles.GetPackedFile("rock_fall.wav")
    ExSnds(5).InitSound pckOrigThemeFiles.GetPackedFile("rock_crash.wav")
    ExSnds(6).InitSound pckOrigThemeFiles.GetPackedFile("crown.wav")
  DisplayLoadingScr 14, 17 + rrMap.intMapSizeY
    ExSnds(7).InitSound pckOrigThemeFiles.GetPackedFile("egg_cracking.wav")
    ExSnds(8).InitSound pckOrigThemeFiles.GetPackedFile("egg_crunch.wav")
    ExSnds(9).InitSound pckOrigThemeFiles.GetPackedFile("spirit_caught.wav")
    ExSnds(10).InitSound pckOrigThemeFiles.GetPackedFile("spirit_near.wav")
    ExSnds(11).InitSound pckOrigThemeFiles.GetPackedFile("time_cap.wav")
    ExSnds(12).InitSound pckOrigThemeFiles.GetPackedFile("transporter.wav")
  DisplayLoadingScr 15, 17 + rrMap.intMapSizeY
    If Not (bTransporting) Then ExSnds(13).InitSound pckOrigThemeFiles.GetPackedFile("level-trans.wav")
    ExSnds(14).InitSound pckOrigThemeFiles.GetPackedFile("key.wav")
    ExSnds(15).InitSound pckOrigThemeFiles.GetPackedFile("fungus.wav")
    ExSnds(16).InitSound pckOrigThemeFiles.GetPackedFile("dig.wav")
    ExSnds(17).InitSound pckOrigThemeFiles.GetPackedFile("monster_awake.wav")
  DisplayLoadingScr 16, 17 + rrMap.intMapSizeY
    ExSnds(18).InitSound pckOrigThemeFiles.GetPackedFile("monster_die.wav")
    ExSnds(19).InitSound pckOrigThemeFiles.GetPackedFile("rep_die.wav")
    ExSnds(20).InitSound pckOrigThemeFiles.GetPackedFile("bomb_explosion.wav")
    
    For intX = 0 To UBound(ExSnds)
        ExSnds(intX).VolumeFadeTo rrGame.sngSfxVol, 0.001
    Next intX
    
    ExMsgBoard.InitXFile pckGenFiles.GetPackedFile("msg_board.x")
  
  DisplayLoadingScr 16, 17 + rrMap.intMapSizeY
  StartFader 3
  
    rrMap.intTotRocksOrEggs = 0
    rrMap.intTotEggs = 0
    rrMap.intTotMonstersAlive = 0
    rrMap.intTotMonsters = 0
    rrMap.intTotSpirits = 0
    rrMap.intTotDimonds = 0
    rrMap.intTotFunguses = 0
    rrMap.intTotTransporters = 0
    rrMap.intTotLevelTrans = 0
    
    
'    timRockSndPlaying.ReSet
    
   For intY = 1 To rrMap.intMapSizeY
  
      DisplayLoadingScr 16 + intY, 17 + rrMap.intMapSizeY
  
      For intX = 1 To rrMap.intMapSizeX
        
         rrPieces(intX, intY).intRockOrEggID = -1
         rrPieces(intX, intY).intMonsterID = -1
         rrPieces(intX, intY).SetPosition intX, intY
                  
         ' Set up any relevent propaties for each piece
         Select Case rrPieces(intX, intY).TypeID
'            Case "0"    'Space...
'            Case "5"
            Case "d"    'Dimond
                
                ' Keep track of total dimonds
                rrMap.intTotDimonds = rrMap.intTotDimonds + 1
                
'            Case "8"    'Walls...
'            Case "2"
'            Case "6"
'            Case "4"
'            Case "9"
'            Case "7"
'            Case "3"
'            Case "1"
'            Case "e"   'Earth
            Case "r"   'Rock
                ReDim Preserve rrRocksOrEggs(rrMap.intTotRocksOrEggs)
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).Init Rock, intX, intY
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).intMyRockOrEggID = rrMap.intTotRocksOrEggs
                rrPieces(intX, intY).intRockOrEggID = rrMap.intTotRocksOrEggs
                rrMap.intTotRocksOrEggs = rrMap.intTotRocksOrEggs + 1
            
            Case "s"   'Safe
                
                ' Keep track of total dimonds
                rrMap.intTotDimonds = rrMap.intTotDimonds + 1
            
'            Case "k"   'Key

            Case "g"   'Egg
                rrMap.intTotEggs = rrMap.intTotEggs + 1
                
                ReDim Preserve rrRocksOrEggs(rrMap.intTotRocksOrEggs)
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).Init Egg, intX, intY
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).intMyRockOrEggID = rrMap.intTotRocksOrEggs
                rrPieces(intX, intY).intRockOrEggID = rrMap.intTotRocksOrEggs
                rrMap.intTotRocksOrEggs = rrMap.intTotRocksOrEggs + 1
                
                
                ' Init a monster for this egg
                rrMap.intTotMonsters = rrMap.intTotMonsters + 1
                rrMonster(rrMap.intTotMonsters).Init intX, intY
                rrMonster(rrMap.intTotMonsters).intMyID = rrMap.intTotMonsters
                
            
            Case "i"   'Repton stating point
               
                ' Set starting position of objects...
                rrRepton.intOldX = intX
                rrRepton.intOldY = intY
               
               
                
            Case "t"   'Crown
                rrMap.intTotCrowns = rrMap.intTotCrowns + 1

            Case "c"   'Cage
                rrMap.intTotDimonds = rrMap.intTotDimonds + 1
                
            Case "p"   ' Spirit stating point
                rrSpirit(rrMap.intTotSpirits).Init intX, intY
                
                rrMap.intTotSpirits = rrMap.intTotSpirits + 1
                
                ' Ok, now remove refernce from logical map (all spirts are rendered on each frame)
                '  because, spirits do not always requirer a map piece to be a 'Space' in order to move to
                '  that piece.
                rrMap.SetData intX, intY, Space
                rrPieces(intX, intY).TypeID = DataInt2Str(Space)     ' ...and visual object, there is
                                                                     '  a seperret visual object for spirits
            Case "b"   'Bomb
            
            Case " "  'Space
            
            Case "f"    ' Fungus
                rrMap.intTotFunguses = rrMap.intTotFunguses + 1
            
            Case "u"    ' Skull
            
            Case "n"    ' Transport
                rrMap.intTotTransporters = rrMap.intTotTransporters + 1
                rrPieces(intX, intY).intTransporterID = rrMap.intTotTransporters
                
            Case "y"    ' Level-Transport
                rrMap.intTotLevelTrans = rrMap.intTotLevelTrans + 1
                rrPieces(intX, intY).intTransporterID = rrMap.intTotLevelTrans
            
            Case Else 'Error!
                
                
        
        End Select
        
      Next intX
   Next intY
   
   ' Now properly set Repton starting position (this is done here, because it moves the cam and effects nice lever loading fader)
   rrRepton.SetPosition rrRepton.intOldX, rrRepton.intOldY
   
   ' Start time-bomb
   rrMap.timTimeBomb.ReSet

End Function


Function DeinitLevel() As Integer
' 0 = Okay
' 1 = Error while processing map

    'Dim intX As Integer
    'Dim intY As Integer
    
    Dim n As Integer
    
    'Dim strThemeDir As String
    
    'Randomize
    
    ' Get Full Dir Path of theme
    'rrGame.strVisualTheme = App.Path & "\data\themes\origonal"
     'strThemeDir = App.Path & "\data\themes\origonal"
    
    For n = 0 To UBound(rrRocksOrEggs)      ' This is near top because rock- falling-sound needs to be shut off ASAP
        rrRocksOrEggs(n).DeInit
        Set rrRocksOrEggs(n) = Nothing
    Next n
    
    For n = 1 To UBound(Ex3DP)
        Set Ex3DP(n) = Nothing
    Next n
        
'    For n = 0 To 15
        Set Ex3DGround(0) = Nothing
'    Next n
    
    ' Visual FXs
    For n = 0 To UBound(fxParticles)
        Set fxParticles(n) = Nothing
    Next n
    
    For n = 0 To 3
        Set Ex3DWallSides(n) = Nothing
    Next n
    ' Scenery pieces
    rrMap.DeinitScenery
    Set rrMap = Nothing
    Set rrRepton = Nothing
    
    For n = 0 To UBound(rrSpirit)
        Set rrSpirit(n) = Nothing
    Next n
    
    
    Set ExMsgBoard = Nothing

End Function




Function GetPlayerOffsetPiece(intX As Integer, intY As Integer) As Integer
' -1 = No piece (off the edge of the map)
' Else the piece int ID is returned

    Dim ix As Integer
    Dim iY As Integer

    ' Calculate its position
    ix = rrRepton.GetXPos + intX
    iY = rrRepton.GetYPos + intY

    ' Check if this is a piece off the edge of the map...
    '  Left, Top, Right, Bottom
 
    If ix < 1 Or iY < 1 Or ix > rrMap.intMapSizeX Or iY > rrMap.intMapSizeY Then
       
            ' Flat wall
            GetPlayerOffsetPiece = -1  'enmPieceType.Wall
            
            Exit Function
            
    End If
    
    
        'THIS data is not needed, just make sure it isn't -1
    'GetPlayerOffsetPiece = DataStr2Int(rrPieces(iX, iY).TypeID)
    GetPlayerOffsetPiece = 0
    
End Function

'Sub SetupWallAroundInfo_LookUpTable()
'
'    '                    2  4  6  8    TypeOfFloor
'    intWallAround_LOOKUP(0, 0, 0, 0) = 5
'    intWallAround_LOOKUP(0, 0, 0, 1) = 8
'    intWallAround_LOOKUP(0, 0, 1, 0) = 6
'    intWallAround_LOOKUP(0, 0, 1, 1) = 9
'
'    intWallAround_LOOKUP(0, 1, 0, 0) = 4
'    intWallAround_LOOKUP(0, 1, 0, 1) = 7
'    intWallAround_LOOKUP(0, 1, 1, 0) = 10
'    intWallAround_LOOKUP(0, 1, 1, 1) = 14
'
'    intWallAround_LOOKUP(1, 0, 0, 0) = 2
'    intWallAround_LOOKUP(1, 0, 0, 1) = 11
'    intWallAround_LOOKUP(1, 0, 1, 0) = 3
'    intWallAround_LOOKUP(1, 0, 1, 1) = 15
'
'    intWallAround_LOOKUP(1, 1, 0, 0) = 1
'    intWallAround_LOOKUP(1, 1, 0, 1) = 13
'    intWallAround_LOOKUP(1, 1, 1, 0) = 12
'    intWallAround_LOOKUP(1, 1, 1, 1) = 0
'
'End Sub
'Function GetWallAroundInfo(intX As Integer, intY As Integer) As Integer
'' Selects the correct meshID for 'specal case' map piece. Eg. need to know what type of ground should be
''  rendered with consideration to the surrounding walls
'
'    Dim blnOffWall(4) As Boolean
'
'
'    ' Dermine what walls are present
'    blnOffWall(1) = (rrMap.GetGeneralPieceType(intX, intY + 1) = enmPieceType.Wall)     ' 2
'    blnOffWall(2) = (rrMap.GetGeneralPieceType(intX - 1, intY) = enmPieceType.Wall)     ' 4
'    blnOffWall(3) = (rrMap.GetGeneralPieceType(intX + 1, intY) = enmPieceType.Wall)     ' 6
'    blnOffWall(4) = (rrMap.GetGeneralPieceType(intX, intY - 1) = enmPieceType.Wall)     ' 8
'
'    ' 'Look-Up' the type of ground mesh using our lookup table
'    GetWallAroundInfo = intWallAround_LOOKUP(CInt(blnOffWall(1) * -1), CInt(blnOffWall(2) * -1), Int(blnOffWall(3)) * -1, Int(blnOffWall(4)) * -1)
'                                                'CInt' needed  ???
'End Function



' TODO: Convert to lookup table, or, irradicate one type

Function DataInt2Str(intIn As enmPieceType) As String

' Used charicters:   abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ%*)^$(&£!|\`¬¦@;:.<>#~=+-_
'  (underlined)      ------- - - -- - ----  -------------                          -    ----

   If intIn = 0 Then DataInt2Str = "0"    'Space...
   If intIn = 1 Then DataInt2Str = "5"
   If intIn = 2 Then DataInt2Str = "d"    'Dimond
   If intIn = 3 Then DataInt2Str = "8"    'Walls...
   If intIn = 4 Then DataInt2Str = "2"
   If intIn = 5 Then DataInt2Str = "6"
   If intIn = 6 Then DataInt2Str = "4"
   If intIn = 7 Then DataInt2Str = "9"
   If intIn = 8 Then DataInt2Str = "7"
   If intIn = 9 Then DataInt2Str = "3"
   If intIn = 10 Then DataInt2Str = "1"
   If intIn = 11 Then DataInt2Str = "e"   'Earth
   If intIn = 12 Then DataInt2Str = "r"   'Rock
   If intIn = 13 Then DataInt2Str = "s"   'Safe
   If intIn = 14 Then DataInt2Str = "k"   'Key
   If intIn = 15 Then DataInt2Str = "g"   'Egg
   If intIn = 16 Then DataInt2Str = "i"   'Repton stating point
   If intIn = 17 Then DataInt2Str = "t"   'Crown
   If intIn = 18 Then DataInt2Str = "c"   'Cage
   If intIn = 19 Then DataInt2Str = "p"   'Spirit stating point
   If intIn = 20 Then DataInt2Str = "b"   'Bomb
   If intIn = 21 Then DataInt2Str = "f"   'Fungus
   If intIn = 22 Then DataInt2Str = "u"   'Skull
   If intIn = 23 Then DataInt2Str = "a"   'Barrier (looks like batteries)
   If intIn = 24 Then DataInt2Str = "m"   'Monster
   If intIn = 25 Then DataInt2Str = "n"   'Transporter
   If intIn = 26 Then DataInt2Str = "z"   'TimeCapsule
   
   If intIn = enmPieceType.FilledWall Then DataInt2Str = "%"
   If intIn = enmPieceType.FilledWall7 Then DataInt2Str = "&"
   If intIn = enmPieceType.FilledWall9 Then DataInt2Str = "("
   If intIn = enmPieceType.FilledWall1 Then DataInt2Str = "!"
   If intIn = enmPieceType.FilledWall3 Then DataInt2Str = "£"
   
   If intIn = enmPieceType.NavigationalMap Then DataInt2Str = "x"
   
   If intIn = enmPieceType.LevelTransport Then DataInt2Str = "y"
   
End Function



Function DataStr2Int(strIn As String) As Integer

   DataStr2Int = 0
   
   If strIn = "0" Then DataStr2Int = 0
   If strIn = "5" Then DataStr2Int = 1
   If strIn = "d" Then DataStr2Int = 2
   If strIn = "8" Then DataStr2Int = 3
   If strIn = "2" Then DataStr2Int = 4
   If strIn = "6" Then DataStr2Int = 5
   If strIn = "4" Then DataStr2Int = 6
   If strIn = "9" Then DataStr2Int = 7
   If strIn = "7" Then DataStr2Int = 8
   If strIn = "3" Then DataStr2Int = 9
   If strIn = "1" Then DataStr2Int = 10
   If strIn = "e" Then DataStr2Int = 11
   If strIn = "r" Then DataStr2Int = 12
   If strIn = "s" Then DataStr2Int = 13
   If strIn = "k" Then DataStr2Int = 14
   If strIn = "g" Then DataStr2Int = 15
   If strIn = "i" Then DataStr2Int = 16
   If strIn = "t" Then DataStr2Int = 17
   If strIn = "c" Then DataStr2Int = 18
   If strIn = "p" Then DataStr2Int = 19
   If strIn = "b" Then DataStr2Int = 20
   If strIn = "f" Then DataStr2Int = 21    'Fungus
   If strIn = "u" Then DataStr2Int = 22    'Skull
   If strIn = "a" Then DataStr2Int = 23    'Barrier (looks like batteries)
   If strIn = "m" Then DataStr2Int = 24
   If strIn = "n" Then DataStr2Int = 25
   If strIn = "z" Then DataStr2Int = 26
   
   If strIn = "%" Then DataStr2Int = enmPieceType.FilledWall
   If strIn = "&" Then DataStr2Int = enmPieceType.FilledWall7
   If strIn = "(" Then DataStr2Int = enmPieceType.FilledWall9
   If strIn = "!" Then DataStr2Int = enmPieceType.FilledWall1
   If strIn = "£" Then DataStr2Int = enmPieceType.FilledWall3
   
   If strIn = "x" Then DataStr2Int = enmPieceType.NavigationalMap
   
   If strIn = "y" Then DataStr2Int = enmPieceType.LevelTransport
      
End Function


'Sub PlayFallingSnd()
'    'Debug.Print timRockSndPlaying.LocalTime
'    If bRockSndPlaying = False Or timRockSndPlaying.LocalTime > 3.911 Then
'        ExSnds(4).PlaySound True
'        bRockSndPlaying = True
'        timRockSndPlaying.ReSet
'    End If
'End Sub

Function DisplayLoadingScr(iCur As Integer, iMax As Integer)
    
    Dim n As Integer
    Dim b As Single
   
    ExPrj.Render
    
    ' Control fader
    ExTxtMsg.Colour &HFF11FF11
    ExTxtMsg.position 90, frmMain.iYsize * 0.5
    ExTxtMsg.Text "Loading..."
    ExTxtMsg.Render

    ExTxtMsg.position frmMain.iXsize * 0.4 * (1 / iMax) - 1, frmMain.iYsize * 0.6
    ExTxtMsg.Text "|"
    ExTxtMsg.Render

    n = Int((frmMain.iXsize * 0.99) * (iCur / iMax))

    For b = 0 To n Step 2
        ExTxtMsg.position b, frmMain.iYsize * 0.6
        ExTxtMsg.Text "|"
        ExTxtMsg.Render
    Next b

    ExTxtMsg.position (frmMain.iXsize * 0.99) - 2, frmMain.iYsize * 0.6
    ExTxtMsg.Text "|"
    ExTxtMsg.Render
    
    RenderFader (iCur <= 16)

    ExPrj.Sync

End Function
