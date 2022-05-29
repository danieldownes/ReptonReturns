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


Public sEpisodeDir As String
Public iCurGameLevel As Integer

Public strEpisodeName As String
Public intGamePlayType               As Integer
Dim strLevelOrder()               As String
Public strVisualTheme As String


Private Type type_Pause
    timPauseContol As New exTools_Timer     ' See 'Pause' function for detail
    sngDelay       As Single                '  " . . .
    bPaused        As Boolean
End Type
Dim tPause As type_Pause

Function Init()

    ' Init Pause functionality
    Pause -1
    
    
    sEpisodeDir = "C:\Documents and Settings\Dan.DAN-NEWCOMP\My Documents\Ex-D\Software Development\Projects\Games\Repton Returns\v1\data\episode\Tutorial\"
    strEpisodeName = "Tutorial"
    
    OpenFileEpisode sEpisodeDir
    
    iCurGameLevel = 1
    rrMap.LoadFileLevel
    
    
    SetupLevel

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
        n = 1
        Do
            ReDim Preserve strLevelOrder(n)
            Input #1, strLevelOrder(n)
            
            n = n + 1
        Loop Until EOF(1)
        
        
        
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
    MsgBox "You have cleared all dimonds from level " & Str(rrGame.iCurGameLevel) & "!!!"
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

