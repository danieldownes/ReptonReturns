using UnityEngine;
using System;
using System.IO;
using System.Collections.Generic;


// Repton Returns
// Ex-D Software Development(TM)
// All rights reserved.

public class Level : MonoBehaviour
{
    public Game game;

    public int MapSizeX;
    public int MapSizeY;
	public float fMapSlant = 0.35f; // For every Z, Y increases this much
	//public Vector3 vMapSize3d;
	
    public MapPiece2d[,] MapDetail;
	
	public Vector3[] tTransporter;

    public int[] colourKey;  // index = key, value = door, as numbered in the order they apper in the file

    public int[] iPieceTot; // Count types of pieces (useful for keeping track of coloured keys, etc)
	

    public List<GameObject> lObjects3 = new List<GameObject>();	// Reference to all our game object map pieces, including movables
	private int iObjTot;

    public Vector3 vStartPos;


    // older stuff...
    //Public rrMonster(4)      As New cMonster
    //Public rrSpirit(8)       As New cSpirt


    float fTime; 	 //Public sngTimeLeft As Single
    float fTimeBomb; //Public sngTimeBombOut As Single
    //Public timTimeBomb As New exTools_Timer


    // Totals in level:
    public int iDiamonds;			 	//    \
    public int iCrowns;				    //     -  All must = 0 before bomb can be defused
    public int iEggs;					//    /
    public int iMonstersAlive;			//   /
    public int iSpirits;                //  /


    public int iMonsters;
    public Dictionary<int, GameObject> lMonsters = new Dictionary<int, GameObject>();

    int iMovables;
    public int iFires;				// Needed for fire growth determination
    int iTransporters;
    int iLevelTrans;

    public enum Piece
    {
        // Used charicters:   abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ%*)^$(&£!|\`¬¦@;:.<>#~=+-_
        // (underlined)      ------- - - -- - ----  -------------            --            -    ----                 
        Space = '0',
        Dimond = 'd',
        Wall = '5',
        Wall8 = '8',
        Wall2 = '2',
        Wall6 = '6',
        Wall4 = '4',
        Wall9 = '9',
        Wall7 = '7',
        Wall3 = '3',
        Wall1 = '1',
        Earth = 'e',
        Rock = 'r',
        Safe = 's',
        Key = 'k',
        Egg = 'g',
        Repton = 'i',
        Crown = 't',
        Cage = 'c',
        Spirit = 'p',
        Bomb = 'b',
        Fungus = 'f',
        Skull = 'u',
        Barrier = 'a',
        Monster = 'm',
        Transporter = 'n',
        TimeCapsule = 'z',
        FilledWall = '%',
        FilledWall7 = '&',
        FilledWall9 = '(',
        FilledWall1 = '!',
        FilledWall3 = '£',
        Map = 'x',
        LevelTransport = 'y',
        ColourKey = 'C',
        Door = 'D'
    }

    public struct MapPiece2d
    {
        public char TypeID;
        public int id;
        //public GameObject go;
        //public rr2moveable scriptMoveable;

