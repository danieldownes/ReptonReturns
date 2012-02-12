using System;
using UnityEngine;

public class rr2spirit : rr2moveable2
{
	public rr2game rr2gameObject;
	
	public int iId; // lObjects ref
	
	public int iState;  // 0 = Seek (check direction), 1 = Moving
	
	private bool bFirstMove;		// Helps to make sure the first move of the spirit is the same as origonal version of Repton
		
	private int iCornTry; 			// If spirit did not move (ie, determined new direct) this is > 0, stops
                                    //  spirit from 'waiting' while turning around corners.
                                    //  Will try to 'move' spirit upto 4 times per function call to
                                    //  keep in sync. with other spirts 
	
	public char cOnPiece; 
	public char cLastOnPiece;
	public int iOnId;
	public int iLastOnId;
	
	public rr2spirit ()
	{
		
	}
	
	public void Init(Vector3 vPos)
    {
        pPieceType = rr2level.enmPiece.Spirit;

        fTimeToMove = 0.45f;

        cOnPiece = '0';
        iOnId = -1;

        iState = 1;
        fTime = 1.0f;


        vPosition = vLastPosition = vPos;
		
		// Determine starting direction ...      ' (in origonal Repton this is done on every spirt move; hence 'dazed sprits')
		
		// If nothing is set, then default to Up
        vDirection = vLastDirection = Vector3.forward;
        
		// Move Right?
    	if( !MoveableTo(vPosition, Vector3.back))
        	vDirection = Vector3.right;
    
    	// Move Down?
    	if( !MoveableTo(vPosition, Vector3.right))
        	vDirection = Vector3.back;
    
    	// Move Left?
    	if( !MoveableTo(vPosition, Vector3.forward))
        	vDirection = Vector3.left;
    

    	bFirstMove = true;
    	//bDidNotMoveLast = true;
		
		
		vLastDirection = vDirection;
        
    }
	
	void Update()
	{
		fTime -= Time.deltaTime;
		
		if( iState == 1)
        {
            if( fTime <= 0.0f)
                iState = 0;
        }else
        {
            ControlSeek();
        }
		
		//Move3D();
		// Interpolate
		transform.position = Vector3.Lerp(vLastPosition, vPosition, (fTimeToMove - fTime) / fTimeToMove);
	}
	
	void Move( Vector3 vDir)
	{
		// Update local info
		
		Debug.Log("Spirit Move:" + vDir);
		
		vLastPosition = vPosition;
		vLastDirection = vDirection;
			
		vPosition += vDir;
		vDirection = vDir;
		
		cLastOnPiece = cOnPiece;
		iLastOnId = iOnId;

        fTime = fTimeToMove;

		iOnId = rr2gameObject.loadedLevel.GetMapPId(vPosition);
		
		// Does Repton die in result of this move?
		if( rr2gameObject.loadedLevel.GetMapP(vPosition) == 'i' 
		 || rr2gameObject.loadedLevel.GetMapP(vLastPosition) == 'i' )
        {
			rr2gameObject.playerObject.Die();
            //cOnPiece = '0';
		}	
		
		rr2gameObject.loadedLevel.SetMapP(vLastPosition, cOnPiece, iOnId);
		rr2gameObject.loadedLevel.SetMapP(vPosition, (char)pPieceType, iId);
		
	}
	
	public bool MoveableTo( Vector3 vPos, Vector3 vDir)
	{
		bool bMoveableTo;
		char cT;
		
		cT = rr2gameObject.loadedLevel.GetMapP(vPos + vDir);
		
		// Checks if a spirit can move to the piece at the given map coords.
		bMoveableTo = ( cT == '0' || cT == 'i' || cT == 'e' || cT == 'c' );
		
		return bMoveableTo;
	}
	
	public void ControlSeek()
	{
		char cT;
		bool bCanMove;
		Vector3 vOldDir;
		
		
		while( iCornTry < 4)
		{
	        vOldDir = vDirection;
	        
	        // Is there a wall there we should hug? ...
			if( !bFirstMove)	// Only do this if not the first move
			{
	            vDirection = vOldDir;      // In case we turned right (if wall was infront) //??
				bCanMove = MoveableTo(vPosition, vDirection);
	            
				// Do the check
				if( bCanMove)
				{
					// No! Then turn left
					// AKA: Hug wall left (antturn CCW)
					if( vDirection == Vector3.forward)
						vDirection = Vector3.left;
					else if( vDirection == Vector3.back)
						vDirection = Vector3.right;
					else if( vDirection == Vector3.left)
						vDirection = Vector3.back;
					else if( vDirection == Vector3.right)
						vDirection = Vector3.forward;
				}
			}else
				bFirstMove = false;
	
			// Which way are we facing?
			bCanMove = MoveableTo(vPosition, vDirection);
	
			// Ok to move forward??
			if( bCanMove)
			{
				Move(vDirection);
				iCornTry = 0;
				
				cT = rr2gameObject.loadedLevel.GetMapP(vPosition);
	
				// If we went into a cage, we should turn into a dimond (deactivate and change map)
				//if (cT == 'c')
				//{
	//                ExSnds(9).PlaySound False
	//                
	//                bActive = False
	//                
	//                rrMap.SetData intCurX, intCurY, Dimond
	//                rrPieces(intCurX, intCurY).TypeID = DataInt2Str(Dimond)
				//}
	//            
	//            ' If we went into Repton, he should die
	//            If sTemp = "i" Or rrMap.GetData(intOldX, intOldY) = "i" Then
	//                rrRepton.Die
	//            End If
	//            
				// Remember last coords. - used to check if Repton moved where spirit has just been (Repton should die if this is true)
				vLastPosition = vPosition;
				
			}else
			{
				// Try next direction (turn clockwise)
				if( vDirection == Vector3.forward)
					vDirection = Vector3.right;
				else if( vDirection == Vector3.back)
					vDirection = Vector3.left;
				else if( vDirection == Vector3.left)
					vDirection = Vector3.forward;
				else if( vDirection == Vector3.right)
					vDirection = Vector3.back;
				
				iCornTry++;
			}
		}
	}
	
}