using UnityEngine;
using System.Collections;

// Replaces ccRockOrEgg vb6 class
public class rr2moveable : rr2moveable2 
{
		
	public bool bFalling;
    public bool bWasFalling;
	public bool bFreeFall;
	public bool bPlayingSnd;

	public bool bEggCracking;  //Public bEggCracking As Boolean
		
	private string sSlantedLeft;		// Pieces that this movable will fall/slide off to the left from when unsupported
	private string sSlantedRight;		//  "" but for right
	
	
	void Start () 
	{
	
	}
	
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
	
	void Update() 
	{
		
		
		if( fTime > 0.00f)
			fTime -= Time.deltaTime;
		
		// TODO: Control cracking animation
		if( bEggCracking )
		{
			
			if( fTime <= 0.0f)
            {
				
                rr2gameObject.loadedLevel.iEggs--;

                
                
                // Prevent egg from further prosessing
                //rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x - 1, (int)-vPosition.z + 1].id = -1;
                
                
                
                // Start particle emitter?
                //

                // Remove self
                rr2gameObject.loadedLevel.ReplacePiece(vPosition, '0');


                // Spawn monster
                rr2gameObject.loadedLevel.SpawnMonster(vPosition);

                // Remove reference that this is an egg
                iId = -1;
            }
		}else
        {
		    Move3D();
            CheckIfFall();
		}

        // Stop sound?
        if( fTime <= 0.00f && bPlayingSnd)
        {
            this.audio.Stop();
            bPlayingSnd = false;
        }
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
		
		// Space for the rock to move? -- this check is already being done in rr2player.
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
		if( rr2gameObject.loadedLevel.GetMapP(vPosition) == (char)rr2level.enmPiece.Monster )
        {
			rr2gameObject.loadedLevel.KillMonsters(vPosition);
        }


	   		
		rr2gameObject.loadedLevel.SetMapP(vPosition, (char)pPieceType, iId);
		rr2gameObject.loadedLevel.SetMapP(vLastPosition, (char)rr2level.enmPiece.Space, -1);
				
		return true;
	}


    private void Move3D()
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
		
		char sTemp;
		int i;
		//int n;

        bWasFalling = false;
			
		
		
		// Have we stoped falling?
		bWasFalling = false;
    
		if( bFalling && fTime <= 0.0f)
		{
    		bFalling = false;
        	bWasFalling = true;
			
			// TODO: falling stop sound
			//If bPlayingSnd Then rrGame.PlayRockRumbleSound False
			//bPlayingSnd = False
        	//If intPieceType = Rock Then ExSnds(5).PlaySound (False) Else ExSnds(8).PlaySound (False)


            if (pPieceType == rr2level.enmPiece.Egg)
            {
                CrackEgg();
                return;
            }
    
		}
		
	
		
		// Fall stright down?
		// TODO: Fix
		sTemp = '5';
        //sTemp = (char)rr2gameObject.loadedLevel.RrMapDetail[(int)vPosition.x, (int)-vPosition.z + 1].TypeID;
		
		
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
            //if( sTemp == (char)rr2level.enmPiece.Monster)
                rr2gameObject.loadedLevel.KillMonsters(vPosition + Vector3.back);
		} 
        // Is player already under moving rock?
        else if( sTemp == (char)rr2level.enmPiece.Repton )
		{
            if( bWasFalling )
			{
                rr2gameObject.playerObject.Die();
			}
		}

	
	
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
            sTemp = rr2gameObject.loadedLevel.GetMapPId(vPosition + Vector3.back);
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
                        if( sTemp == 'm')
                            rr2gameObject.loadedLevel.KillMonsters(vPosition + Vector3.left + Vector3.back);

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
                        //if( sTemp == 'm')
                        rr2gameObject.loadedLevel.KillMonsters(vPosition + Vector3.right + Vector3.back);

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
	
	

        //bWasFalling = bFalling;

	}


    void CrackEgg()
    {
        bEggCracking = true;     // Flag for egg cracking animation sequence
        bWasFalling = false;
                
        fTime = 2.0f;  // Now acts as a counter to control cracking/twitching animation
        //ExLog3D.AnimatedTransform.TransformTo Rotation3D, ExPrj.exReturn3DVec(1, 2, 0), ExPrj.exReturn3DVec(0, 0, 0), (1 / rrGame.sngGameSpeed)

        //ExSnds(7).PlaySound False
                
    }

}