VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPlayer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Public strName As String

Public intDimondsCollected  As Integer


Private ex3DPlayer As New exMesh                ' Repton - as seen on screen
Private exPlayer_logic As New exMesh            ' Blank object so that animations are smooth
                                                '  - needed due to flaw in design of Ex-Perspective
                                                '    (or rendering pipeline of RR's game engine)
                                                
Private int3DDirection As enmDirection          ' The direction that the visual mesh is facing
Private int3DLastDirection As enmDirection      '


Private intAniN   As Integer
Private intAniMin As Integer
Private intAniMax As Integer
Private intAniSpeed As Single

Enum StateEN
    Stoped = 0
    Walk            ' 1
    Push            ' 2
    PushNoWalk      ' 3
    DigAndWalk      ' 4
    Board           ' 5
End Enum

Dim enmPlayerState As StateEN

Dim exTimPlayerCont As New exTools_Timer


Dim intOrgX As Integer
Dim intOrgY As Integer

Dim intCurX As Integer
Dim intCurY As Integer
Public intOldX As Integer
Public intOldY As Integer

Dim intClsMeshNum As Integer

'Public intLives As Integer

Public bVisFocus As Boolean

Enum enmDirection
' (Note: uses keypad arrowkeys
    
    Up = 8
    Down = 2
    Left = 4
    Right = 6
End Enum


Dim iDimondSndCont As Integer

Private cintTimeToMove As Single     ' Number of seconds it take for player to move from one
                                     '  map piece to another.


' Logical functions (these control the 'Visual Controlling' functions)...
Function UpDate()

    Dim sTemp As String
   
    ' If moving, check if player has arrived at new pos. yet
    If (enmPlayerState = Walk Or enmPlayerState = DigAndWalk) And exTimPlayerCont.LocalTime + 0.01 > cintTimeToMove Then
        
        enmPlayerState = Stoped
        
        ' In-games message trigger?
        rrMap.MessageCheckAndShow intCurX, intCurY
    
        ' Piece type event
        Select Case rrMap.GetData(intCurX, intCurY)
            
            Case "d"                                            ' Collect a dimond?
                
                ExSnds(intDimondsCollected Mod 4).PlaySound False
                                                                ' Keep track of collected dimonds
                intDimondsCollected = intDimondsCollected + 1
                
            Case "t"
                ExSnds(6).PlaySound False
            
                rrMap.intTotCrowns = rrMap.intTotCrowns - 1
                                
            Case "k"                                            ' Key collected; Open all safes
                ExSnds(14).PlaySound False
                
                rrMap.OpenSafes
                
            Case "b"                                            ' Collected a bomb, thus completing the map
                rrGame.LevelCompleted                           '  Note; Can only be collected when all dimonds have been
                                                                '   collected; this is handeled by the 'MovableTo' function.
                                                                
            Case "u"                                            ' Skull; die
                If rrGame.strEpisodeName = "Home" Then
                    If MsgBox("Sure to delete " & rrRepton.strName & "'s saved positions and settings?", vbYesNo, "Repton Returns") = vbYes Then
                    
                       ' Delete player records
                       DeleteFolder App.Path & "\data\players\" & rrRepton.strName
                    
                       'on error resume next
                       Open App.Path & "\data\players\names.dat" For Input As #1
                           Open App.Path & "\data\players\names.tmp" For Output As #2
                                Do
                                    Input #1, sTemp
                                    If sTemp <> rrRepton.strName Then Print #2, sTemp
                                Loop Until EOF(1)
                           Close #2
                       Close #1
                       MoveFile App.Path & "\data\players\names.tmp", App.Path & "\data\players\names.dat"
                       
                       rrGame.iLevelCompeted = -1
                       
                       sTemp = ""
                    Else
                        intCurX = intOldX
                        intCurY = intOldY
                    End If
                Else
                
                    Me.Die
                    
                End If
                
            Case "f"                                            ' Fungus; die
                Me.Die
                
            Case "n"                                            ' Transporter; reposition
            
                ExSnds(12).PlaySound False
            
                ' Update the realtime map piece of the old position
                rrMap.SetData intOldX, intOldY, Space
                rrPieces(intOldX, intOldY).TypeID = "0"
            
                ' Remove transporter from map
                rrMap.SetData intCurX, intCurY, Space
                rrPieces(intCurX, intCurY).TypeID = "0"
                
                intCurY = rrPieces(intCurX, intCurY).intTransporterID
                
                intCurX = tTransporters(intCurY).iToX
                intCurY = tTransporters(intCurY).iToY
                                               
                Move3D
                                               
                Me.SetPosition intCurX, intCurY
                rrPieces(intOldX, intOldY).TypeID = "0"
                
                ' Start pause
                rrGame.Pause 2.5
                
                ' Start FX
                
            Case "z"                                            ' Time capsule; reset time bomb timer
                ExSnds(11).PlaySound False
            
                rrMap.TimeBombControl 3
                
            Case "y"                                            ' Level Transporter
                
                ExSnds(13).PlaySound False
                                              
                sTemp = tLevelTrans(rrPieces(intCurX, intCurY).intTransporterID).sLocalFile
                
                ' Keep track of deleted level-transporter
                tLevelTrans(rrPieces(intCurX, intCurY).intTransporterID).sLocalFile = "!deleted!"
                
        End Select
        
        
        ' Set the realtime map visual piece of this position
        rrMap.SetData intCurX, intCurY, Repton
        rrPieces(intCurX, intCurY).TypeID = "i"
        
        ' Update the realtime map piece of the old position
        rrMap.SetData intOldX, intOldY, Space
