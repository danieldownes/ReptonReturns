using UnityEngine;

public class Fire : MonoBehaviour
{
    public Game game;

    private float time;
    private float timeToMove;

    //Private timFungus As New exTools_Timer      ' Control Timing of fungus growth thoughout map
    //Private sngNextFungusTime As Single


    void Start()
    {
        NewTime();
    }

    void Update()
    {
        time -= Time.deltaTime;

        if (time <= 0.0f)
            GrowFire();
    }

    void NewTime()
    {
        time = Random.Range(1, 2); //* rrGame.sngGameSpeed;
    }


    /*
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
        
        
        ' Randomaly choose a fungus to possibly grow
        intFungusToGrow = Int(Rnd() * (rrMap.intTotFunguses - 1)) + 1
        
        ' Find this fungus'es map coords.
        n = 0
        For intY = 1 To rrMap.intMapSizeY
            For intX = 1 To rrMap.intMapSizeY
            
                If rrMap.GetData(intX, intY) = "f" Then n = n + 1
                
                If n = intFungusToGrow Then GoTo FungusFound
            
            Next intX
        Next intY

FungusFound:
        
        ' Now check if this fungus is elegable to grow (ie; nothing in the way (other than Repton)) ...
        
        n = 0
        
        ' Left?
        sTemp = rrMap.GetData(intX - 1, intY)
        If sTemp = "i" Or sTemp = "m" Or sTemp = "0" Then
            bCanGrow(1) = True
            n = n + 1
        End If
        
        ' Right?
        sTemp = rrMap.GetData(intX + 1, intY)
        If sTemp = "i" Or sTemp = "m" Or sTemp = "0" Then
            bCanGrow(2) = True
            n = n + 1
        End If
        
        ' Up?
        sTemp = rrMap.GetData(intX, intY - 1)
        If sTemp = "i" Or sTemp = "m" Or sTemp = "0" Then
            bCanGrow(3) = True
            n = n + 1
        End If
        
        ' Down?
        sTemp = rrMap.GetData(intX, intY + 1)
        If sTemp = "i" Or sTemp = "m" Or sTemp = "0" Then
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
            
            ' Play sound
            If rrRepton.GetXPos > (intX - 7) And rrRepton.GetXPos < (intX + 7) And rrRepton.GetYPos > (intY - 7) And rrRepton.GetYPos < (intY + 7) Then
                ' Repton is near, play fungus sound
                ExSnds(15).PlaySound False
            End If
            
            ' Check if Repton should die
            If rrMap.GetData(intX, intY) = "i" Then
                rrRepton.Die
            End If
            
            ' Check if monster should die
            If rrMap.GetData(intX, intY) = "m" Then
                ' Find ID of this monster and kill it - should also work if more than one monster is in same place
                For n2 = 1 To rrMap.intTotMonstersAlive
                    If rrMonster(n2).GetXPos = intX And rrMonster(n2).GetYPos = intY Then
                        rrMonster(n2).DieForced
                    End If
                Next n2
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

    ' If no funguses can grow then reset timer so that once fungus can grow, it dosn't grow instently
    If timFungus.LocalTime >= sngNextFungusTime Then timFungus.ReSet
    
End Function



Function FungusNewTime()
    sngNextFungusTime = (Rnd() * 10 + 5) * rrGame.sngGameSpeed
    
    ' Reset timer
    
    'timFungus.Start
End Function

	 */

