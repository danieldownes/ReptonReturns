Attribute VB_Name = "modReptonReturns"
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit


Public rrGame            As New cGame       ' Main game flow control (loading/exiting levels, etc)
Public rrMap             As New cMap        ' The loaded level
Public rrRepton          As New cPlayer     ' A human player (Repton)
Public rrPieces(30, 27)  As New cPiece      ' A piece on the level
Public rrRocksOrEggs(50) As New cRockOrEgg  ' A rock or egg; moveable piece
Public rrMonster(4)      As New cMonster
Public rrSpirit(4)       As New cSpirt


Dim intWallAround_LOOKUP(1, 1, 1, 1) As Integer       ' (2,4,6,8) - wall is there(1) or not(0) for each
                                                      '  Down [2], Left [4], Right [6], Up [8]  (KeyPad)
                                                      '  Used in 'GetWallAroundInfo'
                                           

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
End Enum



Function DrawFrame()
    
    Dim intObj As Integer
    
    Dim intX As Integer
    Dim intY As Integer
    
    
    ' Start of Rendering process
    ExPrj.Render
    
    
    ' Only render the pieces that are in view
    For intY = -4 To 4
        For intX = -6 To 6

            If GetPlayerOffsetPiece(intX, intY) <> -1 Then
                rrPieces(rrRepton.GetXPos + intX, rrRepton.GetYPos + intY).Render
            Else
                ' Default to a wall (this is outside the defined map)
                Ex3DP(1).Position Ret3DPos(rrRepton.GetXPos + intX), Ret3DPos(rrRepton.GetYPos + intY), -240, True
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
    
    ' Render spirts
    For intX = 0 To rrMap.intTotSpirits
        rrSpirit(intX).Render
    Next intX
    
    ' Update and Render the visual player
    rrRepton.UpDate
    
    
    ' Render GUI
    txt2D.Render
    
    txtScore2D.Position 10, 10
    txtScore2D.Text "Dimonds left: " & rrMap.intTotDimonds - rrRepton.intDimondsCollected
    txtScore2D.Render
    
    txtScore2D.Position 600, 10
    txtScore2D.Text "Lives: " & Str(rrRepton.intLives)
    txtScore2D.Render
    
    
    ' Finally flip the buffers, completing the rendering process.
    ExPrj.Sync



End Function


Function UserInteraction()

    
    ' Check for inputs
    If ExInp.exInput(ex_Right_arrow) Then rrRepton.Move Right
    If ExInp.exInput(ex_Left_arrow) Then rrRepton.Move Left
    If ExInp.exInput(ex_Down_arrow) Then rrRepton.Move Down
    If ExInp.exInput(ex_Up_arrow) Then rrRepton.Move Up
    
    'If ExInp.exInput(ex_a) Then msgbox(str(Ex3DP(
    
    ' If ExInp.exInput(ex_f2) Then prj.ChangeRenderDevice
    
    
    If ExInp.exInput(ex_ESCAPE) Then frmMain.Form_Unload 0
    
End Function




