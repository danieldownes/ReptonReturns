VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSpirt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.


Dim bActive As Boolean

Dim intCurX As Integer
Dim intCurY As Integer

Dim intOldX As Integer
Dim intOldY As Integer


Dim int3DDirection As enmDirection              ' Current direction that we are moving

Dim intPieceType As Integer

Dim bFirstMove  As Boolean          ' Helps to make sure the first move of the spirit is the same as origonal version of Repton

Dim bDidNotMoveLast As Boolean             ' If spirit did not move (ie, determined new direct) this is true, stops
                                           '  spirit from 'waiting' while turning around corners
                                           '  NOTE: Could caluse formation/syncronisation to be brocken

Public ExLog3D As New exMesh               ' Logical 3D (so that transformations are preserved; no mesh data).
                                           ' Needs to be public becase the timer has to be shared amogst other spirits
                                           '  so that they stay is sync (eg, formation problem when individual timers
                                           '  are used). The last spirits logical timer is used to chech if each spirit
                                           '  can move.

Const cintTimeToMove As Single = 0.15      ' Number of seconds it take for move from one
                                           '  map piece to another.


Function Init(intX As Integer, intY As Integer)
    
    intCurX = intX
    intCurY = intY
    intOldX = intX
    intOldY = intY
    
    intPieceType = Spirit
    
    ExLog3D.Position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    ' Random post rotation?
    'ExLog3D.InitXFile ""
    ExLog3D.Rotate Rnd(360), Rnd(360), Rnd(360), True
    'ExLog3D.ResetMatrix

    
    bActive = True
    
    
    
    ' Determine starting direction ...      ' (in origonal Repton this is done on every spirt move; hence 'dazed sprits')
    
    int3DDirection = Up             ' If nothing is set, then default to Up
           
    ' Move Right?
    If CanMoveTo(intCurX, intCurY - 1) = False Then
        int3DDirection = Right
    End If
    
    ' Move Down?
    If CanMoveTo(intCurX + 1, intCurY) = False Then
        int3DDirection = Right
    End If
    
    ' Move Left?
    If CanMoveTo(intCurX, intCurY + 1) = False Then
        int3DDirection = Left
    End If

    bFirstMove = True
    
    bDidNotMoveLast = True
    
End Function


Function Render()

    ExLog3D.Render  ' Simply to update animation; should be done even when spirit is dead, as all spirits reliy on last spirit's logical timer

    ' Only render if Spirit is active
    If bActive = True Then
        
        Ex3DP(intPieceType).Rotate ExLog3D.Rotate.X, ExLog3D.Rotate.Y, ExLog3D.Rotate.Z, True
        Ex3DP(intPieceType).Position ExLog3D.Position.X, ExLog3D.Position.Y, ExLog3D.Position.Z, True
        
        
        Ex3DP(intPieceType).Render
        
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
    
    
    
'    ' Its already been dertimined that its ok to move to the new coords.- so let update this logically
'    rrMap.SetData intCurX, intCurY, Spirit
'
'    If bSandToo = True Then
'        rrMap.SetData intOldX, intOldY, Earth
'    Else
'        rrMap.SetData intOldX, intOldY, Space
'    End If
    
   
    
    Move3D          ' Direction and/or position may have changed
    
    
    
End Function

Function Move3D()
    
    ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ExLog3D.Position, cintTimeToMove
    'ExLog3D.Position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    
End Function


Function CheckIfMove()
    
    Dim sTemp As String * 1
    Dim bCanMove  As Boolean
    Dim intOldDir As enmDirection
    
    
                    
    'ExLog3D.Render      ' We'll need to update transformations in the background

    ' Are we still alive? If not, don't do any thing
    If bActive = False Then
        
        ' Keep moving (all other spirits depend upon the last spirit in array to be still logically active)
        If rrSpirit(rrMap.intTotSpirits - 1).ExLog3D.AnimatedTransform.Active(Translation3D) = False Then
            ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ExLog3D.Position, cintTimeToMove
        End If
        
        Exit Function
    End If
    
    ' Have we stoped moving?
    If rrSpirit(rrMap.intTotSpirits - 1).ExLog3D.AnimatedTransform.Active(Translation3D) = False Or bDidNotMoveLast = True Then
        
        intOldDir = int3DDirection
        
        ' Is there a wall there we should hug? ...
        If bFirstMove = False Then                      ' Only do this if not the first move
            int3DDirection = intOldDir      ' Incase we turned right (if wall was infrount)
            Select Case int3DDirection
            
                Case Up
                    bCanMove = CanMoveTo(intCurX - 1, intCurY)
                
                Case Down
                    bCanMove = CanMoveTo(intCurX + 1, intCurY)
                
                Case Left
                    bCanMove = CanMoveTo(intCurX, intCurY + 1)
                
                Case Right
                    bCanMove = CanMoveTo(intCurX, intCurY - 1)
                
            End Select
            
            ' Do the check
            If bCanMove = True Then
    
                ' No! Then turn left
    
                Select Case int3DDirection      ' Hug left (anti-clockwise)
    
                    Case Up
                        int3DDirection = Left
    
                    Case Down
                        int3DDirection = Right
    
                    Case Left
                        int3DDirection = Down
    
                    Case Right
                        int3DDirection = Up
    
                End Select
    
            End If
        Else
            bFirstMove = False
        End If
        
        
        
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
            
            bDidNotMoveLast = False
            
            sTemp = rrMap.GetData(intCurX, intCurY)
                       
            ' If we went into a cage, we should turn into a dimond (deactivate and change map)
            If sTemp = "c" Then
                bActive = False
                
                rrMap.SetData intCurX, intCurY, Dimond
                rrPieces(intCurX, intCurY).TypeID = DataInt2Str(Dimond)
            End If
            
            ' If we went into Repton, he should die
            If sTemp = "i" Or rrMap.GetData(intOldX, intOldY) = "i" Then
                rrRepton.Die
            End If
            
            ' Remember last coords. - used to check if Repton moved where spirit has just been (Repton should die if this is true)
            intOldX = intCurX
            intOldY = intCurY
            
        Else
        
            ' Try next direction (moves clockwise)
            Select Case int3DDirection
        
                Case Up
                    int3DDirection = Right
                
                Case Down
                    int3DDirection = Left
                
                Case Left
                    int3DDirection = Up
                
                Case Right
                    int3DDirection = Down
        
            End Select
            
            bDidNotMoveLast = True
            
        End If

    End If
    
    
End Function


Private Function CanMoveTo(intX As Integer, intY As Integer) As Boolean
' Checks if a spirit can move to the piece at the given map coords.

    Dim sTemp As String * 1
    
    sTemp = rrMap.GetData(intX, intY)
    
    If sTemp = "0" Or sTemp = "i" Or sTemp = "e" Or sTemp = "c" Then
        CanMoveTo = True
    Else
        CanMoveTo = False
    End If
End Function
