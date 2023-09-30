namespace ReptonReturnsLogic.LoadLevel
{
    internal class Rrl
    {
        /*
        
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
				//IVector vThisPos = new IVector(x * 1.0f, 0.0f, y * -1.0f);
				
				
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
		
		tTransporter = new IVector[ iPieceTot[nP] ];
        
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
                IVector vThisPos = new IVector(x * 1.0f, -y * fMapSlant, y * -1.0f);

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
                            Movable oScript = lObjects3[iObjTot].GetComponent("rr2moveable") as Movable;
                            if (oScript)
                            {
                                //oScript.Init(Piece.Rock, vThisPos);
                                //oScript.iId = iObjTot;
                                //oScript.game = game;
                            }
                        }
						
						else if (cT == (char)Piece.Egg)
                        {
                            Movable oScript = lObjects3[iObjTot].GetComponent("rr2moveable") as Movable;
                            if (oScript)
                            {
                                //oScript.Init(Piece.Egg, vThisPos);
                                //oScript.iId = iObjTot;
                                //oScript.game = game;
                            }
                        }
						
						else if (cT == (char)Piece.Spirit)
                        {
                            Spirit oScript = lObjects3[iObjTot].GetComponent("rr2spirit") as Spirit;
                            if (oScript)
                            {
                                oScript.Init(vThisPos);
                                //oScript.iId = iObjTot;
                                //oScript.game = game;
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
                        StartPos.x = x;
                        StartPos.z = -y;
                        game.playerObject.StartPos = StartPos;
						game.playerObject.MoveToPos(StartPos);
						
                    }
                }
            }
        }
		return loadedOk;
	}	}
			*/

    }
}
