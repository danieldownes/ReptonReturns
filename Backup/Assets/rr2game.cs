using UnityEngine;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;


public class rr2game : MonoBehaviour 
{
	public rr2gui guiObject;
	
	public rr2player playerObject;
	public int iMapSizeX;
	public int iMapSizeY;
	public MapPiece2d[,] RrMapDetail; 
	
	public int[] colourKey;  // index = key, value = door, as numbered in the order they apper in the file
	
	public List<GameObject> lObjects3 = new List<GameObject>();	// Reference to all our game object map pieces, including movables
	
	public Vector3 vStartPos;
	
	
	
	/*
	 * Public Type type_Transporter
    iToX As Integer
    iToY As Integer
End Type

Public Type type_LevelTrans
    'tPos        As Corrds2D_T
    sLocalFile  As String
End Type


Public rrMap             As New cMap        ' The loaded level
Public rrRepton          As New cPlayer     ' A human player (Repton)
Public rrPieces()        As New cPiece      ' A piece on the level
Public rrRocksOrEggs()   As New cRockOrEgg  ' A rock or egg; moveable piece
Public rrMonster(4)      As New cMonster
Public rrSpirit(8)       As New cSpirt

Public tTransporters()   As type_Transporter
Public tLevelTrans()     As type_LevelTrans

Public sPrimPlayerName   As String
Public intPlayerLives    As Integer

Public fxParticles(15)   As New cGameFxParticle

Private tDiamondFxTimer  As New exTools_Timer


'Dim intWallAround_LOOKUP(1, 1, 1, 1) As Integer       ' (2,4,6,8) - wall is there(1) or not(0) for each
                                                      '  Down [2], Left [4], Right [6], Up [8]  (KeyPad)
                                                      '  Used in 'GetWallAroundInfo'

'Dim timRockSndPlaying As New exTools_Timer
'Public bRockSndPlaying As Boolean

Dim iFPScount As Integer
Dim iFPSval As Integer
Dim sLastTime As Single
Dim sngTemp As Single

Dim intLastKeyPress As exInputKeys
*/
	
	public enum enmPiece
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

