VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRockOrEgg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit


Public intMyRockOrEggID As Integer

Public intPieceType As enmPieceType      ' Should only be Rock OR Egg



Public intCurX As Integer
Public intCurY As Integer

Dim int3DDirection As enmDirection              ' Current direction that we are rolling (if rolling at all)
Dim int3DLastDir   As enmDirection              ' Last direction we rolled

Public blnFalling   As Boolean
Public blnFreeFall  As Boolean

Private ExLog3D As New exMesh               ' Logical 3D (so that transformations are preserved; no mesh data)

Const cintTimeToMove = 0.15          ' Number of seconds it take for rock/egg to move from one
                                     '  map piece to another.


Function Init(intType As enmPieceType, intX As Integer, intY As Integer)
' intType should only be Rock OR Egg

    intPieceType = intType
    
    intCurX = intX
    intCurY = intY
    
    ExLog3D.Position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    
    If intType = Rock Then
        ' Random post rotation?
        'ExLog3D.InitXFile ""
        ExLog3D.Rotate 0, Rnd() * 360, 0, True
        'ExLog3D.ResetMatrix
    End If
    
    blnFalling = False

End Function


Function Render()

    ExLog3D.Render '' Simply to update animation
    
    Ex3DP(intPieceType).Rotate ExLog3D.Rotate.x, ExLog3D.Rotate.y, ExLog3D.Rotate.Z, True
    Ex3DP(intPieceType).Position ExLog3D.Position.x, ExLog3D.Position.y, ExLog3D.Position.Z, True
    
    
    Ex3DP(intPieceType).Render

End Function


Public Function Move(intDir As enmDirection)

    Dim intOldX As Integer
    Dim intOldY As Integer
    Dim n       As Integer

    intOldX = intCurX
    intOldY = intCurY
    
    Select Case intDir
        Case Up
            ' Rocks can not move up, exit now
            Exit Function
            
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
    
    
    
    ' Its already been dertimined that its ok to move to the new coords.- so let update this logically...
    
    ' Before we do though, are there any monsters in the way? if so they should die..
    
    ' Is monster under rock?
    If rrMap.GetData(intCurX, intCurY) = "m" Then
        ' Find ID of this monster and kill it - should also work if more than one monster is in same place
        For n = 1 To rrMap.intTotMonstersAlive
            If rrMonster(n).GetXPos = intCurX And rrMonster(n).GetYPos = intCurY Then
                rrMonster(n).Die
            End If
        Next n
    End If
    
    rrMap.SetData intCurX, intCurY, intPieceType
    rrMap.SetData intOldX, intOldY, Space
    rrPieces(intCurX, intCurY).intRockOrEggID = intMyRockOrEggID
    rrPieces(intOldX, intOldY).intRockOrEggID = -1
    
    
    Move3D          ' Direction and/or position may have changed
    
End Function

Function Move3D()
    
    ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), -240), ExLog3D.Position, 0.15  'cintTimeToMove
    'ExLog3D.Position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
    
End Function


Function CheckIfFall()
    
    Dim sTemp As String * 1
    Dim bWasFalling As Boolean
    Dim iTemp As Integer
    Dim n As Integer
    
    bWasFalling = False
    
    
    
    
    ' Have we stoped falling?
    If blnFalling = True And ExLog3D.AnimatedTransform.Active(Translation3D) = False Then
        blnFalling = False
        bWasFalling = True
    End If
    
    ' Can only fall if not already falling
    If blnFalling = False Then
    
        ' Is below rock still falling? If so, don't do anything until that rock is out of the way
        If rrPieces(intCurX, intCurY + 1).intRockOrEggID <> -1 Then
            If rrRocksOrEggs(rrPieces(intCurX, intCurY + 1).intRockOrEggID).blnFalling = True Then
                Exit Function
            End If
        End If
        
        ' Fall stight down?
        sTemp = rrMap.GetData(intCurX, intCurY + 1)
        If sTemp = "0" Then
        
            ' Is player moveing under rock?
            If Not (rrRepton.GetXPos = intCurX And rrRepton.GetYPos = intCurY + 1) Then
            
                ' It is ok to make rock fall
                blnFalling = True
                Me.Move Down
            End If
            