'        rrPieces(intOldX, intOldX).TypeID = "0"
        
        
        GameEvents
        
        If sTemp <> "" Then           ' Level-transporter?
                   
            If rrGame.strEpisodeName = "Home" Then
                ' Save level
                rrMap.SaveFileLevel App.Path & "\data\players\" & sPrimPlayerName & "\home\start.rrl"          '& rrGame.strEpisodeName  & rrGame.LevelOrder(rrGame.iCurGameLevel)
            End If
            
            ExPrj.Sync
            
            ' Start Game
            rrGame.DeInit
            rrGame.sEpisodeDir = sTemp
            rrGame.Init True
            
            intOldX = intCurX
            intOldY = intCurY
            
            ExPrj.Render
        End If
        

        UserInteraction   ' Still moving?
        
    End If
    
    Render
    
End Function


Function ReSet()
    'intLives = 3
End Function

Function SetPosition(intX As Integer, intY As Integer)
' Note: Sets Origan position
    
    intOrgX = intX
    intOrgY = intY
    
    ' Now change the current position
    intCurX = intX
    intCurY = intY
    
    ' Set old pos.
    intOldX = intX
    intOldY = intY
    
    ' Update visual player
    ex3DPlayer.position Ret3DPos(intX), Ret3DPos(intY), -240, True
    exPlayer_logic.position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
        
    enmPlayerState = Walk
    
    UpDate
    
End Function

Function GetXPos() As Integer
    GetXPos = intCurX
End Function
Function GetYPos() As Integer
    GetYPos = intCurY
End Function

Function GetPreXPos() As Integer
    If exTimPlayerCont.LocalTime < cintTimeToMove And enmPlayerState = Walk Then
        GetPreXPos = intOldX
    Else
        GetPreXPos = intCurX
    End If
End Function
Function GetPreYPos() As Integer
    If exTimPlayerCont.LocalTime < cintTimeToMove And enmPlayerState = Walk Then
        GetPreYPos = intOldY
    Else
        GetPreYPos = intCurY
    End If
End Function


