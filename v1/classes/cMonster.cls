VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMonster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit


Public intMyID As Integer                       ' An instantes array ID


Private exPlayer_logic As New exMesh            ' Blank object so that animations are smooth
                                                '  - needed due to flaw in design of Ex-Perspective
                                                '    (or rendering pipeline of RR's game engine)
                                                
Private int3DDirection As enmDirection          ' The direction that the visual mesh is facing
Private int3DLastDirection As enmDirection      '


Private Enum StateEN
    StillInEgg = 0
    EggIsCracking   ' 1
    MonsterWaking   ' 2
    SeekingRepton   ' 3
    Dead            ' 4
End Enum

Dim enmMonsterState As StateEN

Dim timMonsterSpawnCont As New exTools_Timer

Dim intCurX As Integer
Dim intCurY As Integer

Dim intOldX As Integer
Dim intOldY As Integer


Dim intAniN     As Integer
Dim intAniMin   As Integer
Dim intAniMax   As Integer
Dim intAniSpeed As Integer


Dim intPieceType As enmPieceType


Public ExLog3D As New exMesh               ' Logical 3D (so that transformations are preserved; no mesh data).

Const cintTimeToMove As Single = 0.45      ' Number of seconds it take for move from one
                                           '  map piece to another.


Function Init(intX As Integer, intY As Integer)
    
    intCurX = intX
    intCurY = intY
    intOldX = intX
    intOldY = intY
        
    ' Internal ani settings
    intAniN = 0
    intAniMin = 1      '56
    intAniMax = 94
    intAniSpeed = 4
    
    intMyID = rrMap.intTotMonsters
    
    ExLog3D.position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    ' Random post rotation?
    'ExLog3D.InitXFile ""
    ExLog3D.Rotate Rnd(360), Rnd(360), Rnd(360), True
    'ExLog3D.ResetMatrix

    
    enmMonsterState = StillInEgg
   
End Function


Function Render()

    ExLog3D.Render

    ' Only render if Monster is active
    If enmMonsterState = EggIsCracking Or enmMonsterState = MonsterWaking Or enmMonsterState = SeekingRepton Then
        
        Ex3DP(intPieceType).ResetMatrix
        Ex3DP(intPieceType).Rotate ExLog3D.Rotate.x, ExLog3D.Rotate.y, ExLog3D.Rotate.z, True
        Ex3DP(intPieceType).position ExLog3D.position.x, ExLog3D.position.y, ExLog3D.position.z, True
        
        
        Ex3DP(intPieceType).Render
        
        ' Update internal animation
        intAniN = intAniN + 1
        If intAniN > intAniMax Then intAniN = intAniMin
        Ex3DP(intPieceType).Animate intAniN * 160, 6000 * intAniSpeed
        
    End If
    
    
    
End Function


Public Function Move(intDir As enmDirection)

    Dim intOldX As Integer
    Dim intOldY As Integer

    intOldX = intCurX
    intOldY = intCurY
    
    Select Case intDir
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
    
    
    ' Does Repton die in result of this move?
    If rrMap.GetData(intCurX, intCurY) = "i" Or rrMap.GetData(intOldX, intOldY) = "i" Then
        rrRepton.Die
    End If
    
    rrMap.SetData intOldX, intOldY, Space
    rrMap.SetData intCurX, intCurY, intPieceType
        
    rrPieces(intOldX, intOldY).intMonsterID = -1  '-2
    rrPieces(intCurX, intCurY).intMonsterID = intMyID
        
    Move3D          ' Direction and/or position may have changed
    
End Function

Function Move3D()
    
    ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ExLog3D.position, cintTimeToMove
    'ExLog3D.Position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    
    
    ' Direction/Rotation
    If int3DDirection <> int3DLastDirection Then
        Select Case int3DDirection
        
            Case Up
                If int3DLastDirection = Left Then ExLog3D.Rotate 0, 0, 90, True
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 180), ExLog3D.Rotate, 0.2
                
            Case Down
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 360), ExLog3D.Rotate, 0.2
                
            Case Left
                If int3DLastDirection = Up Then ExLog3D.Rotate 0, 0, 540, True
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 450), ExLog3D.Rotate, 0.2
                                
            Case Right
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 270), ExLog3D.Rotate, 0.2
                
        End Select
                
    End If
    
End Function


