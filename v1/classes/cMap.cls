VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Public sngTimeLeft As Single
Public sngTimeBombOut As Single

Public timTimeBomb As New exTools_Timer



Public intTotDimonds      As Integer       '    \
Public intTotCrowns       As Integer       '      -  All must = 0 before bomb can be defused
Public intTotEggs         As Integer       '    /
Public intTotMonstersAlive As Integer      '   /
Public intTotMonsters     As Integer

Public intTotRocksOrEggs  As Integer
Public intTotSpirits      As Integer
Public intTotFunguses     As Integer       ' Needed for fungus growth determination
Public intTotTransporters As Integer


Dim intRTData() As String          ' Real Time map data

Public intMapSizeX     As Integer
Public intMapSizeY     As Integer





Private Type Corrds2D_T
    x As Integer
    y As Integer
End Type

Private Type GameMessages_T
    strMessage As String
    tTriggers(20) As Corrds2D_T
    iTotTrigs     As Integer
End Type

Private Type SceneryInfo_T
    strMeshFile    As String
    strTexFile     As String
    tSizeTopLeft   As Corrds2D_T
    tSizeBotRight  As Corrds2D_T
    bIsMovableTo   As Boolean
End Type

Dim tInGameMessages()             As GameMessages_T
Dim intShowingMsg As Integer
Dim intCurMsgLine As Integer

Dim SceneryPieces()               As SceneryInfo_T
Dim bNavMapFromStart              As Boolean


Function LoadFileLevel() As Boolean

    Dim n As Integer
    Dim x As Integer
    Dim y As Integer
    Dim sTemp As String
    
    intShowingMsg = -1
    
    LoadFileLevel = False

    ' Individual level info::
sTemp = rrGame.LevelOrder(rrGame.iCurGameLevel)
    Open rrGame.sEpisodeDir & sTemp & ".rrl" For Input As #1
    
        ReDim tTransporters(0)
    
        ' RR file version
        Input #1, sTemp   '"ReptonReturnsLevelV1.1"
        If Mid(sTemp, 1, 18) = "ReptonReturnsLevel" Then
            If Val(Mid(sTemp, 19, 3)) > 1.1 Then
                MsgBox "The choosen Repton Returns level file requieres a newer version of the Repton Returns game, check the website for updates", , "Repton Returns"
                
                Exit Function
            End If
        Else
            MsgBox "The selected file is not a compatable Repton Returns level", , "Repton Returns"
            
            Exit Function
        End If
        
        ' Level Name
        Input #1, sTemp
        rrGame.LevelOrder rrGame.iCurGameLevel, sTemp
        
        ' Time allowed
        Input #1, sngTimeBombOut
        
        ' Map Size
        Input #1, sTemp
        intMapSizeX = Int(sTemp) + 2
        Input #1, sTemp
        intMapSizeY = Int(sTemp) + 2
        
        ' Map data
        ReDim intRTData(intMapSizeX, intMapSizeY)
        ReDim rrPieces(intMapSizeX, intMapSizeY)

        ' Get map layout data
        x = 1
        y = 1
        Do
            
            If y < intMapSizeY - 1 Then Input #1, sTemp
                    
            For x = 1 To intMapSizeX
            
                ' Put wall boarder around map
                If x = 1 Or x = intMapSizeX Or y = 1 Or y = intMapSizeY Then
                    rrPieces(x, y).TypeID = "5"
                    
                ' Else use read in value
                Else
                    rrPieces(x, y).TypeID = Mid(sTemp, x - 1, 1)
                    
                    ' Keep track of piece count
                    Select Case rrPieces(x, y).TypeID
                        Case "n"
                            ReDim tTransporters(UBound(tTransporters) + 1)
                    End Select
                    
                End If
                intRTData(x, y) = rrPieces(x, y).TypeID
            Next x
            y = y + 1
        
        Loop While y <= intMapSizeY

        
        ' Transporter info (in order as from map)
        If UBound(tTransporters) > 0 Then
            For n = 1 To UBound(tTransporters)
                Input #1, sTemp
                tTransporters(n).iToX = Int(sTemp)
                Input #1, sTemp
                tTransporters(n).iToY = Int(sTemp)
            Next n
        End If
        
        ' Sceinary filenames (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim SceneryPieces(Int(sTemp))
        If UBound(SceneryPieces) > 0 Then
            For n = 1 To UBound(SceneryPieces)
                Input #1, sTemp
                SceneryPieces(n).tSizeTopLeft.x = Int(sTemp)
                Input #1, sTemp
                SceneryPieces(n).tSizeTopLeft.y = Int(sTemp)
                
                Input #1, sTemp
                SceneryPieces(n).tSizeBotRight.x = Int(sTemp)
                Input #1, sTemp
                SceneryPieces(n).tSizeBotRight.y = Int(sTemp)
                
                Input #1, sTemp
                SceneryPieces(n).bIsMovableTo = CBool(sTemp)
                
                Input #1, SceneryPieces(n).strMeshFile
                Input #1, SceneryPieces(n).strTexFile
                
            Next n

        End If
        
        ' In-game messages data (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim tInGameMessages(Int(sTemp))
            
        If UBound(tInGameMessages) > 1 Then
            For n = 1 To UBound(tInGameMessages)
                Input #1, sTemp
                tInGameMessages(n).iTotTrigs = Int(sTemp)
                
                If tInGameMessages(n).iTotTrigs > 0 Then
                    For x = 1 To tInGameMessages(n).iTotTrigs
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(x).x = Int(sTemp)
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(x).y = Int(sTemp)
                    Next x
                End If
                
                Input #1, sTemp
                Do While sTemp <> "</game-message>"
                    tInGameMessages(n).strMessage = tInGameMessages(n).strMessage + vbCrLf + sTemp
                    Input #1, sTemp
                Loop
            
            Next n
        End If
        
        ' Navigation map is present from start
        Input #1, sTemp
        bNavMapFromStart = CBool(sTemp)
        
        LoadFileLevel = True
        
    Close #1
    
