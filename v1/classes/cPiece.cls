VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPiece"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit


Dim strCType    As String   ' Current value of 'TypeID'

Dim intCurX As Integer
Dim intCurY As Integer

Public intRockOrEggID As Integer    ' Holds the moveable repersentation ID for this piece;
                                 '  (ID = -1) = Not a moveable piece; (0 => ID =< UBound(ID)) = rrRocksOrEggs(ID)
                                 
Public intMonsterID As Integer

Public intTransporterID As Integer  ' Holds look up ID for transporter
                                    '  Note: ID will be relitive to the number of transporters within the MAP
                                    '         upto the position of this transporter (starting at 1)



Function Render()
    Dim intPieceType As Integer
    
    ' Ground is everywhere (except for where walls are)
    If rrMap.GetGeneralPieceType(intCurX, intCurY) <> Wall Then
        
        ' Lets render the ground now
        intPieceType = GetWallAroundInfo(intCurX, intCurY)
        Ex3DGround(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
        Ex3DGround(intPieceType).Render
        
    End If
    
    ' Continue rendering this piece
    intPieceType = DataStr2Int(strCType)
    
    ' Specal Case for pieces that can be repersented by multiple meshes, or is a moveable piece
    Select Case intPieceType
    
        Case Wall
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
            Ex3DWallSides(0).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(0).Render
            
            Ex3DWallSides(1).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(1).Render

            Ex3DWallSides(2).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(2).Render

            Ex3DWallSides(3).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(3).Render
        
        Case Wall2
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render

            
            Ex3DWallSides(3).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(3).Render

        Case Wall4
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render

            Ex3DWallSides(2).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(2).Render


        Case Wall6
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
            Ex3DWallSides(1).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(1).Render
        
        Case Wall8
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
'
            Ex3DWallSides(0).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DWallSides(0).Render
            
        Case Rock
            rrRocksOrEggs(intRockOrEggID).Render
        
        Case Egg
            If intRockOrEggID <> -1 Then rrRocksOrEggs(intRockOrEggID).Render
            ''' DEBUG:: this check is needed because of some unknown bug
            
        Case skull
            SpinObject intPieceType, 2
            
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
        Case Dimond
            SpinObject intPieceType, 1
            
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
        Case TimeCapsule
            SpinObject intPieceType, 1
            
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
        
        Case Key
            SpinObject intPieceType, 1
            
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
        Case Cage
            SpinObject intPieceType, 0.7
            
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
            
        Case monster
            ' Do nothing
        
        Case Else
            Ex3DP(intPieceType).position Ret3DPos(intCurX), Ret3DPos(intCurY), -240, True
            Ex3DP(intPieceType).Render
        
    End Select
    
End Function

Public Property Get TypeID() As String
    TypeID = strCType
End Property
Public Property Let TypeID(strType As String)
    strCType = strType
End Property

Function SetPosition(intX As Integer, intY As Integer)
    intCurX = intX
    intCurY = intY
End Function

Function GetXPos() As Integer
    GetXPos = intCurX
End Function
Function GetYPos() As Integer
    GetYPos = intCurY
End Function


Private Function SpinObject(intPieceType As Integer, iSpeed As Single)
    If Ex3DP(intPieceType).AnimatedTransform.active(Rotation3D) = False Then
        'Ex3DP(intPieceType).ResetMatrix
        Ex3DP(intPieceType).AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(0, 0, 360), ExPrj.exReturn3DVec(0, 0, 0), iSpeed
    End If
End Function

