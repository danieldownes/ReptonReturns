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

Private ExLog3D As New exMesh



Const cintTimeToMove = 0.27          ' Number of seconds it take for rock/egg to move from one
                                     '  map piece to another.


Function Init(intType As enmPieceType, intX As Integer, intY As Integer)
' intType should only be Rock OR Egg

    Dim strThemeDir As String
    strThemeDir = rrGame.strVisualTheme

    intPieceType = intType
    
    intCurX = intX
    intCurY = intY
    
    
    If intType = Rock Then
        
        ExLog3D.InitXFile strThemeDir & "\meshes\rock.x", strThemeDir & "\textures\ROCK.BMP"
        
        ' Random post rotation?
        ExLog3D.RotateVecs Rnd() * 360, Rnd() * 360, 0
        
    Else
        ' Egg
        ExLog3D.InitXFile strThemeDir & "\meshes\egg.x", strThemeDir & "\textures\egg.bmp"
    End If

    ExLog3D.position Ret3DPos(intCurX), Ret3DPos(intCurY), -200, True
    
    blnFalling = False

End Function


Function Render()

    ExLog3D.Render
    
    If ExLog3D.AnimatedTransform.active(Translation3D) = False Then
       'ExSnds(4).StopSound
    End If
    
End Function


Public Function Move(intDir As enmDirection)

    Dim intOldX As Integer
    Dim intOldY As Integer
    Dim n       As Integer
    
    Dim bDiagRot As Boolean

    intOldX = intCurX
    intOldY = intCurY
    
    If ExLog3D.AnimatedTransform.active(Rotation3D) = True Then
        ' Must be going down already, flag to say to rotate diagonally
        bDiagRot = True
    Else
        bDiagRot = False
    End If
    
    Select Case intDir
        Case Up
            ' Rocks can not move up, exit now
            Exit Function
            
        Case Down
            intCurY = intCurY + 1
                        
                
            If ExLog3D.AnimatedTransform.active(Rotation3D) <> True Then
                ExLog3D.RotateVecs 90, 0, 0
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0.00001, 0, 0), ExPrj.exReturn3DVec(-90, 0, 0), cintTimeToMove
            End If
            
            int3DDirection = Down
            
            PlayFallingSnd True
            
        Case Right
            intCurX = intCurX + 1
            int3DDirection = Right
    
            ExLog3D.RotateVecs 0, -90, 0
            
            ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0.00001, 0), ExPrj.exReturn3DVec(0, 90, 0), cintTimeToMove
            
            PlayFallingSnd True
                        
        Case Left
            intCurX = intCurX - 1
            int3DDirection = Left
            
            ExLog3D.RotateVecs 0, 90, 0
            

            ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0.00001, 0), ExPrj.exReturn3DVec(0, -90, 0), cintTimeToMove
            
            PlayFallingSnd True
               
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
    
    
    Move3D
    
End Function

Function Move3D()
    
    If ExLog3D.AnimatedTransform.active(Translation3D) = False Then
       ' ExSnds(4).PlaySound True
    End If
    
    ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), ExLog3D.position.z), ExLog3D.position, cintTimeToMove
    
End Function


Function CheckIfFall()
    
    Dim sTemp As String * 1
    Dim bWasFalling As Boolean
    Dim iTemp As Integer
    Dim n As Integer
    
    bWasFalling = False
    
    
    ' Have we stoped falling?
    ExLog3D.Render
    If blnFalling = True And ExLog3D.AnimatedTransform.active(Translation3D) = False Then
        blnFalling = False
        bWasFalling = True
        
        ExSnds(4).StopSound
        ExSnds(5).PlaySound False
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
        
            
            sTemp = rrMap.GetData(intCurX - 1, intCurY)     ' Check if room exists to the left (And Repton isn't there)
            If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX - 1 And rrRepton.GetYPos = intCurY) Then
                
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
            
            sTemp = rrMap.GetData(intCurX + 1, intCurY)     ' Check if room exists to the left (And Repton isn't there)
            If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX + 1 And rrRepton.GetYPos = intCurY) Then
                
                sTemp = rrMap.GetData(intCurX + 1, intCurY + 1)   ' Check if room exists to 1 left, 1 down (And Repton isn't there)
                If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX + 1 And rrRepton.GetYPos = intCurY + 1) Then
                
                    iTemp = rrPieces(intCurX + 1, intCurY + 1).intMonsterID
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

Private Sub PlayFallingSnd(bNewFall As Boolean)
    If bNewFall Then
        ExSnds(4).PlaySound True
    End If
End Sub