Function Move(intDirection As enmDirection)

    If enmPlayerState = Stoped Or enmPlayerState = PushNoWalk Or enmPlayerState = Board Then
        intOldX = intCurX
        intOldY = intCurY
        
        Select Case intDirection
            Case Up
                intCurY = intCurY - 1
                int3DDirection = Up
                
            Case Down
                intCurY = intCurY + 1
                int3DDirection = Down
                
            Case Left
                intCurX = intCurX - 1
                int3DDirection = Left
                
            Case Right
                intCurX = intCurX + 1
                int3DDirection = Right
                
        End Select
        
        If MoveableTo(intCurX, intCurY, intDirection) = True Then
        
            StartParticleFountian intOldX, intOldY, "repton_walk" & Trim(Str(intDirection))
            
            If rrMap.GetData(intCurX, intCurY) = "e" Then
                If enmPlayerState <> DigAndWalk Then
                    enmPlayerState = DigAndWalk
                    intAniMin = 110
                    intAniMax = 155
                    intAniSpeed = 5.2
                End If
            Else
                If enmPlayerState <> Walk Then
                    enmPlayerState = Walk
                    intAniMin = 56
                    intAniMax = 97
                    intAniSpeed = 4
                End If
            End If
            
        Else
        
            intCurX = intOldX
            intCurY = intOldY
            
            enmPlayerState = PushNoWalk
        
        End If
        
        Move3D          ' Direction and/or position may have changed
        
    End If
        
End Function


Function Die(Optional bPlaySound As Boolean = True) As Integer
'Returns number of remening lifes

    Dim sTemp As String
    
    
    If bPlaySound Then ExSnds(19).PlaySound False
        
    
    intPlayerLives = intPlayerLives - 1
      
    Die = intPlayerLives
        
    ' Write to file
    Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat" For Input As #1
        Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp" For Output As #2
            ' Number of times player selected
            Input #1, sTemp
            Print #2, sTemp
            ' Number of lives remaining
            Input #1, sTemp
            sTemp = Trim(Str(Val(sTemp) - 1))
            Print #2, sTemp
        Close #2
    Close #1
    MoveFile App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp", App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat"

    If intPlayerLives < 0 Then
        rrGame.iLevelCompeted = -2
        Exit Function
    End If
      
    If rrMap.GetData(intCurX, intCurY) <> "u" Then
        rrMap.SetData intCurX, intCurY, Space
        rrPieces(intCurX, intCurY).TypeID = "0"
    End If
    
    If rrMap.GetData(intOldX, intOldY) = "i" Then
        rrMap.SetData intOldX, intOldY, Space
        rrPieces(intOldX, intOldY).TypeID = "0"
    End If
       
    ' Reset to starting position
    intCurX = intOrgX
    intCurY = intOrgY
    int3DDirection = Down
    Move3D
    Me.SetPosition intCurX, intCurY
    
    ' Reset TimeBomb
    rrMap.TimeBombControl 3
    
    ' Start pause
    rrGame.Pause 2.5
    
    ' Start FX
    
    
End Function


Private Function MoveableTo(intX As Integer, intY As Integer, intDirection As enmDirection) As Boolean
    
    Dim intTemp As Integer
    
    MoveableTo = True
    
    intTemp = DataStr2Int(rrMap.GetData(intX, intY))
    
    ' Static pieces...
    Select Case intTemp
    
        Case enmPieceType.Bomb
            If rrRepton.intDimondsCollected <> rrMap.intTotDimonds _
               Or rrMap.intTotCrowns <> 0 Or rrMap.intTotEggs <> 0 Or rrMap.intTotMonstersAlive <> 0 Then
               
                MoveableTo = False
            End If
        
        Case enmPieceType.Monster
            If rrMonster(rrPieces(intX, intY).intMonsterID).blnEarth Then MoveableTo = False
        
        Case enmPieceType.Cage
            MoveableTo = False
            
        Case enmPieceType.Safe
            MoveableTo = False

        Case enmPieceType.Wall
            MoveableTo = False
            
        Case enmPieceType.Barrier
            MoveableTo = False
            
        Case enmPieceType.Egg
            If rrPieces(intX, intY).intRockOrEggID = -1 Then
                MoveableTo = False
                Exit Function
            End If
        
        Case enmPieceType.Earth
            ExSnds(16).PlaySound False
        
            
    End Select
    If intTemp >= 3 And intTemp <= 10 Then MoveableTo = False       ' Sides of normal type wall
    If intTemp >= 27 And intTemp <= 31 Then MoveableTo = False       ' Stagnights
    
    
    ' Movable pieces...
    
    If intTemp = enmPieceType.Rock Or (intTemp = enmPieceType.Egg) Then        ' Rocks or eggs
        If intDirection = Up Or intDirection = Down Then
            MoveableTo = False
        Else
            If intDirection = Left Then
                If rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Space) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                Else
                    MoveableTo = False
                End If
                
                If rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                End If
            Else
                If rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Space) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                Else
                    MoveableTo = False
                End If
                
                If rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                End If
            End If
        End If
    End If
    
    
