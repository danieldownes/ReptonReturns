using UnityEngine;
using System.Collections;

// Replaces ccRockOrEgg vb6 class
public class rr2moveable : rr2moveable2 
{
		
	public bool bFalling;
	public bool bFreeFall;
	public bool bPlayingSnd;

	public bool bEggCracking;  //Public bEggCracking As Boolean
	
	private float fTime;
	private float fTimeToMove; 	//Private cintTimeToMove As Single     ' Number of seconds it take for rock/egg to move from one map piece to another.
	
	private string sSlantedLeft;		// Pieces that this movable will fall/slide off to the left from when unsupported
	private string sSlantedRight;		//  "" but for right
	
	
	void Start () 
	{
	
	}
	
	/*
	 * Function Init(intType As enmPieceType, intX As Integer, intY As Integer)
	' intType should only be Rock OR Egg
	
	    Dim strThemeDir As String
	    strThemeDir = rrGame.strVisualTheme
	
	    intPieceType = intType
	    
	    intCurX = intX
	    intCurY = intY
	    
	    
	    If intType = Rock Then
	        
	        ExLog3D.InitXFile pckOrigThemeFiles.GetPackedFile("rock.x"), pckOrigThemeFiles.GetPackedFile("ROCK.BMP")
	        
	        ' Random post rotation?
	        ExLog3D.RotateVecs Rnd() * 360, Rnd() * 360, 0
	        
	    Else
	        ' Egg
	        ExLog3D.InitXFile pckOrigThemeFiles.GetPackedFile("egg.x"), pckOrigThemeFiles.GetPackedFile("egg.bmp")
	    End If
	
	    ExLog3D.ResetMatrix
	    ExLog3D.position Ret3DPos(intCurX), Ret3DPos(intCurY), -200, True
	    
	    blnFalling = False
	    bEggCracking = False
	    
	    cintTimeToMove = 0.22 / rrGame.sngGameSpeed
	
	
	End Function
*/
	public void Init(rr2level.enmPiece iSetPieceType, Vector3 vSetPos)
	{
		pPieceType = iSetPieceType;
		vPosition = vSetPos;
		
		sSlantedLeft = "d7rkgtb&";
		sSlantedRight = "d9rkgtb(";  // Can fall to the right if did not fall left
		
		bEggCracking = false;
		
		fTime = 0f;
		fTimeToMove = 0.3f;
		bFalling = false;
	}
	
	void Update () 
	{
		
		
		if( fTime > 0.00f)
			fTime -= Time.deltaTime;
		
		// TODO: Control cracking animation
		if( bEggCracking )
		{
			
			/*
			 * fTimeToMove
			 * 
				' Remove reference that this is an egg
                rrMap.intTotEggs = rrMap.intTotEggs - 1
                intMyRockOrEggID = -1
                
                ' Prevent egg from further prosessing
                rrPieces(intCurX, intCurY).intRockOrEggID = -1
                
                
                ' Flash vis effect/emitter?
                '
                
                ' Start particle emitter?
                '
                
                
                ' Spawn monster
                rrMonster(rrMap.intTotMonstersAlive + 1).Spawn intCurX, intCurY
             */
		}
		
		
		//CheckIfFall();
		
		move3D();
		
	}
	
