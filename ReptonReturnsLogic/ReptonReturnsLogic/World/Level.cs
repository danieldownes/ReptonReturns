using ReptonReturnsLogic.World;
using ReptonReturnsLogic.Pieces;

namespace ReptonReturnsLogic;

/// <summary>
/// A Level holds a map of the world.
/// It allows query of all pieces at play with each pieces respective position.
/// It allows construction and modification of such data structures to allow this representation.
/// It is void of reference to 2D/3D space or game-play logic.
/// It does not care about any particular Piece type.
/// </summary>
public class Level
{
    public IVector Size;
	
    public IPiecePositionMap Map;
    
    // Reference to all our game map pieces
    public List<Piece> Pieces = new List<Piece>();

    public IVector StartPos;


    public int iMonsters;
    public Dictionary<int, GameObject> lMonsters = new Dictionary<int, GameObject>();

    int iMovables;
    int iTransporters;
    int iLevelTrans;

    /*
	public IVector AddSlant(IVector v)
	{
		return new IVector(v.x, v.z * fMapSlant, v.z);
	}
    */

/*
 * 
 * ' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit





Public intTotMonsters     As Integer

Public intTotRocksOrEggs  As Integer
Public intTotSpirits      As Integer
Public intTotFunguses     As Integer       ' Needed for fungus growth determination
Public intTotTransporters As Integer
Public intTotLevelTrans   As Integer


Dim intRTData() As String          ' Real Time map data

Public intMapSizeX     As Integer
Public intMapSizeY     As Integer




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
Public intShowingMsg As Integer
Dim intCurMsgLine As Integer

Dim SceneryPieces()               As SceneryInfo_T
Dim bNavMapFromStart              As Boolean


Dim intLastKey As Integer

Function LoadFileLevel() As Boolean

    Dim n As Integer
    Dim X As Integer
    Dim Y As Integer
    Dim sTemp As String
    Dim sFile As String
    
    intShowingMsg = -1
    
    LoadFileLevel = False
    
    
    ' Individual level info::
    sTemp = rrGame.LevelOrder(rrGame.iCurGameLevel)

    
    ' Make sure sEpisodeDir is correctly formatted
    If Mid(rrGame.sEpisodeDir, Len(rrGame.sEpisodeDir) - 3, 4) = ".rre" Then
        rrGame.sEpisodeDir = Mid(rrGame.sEpisodeDir, 1, InStrRev(rrGame.sEpisodeDir, "\"))
        Select Case UCase(rrGame.strEpisodeName)
            Case "PRELUDE"
                sFile = pckLevelsFiles.GetPackedFile(sTemp & ".rrl")
            Case "FIN"
        End Select
        
    Else
        ' a 'Home' file is being loaded  -- TEMP code
        sFile = rrGame.sEpisodeDir & sTemp & ".rrl"

    End If
    
       
    
    Open sFile For Input As #1
    
        ReDim tTransporters(0)
        ReDim tLevelTrans(0)
        ReDim SceneryPieces(0)
    
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
        X = 1
        Y = 1
        Do
            
            If Y <> 1 And Y < intMapSizeY Then Input #1, sTemp
                    
            For X = 1 To intMapSizeX
            
                ' Put wall boarder around map
                If X = 1 Or X = intMapSizeX Or Y = 1 Or Y = intMapSizeY Then
                    rrPieces(X, Y).TypeID = "5"
                    
                ' Else use read in value
                Else
                    rrPieces(X, Y).TypeID = Mid(sTemp, X - 1, 1)
                    
                    ' Keep track of piece count
                    Select Case rrPieces(X, Y).TypeID
                        Case "n"
                            ReDim tTransporters(UBound(tTransporters) + 1)
                        Case "y"
                            ReDim tLevelTrans(UBound(tLevelTrans) + 1)
                    End Select
                    
                End If
                intRTData(X, Y) = rrPieces(X, Y).TypeID
            Next X
            Y = Y + 1
        
        Loop While Y <= intMapSizeY

        
        ' Transporter info (in order as from map)
        If UBound(tTransporters) > 0 Then
            For n = 1 To UBound(tTransporters)
                Input #1, sTemp
                tTransporters(n).iToX = Int(sTemp) + 1
                Input #1, sTemp
                tTransporters(n).iToY = Int(sTemp) + 1
            Next n
        End If
        
        ' Level-Transporter info (in order as from map)
        If UBound(tLevelTrans) > 0 Then
            For n = 1 To UBound(tLevelTrans)
                Input #1, sTemp
                'tLevelTrans(n).tPos.x = Int(sTemp)
                Input #1, sTemp
                'tLevelTrans(n).tPos.y = Int(sTemp)
                Input #1, tLevelTrans(n).sLocalFile
            Next n
        End If
        
        ' Sceinary filenames (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim SceneryPieces(Int(sTemp))
        If UBound(SceneryPieces) > 0 Then
            If UBound(SceneryPieces) > 0 Then
                For n = 1 To UBound(SceneryPieces)
                    Input #1, sTemp
                    SceneryPieces(n).tSizeTopLeft.X = Int(sTemp) + 1
                    Input #1, sTemp
                    SceneryPieces(n).tSizeTopLeft.Y = Int(sTemp) + 1
                    
                    Input #1, sTemp
                    SceneryPieces(n).tSizeBotRight.X = Int(sTemp) + 1
                    Input #1, sTemp
                    SceneryPieces(n).tSizeBotRight.Y = Int(sTemp) + 1
                    
                    Input #1, sTemp
                    SceneryPieces(n).bIsMovableTo = CBool(sTemp)
                    
                    Input #1, SceneryPieces(n).strMeshFile
                    Input #1, SceneryPieces(n).strTexFile
                    
                Next n
    
            End If
        End If
        
        ' In-game messages data (in order as IDed)
        Input #1, sTemp                              ' How many
        ReDim tInGameMessages(Int(sTemp))
            
        If UBound(tInGameMessages) > 1 Then
            For n = 1 To UBound(tInGameMessages)
                Input #1, sTemp
                tInGameMessages(n).iTotTrigs = Int(sTemp)
                
                If tInGameMessages(n).iTotTrigs > 0 Then
                    For X = 1 To tInGameMessages(n).iTotTrigs
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(X).X = Int(sTemp) + 1
                        Input #1, sTemp
                        tInGameMessages(n).tTriggers(X).Y = Int(sTemp) + 1
                    Next X
                End If
                
                Input #1, sTemp
                Do While sTemp <> "</game-message>"
                    sTemp = Replace(sTemp, "<comma>", ",")
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



Function SaveFileLevel(strFile As String) As Boolean

    Dim n As Integer
    Dim X As Integer
    Dim Y As Integer
    Dim sTemp As String

    SaveFileLevel = False

    ' Individual level info::

    Open strFile For Output As #1
    
        ' RR file version
        Print #1, "ReptonReturnsLevelV1.1"
        
        ' Level Name
        Print #1, rrGame.LevelOrder(rrGame.iCurGameLevel)
        
        ' Time allowed
        Print #1, rrMap.sngTimeBombOut
        
        ' Map Size
        Print #1, Trim(Str(intMapSizeX - 2)) + "," + Trim(Str(intMapSizeY - 2))
       
        ' Map data
        For Y = 2 To intMapSizeY - 1
            sTemp = ""
            For X = 2 To intMapSizeX - 1
                For n = 0 To UBound(rrSpirit)
                    If rrSpirit(n).intOrgX = X And rrSpirit(n).intOrgY = Y And n < (rrMap.intTotSpirits - 1) Then
                        n = 10
                    End If
                Next n
                
                If n = 11 Then
                    sTemp = sTemp + "p"
                Else
                    sTemp = sTemp + rrMap.GetData(X, Y)
                End If
            Next X
            Print #1, sTemp
        Next Y
        
        ' Transporter info (in order as from map)
        If UBound(tTransporters) > 0 Then
            For n = 1 To UBound(tTransporters)
                Print #1, Trim(Str(tTransporters(n).iToX - 1)) + "," + Trim(Str(tTransporters(n).iToY - 1))
            Next n
        End If
        
        ' Level-transorters
        If UBound(tLevelTrans) > 0 Then
            For n = 1 To UBound(tLevelTrans)
                If tLevelTrans(n).sLocalFile <> "!deleted!" Then
                    Print #1, "0,0"
                    Print #1, tLevelTrans(n).sLocalFile
                End If
            Next n
        End If
        
        
        ' Sceinary filenames (in order as IDed)
        Print #1, Trim(Str(UBound(SceneryPieces)))              ' How many
        If UBound(SceneryPieces) > 0 Then
            For n = 1 To UBound(SceneryPieces)
                Print #1, Trim(Str(SceneryPieces(n).tSizeTopLeft.X - 1)) + "," + Trim(Str(SceneryPieces(n).tSizeTopLeft.Y - 1))
               
                Print #1, Trim(Str(SceneryPieces(n).tSizeBotRight.X - 1)) + "," + Trim(Str(SceneryPieces(n).tSizeBotRight.Y - 1))
                
                Print #1, CStr(SceneryPieces(n).bIsMovableTo)
                
                Print #1, SceneryPieces(n).strMeshFile
                Print #1, SceneryPieces(n).strTexFile
            Next n

        End If
        
        ' In-game messages data (in order as IDed)
        Print #1, Trim(Str(UBound(tInGameMessages)))                  ' How many
        If UBound(tInGameMessages) > 0 Then
        
            For n = 1 To UBound(tInGameMessages)
                
                Print #1, Trim(Str(tInGameMessages(n).iTotTrigs))
                If tInGameMessages(n).iTotTrigs > 0 Then
                    For X = 1 To tInGameMessages(n).iTotTrigs
                        Print #1, Trim(Str(tInGameMessages(n).tTriggers(X).X)) + "," + Trim(Str(tInGameMessages(n).tTriggers(X).Y))
                    Next X
                End If
                
                sTemp = tInGameMessages(n).strMessage
                
                Print #1, sTemp
                Replace sTemp, ",", "<comma>"
                
                Print #1, "</game-message>"
            Next n
        End If
        
        ' Navigation map is present from start
        Print #1, CStr(bNavMapFromStart)
        
        SaveFileLevel = True

    Close #1
    
End Function


*/