Function SetupLevel() As Integer
' 0 = Okay
' 1 = Error while processing map

    Dim intX As Integer
    Dim intY As Integer
    
    Dim strThemeDir As String
    
    Randomize
    
    ' Get Full Dir Path of theme
     strThemeDir = App.Path & "\data\themes"     ' rrMap.ThemeDir
    
    
   
    
    ' Load meshes...   (note that Ex-Perspective horizontaliy flips the screen output and that the
    '                    actual file data does not respect this; n.b. walls will use their opposit
    '                    equivalent; e.g wall4 = the image that would normally show wall6)
    
    'Ex3DP(enmPieceType.Space).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\space.bmp"
    
    Ex3DP(enmPieceType.Dimond).InitXFile strThemeDir & "\meshes\dimond.x"  ', strThemeDir & "\dimond.bmp"
    
    Ex3DP(enmPieceType.Wall).InitXFile strThemeDir & "\meshes\std_wall\w5.x", strThemeDir & "\wall.bmp"
    Ex3DP(enmPieceType.Wall8).InitXFile strThemeDir & "\meshes\std_wall\w8.x", strThemeDir & "\wall8.bmp"
    Ex3DP(enmPieceType.Wall2).InitXFile strThemeDir & "\meshes\std_wall\w2.x", strThemeDir & "\wall2.bmp"
    Ex3DP(enmPieceType.Wall4).InitXFile strThemeDir & "\meshes\std_wall\w6.x", strThemeDir & "\wall6.bmp"
    Ex3DP(enmPieceType.Wall6).InitXFile strThemeDir & "\meshes\std_wall\w4.x", strThemeDir & "\wall4.bmp"
    Ex3DP(enmPieceType.Wall9).InitXFile strThemeDir & "\meshes\std_wall\w7.x", strThemeDir & "\wall7.bmp"
    Ex3DP(enmPieceType.Wall7).InitXFile strThemeDir & "\meshes\std_wall\w9.x", strThemeDir & "\wall9.bmp"
    Ex3DP(enmPieceType.Wall3).InitXFile strThemeDir & "\meshes\std_wall\w1.x", strThemeDir & "\wall1.bmp"
    Ex3DP(enmPieceType.Wall1).InitXFile strThemeDir & "\meshes\std_wall\w3.x", strThemeDir & "\wall3.bmp"

    Ex3DP(11).InitXFile strThemeDir & "\meshes\egg.x", strThemeDir & "\earth.bmp"
    Ex3DP(12).InitXFile strThemeDir & "\meshes\rock.x", strThemeDir & "\textures\ROCK.BMP"
    Ex3DP(13).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\safe.bmp"
    Ex3DP(14).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\key.bmp"
    Ex3DP(15).InitXFile strThemeDir & "\meshes\egg.x", strThemeDir & "\textures\egg.bmp"
    Ex3DP(16).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\repton.bmp"
    Ex3DP(17).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\crown.bmp"
    Ex3DP(18).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\cage.bmp"
    Ex3DP(19).InitXFile strThemeDir & "\meshes\rock.x", strThemeDir & "\spirit.bmp"
    Ex3DP(20).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\bomb.bmp"
    Ex3DP(21).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\fungus.bmp"
    Ex3DP(22).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\skull.bmp"
    Ex3DP(23).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\barrier.bmp"
    Ex3DP(24).InitXFile App.Path & "\_debug\3.x", strThemeDir & "\repton.bmp"
    
    
    ' Ground meshes
    For intX = 0 To 15
        Ex3DGround(intX).InitXFile strThemeDir & "\meshes\ground\" & Trim(Str(intX)) & ".x", strThemeDir & "\textures\ground.bmp"
        Ex3DGround(intX).Rotate 90, 0, 0, True
    Next intX
    
    ' Wall sides
    
    Ex3DWallSides(0).InitXFile strThemeDir & "\meshes\wall_sides\s2.x", strThemeDir & "\textures\stdwall_side.bmp"
    Ex3DWallSides(1).InitXFile strThemeDir & "\meshes\wall_sides\s4.x", strThemeDir & "\textures\stdwall_side.bmp"
    Ex3DWallSides(2).InitXFile strThemeDir & "\meshes\wall_sides\s6.x", strThemeDir & "\textures\stdwall_side.bmp"
    Ex3DWallSides(3).InitXFile strThemeDir & "\meshes\wall_sides\s8.x", strThemeDir & "\textures\stdwall_side.bmp"
    Ex3DWallSides(0).Rotate 90, 180, 0, True
    Ex3DWallSides(1).Rotate 90, 180, 0, True
    Ex3DWallSides(2).Rotate 90, 180, 0, True
    Ex3DWallSides(3).Rotate 90, 180, 0, True
    
    
    rrRepton.Init
    
    modRR_GameEvents.FungusNewTime
    
    
    ' Load sounds...
    ExSnds(0).InitSound strThemeDir & "\sounds\m_dimond.wav"
    
    
    rrMap.intTotRocksOrEggs = 0
    rrMap.intTotEggs = 0
    rrMap.intTotMonsters = 0
    rrMap.intTotSpirits = 0
    rrMap.intTotDimonds = 0
    rrMap.intTotFunguses = 0
    
    
   For intY = 1 To 27
      For intX = 1 To 30
        
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
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).Init Rock, intX, intY
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).intMyRockOrEggID = rrMap.intTotRocksOrEggs
                rrPieces(intX, intY).intRockOrEggID = rrMap.intTotRocksOrEggs
                rrMap.intTotRocksOrEggs = rrMap.intTotRocksOrEggs + 1
            
            Case "s"   'Safe
                
                ' Keep track of total dimonds
                rrMap.intTotDimonds = rrMap.intTotDimonds + 1
            
'            Case "k"   'Key

            Case "g"   'Egg
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).Init Egg, intX, intY
                rrRocksOrEggs(rrMap.intTotRocksOrEggs).intMyRockOrEggID = rrMap.intTotRocksOrEggs
                rrPieces(intX, intY).intRockOrEggID = rrMap.intTotRocksOrEggs
                rrMap.intTotRocksOrEggs = rrMap.intTotRocksOrEggs + 1
                
                
                ' Init a monster for this egg
                rrMonster(rrMap.intTotEggs).Init 1, 1
                rrMonster(rrMap.intTotEggs).intMyID = rrMap.intTotEggs
                
                rrMap.intTotEggs = rrMap.intTotEggs + 1
                
            
            Case "i"   'Repton stating point
               
                ' Set starting position of objects...
                rrRepton.SetPosition intX, intY
                ExCam.Position -((rrRepton.GetXPos - 1) * 95.5), -((rrRepton.GetYPos - 1) * 95.5) - 200, 700, True
                ExCam.LookAt -((rrRepton.GetXPos - 1) * 95.5), -((rrRepton.GetYPos - 1) * 95.5), 0

                
            Case "t"   'Crown

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
            
            Case Else 'Error!
                
                
        
        End Select
        
      Next intX
   Next intY