	public bool Move(Vector3 vDir)
	{
		//Vector3 vNewPos;
		
		//vNewPos = vPosition + vDir;
		
		// Not currently moving down?
		if( vDir == Vector3.back && fTime > 0.01f)
			return false;
		
		// Can't move up
		if( vDir == Vector3.forward)
			return false;
		
		// Space for the rock to move?
		//if( rr2gameObject.loadedLevel.RrMapDetail[(int)vNewPos.x, (int)-vNewPos.z].TypeID != (char)rr2level.enmPiece.Space 
		// && rr2gameObject.loadedLevel.RrMapDetail[(int)vNewPos.x, (int)-vNewPos.z].TypeID != (char)rr2level.enmPiece.Monster)
		//	return false;
		
		// Ok, start the move...
		
		fTime = fTimeToMove;
		
		// Update the position
		vLastPosition = vPosition;
		vLastPositionAbs = transform.position;
		vPosition += vDir;
		
		// Play Rock Sound
        if (!bPlayingSnd)
        {
            this.audio.Play();
            bPlayingSnd = true;
        }
		
		
		
		
	    // Its already been dertimined that its ok to move to the new coords.- so lets update this logically...
	    
	    // Before we do though, are there any monsters in the way? if so they should die..
	    
	    // Is monster under rock?
		//if( rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z].TypeID == (char)rr2level.enmPiece.Monster )
		//{
		//	 
		//}
	    /*
	    
	    If rrMap.GetData(intCurX, intCurY) = "m" Then
	        ' Find ID of this monster and kill it - should also work if more than one monster is in same place
	        For n = 1 To rrMap.intTotMonstersAlive
	            If (rrMonster(n).GetXPos = intCurX And rrMonster(n).GetYPos = intCurY) Or _
	               (rrMonster(n).GetXPos = intOldX And rrMonster(n).GetYPos = intOldY) Then
	                rrMonster(n).Die
	            End If
	        Next n
	    End If
	    */
		
		rr2gameObject.loadedLevel.SetMapP(vPosition, (char)pPieceType, iId);
		rr2gameObject.loadedLevel.SetMapP(vLastPosition, (char)rr2level.enmPiece.Space, -1);
				
		return true;
	}
	
	
	private void move3D()
	{
		// Interpolate
		transform.position = Vector3.Lerp(vLastPositionAbs, vPosition, (fTimeToMove - fTime) / fTimeToMove);
		
		/*
		' Movment should be slower if not falling down
	    If int3DDirection = Down Then
	        ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), ExLog3D.position.z), ExLog3D.position, cintTimeToMove
	    Else
	        ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), ExLog3D.position.z), ExLog3D.position, cintTimeToMove * 1.25
	    End If
		 */
		
		// TODO: rotation
		//if( vDir == Vector3.left)
			//transform.RotateAround
	}
	
	
	
	public void CheckIfFall()
	{
		bool bWasFalling;
		char sTemp;
		int i;
		//int n;
		
		// If egg is cracking then exit now as eggs don't fall while cracking
    	if( bEggCracking )
			return;
		
		
		
		// Have we stoped falling?
		bWasFalling = false;
    
		if( bFalling && fTime <= 0.0f)
		{
    		bFalling = false;
        	bWasFalling = true;
			
			Debug.Log("Rock Stoped Falling");
        
			// TODO: falling stop sound
			//If bPlayingSnd Then rrGame.PlayRockRumbleSound False
			//bPlayingSnd = False
        	//If intPieceType = Rock Then ExSnds(5).PlaySound (False) Else ExSnds(8).PlaySound (False)
    
		}
		
		
		
		/*
		' Can only fall if not already falling
	    If blnFalling = False Then
	    
	        ' Is below rock still falling? If so, don't do anything until that rock is out of the way
	        If rrPieces(intCurX, intCurY + 1).intRockOrEggID <> -1 Then
	            If rrRocksOrEggs(rrPieces(intCurX, intCurY + 1).intRockOrEggID).blnFalling = True Then
	                'Exit Function
	            End If
	        End If
		*/
		
		// Can only fall if not already falling
		if( !bFalling )
		{
			// Is below rock still falling? If so, don't do anything until that rock is out of the way
            if (rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x, (int)-vPosition.z + 1].id != -1)
			{
				
			}
			
		}
		