    public void SpawnMonster(IVector vPos)
    {
        Debug.Log("SpawnMonster");

        lMonsters.Add(iMonsters, (GameObject)Instantiate(Resources.Load("m")));
        lMonsters[iMonsters].transform.Translate(vPos);
        

        Monster oScript = lMonsters[iMonsters].GetComponent("rr2monster") as Monster;
        if (oScript)
        {
            Debug.Log("INIT script");
            oScript.Init(vPos);
            //oScript.iId = iMonsters;
            oScript.rr2gameObject = game;
        }else
            Debug.Log("INIT script PROBLEM");

        iMonsters++;
        iMonstersAlive++;
    }

    public void KillMonsters(IVector vP)
    {
        Debug.Log("KillMonsters");
        foreach (KeyValuePair<int, GameObject> lM in lMonsters)
        {
            if( lM.Value != null)
            {
                Monster oScript = lM.Value.GetComponent("rr2monster") as Monster;
                if( oScript)
                {
                    //Debug.Log("FOUND MONSTER " + oScript.iId);
                    if( oScript.Position == vP || oScript.LastPosition == vP)
                        oScript.Die();
                   
                }
            }
        }
    }



	public void OpenSafes()
	{
		for( int y = 0; y < MapSizeY; y++)
		{
			for( int x = 0; x < MapSizeX; x++)
			{
				if( MapDetail[x,y].TypeID == (char)Piece.Safe)
				{
					ReplacePiece(x, y, (char)Piece.Dimond);
				}
			}
		}
	}
	
	
	