End Function


Function GetPlayerOffsetPiece(intX As Integer, intY As Integer) As Integer
' -1 = No piece (off the edge of the map)
' Else the piece int ID is returned

    Dim iX As Integer
    Dim iY As Integer

    ' Calculate its position
    iX = rrRepton.GetXPos + intX
    iY = rrRepton.GetYPos + intY

    ' Check if this is a piece off the edge of the map...
    '  Left, Top, Right, Bottom
 
    If iX <= 0 Or iY <= 0 Or iX > 30 Or iY > 26 Then
       
            ' Flat wall
            GetPlayerOffsetPiece = -1  'enmPieceType.Wall
            
            Exit Function
            
    End If
    
    
        'THIS data is not needed, just make sure it isn't -1
    'GetPlayerOffsetPiece = DataStr2Int(rrPieces(iX, iY).TypeID)
    GetPlayerOffsetPiece = 0
    
End Function

Sub SetupWallAroundInfo_LookUpTable()
    
    '                    2  4  6  8    TypeOfFloor
    intWallAround_LOOKUP(0, 0, 0, 0) = 5
    intWallAround_LOOKUP(0, 0, 0, 1) = 8
    intWallAround_LOOKUP(0, 0, 1, 0) = 6
    intWallAround_LOOKUP(0, 0, 1, 1) = 9
    
    intWallAround_LOOKUP(0, 1, 0, 0) = 4
    intWallAround_LOOKUP(0, 1, 0, 1) = 7
    intWallAround_LOOKUP(0, 1, 1, 0) = 10
    intWallAround_LOOKUP(0, 1, 1, 1) = 12
    
    intWallAround_LOOKUP(1, 0, 0, 0) = 2
    intWallAround_LOOKUP(1, 0, 0, 1) = 11
    intWallAround_LOOKUP(1, 0, 1, 0) = 3
    intWallAround_LOOKUP(1, 0, 1, 1) = 13
    
    intWallAround_LOOKUP(1, 1, 0, 0) = 1
    intWallAround_LOOKUP(1, 1, 0, 1) = 15
    intWallAround_LOOKUP(1, 1, 1, 0) = 14
    intWallAround_LOOKUP(1, 1, 1, 1) = 0
    
End Sub
Function GetWallAroundInfo(intX As Integer, intY As Integer) As Integer
' Selects the correct meshID for 'specal case' map piece. Eg. need to know what type of ground should be
'  rendered with consideration to the surrounding walls

    Dim blnOffWall(4) As Boolean


    ' Dermine what walls are present
    blnOffWall(1) = (rrMap.GetGeneralPieceType(intX, intY + 1) = enmPieceType.Wall)     ' 2
    blnOffWall(2) = (rrMap.GetGeneralPieceType(intX - 1, intY) = enmPieceType.Wall)     ' 4
    blnOffWall(3) = (rrMap.GetGeneralPieceType(intX + 1, intY) = enmPieceType.Wall)     ' 6
    blnOffWall(4) = (rrMap.GetGeneralPieceType(intX, intY - 1) = enmPieceType.Wall)     ' 8
    
    ' 'Look-Up' the type of ground mesh using our lookup table
    GetWallAroundInfo = intWallAround_LOOKUP(CInt(blnOffWall(1) * -1), CInt(blnOffWall(2) * -1), Int(blnOffWall(3)) * -1, Int(blnOffWall(4)) * -1)
                                                'CInt' needed  ???
End Function



' TODO: Convert to lookup table, or, irradicate one type

Function DataInt2Str(intIn As enmPieceType) As String

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
   
End Function


Function DataStr2Int(strIn As String) As Integer

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
   
'   if strIn = "%" then DataStr2Int =
'   if strIn = "*" then DataStr2Int =
'   if strIn = ")" then DataStr2Int =
'   if strIn = "^" then DataStr2Int =
'   if strIn = "$" then DataStr2Int =
'   if strIn = "(" then DataStr2Int =
'   if strIn = "&" then DataStr2Int =
'   if strIn = "£" then DataStr2Int =
'   if strIn = "!" then DataStr2Int =
End Function