Function CheckIfMove()
    
    Dim sTemp As String * 1
    Dim bCanMove  As Boolean
    Dim intOldDir As enmDirection
    
    
    ' Control spawn timing sequences ...
    
    If enmMonsterState = EggIsCracking Then
        If timMonsterSpawnCont.LocalTime > 3 Then
            ' Egg has fully cracked
            intPieceType = Monster
            rrPieces(intCurX, intCurY).intMonsterID = intMyID
            
            rrMap.SetData intCurX, intCurY, Monster
            enmMonsterState = MonsterWaking
            timMonsterSpawnCont.ReSet
            
            ExSnds(17).PlaySound False
            
        End If
        
    ElseIf enmMonsterState = MonsterWaking Then
        If timMonsterSpawnCont.LocalTime > 3 Then
            ' Monster has fully awakened
            
            enmMonsterState = SeekingRepton
        End If
    
    ' Can we move? If not, don't do any thing
    ElseIf enmMonsterState = SeekingRepton Then
        
        ' Have we stoped moving?
        If ExLog3D.AnimatedTransform.active(Translation3D) = False Then
            
            intOldDir = int3DDirection
            
            
            ' Simply move toward Repton ...
            
            If rrRepton.GetXPos <> intCurX Then
                If int3DDirection <> Left Then
                    If rrRepton.GetXPos < intCurX Then
                        int3DDirection = Left
                        GoTo MoveChosen
                    End If
                End If
                If int3DDirection <> Right Then
                    If rrRepton.GetXPos > intCurX Then
                        int3DDirection = Right
                        GoTo MoveChosen
                    End If
                End If
            End If
            If rrRepton.GetYPos <> intCurY Then
                If int3DDirection <> Up Then
                    If rrRepton.GetYPos < intCurY Then
                        int3DDirection = Up
                        GoTo MoveChosen
                    End If
                End If
                If int3DDirection <> Down Then
                    If rrRepton.GetYPos > intCurY Then
                        int3DDirection = Down
                        GoTo MoveChosen
                    End If
                End If
            End If
MoveChosen:
            
            ' Check if it is okay to move in this direction ...
            
            ' Which way are we facing?
            Select Case int3DDirection
            
                Case Up
                    bCanMove = CanMoveTo(intCurX, intCurY - 1)
                
                Case Down
                    bCanMove = CanMoveTo(intCurX, intCurY + 1)
                
                Case Left
                    bCanMove = CanMoveTo(intCurX - 1, intCurY)
                
                Case Right
                    bCanMove = CanMoveTo(intCurX + 1, intCurY)
                
            End Select
                              
            ' Ok to move forward??
            If bCanMove = True Then
                
                               
                Me.Move int3DDirection
               
                
                ' Remember last coords. - used to check if Repton moved where monster has just been (Repton should die if this is true)
                
                intOldX = intCurX
                intOldY = intCurY
                             
            End If
    
        End If
        
    End If
    
End Function

Function Spawn(intX As Integer, intY As Integer)
    intCurX = intX
    intCurY = intY
    
    Me.Move3D               ' Update visual moster with these new coords.
    
    intPieceType = Egg
    
    rrMap.SetData intX, intY, intPieceType
    rrPieces(intX, intY).intMonsterID = intMyID
    
    rrMap.intTotMonstersAlive = rrMap.intTotMonstersAlive + 1
    
    enmMonsterState = EggIsCracking
    
    ExSnds(7).PlaySound False
    
    timMonsterSpawnCont.ReSet
    
End Function

Function Die() As Boolean
    If enmMonsterState = SeekingRepton Or enmMonsterState = MonsterWaking Then
        DieForced
        Die = True
        
        ExSnds(18).PlaySound False
    Else
        Die = False
    End If
End Function

Function DieForced()
    enmMonsterState = Dead
    rrMap.intTotMonstersAlive = rrMap.intTotMonstersAlive - 1
End Function

Function GetXPos() As Integer
    GetXPos = intCurX
End Function
Function GetYPos() As Integer
    GetYPos = intCurY
End Function

Private Function CanMoveTo(intX As Integer, intY As Integer) As Boolean
' Checks if a monster can move to the piece at the given map coords.

    Dim sTemp As String * 1
    
    sTemp = rrMap.GetData(intX, intY)
    
    If sTemp = "0" Or sTemp = "i" Then
        CanMoveTo = True
    Else
        CanMoveTo = False
    End If
End Function

