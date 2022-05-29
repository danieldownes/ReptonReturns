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


Public intTotDimonds      As Integer       '    \
Public intTotCrowns       As Integer       '      -  All must = 0 before bomb can be defused
Public intTotEggs         As Integer       '    /
Public intTotMonsters     As Integer       '   /

Public intTotRocksOrEggs  As Integer
Public intTotSpirits      As Integer
Public intTotFunguses     As Integer       ' Needed for fungus growth determination
Public intTotTransporters As Integer


Dim intRTData(30, 27) As String          ' Real Time map data

Dim intClsLevel     As String
Dim strClsLevelsDir As String
Dim strClsThemeDir  As String

Dim intMapSizeX     As Integer
Dim intMapSizeY     As Integer


Function LoadLevelData(strFileName As String) As String

    Dim intX As Integer
    Dim intY As Integer
    Dim strTemp As String


   Open strFileName For Input As #1

    ' Read name of map
    Input #1, LoadLevelData

    ' Get map layout data
    intX = 0
    intY = 0
    Do

        intY = intY + 1
        
        Input #1, strTemp
                
        For intX = 1 To 30
                    
            rrPieces(intX, intY).TypeID = getStringSeg(strTemp, " ", intX)
            intRTData(intX, intY) = rrPieces(intX, intY).TypeID
            
        Next intX

    Loop Until intY >= 27
    
    ' Save Map size
    intMapSizeX = 30
    intMapSizeY = 27
        
        
    If EOF(1) = False Then

        ' Get transporter data
        intX = 1 ' Used as transporter ID
        Do
            Input #1, strTemp
            tTransporters(intX).iToX = Int(strTemp)
            Input #1, strTemp
            tTransporters(intX).iToY = Int(strTemp)
            intX = intX + 1
        Loop Until EOF(1)

    End If
    
    

   Close #1
         
   SetupLevel

End Function


Public Function OpenSafes()
    Dim intX As Integer
    Dim intY As Integer
    
    For intY = 1 To 27
        For intX = 1 To 30
        
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

Property Let GameLevelsDir(strDir As String)
    strClsLevelsDir = strDir
End Property
Property Get GameLevelsDir() As String
    GameLevelsDir = strClsLevelsDir
End Property

Property Let CurGameLevel(intLevel As Integer)
    intClsLevel = intLevel
End Property
Property Get CurGameLevel() As Integer
    CurGameLevel = intClsLevel
End Property


Property Let ThemeDir(strPath As String)
    strClsThemeDir = strPath
End Property
Property Get ThemeDir() As String
    ThemeDir = strClsThemeDir
End Property


Function GetData(intX As Integer, intY As Integer) As String
    If intX >= 1 And intX <= intMapSizeX And intY >= 1 And intY <= intMapSizeY Then
        GetData = intRTData(intX, intY)
    Else
        GetData = "-1"
    End If
End Function
Function SetData(intX As Integer, intY As Integer, intData As enmPieceType)
    If intX >= 1 And intX <= intMapSizeX And intY >= 1 And intY <= intMapSizeY Then
        intRTData(intX, intY) = DataInt2Str(intData)
        
        ' Update rrPieces
        rrPieces(intX, intY).TypeID = DataInt2Str(intData)
    End If
End Function




' ----- Old Functions -----
'
'Function FindObjNum(intX, intY) As Integer
'Dim intYt As Integer
'Dim intXt As Integer
'
'    FindObjNum = 0
'
'    For intYt = 1 To intY
'        For intXt = 1 To intX
'            FindObjNum = FindObjNum + 1
'        Next intXt
'    Next intYt
'End Function



'Function InitHideAndShow(intX As Integer, intY As Integer)
'Dim ObjNum As Integer
'Dim intXs As Integer
'Dim intYs As Integer
'
'   ObjNum = FindObjNum(intX, intY)
'
'   For intY = -3 To 3
'      For intXs = -4 To 4
'
'          ObjNum = pob(1) + intXs + (intY * 30)
'
'          If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = True
'
'      Next intXs
'   Next intY
'
'End Function


'Function HideAndShow(intMove As Integer)
'
'Dim ObjNum As Integer
'Dim intXs As Integer
'Dim intYs As Integer
'
''8 = up, 2 = down, 4 = left, 6 = right (numpad)
'
'    Select Case intMove
'
'    Case 8
'      For intXs = -4 To 4
'         ObjNum = pob(1) + intXs - 120
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intXs
'
'      For intXs = -4 To 4
'         ObjNum = pob(1) + intXs + 90
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intXs
'
'
'    Case 2
'      For intXs = -5 To 5
'         ObjNum = pob(1) + intXs + 90
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intXs
'
'      For intXs = -4 To 4
'         ObjNum = pob(1) + intXs - 120
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intXs
'
'
'    Case 6
'      For intYs = -4 To 4
'         ObjNum = pob(1) + 4 + (intYs * 30)
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intYs
'
'      For intYs = -4 To 4
'         ObjNum = pob(1) - 4 + (intYs * 30)
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intYs
'
'
'    Case 4
'      For intYs = -3 To 3
'         ObjNum = pob(1) - 4 + (intYs * 30)
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intYs
'
'      For intYs = -3 To 3
'         ObjNum = pob(1) + 4 + (intYs * 30)
'
'         If ObjNum > 0 And ObjNum < 811 Then rrPieces(ObjNum).InScope = False
'      Next intYs
'
'End Function




