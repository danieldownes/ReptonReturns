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
Private intAniSpeed As Integer

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



Dim intCurX As Integer
Dim intCurY As Integer
Dim intOldX As Integer
Dim intOldY As Integer

Dim intClsMeshNum As Integer

Public intLives As Integer

Enum enmDirection
' (Note: uses keypad arrowkeys
    
    Up = 8
    Down = 2
    Left = 4
    Right = 6
End Enum


Const cintTimeToMove = 0.3           ' Number of seconds it take for player to move from one
                                     '  map piece to another.


' Logical functions (these control the 'Visual Controlling' functions)...
Function UpDate()
   
    ' If moving, check if player has arrived at new pos. yet
    If (enmPlayerState = Walk Or enmPlayerState = DigAndWalk) And exTimPlayerCont.LocalTime + 0.01 > cintTimeToMove Then
        
        enmPlayerState = Stoped
    
        Select Case rrMap.GetData(intCurX, intCurY)
            
            Case "d"                                            ' Collect a dimond?
                
                ExSnds(0).PlaySound False
                                                                ' Keep track of collected dimonds
                intDimondsCollected = intDimondsCollected + 1
                
            Case "t"
                rrMap.intTotCrowns = rrMap.intTotCrowns - 1
                                
            Case "k"                                            ' Key collected; Open all safes
                rrMap.OpenSafes
                
            Case "b"                                            ' Collected a bomb, thus completing the map
                rrGame.LevelCompleted                           '  Note; Can only be collected when all dimonds have been
                                                                '   collected; this is handeled by the 'MovableTo' function.
                                                                
            Case "u"                                            ' Skull; die
                Me.Die
                
            Case "f"                                            ' Fungus; die
                Me.Die
                
        End Select
        
        
        
        
        ' Die?
        
        
        ' Set the realtime map visual piece of this position
        rrMap.SetData intCurX, intCurY, Repton
        rrPieces(intCurX, intCurY).TypeID = "0"
        
        ' Update the realtime map piece of the old position
        rrMap.SetData intOldX, intOldY, Space
        
        GameEvents
        UserInteraction   ' Still moving?
        
    End If
    
    Render
    
End Function


Function ReSet()
    intLives = 3
End Function

Function SetPosition(intX As Integer, intY As Integer)
    
    ' Now change the current position
    intCurX = intX
    intCurY = intY
    
    ' Set old pos.
    intOldX = intCurX
    intOldY = intCurY
    
    ' Update visual player
    ex3DPlayer.Position Ret3DPos(intX), Ret3DPos(intY), -240, True
    
End Function

Function GetXPos() As Integer
    GetXPos = intCurX
End Function
Function GetYPos() As Integer
    GetYPos = intCurY
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
            
            enmPlayerState = Walk
            
        Else
        
            intCurX = intOldX
            intCurY = intOldY
            
            enmPlayerState = PushNoWalk
        
        End If
        
        Move3D          ' Direction and/or position may have changed
        
    End If
        
End Function


Function Die() As Integer
'Returns number of remening lifes
    
    MsgBox "Repton just died!"
    
    intLives = intLives - 1
    
    Die = intLives
End Function


Private Function MoveableTo(intX As Integer, intY As Integer, intDirection As enmDirection) As Boolean
    
    Dim intTemp As Integer
    
    MoveableTo = True
    
    intTemp = DataStr2Int(rrMap.GetData(intX, intY))
    
    ' Static pieces...
    Select Case intTemp
    
        Case enmPieceType.Bomb
            If rrRepton.intDimondsCollected <> rrMap.intTotDimonds _
               Or rrMap.intTotCrowns <> 0 Or rrMap.intTotEggs <> 0 Or rrMap.intTotMonsters <> 0 Then
               
                MoveableTo = False
            End If
            
        
        Case enmPieceType.Cage
            MoveableTo = False
            
        Case enmPieceType.Safe
            MoveableTo = False

        Case enmPieceType.Wall
            MoveableTo = False
            
        Case enmPieceType.Barrier
            MoveableTo = False
            
    End Select
    If intTemp >= 3 And intTemp <= 10 Then MoveableTo = False       ' Sides of normal type wall
    
    
    ' Movable pieces...
    
    If intTemp = enmPieceType.Rock Or intTemp = enmPieceType.Egg Then       ' Rocks or eggs
        If intDirection = Up Or intDirection = Down Then
            MoveableTo = False
        Else
            If intDirection = Left Then
                If rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Space) Or rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                Else
                    MoveableTo = False
                End If
            Else
                If rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Space) Or rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                Else
                    MoveableTo = False
                End If
            End If
        End If
    End If
    
    
End Function



' Visual Controlling functions (these control the 'Virtual' aspects of the player)...

Sub Init()

    ' Init public varables
    intDimondsCollected = 0
    intLives = 3
    
    intAniN = 0
    intAniMin = 56      '56
    intAniMax = 97
    intAniSpeed = 4
    int3DDirection = Down
    
    ' Init visual based objects
    ex3DPlayer.InitXFile App.Path + "\data\themes\meshes\repton.x"
    exPlayer_logic.InitXFile ""                                 ' Blank object so that animations are smooth
    
    exTimPlayerCont.Start
    
    Move3D
    
End Sub

Private Function Render()
    
    exPlayer_logic.Render       ' Simply updates animation - draws nothing to screen; Ex-Perspective should has
                                ' 'Update DS animation' as seperate function (currently does this within 'Render'
    
    'if bFocus = True
        
        ExCam.Position exPlayer_logic.Position.X, exPlayer_logic.Position.Y - 350, 350, True
        
        ExCam.LookAt exPlayer_logic.Position.X, exPlayer_logic.Position.Y, ex3DPlayer.Position.Z
            
        'ExCam.AniTransform3D.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), 0), ex3DPlayer.Position, cintTimeToMove   'ex3DPlayer.Position.X, ex3DPlayer.Position.Y - 200, 700, True
        
        
       
    
    'end if

    ex3DPlayer.Position exPlayer_logic.Position.X, exPlayer_logic.Position.Y, exPlayer_logic.Position.Z, True
    
    ' Control Animation
    If intAniN > intAniMax Then intAniN = intAniMin
    ex3DPlayer.Animate intAniN * 160, 6000 * intAniSpeed
    intAniN = intAniN + 1
    
    ex3DPlayer.Render
    

    
End Function

Private Function Move3D()
' Will move the 3D mesh, checking is up to the respective 'Logical' function.

    ' Update position (if changed)
    If intCurX <> intOldX Or intCurY <> intOldY Then
        exPlayer_logic.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ex3DPlayer.Position, cintTimeToMove
        'exTimPlayerCont.Stop_
        exTimPlayerCont.ReSet
        'exTimPlayerCont.Start
    End If
    
    ' Direction/Rotation
    If int3DDirection <> int3DLastDirection Then
        Select Case int3DDirection
        
            Case Up
                If int3DLastDirection = Left Then ex3DPlayer.Rotate 0, 0, 90, True
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 180), ex3DPlayer.Rotate, 0.2
                
            Case Down
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 360), ex3DPlayer.Rotate, 0.2
                
            Case Left
                If int3DLastDirection = Up Then ex3DPlayer.Rotate 0, 0, 540, True
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 450), ex3DPlayer.Rotate, 0.2
                                
            Case Right
                ex3DPlayer.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 270), ex3DPlayer.Rotate, 0.2
                
        End Select
                
    End If
    
    int3DLastDirection = int3DDirection
    
End Function

