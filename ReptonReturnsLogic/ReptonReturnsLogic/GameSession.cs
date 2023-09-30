namespace ReptonReturnsLogic;

public class GameSession
{
    public Player player;
    public Level loadedLevel;
    public int gameState; // 2 == paused

    float fTime; 	 //Public sngTimeLeft As Single
    float fTimeBomb; //Public sngTimeBombOut As Single
    //Public timTimeBomb As New exTools_Timer


    private void Start()
    {
        loadedLevel.LoadFileLevel();
        player.MoveToPos(loadedLevel.StartPos);
    }

}

/*
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