    void GrowFire()
    {
        int x, y, iFireToGrow, n, n2, n3;
        bool[] bGrow = { false, false, false, false };
        char cT;


        // Possible methods to determine/select fungus growth:
        //   1)  Scan whole map, choosing one fungus to check for possible growth
        //   2)  Use an array of all funguses, selecting one to check for growth
        //   3)  Each fungus has its own class instence, checking its self for possible growth
        //   4)  There is a class instence for each cluster of funguses, each with an array of their funguses

        //  I'll try method '1', as it uses less memory and is easiest to implement;
        //   this method could be quite costly though, at least we are using a timer..


        // Randomaly choose a fire to possibly grow
        int iFires = game.loadedLevel.iPieceTot[102 - 32]; //((int)(char)rr2level.enmPiece.Fungus)
        iFireToGrow = Random.Range(0, iFires) + 1;



        // Find this fungus'es map coords.
        n = 0;
        x = 0;
        for (y = 0; y < game.loadedLevel.MapSizeY && n < iFireToGrow; y++)
        {
            for (x = 0; x < game.loadedLevel.MapSizeX && n < iFireToGrow; x++)
            {
                if (game.loadedLevel.MapDetail[x, y].TypeID == (char)Level.Piece.Fungus)
                    n++;
            }
        }




        // Now check if this fire is elegable to grow (ie; nothing in the way (other than Repton)) ...

        n = 0;

        // Left?
        //if( x > 0)
        //{
        cT = (char)game.loadedLevel.MapDetail[x - 1, y].TypeID;
        if (cT == 'i' || cT == 'm' || cT == '0')
        {
            bGrow[0] = true;
            n++;
        }
        //}

        // Right?
        //if( x < rr2gameObject.loadedLevel.iMapSizeX -1)
        //{
        cT = (char)game.loadedLevel.MapDetail[x + 1, y].TypeID;
        if (cT == 'i' || cT == 'm' || cT == '0')
        {
            bGrow[1] = true;
            n++;
        }
        //}

        // Up?
        //if( y > 0)
        //{
        cT = (char)game.loadedLevel.MapDetail[x, y - 1].TypeID;
        Debug.Log("UP=" + cT);
        if (cT == 'i' || cT == 'm' || cT == '0')
        {
            bGrow[2] = true;
            n++;
            Debug.Log("Can UP");
        }
        //}

        // Down?
        //if( y < rr2gameObject.loadedLevel.iMapSizeY -1)
        //{
        cT = (char)game.loadedLevel.MapDetail[x, y + 1].TypeID;
        if (cT == 'i' || cT == 'm' || cT == '0')
        {
            bGrow[3] = true;
            n++;
        }
        //}

        Debug.Log("Fire to grow" + iFireToGrow + " x=" + x + " y=" + y + "n=" + n);

        for (int ii = 0; ii < 4; ii++)
            Debug.Log(ii + "=" + bGrow[ii]);

        // Can we grow?
        if (n > 0)
        {
            // Enter this new fire onto the map ..

            // Choose which way to grow (from the number of posible ways to go)
            n = Random.Range(1, n + 1);

            // Find which way this is
            n2 = 0;
            n3 = 0;
            while (n3 < n)
            {
                if (bGrow[n2])
                {

                    n3++;
                }
                n2++;
            }


            if (n2 == 1)  		// Left
                x--;
            if (n2 == 2)		// Right
                x++;
            if (n2 == 3)        // Up
                y--;
            if (n2 == 4)        // Down
                y++;


            // Play sound?
            //int iX = (int)rr2gameObject.playerObject.vPosition.x;
            //int iY = (int)-rr2gameObject.playerObject.vPosition.z;
            //if( pX > (x - 7) && pX < (x + 7) && pY > (y - 7) && pY < (y + 7)
            // Repton is near, play fire grow sound
            //    ExSnds(15).PlaySound False


            // Check if Repton should die
            //if( MapPiece2d[x,y].TypeID == enmPiece.Repton)
            //rrRepton.Die

            /*
            // Check if monster should die
            if( MapPiece2d[x,y].TypeID == enmPiece.Monster)
			{
                // Find ID of this monster and kill it - should also work if more than one monster is in same place
                for( int m = 1; m < iTotMonstersAlive; m++)
				{
                    if( (int)rrMonster(m).vPosition.x == x && (int)-rrMonster(m).vPosition.z == y)
                        rrMonster(m).DieForced();
				}
            }
            */

            // Write new fungus to map
            //rr2gameObject.loadedLevel.AddPiece( x, y, (char)rr2level.enmPiece.Fungus);

            //rr2gameObject.loadedLevel.iPieceTot[(int)(char)rr2level.enmPiece.Fungus -32 ]++	;
            //iTotFire++;
            Debug.Log("Grow:" + n2);

        }

        // If no funguses can grow then reset timer so that once fungus can grow, it dosn't grow instently
        //If timFungus.LocalTime >= sngNextFungusTime Then timFungus.ReSet

    }
}