	// Map data functions..
	
	public char GetMapP(IVector vP)
	{
		return GetMapP( (int)vP.x,(int)-vP.z);
	}
    public char GetMapP(int x, int y)
    {
        if( x >= 0 && x < MapSizeX && y >= 0 & y < MapSizeY)
            return MapDetail[x, y].TypeID;
        else
            return ' ';
    }

	public int GetMapPId(IVector vP)
	{
		return MapDetail[(int)vP.x,(int)-vP.z].id;
	}
	
	public void SetMapP(IVector vP, char cType)
	{
		MapDetail[(int)vP.x,(int)-vP.z].TypeID = cType;
	}
	public void SetMapP(IVector vP, char cType, int id)
	{
		MapDetail[(int)vP.x,(int)-vP.z].TypeID = cType;
		MapDetail[(int)vP.x,(int)-vP.z].id = id;
	}
	
	public void AddPiece(int x, int y, char cNewTypeID)
	{
		IVector vPos = new IVector(x * 1.0f, 0.0f, y * -1.0f);
			
		MapDetail[x,y].TypeID = cNewTypeID;
			
		lObjects3[iObjTot] = ((GameObject)Instantiate(Resources.Load(MapDetail[x, y].TypeID.ToString())));
		
		lObjects3[iObjTot].transform.Translate(vPos);
		
		iObjTot++;
	}
	