'            ' Is a monster (moveing) under rock?
        ElseIf sTemp = "m" Then
            iTemp = rrPieces(intCurX, intCurY + 1).intMonsterID
            If iTemp <> -1 Then
                blnFalling = rrMonster(iTemp).Die
                If blnFalling Then Me.Move Down
            End If
        
        ' Is player already under moving rock?
        ElseIf sTemp = "i" Then
            If bWasFalling = True Then
                rrRepton.Die
            End If
            
        Else
            
            ' Eggs should crack at this point
            If intPieceType = Egg And bWasFalling = True Then
                rrMonster(rrMap.intTotMonstersAlive + 1).Spawn intCurX, intCurY
                
                ' Remove reference that this is an egg
'               rrMap.SetData intCurX, intCurY, Monster
'               rrPieces(intCurX, intCurY).TypeID = "m"
                rrMap.intTotEggs = rrMap.intTotEggs - 1
                intMyRockOrEggID = -1
               
                ' Start GfxFX - hatching egg
                
                ' Prevent egg from further prosessing
                rrPieces(intCurX, intCurY).intRockOrEggID = -1
                Exit Function
            End If
        
        End If
                
    End If
    
    If blnFalling = False Then      ' Still not falling
        
        
        ' Fall to the left?
        
        ' Is left-below rock still falling? If so, don't do anything until that rock is out of the way
        If rrPieces(intCurX - 1, intCurY + 1).intRockOrEggID <> -1 Then
            If rrRocksOrEggs(rrPieces(intCurX - 1, intCurY + 1).intRockOrEggID).blnFalling = True Then
                Exit Function
            End If
        End If
        
        
        ' Is the support currently under rock slanted to the left?
        sTemp = rrMap.GetData(intCurX, intCurY + 1)
        If sTemp = "d" Or sTemp = "7" Or sTemp = "r" Or sTemp = "k" Or sTemp = "g" Or sTemp = "t" Or sTemp = "b" Then
        
            ' if rock or egg support, this needs specal attention
            
                      
            
            sTemp = rrMap.GetData(intCurX - 1, intCurY)     ' Check if room exists to the left (And Repton isn't there)
            If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX And rrRepton.GetYPos = intCurY + 1) Then
                
                sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   ' Check if room exists to 1 left, 1 down (And Repton isn't there)
                If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX - 1 And rrRepton.GetYPos = intCurY + 1) Then
                    
                    iTemp = rrPieces(intCurX - 1, intCurY + 1).intMonsterID
                    If iTemp <> -1 Then
                        rrMonster(iTemp).Die
                    End If
                    
                    ' This rock should fall to the left
                    blnFalling = True
                    Me.Move Left
                    Me.Move Down
                    
                End If
            End If
        End If
    End If
        
    If blnFalling = False Then      ' Still not falling
        
        ' Fall to the right?
        
        ' Is rock-below rock still falling? If so, don't do anything until that rock is out of the way
        If rrPieces(intCurX + 1, intCurY + 1).intRockOrEggID <> -1 Then
            If rrRocksOrEggs(rrPieces(intCurX + 1, intCurY + 1).intRockOrEggID).blnFalling = True Then
                Exit Function
            End If
        End If

        
        
        ' Is the support currently under rock slanted to the right? (Note: this should only be checked if there is no
        '  fall to the left, as in this function)
        sTemp = rrMap.GetData(intCurX, intCurY + 1)
        If sTemp = "d" Or sTemp = "9" Or sTemp = "r" Or sTemp = "k" Or sTemp = "g" Or sTemp = "t" Or sTemp = "b" Then
        
            ' if rock or egg support, this needs specal attention
            
                      
            
            sTemp = rrMap.GetData(intCurX + 1, intCurY)     ' Check if room exists to the left (And Repton isn't there)
            If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX And rrRepton.GetYPos = intCurY + 1) Then
                
                sTemp = rrMap.GetData(intCurX + 1, intCurY + 1)   ' Check if room exists to 1 left, 1 down (And Repton isn't there)
                If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX - 1 And rrRepton.GetYPos = intCurY + 1) Then
                
                    iTemp = rrPieces(intCurX - 1, intCurY + 1).intMonsterID
                    If iTemp <> -1 Then
                        rrMonster(iTemp).Die
                    End If
                    
                    ' This rock should fall to the left
                    blnFalling = True
                    Me.Move Right
                    Me.Move Down
                    
                End If
            End If
        End If
        
    End If
    
    ' If rock is in free falling (ie, it has been falling before it was detected that it should fall
    '  again (directly afterward), then add count (so that it can be detected if it hit repton, or if this is
    '  an egg, if it should crack).
    If blnFalling = True And bWasFalling = True Then
        blnFreeFall = True
    Else
        blnFreeFall = False
    End If
End Function