        public int iRef;  // Look-up reference used by some piece types (eg coloured keys, transporters, etc..)
    }

    	
	public bool LoadFileLevel()
	{
		MapSizeX = 30;
		MapSizeY = 30;
        MapDetail = new MapPiece2d[MapSizeX, MapSizeY];

		int iPType = 0;

		lObjects3.Clear();
        iObjTot = 0;
		
        iPieceTot = new int[110]; // First useful ASCII code = 32DEC (space), last useful is 126DEC (~), 126-32=94
        colourKey = new int[5];

        for (int n = 0; n < 35; n++)
            iPieceTot[n] = 0;

		//int iMapEdgeSize = 2;
		
		string sTemp;
	
		bool loadedOk = false;
		
		// Individual level info::
	//    sTemp = rrGame.LevelOrder(rrGame.iCurGameLevel)
		
		
	//    ' Make sure sEpisodeDir is correctly formatted
	//    If Mid(rrGame.sEpisodeDir, Len(rrGame.sEpisodeDir) - 3, 4) = ".rre" Then
	//        rrGame.sEpisodeDir = Mid(rrGame.sEpisodeDir, 1, InStrRev(rrGame.sEpisodeDir, "\"))
	//        Select Case UCase(rrGame.strEpisodeName)
	//            Case "PRELUDE"
	//                sFile = pckLevelsFiles.GetPackedFile(sTemp & ".rrl")
	//            Case "FIN"
	//        End Select
	//        
	//    Else
	//        ' a 'Home' file is being loaded  -- TEMP code
	//        sFile = rrGame.sEpisodeDir & sTemp & ".rrl"
	//
	//    End If
	//  
		
		
		//    Open sFile For Input As #1 ...
		// Read line using Unity IO functionality
		///StreamReader tr = new StreamReader("Assets\\Levels\\Tutorial.rrl"); //Prelude\\prelude.rrl
		
		// Unity TextAsset functionality
		//FileInfo theSourceFile = null;
		StringReader tr = null;
        TextAsset puzdata = (TextAsset)Resources.Load("Tutorial.rrl", typeof(TextAsset)); // Level1
		 
		// puzdata.text is a string containing the whole file. To read it line-by-line:
		tr = new StringReader(puzdata.text);
		
		if ( tr == null )
			Debug.Log("Tutorial.rrl.txt not found or not readable");
			
            
//    
//        ReDim tTransporters(0)
//        ReDim tLevelTrans(0)
//        ReDim SceneryPieces(0)
//    
		// RR file version
		sTemp = tr.ReadLine(); // expecting "ReptonReturnsLevelV2"
	
//        If Mid(sTemp, 1, 18) = "ReptonReturnsLevel" Then
//            If Val(Mid(sTemp, 19, 3)) > 1.1 Then
//                MsgBox "The choosen Repton Returns level file requieres a newer version of the Repton Returns game, check the website for updates", , "Repton Returns"
//                
//                Exit Function
//            End If
//        Else
//            MsgBox "The selected file is not a compatable Repton Returns level", , "Repton Returns"
//            
//            Exit Function
//        End If
//        
//        ' Level Name
		sTemp = tr.ReadLine();
//        rrGame.LevelOrder rrGame.iCurGameLevel, sTemp
//        
//        ' Time allowed
//        Input #1, sngTimeBombOut
		sTemp = tr.ReadLine();
//        
//        ' Map Size
//        Input #1, sTemp
		sTemp = tr.ReadLine();
		Debug.Log(sTemp);
        MapSizeX = Convert.ToInt32(sTemp.Split(',')[0]);
        MapSizeY = Convert.ToInt32(sTemp.Split(',')[1]);
		
		Debug.Log(MapSizeX + ":" + MapSizeY);
       		
		
		// Get map layout data	
		for( int y = 0; y < MapSizeY; y++ )
		{
			if( y >= 0 && y < MapSizeY )
				sTemp = tr.ReadLine();
			
			Debug.Log(sTemp);
						
			for( int x = 0; x < MapSizeX; x++)
			{
				//Vector3 vThisPos = new Vector3(x * 1.0f, 0.0f, y * -1.0f);
				
				
				// Put wall boarder around map
				if( x < 0 || x >= (MapSizeX-2) || y < 0 || y >= (MapSizeY-2) )
				{
					//RrMapDetail[x,y].TypeID = '5';
				}else
				{
                	// Else use read in value
					MapDetail[x,y].TypeID = sTemp[x];
					
					if (sTemp[x] == (char)Piece.Transporter)
						MapDetail[x, y].iRef = iPieceTot[110-32]; // References vTransporter array
					
					// Count piece types
					//Debug.Log( "count:" +  (((int)sTemp[x])-32).ToString() );
					iPieceTot[ ((int)sTemp[x])-32 ]++;
				}
			}
		}
		
		
		// Transporter info (indexed in order as from map)
		int nP = 110 - 32; // int piece type id
		
		tTransporter = new Vector3[ iPieceTot[nP] ];
        
		for( int n = 0; n < iPieceTot[nP]; n++)
		{
			sTemp = tr.ReadLine();
			Debug.Log("transporter:" + sTemp);
			string[] aTemp = sTemp.Split(',');
			tTransporter[n].x = Convert.ToInt32(aTemp[0]) - 1;
			tTransporter[n].z = -Convert.ToInt32(aTemp[1]) + 1;
		}


        sTemp = tr.ReadLine();
//        
//        ' In-game messages data (in order as IDed)
//        Input #1, sTemp                              ' How many
		sTemp = tr.ReadLine();
		Debug.Log(sTemp);
//        ReDim tInGameMessages(Int(sTemp))
//            
//        If UBound(tInGameMessages) > 1 Then
//            For n = 1 To UBound(tInGameMessages)
//                Input #1, sTemp
//                tInGameMessages(n).iTotTrigs = Int(sTemp)
//                
//                If tInGameMessages(n).iTotTrigs > 0 Then
//                    For X = 1 To tInGameMessages(n).iTotTrigs
//                        Input #1, sTemp
//                        tInGameMessages(n).tTriggers(X).X = Int(sTemp) + 1
//                        Input #1, sTemp
//                        tInGameMessages(n).tTriggers(X).Y = Int(sTemp) + 1
//                    Next X
//                End If
//                
//                Input #1, sTemp
//                Do While sTemp <> "</game-message>"
//                    sTemp = Replace(sTemp, "<comma>", ",")
//                    tInGameMessages(n).strMessage = tInGameMessages(n).strMessage + vbCrLf + sTemp
//                    Input #1, sTemp
//                Loop
//            
//            Next n
//        End If
//        
//        ' Navigation map is present from start
		sTemp = tr.ReadLine();
		Debug.Log(sTemp);
//        Input #1, sTemp
//        bNavMapFromStart = CBool(sTemp)
//        
//        LoadFileLevel = True
//        

		// Coloured Keys, door info (indexed in order as from map)
        //data eg: 2;4;3   .. key 0 opens door 2, key 1 opens door 4, etc...
        if (iPieceTot[67 - 32] > 0)  //((int)(char)enmPiece.ColourKey)
		{
			sTemp = tr.ReadLine();
			Debug.Log("Coloured Keys:" + sTemp);
	
	        string[] aKeyTemp = sTemp.Split(';');
	
	        for (int n = 0; n < aKeyTemp.Length; n++)
	        {
	            colourKey[n] = Convert.ToInt32(aKeyTemp[n]);
	            Debug.Log("Key" + n + " = " + aKeyTemp[n]);
	            
	        }
		}
		
        // Finished reading file	
		tr.Close();

        
        // Post-read operations
        iPieceTot[67 - 32] = 0; //((int)(char)enmPiece.ColourKey)	// Reset coloured key count (ugly as we are counting them twice, but sfor now..)
        iPieceTot[68 - 32] = 0; // Door


        // Process map data
        for (int y = 0; y < MapSizeY; y++)
        {

            for (int x = 0; x < MapSizeX; x++)
            {
                Vector3 vThisPos = new Vector3(x * 1.0f, -y * fMapSlant, y * -1.0f);

                // Put wall boarder around map
                if (x < 0 || x >= (MapSizeX - 2) || y < 0 || y >= (MapSizeY - 2))
                {
                    //RrMapDetail[x,y].TypeID = '5';
                }
                else
                {

                    char cT = MapDetail[x, y].TypeID;
                    string sExtra = "";
                    iPType = 0;
                    
                    // Coloured Key
                    if (cT == (char)Piece.ColourKey)
                    {
                        iPType = 67-32;
                        sExtra = iPieceTot[iPType].ToString();
                        MapDetail[x, y].iRef = iPieceTot[iPType]; // Record key id ref in map data
                        iPieceTot[iPType]++;
                    }
                    if (cT == (char)Piece.Door)
                    {
                        iPType = 68-32;
                        sExtra = colourKey[iPieceTot[iPType]].ToString(); // Select corrisponding colour as indexed by key
                        MapDetail[x, y].iRef = iPieceTot[iPType]; // Record door id ref in map data
                        iPieceTot[iPType]++;
                    }

                    try
                    {
                        lObjects3.Add((GameObject)Instantiate(Resources.Load(MapDetail[x, y].TypeID.ToString() + sExtra)));
                        //RrMapDetail[x,y].go = (GameObject)Instantiate(Resources.Load(RrMapDetail[x,y].TypeID.ToString())); 
                        lObjects3[iObjTot].transform.Translate(vThisPos);
                        MapDetail[x, y].id = iObjTot;



                        //if( lObjects3[iId] != null)


                        if (cT == (char)Piece.Rock)
                        {
                            Moveable oScript = lObjects3[iObjTot].GetComponent("rr2moveable") as Moveable;
                            if (oScript)
                            {
                                oScript.Init(Piece.Rock, vThisPos);
                                oScript.iId = iObjTot;
                                oScript.game = game;
                            }
                        }
						
						else if (cT == (char)Piece.Egg)
                        {
                            Moveable oScript = lObjects3[iObjTot].GetComponent("rr2moveable") as Moveable;
                            if (oScript)
                            {
                                oScript.Init(Piece.Egg, vThisPos);
                                oScript.iId = iObjTot;
                                oScript.game = game;
                            }
                        }
						
						else if (cT == (char)Piece.Spirit)
                        {
                            Spirit oScript = lObjects3[iObjTot].GetComponent("rr2spirit") as Spirit;
                            if (oScript)
                            {
                                oScript.Init(vThisPos);
                                oScript.iId = iObjTot;
                                oScript.game = game;
                            }
                        }

                        iObjTot++;
                    }
                    catch
                    {
						MapDetail[x, y].id = -1;
                    }

                    // Move Player to starting position
                    if (cT == 'i')
                    {
                        vStartPos.x = x;
                        vStartPos.z = -y;
                        game.playerObject.StartPos = vStartPos;
						game.playerObject.MoveToPos(vStartPos);
						
                    }
                }
            }
        }
			
		return loadedOk;
	}	