	public void ReplacePiece(int x, int y, char cNewTypeID)
	{
		IVector vPos = new IVector(x * 1.0f, 0.0f, y * -1.0f);
		int pId = game.loadedLevel.MapDetail[(int)x, (int)y].id;
			
		MapDetail[x,y].TypeID = cNewTypeID;
			
		// Replace GFX
		Destroy(game.loadedLevel.lObjects3[pId]);
		if( cNewTypeID != '0')
        {
		    lObjects3[pId] = ((GameObject)Instantiate(Resources.Load(MapDetail[x, y].TypeID.ToString())));
		    lObjects3[pId].transform.Translate(vPos);
        }
	}
	public void ReplacePiece(IVector vP, char cNewTypeID)
	{
		ReplacePiece( (int)vP.x, (int)-vP.z, cNewTypeID);
	}


    public void RemovePiece(int x, int y)
    {
        try
        {
            int pId = game.loadedLevel.MapDetail[x, y].id;

            if (pId != -1)
                Destroy(game.loadedLevel.lObjects3[pId]);
        }
        catch { }
    }
    public void RemovePiece(IVector vP)
    {
        RemovePiece( (int)vP.x, (int)-vP.z);
    }


    public void RemoveNearBy(IVector vP, int iRadius, char cPieceType)
    {
        int xP = (int)vP.x;
        int yP = (int)-vP.z;

        for( int y = yP - iRadius; y < yP + iRadius; y++)
        {
            for( int x = xP - iRadius; x < xP + iRadius; x++)
            {
                if( GetMapP(x, y) == cPieceType) 
                    ReplacePiece(x, y, '0');
            }
        }
    }