End Function

' For game saves, or future Repton 2 functionallity
'Function SaveFileLevel() As Boolean
'
'    Dim n As Integer
'    Dim x As Integer
'    Dim y As Integer
'    Dim sTemp As String
'
'    SaveFileLevel = False
'
'    ' Individual level info::
'
'    Open App.Path + "\temp\" + strLevelOrder(intCurSelLevel) + ".rrl" For Output As #1
'
'        ' RR file version
'        Print #1, "ReptonReturnsLevelV1.1"
'
'        ' Level Name
'        Print #1, strLevelOrder(intCurSelLevel)
'
'        ' Time allowed
'        Print #1, Trim(Str(sngMapTime))
'
'        ' Map Size
'        Print #1, Trim(Str(tMapSize.x)) + "," + Trim(Str(tMapSize.y))
'
'        ' Map data
'        n = 1
'        For y = 1 To tMapSize.y
'            sTemp = ""
'            For x = 1 To tMapSize.x
'                If sLogicalMap(n) = "" Or sLogicalMap(n) = " " Then sLogicalMap(n) = "0"
'                sTemp = sTemp + sLogicalMap(n)
'
'                n = n + 1
'            Next x
'            Print #1, sTemp
'        Next y
'
'        ' Transporter info (in order as from map)
'        If UBound(tTransporterCorrds) > 0 Then
'            For n = 1 To UBound(tTransporterCorrds)
'                Print #1, Trim(Str(tTransporterCorrds(n).x)) + "," + Trim(Str(tTransporterCorrds(n).y))
'            Next n
'        End If
'
'        ' Sceinary filenames (in order as IDed)
'        Print #1, Trim(Str(UBound(SceneryPieces)))              ' How many
'        If UBound(SceneryPieces) > 0 Then
'            For n = 1 To UBound(SceneryPieces)
'                Print #1, Trim(Str(SceneryPieces(n).tSizeTopLeft.x)) + "," + Trim(Str(SceneryPieces(n).tSizeTopLeft.y))
'
'                Print #1, Trim(Str(SceneryPieces(n).tSizeBotRight.x)) + "," + Trim(Str(SceneryPieces(n).tSizeBotRight.y))
'
'                Print #1, CStr(SceneryPieces(n).bIsMovableTo)
'
'                Print #1, SceneryPieces(n).strMeshFile
'                Print #1, SceneryPieces(n).strTexFile
'            Next n
'
'        End If
'
'        ' In-game messages data (in order as IDed)
'        Print #1, Trim(Str(UBound(tInGameMessages)))                  ' How many
'        If UBound(tInGameMessages) > 0 Then
'
'            For n = 1 To UBound(tInGameMessages)
'
'                Print #1, Trim(Str(tInGameMessages(n).iTotTrigs))
'                If tInGameMessages(n).iTotTrigs > 0 Then
'                    For x = 1 To tInGameMessages(n).iTotTrigs
'                        Print #1, Trim(Str(tInGameMessages(n).tTriggers(x).x)) + "," + Trim(Str(tInGameMessages(n).tTriggers(x).y))
'                    Next x
'                End If
'
'                Print #1, tInGameMessages(n).strMessage
'
'                Print #1, "</game-message>"
'            Next n
'        End If
'
'        ' Navigation map is present from start
'        Print #1, CStr(bNavMapFromStart)
'
'        SaveFileLevel = True
'
'    Close #1
'
'End Function


Public Function OpenSafes()
    Dim intX As Integer
    Dim intY As Integer
    
    For intY = 1 To rrMap.intMapSizeX
        For intX = 1 To rrMap.intMapSizeY
        
            If intRTData(intX, intY) = "s" Then
                intRTData(intX, intY) = "d"
                rrPieces(intX, intY).TypeID = "d"
            End If
            
        Next intX
    Next intY