		// Fall stright down?
        sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x, (int)-vPosition.z + 1].TypeID;
		
		if( sTemp == (char)rr2level.enmPiece.Space )
		{
			// Is player currently moving under rock?
			if( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.back) )
			{
				// It is ok to make rock fall
            	bFalling = true;
                this.Move(Vector3.back);
            }
		}
		// Is a monster currently moving under rock?
		else if(sTemp == (char)rr2level.enmPiece.Monster)
		{
			/*
			i = rrPieces(intCurX, intCurY + 1).intMonsterID
            If i <> -1 Then
                blnFalling = rrMonster(iTemp).Die
                If blnFalling Then Me.Move Down
            End If
            */
		} 
        // Is player already under moving rock?
        else if( sTemp == (char)rr2level.enmPiece.Repton )
		{
            if( bWasFalling )
			{
             //   rrRepton.Die
             //   GoTo CrackEgg
			}
		}
		
		/*
		
		Else
CrackEgg:
            ' Eggs should crack at this point
            If intPieceType = Egg And bWasFalling = True Then
                               
                
                bEggCracking = True     ' Flag for egg cracking animation sequence
                bWasFalling = False
                
                cintTimeToMove = 0  ' Now acts as a counter to control cracking/twitching animation
                ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(1, 2, 0), ExPrj.exReturn3DVec(0, 0, 0), (1 / rrGame.sngGameSpeed)

                ExSnds(7).PlaySound False
                
                
                Exit Function
                
                
            End If
        
        End If
                
    End If
		    */
		
	
	
	
	    // Still not falling?
	    //  Try fall to the left..
	    if( !bFalling)
	    {
        
            // Is left-below rock still falling? If so, don't do anything until that rock is out of the way
			if( vPosition.x > 0)
			{
				sTemp = rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x - 1, (int)-vPosition.z + 1].TypeID;
	            if( sTemp == (char)rr2level.enmPiece.Rock || sTemp == (char)rr2level.enmPiece.Egg)
			    {
	                i = rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x - 1, (int)-vPosition.z + 1].id;
		            if( i != -1 )
				    {
	                    rr2moveable oScript = rr2gameObject.loadedLevel.lObjects3[i].GetComponent("rr2moveable") as rr2moveable;
					    if( oScript)
					    {
			                if( oScript.bFalling)
			                    return;
					    }
				    }		
			    }
			}
        
            // Is the support currently under rock slanted to the left?
            sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x, (int)-vPosition.z + 1].TypeID;
		    //Debug.Log("Contains:" + sTemp.ToString());
            if( sSlantedLeft.Contains( sTemp.ToString() ) )
		    {
			   // Debug.Log("IN Contains:" + sTemp.ToString());	
				
			    // Check if room exists to the left (And Repton isn't there)
                sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x - 1, (int)-vPosition.z].TypeID;
            
                if( (sTemp == '0' || sTemp == 'm') && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.left)) )
			    {
				    // Check if room exists to 1 left, 1 down (And Repton isn't there)
                    //sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   
                    sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x - 1, (int)-vPosition.z + 1].TypeID;
                    if( (sTemp == '0' || sTemp == 'm') && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.left + Vector3.back)) )
				    {
					    /*
                        iTemp = rrPieces(intCurX - 1, intCurY + 1).intMonsterID
                        If iTemp <> -1 Then
                            If rrMonster(iTemp).Die = False Then Exit Function
                        End If
                        */
					
                        // This rock should fall to the left
                        bFalling = true;
                        this.Move( Vector3.left + Vector3.back );
                    
				    }
			    }
		    }
	    }

	
	    // Still not falling?
	    //  Try fall to the right..
	    if( !bFalling)
	    {
            // Is left-below rock still falling? If so, don't do anything until that rock is out of the way
			sTemp = rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].TypeID;
		    if( sTemp == (char)rr2level.enmPiece.Rock || sTemp == (char)rr2level.enmPiece.Egg )
		    {
			    i = rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].id;
	            if( i != -1 )
			    {
	                rr2moveable oScript = rr2gameObject.loadedLevel.lObjects3[i].GetComponent("rr2moveable") as rr2moveable;
				    if( oScript)
				    {
		                if( oScript.bFalling)
		                    return;
				    }
			    }	
		    }
        
        
            // Is the support currently under rock slanted to the right?
            sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x, (int)-vPosition.z + 1].TypeID;
            if( sSlantedRight.Contains( sTemp.ToString() ) )
		    {
			    // Check if room exists to the right (And Repton isn't there)
                sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z].TypeID;
            
                if( (sTemp == '0' || sTemp == 'm') && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.right)) )
			    {
				    // Check if room exists to 1 left, 1 down (And Repton isn't there)
                    //sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   
				    sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].TypeID;
                    if( (sTemp == '0' || sTemp == 'm') && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.right + Vector3.back)) )
				    {
					    /*
                        iTemp = rrPieces(intCurX - 1, intCurY + 1).intMonsterID
                        If iTemp <> -1 Then
                            If rrMonster(iTemp).Die = False Then Exit Function
                        End If
                        */

                        // This rock should fall to the right
                        bFalling = true;
                        this.Move( Vector3.right + Vector3.back );
                    
				    }
			    }
		    }
	    }
	
	    // If rock is in free falling (ie, it has been falling before it was detected that it should fall
	    //  again (directly afterward), then add count (so that it can be detected if it hit repton, or if this is
	    //  an egg, if it should crack).
	    if( bFalling && bWasFalling )
	        bFreeFall = true;
	    else
	        bFreeFall = false;
	
	
	    // Should falling sound stop?
        if (!bFalling ) // && bWasFalling
        {
            
            if (bPlayingSnd)
            {
                this.audio.Stop();
                
                

                bPlayingSnd = false;
            }
	     
            // Crash sound
    //	    if( intPieceType == Rock 
      //            ExSnds(5).PlaySound (False) 
            //Else ExSnds(8).PlaySound (False)
	    }

        //bWasFalling = bFalling;

	}
}