    /*

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
    ' 3 = Reset

        Select Case intCont
            Case 0
                'sngTimeLeft = (sngTimeBombOut - timTimeBomb.LocalTime) * rrGame.sngGameSpeed
                timTimeBomb.Stop_

            Case 1
                If sngTimeBombOut <> -1 Then
                '    sngTimeBombOut = (sngTimeLeft + timTimeBomb.LocalTime) * rrGame.sngGameSpeed
                    timTimeBomb.Start
                End If

            Case 2
                If rrGame.Pause(-2) = False Then
                    sngTimeLeft = (sngTimeBombOut - timTimeBomb.LocalTime) * rrGame.sngGameSpeed
                Else
                    'sngTimeLeft = 1
                End If

            Case 3
                timTimeBomb.ReSet

        End Select

    End Function

    */
    /*
	void TimeBombControl( int iControl) 
	{
		//0 = Pause
		// 1 = Unpause
		// 2 = Update
		// 3 = Reset
		
		if( iControl == 0)
			timTimeBomb.Stop();
		else if( iControl == 1)
			timTimeBomb.Start();
		else if( iControl == 2)
		{
			if( rr2gameObject.gameState != 2)
				timTimeBomb.Update();
			else
				timTimeBomb.Pause();
		}
		else if( iControl == 3)
			timTimeBomb.ReSet();	
	}
	*/
    /*


    Function MessageCheckAndShow(intX As Integer, intY As Integer)

        Dim n As Integer
        Dim t As Integer

        ' Is trigger?
        For n = 1 To UBound(tInGameMessages)
            For t = 1 To tInGameMessages(n).iTotTrigs
                If tInGameMessages(n).tTriggers(t).X = intX And tInGameMessages(n).tTriggers(t).Y = intY Then
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
        intLastKey = 1

        rrGame.Pause 0
    End Function

    Function MessageUpdate()

        'dim sMsgLines(6) as String

        Dim n As Integer
        Dim ln As Integer
        Dim X As Boolean
        Dim sTemp As String

        Dim sChar As String * 1
        Dim iLastSpace As Integer
        Dim iNLastSpace As Integer
        Dim iLines As Integer


        If intShowingMsg = -1 Then Exit Function

        ' Don't show text if transforming
        If ExMsgBoard.AnimatedTransform.active(Rotation3D) = True Then Exit Function

        ExTxtMsg.Colour &HFFEEEEFF

        ' Show message ...
        n = intCurMsgLine
        If n = 1 Then iLines = 0 Else iLines = 1
        Do

            ' Get a line
            sTemp = ""
            X = False
            ln = 1
            iLastSpace = 0
            iNLastSpace = 0
            Do While X = False And ln < 51 And n <= Len(tInGameMessages(intShowingMsg).strMessage)

                sChar = Mid(tInGameMessages(intShowingMsg).strMessage, n, 1)

                If sChar <> vbCr Then

                    If sChar <> " " And sChar <> "-" Then
                        If ln < 50 Then
                            sTemp = sTemp + sChar
                        Else
                            sTemp = Mid(sTemp, 1, iLastSpace)
                            n = iNLastSpace

                            X = True
                        End If
                    Else
                        If ln < 50 Then
                            sTemp = sTemp + sChar
                            iLastSpace = ln
                            iNLastSpace = n
                        Else
                            X = True
                        End If
                    End If
                Else
                    n = n + 1   ' Discard the line feed
                    X = True
                End If
                n = n + 1
                ln = ln + 1

            Loop

            ExTxtMsg.Text sTemp
            ExTxtMsg.position frmMain.iXsize / 6, (frmMain.iYsize / 5) + (iLines * 30)
            ExTxtMsg.Render

            iLines = iLines + 1

        Loop While iLines < 11 And n <= Len(tInGameMessages(intShowingMsg).strMessage)

        ' Show navigation instruction
        If n < Len(tInGameMessages(intShowingMsg).strMessage) Then
            ExTxtMsg.Text "[ENTER] for next page"
            ExTxtMsg.position frmMain.iXsize / 2, (frmMain.iYsize / 5) + 330
        Else
            ExTxtMsg.Text "[ENTER] to resume game"
            ExTxtMsg.position frmMain.iXsize / 2, (frmMain.iYsize / 5) + 330
        End If
        ExTxtMsg.Colour &HFFCCCCFF
        ExTxtMsg.Render

        If ExInp.exInput(ex_Return) = True Then
            If intLastKey <> 1 Then


                If n < Len(tInGameMessages(intShowingMsg).strMessage) Then
                    ' Show next page

                    intCurMsgLine = n
                Else
                    ' Delete message and exit

                    For n = intShowingMsg To UBound(tInGameMessages) - 1
                        tInGameMessages(n) = tInGameMessages(n + 1)
                    Next n
                    ReDim Preserve tInGameMessages(UBound(tInGameMessages) - 1)

                    intShowingMsg = -1
                    rrGame.Pause -1
                    intCurMsgLine = 1

                    ExMsgBoard.ResetMatrix
                    ExMsgBoard.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(rrRepton.GetXPos), Ret3DPos(rrRepton.GetYPos), -200), ExPrj.exReturn3DVec(Ret3DPos(rrRepton.GetXPos), Ret3DPos(rrRepton.GetYPos) - 260, 200), 0.5
                    ExMsgBoard.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(-180, 0, 0), ExPrj.exReturn3DVec(211, 0.1, 0.1), 0.5
                End If

            End If
            intLastKey = 1
        Else
            intLastKey = 0
        End If
    End Function



    'Dim intWallAround_LOOKUP(1, 1, 1, 1) As Integer       ' (2,4,6,8) - wall is there(1) or not(0) for each
                                                          '  Down [2], Left [4], Right [6], Up [8]  (KeyPad)
                                                          '  Used in 'GetWallAroundInfo'



    Option Explicit

    Private timFungus As New exTools_Timer      ' Control Timing of fungus growth thoughout map
    Private sngNextFungusTime As Single




    */



}