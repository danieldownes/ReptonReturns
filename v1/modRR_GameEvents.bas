Attribute VB_Name = "modRR_GameEvents"
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Private timFungus As New exTools_Timer      ' Control Timing of fungus growth thoughout map
Private sngNextFungusTime As Single


Function GameEvents()
    
    Dim n As Integer
    
    ' Move any spirts
    For n = 0 To rrMap.intTotSpirits
    
        rrSpirit(n).CheckIfMove
        
            
       
        'Does this spirit walk into a cage
        
    Next n
    
    'Move any falling rocks
    For n = 0 To rrMap.intTotRocksOrEggs
    
        rrRocksOrEggs(n).CheckIfFall
    
        'Check for a kill
            
            'Does this rock kill repton
            
            'Does this rock kill an alien
            
    Next n
    
    ' Move any monsters
    If rrMap.intTotMonsters <> 0 Then
        For n = 1 To rrMap.intTotMonsters
            rrMonster(n).CheckIfMove
        Next n
    End If
    

    
    ' Do any fungas'es grow?
    GrowFunguses
       


    
    'Check time remaining
    
End Function



Function GrowFunguses()
    
    Dim intX As Integer
    Dim intY As Integer
    Dim intFungusToGrow As Integer
    Dim n As Integer
    Dim n2 As Integer
    Dim n3 As Integer
    Dim bCanGrow(4) As Boolean
    Dim sTemp As String * 1
    
    ' Check if there has been sufficent time since last growth
    If timFungus.LocalTime >= sngNextFungusTime Then
        
        ' Possible methods to determine/select fungus growth:
        '   1)  Scan whole map, choosing one fungus to check for possible growth
        '   2)  Use an array of all funguses, selecting one to check for growth
        '   3)  Each fungus has its own class instence, checking its self for possible growth
        '   4)  There is a class instence for each cluster of funguses, each with an array of their funguses
        '
        '  I'll try method '1', as it uses less memory and is easiest to implement;
        '   this method could be quite slow though.
        
        
        ' Randomaly choose a fungus to possible grow
        intFungusToGrow = Int(Rnd() * (rrMap.intTotFunguses - 1)) + 1
        
        ' Find this fungus'es map coords.
        n = 0
        For intY = 1 To 27
            For intX = 1 To 30
            
                If rrMap.GetData(intX, intY) = "f" Then n = n + 1
                
                If n = intFungusToGrow Then GoTo FungusFound
            
            Next intX
        Next intY

FungusFound:
        
        ' Now check if this fungus is elegable to grow (ie; nothing in the way (other than Repton)) ...
        
        n = 0
        
        ' Left?
        sTemp = rrMap.GetData(intX - 1, intY)
        If sTemp = "i" Or sTemp = "0" Then
            bCanGrow(1) = True
            n = n + 1
        End If
        
        ' Right?
        sTemp = rrMap.GetData(intX + 1, intY)
        If sTemp = "i" Or sTemp = "0" Then
            bCanGrow(2) = True
            n = n + 1
        End If
        
        ' Up?
        sTemp = rrMap.GetData(intX, intY - 1)
        If sTemp = "i" Or sTemp = "0" Then
            bCanGrow(3) = True
            n = n + 1
        End If
        
        ' Down?
        sTemp = rrMap.GetData(intX, intY + 1)
        If sTemp = "i" Or sTemp = "0" Then
            bCanGrow(4) = True
            n = n + 1
        End If
        
        ' Can we grow?
        If n <> 0 Then
            
            ' Choose which way to grow (from the number of posible ways to go)
            n = Int(Rnd() * n) + 1
            
            ' Find which way this is
            n2 = 0
            n3 = 0
            Do
                n2 = n2 + 1
                If bCanGrow(n2) = True Then n3 = n3 + 1
            Loop While (n <> n3)
            
                    
            ' Enter this new fungus onto the map
            Select Case n2
            
                Case 1          ' Left
                    intX = intX - 1
                    
                Case 2          ' Right
                    intX = intX + 1
                    
                Case 3          ' Up
                    intY = intY - 1
                    
                Case 4          ' Down
                    intY = intY + 1
                    
            End Select
            
            ' Check if Repton should die
            If rrMap.GetData(intX, intY) = "i" Then
                rrRepton.Die
            End If
            
            ' Write new fungus to map
            rrMap.SetData intX, intY, Fungus
            rrPieces(intX, intY).TypeID = "f"
            
            rrMap.intTotFunguses = rrMap.intTotFunguses + 1
            
            ' Generate new interval and Reset timer
            
            'timFungus.Stop_
            timFungus.ReSet
            FungusNewTime
            
        End If
    End If
    
End Function

Function FungusNewTime()
    sngNextFungusTime = Rnd() * 5 + 3
    
    ' Reset timer
    
    'timFungus.Start
End Function
