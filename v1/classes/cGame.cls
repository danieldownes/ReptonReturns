VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGame"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Public bGameCompleted As Boolean

Public sEpisodeDir As String
Public iCurGameLevel As Integer
Public iTotGameLevels As Integer
Public bEpisodeCompeted As Boolean
Public iLevelCompeted As Integer

Public strEpisodeName As String
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

Private Type type_MusicControl
    exMusicControl   As New exTools_Timer
    strMusicFiles(3) As String
    sngMusicLen(3)   As Single
    intCurMusicTrack As Integer
End Type
Private tMusicControl As type_MusicControl

Function Init(Optional bTransporting As Boolean = False)

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
    
    OpenFileEpisode sEpisodeDir
    
    rrMap.LoadFileLevel
    
    bGameCompleted = False
    bEpisodeCompeted = False
    iLevelCompeted = 0
        
    ExPrj.BackColour &H0
    
    SetupLevel bTransporting
    
    ' Music
    tMusicControl.strMusicFiles(1) = ""
    tMusicControl.sngMusicLen(1) = 0
    tMusicControl.strMusicFiles(2) = "Persistence.mp3"
    tMusicControl.sngMusicLen(2) = 159
    tMusicControl.strMusicFiles(3) = ""
    tMusicControl.sngMusicLen(3) = 0
    
    tMusicControl.intCurMusicTrack = 1

End Function

Function MainLoop() As Boolean
' Returns:
'  1 if MainLoop should be recalled
'  0 if not

    ' The main loop. Each cycle represents one frame.
    Do While Not (UserInteraction) And iLevelCompeted = 0           ' {  Input
        
        ' Allow events in this game to accour                       ' /
        GameEvents                                                  ' |
                                                                    '-   Process
        ' Allow other events to process.                            ' |
        DoEvents                                                    ' \
        
        DrawFrame                                                   ' {  Output
                
    Loop
    
    If iLevelCompeted = 1 Then
    
        If rrGame.strEpisodeName = "Home" Then
            ' Whole game has been completed
            bGameCompleted = True
        Else
            ' This level has been completed, copy 'Home' into 'Home\old\'
            DeleteFile App.Path & "\data\players\" & rrRepton.strName & "\Home\old\start.rrl", False
            CopyFile App.Path & "\data\players\" & rrRepton.strName & "\Home\start.rrl", App.Path & "\data\players\" & rrRepton.strName & "\Home\old\start.rrl"
        End If
        
    ElseIf iLevelCompeted = 0 Then
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

    Open strFile + strEpisodeName + ".rre" For Input As #1
        
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
        OpenFMOD App.Path & "\data\music\" & tMusicControl.strMusicFiles(tMusicControl.intCurMusicTrack)
        PlayFMOD
        tMusicControl.exMusicControl.ReSet
    End If
End Function