	// Use this for initialization
	IEnumerator Start () //IEnumerator
	{
		LoadFileLevel();
		
		playerObject.MoveToPos( vStartPos );
			
		/*
		GameObject go = GameObject.Find("Player");
		rr2player oPlayer = go.GetComponent(rr2player) as rr2player;
		if (oPlayer)
        	oPlayer.MoveToPos( vStartPos );
		
		//rr2player playerObject = GameObject.Find("Player");
		//playerObject.GetComponent(rr2player)
		
		*/
		
		//StartCoroutine( getDataTest);
		
		string dataUrl = "http://symbiosoft/game/test.txt";
		string playName = "Player 1";
		int score = -1;

		// Create a form object for sending high score data to the server
		var form = new WWWForm();
		// Assuming the perl script manages high scores for different games
		form.AddField( "game", "MyGameName" );
		 // The name of the player submitting the scores
		form.AddField( "playerName", playName );
		 // The score
		form.AddField( "score", score );

		// Create a download object
		WWW downloadW = new WWW( dataUrl, form );

		// Wait until the download is done
		yield return downloadW;
		
		
		if(downloadW.error != null) {
			print( "Error downloading: " + downloadW.error );
			return false;
		} else {
			// show the highscores
			Debug.Log(downloadW.text);
		}
		
		
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
	
	/*
	IEnumerator getDataTest()
	{
		
		string dataUrl = "http://symbiosoft/game/test.php";
		string playName = "Player 1";
		int score = -1;

		// Create a form object for sending high score data to the server
		var form = new WWWForm();
		// Assuming the perl script manages high scores for different games
		form.AddField( "game", "MyGameName" );
		 // The name of the player submitting the scores
		form.AddField( "playerName", playName );
		 // The score
		form.AddField( "score", score );

		// Create a download object
		WWW downloadW = new WWW( dataUrl, form );

		// Wait until the download is done
		//yield return true; //downloadW
		
		
		if(downloadW.error == null) {
			print( "Error downloading: " + downloadW.error );
			return false;
		} else {
			// show the highscores
			Debug.Log(downloadW.text);
		}
		
		return true;
	}
	*/
	

	
	public struct MapPiece2d
	{
		public char TypeID;
		public int id;
		//public GameObject go;
		//public rr2moveable scriptMoveable;
	}
		
	
	
	
//	Function LoadFileLevel() As Boolean
	public bool LoadFileLevel()
	{
		
		int iId;
		iMapSizeX = 30;
		iMapSizeY = 30;
		RrMapDetail = new MapPiece2d[iMapSizeX,iMapSizeY];
		
		int iMapEdgeSize = 2;
		
		//StartCoroutine("getDataTest");
	
		string sTemp;
	
	//	string sFile;
	
	//    intShowingMsg = -1
		
		
	//    LoadFileLevel = False
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
		TextAsset puzdata = (TextAsset)Resources.Load("Level1.rrl", typeof(TextAsset));
		 
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
        iMapSizeX = Convert.ToInt32(sTemp.Split(',')[0]);
        iMapSizeY = Convert.ToInt32(sTemp.Split(',')[1]);
		
		Debug.Log(iMapSizeX + ":" + iMapSizeY);
//        
//        ' Map data
//        ReDim intRTData(intMapSizeX, intMapSizeY)
//        ReDim rrPieces(intMapSizeX, intMapSizeY)

		iId = 0;
		
		// Get map layout data	
		for( int y = 0; y < iMapSizeY; y++ )
		{
			if( y > 0 && y < iMapSizeY - 1)
				sTemp = tr.ReadLine();
			
			Debug.Log(sTemp);
						
			for( int x = 0; x < iMapSizeX; x++)
			{
				Vector3 vThisPos = new Vector3(x * 1.0f, 0.0f, y * -1.0f);
				
				// Put wall boarder around map
				if( x <= 0 || x >= (iMapSizeX-2) || y <= 0 || y >= (iMapSizeY-2) )
				{
					RrMapDetail[x,y].TypeID = '5';
				}else
				{
                	// Else use read in value
					RrMapDetail[x,y].TypeID = sTemp[x];
					
					char cT = sTemp[x];
					
					
					
					//GameObject.Find("d")
					try
					{
						lObjects3.Add( (GameObject)Instantiate(Resources.Load(RrMapDetail[x,y].TypeID.ToString())) ); 
						//RrMapDetail[x,y].go = (GameObject)Instantiate(Resources.Load(RrMapDetail[x,y].TypeID.ToString())); 
						lObjects3[iId].transform.Translate(vThisPos);
						RrMapDetail[x,y].id = iId;
						
						
					
					
						//if( lObjects3[iId] != null)
							
						
						if( cT == 'r')
						{
							
							rr2moveable oScript = lObjects3[iId].GetComponent("rr2moveable") as rr2moveable;
							if( oScript)
							{
	        					oScript.Init(enmPiece.Rock, vThisPos);
								oScript.iId = iId;
								oScript.rr2gameObject = this;
							}
							
						}
					
					
					
//                    ' Keep track of piece count
//                    Select Case rrPieces(X, Y).TypeID
//                        Case "n"
//                            ReDim tTransporters(UBound(tTransporters) + 1)
//                        Case "y"
//                            ReDim tLevelTrans(UBound(tLevelTrans) + 1)
//                    End Select
						
						iId++;
					}catch
					{
					}
					
					// Move Player to starting position
					if( cT == 'i' )
					{
						vStartPos.x = x;
						vStartPos.z = -y;
					}
				}
			}
		}

		
        
//        ' Transporter info (in order as from map)
//        If UBound(tTransporters) > 0 Then
//            For n = 1 To UBound(tTransporters)
//                Input #1, sTemp
//                tTransporters(n).iToX = Int(sTemp) + 1
//                Input #1, sTemp
//                tTransporters(n).iToY = Int(sTemp) + 1
//            Next n
//        End If

		sTemp = tr.ReadLine();
		
//        ' Level-Transporter info (in order as from map)
//        If UBound(tLevelTrans) > 0 Then
//            For n = 1 To UBound(tLevelTrans)
//                Input #1, sTemp
//                'tLevelTrans(n).tPos.x = Int(sTemp)
//                Input #1, sTemp
//                'tLevelTrans(n).tPos.y = Int(sTemp)
//                Input #1, tLevelTrans(n).sLocalFile
//            Next n
//        End If
//        




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

		// Coloured Key+Door pairs (indexed in order as from map)
		sTemp = tr.ReadLine();
		Debug.Log(sTemp);
		//data eg: 0,2;1,4;2,3   .. key 0 opens door 2, key 1 opens door 4, etc...
		//iMapSizeX = Convert.ToInt32(sTemp.Split(',')[0]);
        //iMapSizeY = Convert.ToInt32(sTemp.Split(',')[1]);
			
		tr.Close();
			
		return loadedOk;
	}	
}


/*
 * ' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Public bGameCompleted As Boolean

Public pckLevelFiles As New cFilePackage
Public iCurGameLevel As Integer
Public iTotGameLevels As Integer
Public bEpisodeCompeted As Boolean
Public iLevelCompeted As Integer

Public strEpisodeName As String
Public sEpisodeDir As String
Public intGamePlayType               As Integer
Dim strLevelOrder()               As String
Public strVisualTheme As String

Public sngGameSpeed As Single
Public sngSfxVol As Single
Public sngMusicVol As Single

Private Type type_Pause
    timPauseContol As New exTools_Timer     ' See 'Pause' function for detail
    sngDelay       As Single                '  " . . .
    bPaused        As Boolean
End Type
Dim tPause As type_Pause

Private iRockRumbleSounds As Integer    ' Controls the sound of the rock rumbling for all instences of 'cRockOrEgg'

Private Type type_MusicControl
    exMusicControl   As New exTools_Timer
    strMusicFiles(3) As String
    sngMusicLen(3)   As Single
    intCurMusicTrack As Integer
End Type
Private tMusicControl As type_MusicControl

Function Init(Optional bTransporting As Boolean = False)

    Dim sTemp As String
    
    ' Init Pause functionality
    Pause -1
    
    rrGame.iCurGameLevel = 1
    ReDim strLevelOrder(1)
    
    If Mid(sEpisodeDir, Len(sEpisodeDir) - 3, 4) = ".rrl" Then
        ' Extract level name
        strEpisodeName = Mid(sEpisodeDir, 1, Len(sEpisodeDir) - 4)
        strLevelOrder(1) = Trim(Mid(strEpisodeName, InStrRev(strEpisodeName, "\") + 1, Len(strEpisodeName) - InStrRev(strEpisodeName, "\") + 1))
        ' Remove level name from dir string
        strEpisodeName = Trim(strEpisodeName)
        strLevelOrder(1) = Trim(strLevelOrder(1))
        sEpisodeDir = Mid(strEpisodeName, 1, Len(strEpisodeName) - Len(strLevelOrder(1)))
    End If
    strEpisodeName = Mid(sEpisodeDir, 1, Len(sEpisodeDir) - 1)
    strEpisodeName = Mid(strEpisodeName, InStrRev(strEpisodeName, "\") + 1, Len(strEpisodeName) - InStrRev(strEpisodeName, "\") + 1)
    
    sTemp = Mid(sEpisodeDir, 1, InStr(sEpisodeDir, "\") - 1)
    
    If sTemp = "Repton 3" Then
        sEpisodeDir = pckLevelsFiles.GetPackedFile(strEpisodeName & ".rre")
    End If
    
    
    OpenFileEpisode sEpisodeDir
    
    rrMap.LoadFileLevel
    
    bGameCompleted = False
    bEpisodeCompeted = False
    iLevelCompeted = 0
        
    ExPrj.BackColour &H0
    
    SetupLevel bTransporting
    
    ' Game over?
    If intPlayerLives < 0 Then
        iLevelCompeted = -2
        Exit Function
    End If
    
    ' Music
    tMusicControl.sngMusicLen(0) = 0
    tMusicControl.strMusicFiles(1) = "Ode.mp3"
    tMusicControl.sngMusicLen(1) = 165
    tMusicControl.strMusicFiles(2) = "Persistence.mp3"
    tMusicControl.sngMusicLen(2) = 159
    tMusicControl.strMusicFiles(3) = ""
    tMusicControl.sngMusicLen(3) = 0
    
    tMusicControl.intCurMusicTrack = 0

End Function

Function MainLoop() As Boolean
' Returns:
'  1 if MainLoop should be recalled
'  0 if not

    ' The main loop. Each cycle represents one frame.
    Do While Not (UserInteraction) And (iLevelCompeted = 0 Or rrGame.Pause(-2))           ' {  Input
        
        ' Allow events in this game to accour                                             ' /
        GameEvents                                                                        ' |
                                                                                          '-   Process
        ' Allow other events to process.                                                  ' |
        DoEvents                                                                          ' \
          
        DrawFrame                                                                         ' {  Output
                
    Loop
    
    If intPlayerLives < 0 Then
        ' All lives are gone
        MainLoop = False
        Exit Function
    End If
    
    If iLevelCompeted = 1 Then
    
        If rrGame.strEpisodeName = "Home" Then
            ' Whole game has been completed
            bGameCompleted = True
        Else
            ' This level has been completed, copy 'Home' into 'Home\old\'
            DeleteFile App.Path & "\data\players\" & rrRepton.strName & "\Home\old\start.rrl", False
            CopyFile App.Path & "\data\players\" & rrRepton.strName & "\Home\start.rrl", App.Path & "\data\players\" & rrRepton.strName & "\Home\old\start.rrl"
        End If
        
    ElseIf iLevelCompeted = -1 Then
        ' Player has deleted their account; Do nothing
        
    Else
        ' This level was uncompleted, copy 'old/Home' into 'Home'
        DeleteFile App.Path & "\data\players\" & rrRepton.strName & "\Home\start.rrl", False
        CopyFile App.Path & "\data\players\" & rrRepton.strName & "\Home\old\start.rrl", App.Path & "\data\players\" & rrRepton.strName & "\Home\start.rrl"
    End If
    
    
    If rrGame.strEpisodeName = "Home" Then
        ' Exit to menu
        MainLoop = False
    Else
        ' Load 'Home' level
        
        rrGame.DeInit
        rrGame.sEpisodeDir = App.Path & "\data\players\" & sPrimPlayerName & "\Home\"
        rrGame.Init
        
        MainLoop = True
    End If
    
End Function

Function DeInit()

    If rrGame.sEpisodeDir = App.Path & "\data\episode\Tutorial\" Then
        ' Reset lives
        intPlayerLives = 4

        rrRepton.Die False         ' Will write to file
    End If
    
    DeinitLevel
    
End Function

Function OpenFileEpisode(strFile As String) As Boolean
' Return = True when all is ok

    Dim n As Integer
    Dim iLevel As Integer
    Dim sTemp As String
    

    OpenFileEpisode = False
    
    
    ' Episode info::
    
    'On Error GoTo open_file_err
    
    If Mid(strFile, Len(strFile) - 3, 4) = ".rre" Then
        sTemp = strFile
    Else
        sTemp = strFile + strEpisodeName + ".rre"
    End If
    
    Open sTemp For Input As #1
        
        ' RR file version
        Input #1, sTemp
        If Mid(sTemp, 1, 20) = "ReptonReturnsEpisode" Then
            If Val(Mid(sTemp, 21, 3)) > 1 Then
                MsgBox "The Repton Returns level file requieres a newer version of Repton Returns game, check the website for updates", , "Repton Returns"
                
                Exit Function
            End If
        Else
            MsgBox "The selected file is not a compatable Repton Returns episode file", , "Repton Returns"
            
            Exit Function
        End If
        
        ' Episode name
        Input #1, strEpisodeName
        
        ' Game play type
        Input #1, sTemp
        intGamePlayType = Int(sTemp)
        
        ' Visual Theme name
        Input #1, strVisualTheme
        
        ' Level order (using levelID)
        sTemp = strLevelOrder(1)
        n = 1
        Do
            ReDim Preserve strLevelOrder(n)
            Input #1, strLevelOrder(n)
            
            If sTemp <> "" Then     ' If level filename was given then this will determine the level number within this episode
                If strLevelOrder(n) = sTemp Then rrGame.iCurGameLevel = n
            End If
            
            n = n + 1
        Loop Until EOF(1)
        iTotGameLevels = n - 1
        
        
        OpenFileEpisode = True
        
 '       Resume
        
    Close #1

open_file_err:

End Function



Function LevelOrder(iLevel As Integer, Optional sIn As String = "!return!") As String
    If sIn = "!return!" Then
        LevelOrder = strLevelOrder(iLevel)
    Else
        If sIn = "!redim!" Then
            ReDim Preserve strLevelOrder(iLevel)
        Else
            strLevelOrder(iLevel) = sIn
        End If
    End If
End Function






Function LevelCompleted()
        
    ' Flag that level has been completed
    iLevelCompeted = 1
    
    ' Check if episode is completed
    If rrGame.iCurGameLevel = rrGame.iTotGameLevels Then rrGame.bEpisodeCompeted = True
    
End Function

Function Pause(sngTimed As Single) As Boolean
' sngTimed: -1 = Not paused
'            0 = Paused
'           >0 = Delayed pause in game (given in secs)
' Returns True when is paused

    Select Case sngTimed
        Case 0              ' Pause
            tPause.bPaused = True
            tPause.sngDelay = 0     ' Flag that timer should be ignored
            rrMap.TimeBombControl 0
            
        Case -1             ' Unpause
            tPause.bPaused = False
            rrMap.TimeBombControl 1
            FungusNewTime               ' Reset fungus time so that a fungus dosn't grow instently
            
        Case -2             ' Return pause status
            ' Update timer (if needed, also see if delay has expired)
            If tPause.sngDelay <> 0 And tPause.timPauseContol.LocalTime > tPause.sngDelay Then
                
                rrMap.TimeBombControl 0
                Pause = False
                tPause.bPaused = False
                tPause.sngDelay = 1
                FungusNewTime               ' Reset fungus time so that a fungus dosn't grow instently
                
            End If
        
            Pause = tPause.bPaused
            
        Case Else           ' Start delayed pause
            ' Start timer and set delay time
            tPause.timPauseContol.ReSet
            tPause.sngDelay = sngTimed
            
            tPause.bPaused = True
            rrMap.TimeBombControl 0
            
    End Select

End Function

Function ControlMusic()
    If tMusicControl.exMusicControl.LocalTime > tMusicControl.sngMusicLen(tMusicControl.intCurMusicTrack) Then
        tMusicControl.intCurMusicTrack = tMusicControl.intCurMusicTrack + 1
        If tMusicControl.intCurMusicTrack > UBound(tMusicControl.strMusicFiles) Then tMusicControl.intCurMusicTrack = 1
'        OpenFMOD pckGenFiles(tMusicControl.strMusicFiles(tMusicControl.intCurMusicTrack))
        PlayFMOD
        tMusicControl.exMusicControl.ReSet
    End If
End Function

Function PlayRockRumbleSound(bStart As Boolean)
    If bStart Then
        iRockRumbleSounds = iRockRumbleSounds + 1
        
        ' Start the sound?
        If iRockRumbleSounds = 1 Then ExSnds(4).PlaySound True
        
    Else
        iRockRumbleSounds = iRockRumbleSounds - 1
        
        ' End the sound
        If iRockRumbleSounds <= 0 Then ExSnds(4).StopSound
    End If
    
    
End Function


*/