End Function

Function GetGeneralPieceType(intX As Integer, intY As Integer) As enmPieceType
' Eg, if a type of wall then returns first type of wall piece ID

    Dim iTy As Integer
    
    iTy = DataStr2Int(Me.GetData(intX, intY))
    
    ' Type of wall?
    If iTy = enmPieceType.Wall Or (iTy >= enmPieceType.Wall8 And iTy <= enmPieceType.Wall1) Then
        GetGeneralPieceType = Wall
    End If
    
End Function




Function GetData(intX As Integer, intY As Integer) As String
    If intX >= 0 And intX <= intMapSizeX And intY >= 0 And intY <= intMapSizeY Then
        GetData = intRTData(intX, intY)
    Else
        GetData = "-1"
    End If
End Function
Function SetData(intX As Integer, intY As Integer, intData As enmPieceType)
    If intX >= 0 And intX <= intMapSizeX And intY >= 0 And intY <= intMapSizeY Then
        intRTData(intX, intY) = DataInt2Str(intData)
        
        ' Update rrPieces
        rrPieces(intX, intY).TypeID = DataInt2Str(intData)
    End If
End Function

Function TimeBombControl(intCont As Integer)
' 0 = Pause
' 1 = Unpause
' 2 = Update

    Select Case intCont
        Case 0
            sngTimeLeft = sngTimeBombOut - timTimeBomb.LocalTime
            
        Case 1
            sngTimeBombOut = sngTimeLeft + timTimeBomb.LocalTime
            
        Case 2
            If rrGame.Pause(-2) = False Then sngTimeLeft = sngTimeBombOut - timTimeBomb.LocalTime
        
    End Select

End Function


Function MessageCheckAndShow(intX As Integer, intY As Integer)

    Dim n As Integer
    Dim t As Integer
    
    ' Is trigger?
    For n = 1 To UBound(tInGameMessages)
        For t = 1 To tInGameMessages(n).iTotTrigs
            If tInGameMessages(n).tTriggers(t).x = intX And tInGameMessages(n).tTriggers(t).y = intY Then
                GoTo MsgFound
            End If
        Next t
    Next n
    
  Exit Function
    
MsgFound:
    
    ' Show message board
    ExMsgBoard.ResetMatrix
    ExMsgBoard.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(rrRepton.GetXPos), Ret3DPos(rrRepton.GetYPos) - 260, 200), ExPrj.exReturn3DVec(Ret3DPos(rrRepton.GetXPos), Ret3DPos(rrRepton.GetYPos), -200), 0.5
    ExMsgBoard.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(211, 0.1, 0.1), ExPrj.exReturn3DVec(-180, 0, 0), 0.5
    
    intShowingMsg = n
    intCurMsgLine = 1
    
    rrGame.Pause 0
End Function

Function MessageUpdate()

    'dim sMsgLines(6) as String

    Dim n As Integer
    Dim ln As Integer
    Dim x As Boolean
    Dim sTemp As String
    
    Dim sChar As String * 1
    Dim iLastSpace As Integer
    Dim iNLastSpace As Integer
    Dim iLines As Integer
    
    
    If intShowingMsg = -1 Then Exit Function
    
    ' Don't show text if transforming
    If ExMsgBoard.AnimatedTransform.Active(Rotation3D) = True Then Exit Function
    
    ' Show message ...
    iLines = 0
    n = 1
    Do
        
        ' Get a line
        sTemp = ""
        x = False
        ln = 1
        iLastSpace = 0
        iNLastSpace = 0
        Do While x = False And ln < 51 And n <= Len(tInGameMessages(intShowingMsg).strMessage)
        
            sChar = Mid(tInGameMessages(intShowingMsg).strMessage, n, 1)
            
            If sChar <> vbCr Then
                
                If sChar <> " " And sChar <> "-" Then
                    If ln < 50 Then
                        sTemp = sTemp + sChar
                    Else
                        sTemp = Mid(sTemp, 1, iLastSpace)
                        n = iNLastSpace
                        
                        x = True
                    End If
                Else
                    If ln < 50 Then
                        sTemp = sTemp + sChar
                        iLastSpace = ln
                        iNLastSpace = n
                    Else
                        x = True
                    End If
                End If
            Else
                n = n + 1   ' Discard the line feed
                x = True
            End If
            n = n + 1
            ln = ln + 1
            
        Loop
        
        ExTxtMsg.Text sTemp
        ExTxtMsg.Position frmMain.ScaleWidth / 6, (frmMain.ScaleHeight / 5) + (iLines * 30)
        ExTxtMsg.Render
        
        iLines = iLines + 1
        
    Loop While iLines < 20 And n <= Len(tInGameMessages(intShowingMsg).strMessage)
        
    
    ' Delete message and exit
    'intShowingMsg = -1
    'rrGame.Pause -1
End Function