End Function



' Visual Controlling functions (these control the 'Virtual' aspects of the player)...

Sub Init()

    ' Init public varables
    intDimondsCollected = 0
    strName = sPrimPlayerName
    
    
    intAniN = 56
    intAniMin = 56
    intAniMax = 97
    intAniSpeed = 4
    
    int3DDirection = Down
    
    ' Init visual based objects
    ex3DPlayer.InitXFile pckOrigThemeFiles.GetPackedFile("repton.x")
    exPlayer_logic.InitXFile ""                                 ' Blank object so that animations are smooth
    
    exTimPlayerCont.Start
    
    Move3D
    
    cintTimeToMove = 0.3 / rrGame.sngGameSpeed
    
End Sub

Private Function Render()
    
    exPlayer_logic.Render       ' Simply updates animation - draws nothing to screen; Ex-Perspective should has
                                ' 'Update DS animation' as seperate function (currently does this within 'Render'
    
    If bVisFocus = True Then
        
        ExCam.position exPlayer_logic.position.x, exPlayer_logic.position.y - 350, 350, True
        'ExCam.position exPlayer_logic.position.x, exPlayer_logic.position.y - 650, 50, True        ' debug cam
        
        ExCam.LookAt exPlayer_logic.position.x, exPlayer_logic.position.y, ex3DPlayer.position.z
    
    End If

    ex3DPlayer.position exPlayer_logic.position.x, exPlayer_logic.position.y, exPlayer_logic.position.z, True
    
    ' Control Animation
    If intAniN > intAniMax Or intAniN < intAniMin Then intAniN = intAniMin
    
    Select Case enmPlayerState
        
        Case Stoped
            intAniN = 56
            
        Case Walk
            intAniN = intAniN + 1
            
        Case DigAndWalk
            intAniN = intAniN + 1
            
        Case Board
            intAniN = intAniN + 1
            
    End Select

    ex3DPlayer.Animate intAniN * 160, 6000 * intAniSpeed
    
    ex3DPlayer.Render
    
    ' Is Repton 'board' yet?
    If exTimPlayerCont.LocalTime > 8 And enmPlayerState = Stoped Then
        enmPlayerState = Board
        intAniMin = 170
        intAniMax = 202
        intAniSpeed = 0.1
    End If
    
End Function

Private Function Move3D()
' Will move the 3D mesh, checking is up to the respective 'Logical' function.

    ' Update position (if changed)
    If intCurX <> intOldX Or intCurY <> intOldY Then
        exPlayer_logic.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ex3DPlayer.position, cintTimeToMove
        'exTimPlayerCont.Stop_
        exTimPlayerCont.ReSet
        'exTimPlayerCont.Start
        'enmPlayerState = Walk
    End If
    
    ' Direction/Rotation
    If int3DDirection <> int3DLastDirection Then
        Select Case int3DDirection
        
            Case Up
                If int3DLastDirection = Left Then ex3DPlayer.Rotate 0, 0, 90, True
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 180), ex3DPlayer.Rotate, cintTimeToMove * 0.7
                                
            Case Down
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 360), ex3DPlayer.Rotate, cintTimeToMove * 0.7
                
            Case Left
                If int3DLastDirection = Up Then ex3DPlayer.Rotate 0, 0, 540, True
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 450), ex3DPlayer.Rotate, cintTimeToMove * 0.7
                                
            Case Right
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 270), ex3DPlayer.Rotate, cintTimeToMove * 0.7
                
        End Select
        
    End If
    
    int3DLastDirection = int3DDirection
    
End Function

