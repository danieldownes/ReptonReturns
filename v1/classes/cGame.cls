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




Private Type type_Pause
    timPauseContol As New exTools_Timer     ' See 'Pause' function for detail
    sngDelay       As Single                '  " . . .
End Type
Dim tPause As type_Pause

Function Init()

    ' Init Pause functionality
    Pause -1
    
    ' Load the Repton Level
    rrMap.ThemeDir = "Repton 3"
    rrMap.CurGameLevel = 1
    rrMap.GameLevelsDir = "Repton 3"
    rrMap.LoadLevelData App.Path & "\data\episode\" & "tests\test_level.rr"   '"Repton 3\1.rr"

End Function

Function LevelCompleted()
    MsgBox "You have cleared all dimonds from level " & Str(rrMap.CurGameLevel) & "!!!"
End Function

Function Pause(sngTimed As Single) As Boolean
' sngTimed: -1 = Not paused
'            0 = Paused
'           >0 = Delayed pause in game (given in secs)
' Returns True when is paused

    Select Case sngTimed
        Case 0              ' Pause
            tPause.timPauseContol.Stop_
            tPause.timPauseContol.ReSet
            
        Case -1             ' Unpause
            tPause.timPauseContol.Stop_
            tPause.timPauseContol.ReSet
            tPause.timPauseContol.Increment -1
            
        Case -2             ' Return pause status
            ' Update timer (if needed, also see if delay has expired)
            If tPause.timPauseContol.LocalTime > tPause.sngDelay Then
                ' Stop the timer and say that we are now not paused
                Pause -1
                Pause = False
            Else
                If tPause.timPauseContol.LocalTime = 0 Then
                    Pause = True
                Else
                    Pause = False
                End If
            End If
        
        Case Else           ' Start delayed pause
            ' Start timer and set delay time
            tPause.timPauseContol.Start
            tPause.sngDelay = sngTimed
    
    End Select

End Function