	public Vector3 AddSlant(Vector3 v)
	{
		return new Vector3(v.x, v.z * fMapSlant, v.z);
	}

/*
 * 
 * ' Repton Returns
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

    public void SpawnMonster(Vector3 vPos)
    {
        Debug.Log("SpawnMonster");

        lMonsters.Add(iMonsters, (GameObject)Instantiate(Resources.Load("m")));
        lMonsters[iMonsters].transform.Translate(vPos);
        

        Monster oScript = lMonsters[iMonsters].GetComponent("rr2monster") as Monster;
        if (oScript)
        {
            Debug.Log("INIT script");
            oScript.Init(vPos);
            oScript.iId = iMonsters;
            oScript.rr2gameObject = game;
        }else
            Debug.Log("INIT script PROBLEM");

        iMonsters++;
        iMonstersAlive++;
    }

    public void KillMonsters(Vector3 vP)
    {
        Debug.Log("KillMonsters");
        foreach (KeyValuePair<int, GameObject> lM in lMonsters)
        {
            if( lM.Value != null)
            {
                Monster oScript = lM.Value.GetComponent("rr2monster") as Monster;
                if( oScript)
                {
                    Debug.Log("FOUND MONSTER " + oScript.iId);
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
	
	public char GetMapP(Vector3 vP)
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

	public int GetMapPId(Vector3 vP)
	{
		return MapDetail[(int)vP.x,(int)-vP.z].id;
	}
	
	public void SetMapP(Vector3 vP, char cType)
	{
		MapDetail[(int)vP.x,(int)-vP.z].TypeID = cType;
	}
	public void SetMapP(Vector3 vP, char cType, int id)
	{
		MapDetail[(int)vP.x,(int)-vP.z].TypeID = cType;
		MapDetail[(int)vP.x,(int)-vP.z].id = id;
	}
	
	public void AddPiece(int x, int y, char cNewTypeID)
	{
		Vector3 vPos = new Vector3(x * 1.0f, 0.0f, y * -1.0f);
			
		MapDetail[x,y].TypeID = cNewTypeID;
			
		lObjects3[iObjTot] = ((GameObject)Instantiate(Resources.Load(MapDetail[x, y].TypeID.ToString())));
		
		lObjects3[iObjTot].transform.Translate(vPos);
		
		iObjTot++;
	}
	
	public void ReplacePiece(int x, int y, char cNewTypeID)
	{
		Vector3 vPos = new Vector3(x * 1.0f, 0.0f, y * -1.0f);
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
	public void ReplacePiece(Vector3 vP, char cNewTypeID)
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
    public void RemovePiece(Vector3 vP)
    {
        RemovePiece( (int)vP.x, (int)-vP.z);
    }


    public void RemoveNearBy(Vector3 vP, int iRadius, char cPieceType)
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




Option Explicit

Private timFungus As New exTools_Timer      ' Control Timing of fungus growth thoughout map
Private sngNextFungusTime As Single


Function GameEvents()
    
    Dim n As Integer
    
    ' If game is not paused then do game events
    If rrGame.Pause(-2) = False Then
    
        ' Move any spirts
        For n = 0 To rrMap.intTotSpirits
        
            rrSpirit(n).CheckIfMove
            
        Next n
                
        ' Move any falling rocks
        TryRockFalls
                
        ' Move any monsters
        If rrMap.intTotMonstersAlive <> 0 Then
            For n = 1 To rrMap.intTotMonsters
                rrMonster(n).CheckIfMove
            Next n
        End If
        
        
        ' Do any fungas'es grow?
        GrowFunguses
        
        
        ' Check time remaining
        rrMap.TimeBombControl 2
        If rrMap.sngTimeBombOut <> -1 Then
            If rrMap.sngTimeLeft <= 0 Then
                ' Time has ran out
                ExSnds(20).PlaySound False
                rrRepton.Die False
            End If
        End If
        
        ' Music Control
        rrGame.ControlMusic
        
    End If
        
End Function
*/

	
	
}