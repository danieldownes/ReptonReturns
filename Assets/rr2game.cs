using UnityEngine;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;



public class rr2game : MonoBehaviour
{
    public rr2gui guiObject;

    public rr2player playerObject;

    public rr2level loadedLevel;

    public rr2data dataManager;

	public int gameState; // 2 == paused


/*
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.


Public bGameCompleted As Boolean

Public iCurGameLevel As Integer
Public iTotGameLevels As Integer
Public bEpisodeCompeted As Boolean
Public iLevelCompeted As Integer

Public strEpisodeName As String
Public sEpisodeDir As String
Public intGamePlayType As Integer
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
     * 
Private tMusicControl As type_MusicControl
     * Public Type type_Transporter
    iToX As Integer
    iToY As Integer
End Type

Public Type type_LevelTrans
    'tPos        As Corrds2D_T
    sLocalFile  As String
End Type




Public tTransporters()   As type_Transporter
Public tLevelTrans()     As type_LevelTrans

Public sPrimPlayerName   As String


'Dim intWallAround_LOOKUP(1, 1, 1, 1) As Integer       ' (2,4,6,8) - wall is there(1) or not(0) for each
                                                      '  Down [2], Left [4], Right [6], Up [8]  (KeyPad)
                                                      '  Used in 'GetWallAroundInfo'



Dim iFPScount As Integer
Dim iFPSval As Integer
Dim sLastTime As Single
Dim sngTemp As Single

Dim intLastKeyPress As exInputKeys
*/



    // Use this for initialization
    void Start() //IEnumerator
    {
        loadedLevel.LoadFileLevel();

        playerObject.MoveToPos(loadedLevel.vStartPos);

        /*
        GameObject go = GameObject.Find("Player");
        rr2player oPlayer = go.GetComponent(rr2player) as rr2player;
        if (oPlayer)
            oPlayer.MoveToPos( vStartPos );
		
        //rr2player playerObject = GameObject.Find("Player");
        //playerObject.GetComponent(rr2player)
		
        */

        

    }


    // Update is called once per frame
    void Update()
    {
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
         * */
    }



    

}



/*


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