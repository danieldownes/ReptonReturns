namespace ReptonReturnsLogic.Interactors
{
    internal class Pause
    {
        public void DoPause() { }
        public void DoUnpause() { }
    }
}

/*
Private Type type_Pause
    timPauseContol As New exTools_Timer     ' See 'Pause' function for detail
    sngDelay       As Single                '  " . . .
    bPaused        As Boolean
End Type
Dim tPause As type_Pause



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
*/