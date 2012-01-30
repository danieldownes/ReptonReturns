using UnityEngine;
using System.Collections;


// Replaces ccRockOrEgg vb6 class
public class rr2moveable : MonoBehaviour 
{
	public rr2game rr2gameObject;
	
	public int iId; //Public intMyRockOrEggID As Integer
	
	public rr2game.enmPiece pPieceType; //Public intPieceType As enmPieceType      ' Should only be Rock OR Egg

	
	//Public intCurX As Integer
	//Public intCurY As Integer
	public Vector3 vPosition;
	public Vector3 vLastPosition;

	
	//Dim int3DDirection As enmDirection              ' Current direction that we are rolling (if rolling at all)
	//'Dim int3DLastDir   As enmDirection              ' Last direction we rolled

	//Public blnFalling   As Boolean
	//Public blnFreeFall  As Boolean
	//Public bPlayingSnd  As Boolean
	
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
	public void Init(rr2game.enmPiece iSetPieceType, Vector3 vSetPos)
	{
		pPieceType = iSetPieceType;
		vPosition = vPosition = vSetPos;
		
		sSlantedLeft = "d7rkgtb&";
		sSlantedRight = "d9rkgtb(";
		
		bEggCracking = false;
		
		fTime = 0f;
		fTimeToMove = 0.3f;
	}
	
	void Update () 
	{
		
		
		if( fTime > 0.01f)
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
		
		
		CheckIfFall();
		
		move3D();
		
	}
	
	public void Move(Vector3 vDir)
	{
		Vector3 vOldPos;
		int n;
		
		// Not currently moving?
		if( fTime > 0.01f)
			return;
		
		// Can't move up
		if( vDir == Vector3.forward)
			return;
		
		// Ok, start the move...
		
		fTime = fTimeToMove;
		
		// Update the position
		vLastPosition = vPosition;
		vPosition += vDir;
		
		// Play Rock Sound
        //If Not bPlayingSnd Then rrGame.PlayRockRumbleSound True
        bPlayingSnd = true;
		
		
		
		
	    // Its already been dertimined that its ok to move to the new coords.- so lets update this logically...
	    
	    // Before we do though, are there any monsters in the way? if so they should die..
	    
	    // Is monster under rock?
		//if( rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z].TypeID == (char)rr2game.enmPiece.Monster )
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
		
		rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z].TypeID = (char)pPieceType;
		rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z].id = iId;
		rr2gameObject.RrMapDetail[(int) vLastPosition.x, (int)-vLastPosition.z].TypeID = (char)rr2game.enmPiece.Space;
		rr2gameObject.RrMapDetail[(int) vLastPosition.x, (int)-vLastPosition.z].id = -1;		
	}
	
	
	private void move3D()
	{
		// Interpolate
		transform.position = Vector3.Lerp(vLastPosition, vPosition, (fTimeToMove - fTime) / fTimeToMove);
		
		/*
		' Movment should be slower if not falling down
	    If int3DDirection = Down Then
	        ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), ExLog3D.position.z), ExLog3D.position, cintTimeToMove
	    Else
	        ExLog3D.AnimatedTransform.TransformTo Translation3D, ExPrj.exReturn3DVec(Ret3DPos(intCurX), Ret3DPos(intCurY), ExLog3D.position.z), ExLog3D.position, cintTimeToMove * 1.25
	    End If
		 */
		
		// TODO: rotation
		
		
	}
	
	
	
	public void CheckIfFall()
	{
		bool bWasFalling;
		char sTemp;
		int i;
		int n;
		
		// If egg is cracking then exit now as eggs don't fall while cracking
    	if( bEggCracking )
			return;
		
		
		
		// Have we stoped falling?
		bWasFalling = false;
    
		if( bFalling && fTime <= 0)
		{
    		bFalling = false;
        	bWasFalling = true;
        
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
			if( rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z + 1].id != -1)
			{
				
			}
			
		}
		
		// Fall stright down?
		sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z + 1].TypeID;
		
		if( sTemp == (char)rr2game.enmPiece.Space )
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
		else if(sTemp == (char)rr2game.enmPiece.Monster)
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
        else if( sTemp == (char)rr2game.enmPiece.Repton )
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
		if( rr2gameObject.RrMapDetail[(int) vPosition.x - 1, (int)-vPosition.z + 1].TypeID == (char)rr2game.enmPiece.Rock )
		{
			i = rr2gameObject.RrMapDetail[(int) vPosition.x - 1, (int)-vPosition.z + 1].id;
	        if( i != -1 )
			{
				rr2moveable oScript = rr2gameObject.lObjects3[i].GetComponent("rr2moveable") as rr2moveable;
				if( oScript)
				{
		            if( oScript.bFalling)
		                return;
				}
			}		
		}
        
        
        // Is the support currently under rock slanted to the left?
        sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z + 1].TypeID;
		//Debug.Log("Contains:" + sTemp.ToString());
        if( sSlantedLeft.Contains( sTemp.ToString() ) )
		{
			//Debug.Log("IN Contains:" + sTemp.ToString());	
				
			// Check if room exists to the left (And Repton isn't there)
            sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x - 1, (int)-vPosition.z].TypeID;
            
            if( (sTemp == '0' || sTemp == 'm') && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.left)) )
			{
				// Check if room exists to 1 left, 1 down (And Repton isn't there)
                //sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   
				sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x - 1, (int)-vPosition.z + 1].TypeID;
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

	/*
	// Still not falling?
	//  Try fall to the right..
	if( !bFalling)
	{
        // Is left-below rock still falling? If so, don't do anything until that rock is out of the way
		if( rr2gameObject.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].TypeID == rr2game.enmPiece.Rock )
		{
			i = rr2gameObject.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].id;
	        if( i != -1 )
			{
	            if( rr2gameObject.lObjects3[i].bFalling)
				{
	                return;
				}
			}		
		}
        
        
        // Is the support currently under rock slanted to the right?
        sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x, (int)-vPosition.z + 1].TypeID;
        if( sSlantedLeft.Contains( sTemp ) )
		{
			// Check if room exists to the left (And Repton isn't there)
            sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z].TypeID;
            
            if( (sTemp == "0" || sTemp == "m") && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.left)) )
			{
				// Check if room exists to 1 left, 1 down (And Repton isn't there)
                //sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   
				sTemp = (char)rr2gameObject.RrMapDetail[(int) vPosition.x + 1, (int)-vPosition.z + 1].TypeID;
                if( (sTemp == "0" || sTemp == "m") && ( rr2gameObject.playerObject.vPosition != (vPosition + Vector3.right + Vector3.back)) )
				{
					/*
                    iTemp = rrPieces(intCurX - 1, intCurY + 1).intMonsterID
                    If iTemp <> -1 Then
                        If rrMonster(iTemp).Die = False Then Exit Function
                    End If
                    */
						/*	
                    // This rock should fall to the left
                    bFalling = true;
                    this.Move( Vector3.left + Vector3.back );
                    
				}
			}
		}
	}
	*/


/*
        
	    If blnFalling = False Then      ' Still not falling
	        
	        ' Fall to the right?
	        
	        ' Is rock-below rock still falling? If so, don't do anything until that rock is out of the way
	        If rrPieces(intCurX + 1, intCurY + 1).intRockOrEggID <> -1 Then
	            If rrRocksOrEggs(rrPieces(intCurX + 1, intCurY + 1).intRockOrEggID).blnFalling = True Then
	                Exit Function
	            End If
	        End If
	
	        
	        
	        ' Is the support currently under rock slanted to the right? (Note: this should only be checked if there is no
	        '  fall to the left, as in this function)
	        sTemp = rrMap.GetData(intCurX, intCurY + 1)
	        If sTemp = "d" Or sTemp = "9" Or sTemp = "r" Or sTemp = "k" Or sTemp = "g" Or sTemp = "t" Or sTemp = "b" Or sTemp = "(" Then
	            
	            sTemp = rrMap.GetData(intCurX + 1, intCurY)     ' Check if room exists to the left (And Repton isn't there)
	            If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX + 1 And rrRepton.GetYPos = intCurY) Then
	                
	                sTemp = rrMap.GetData(intCurX + 1, intCurY + 1)   ' Check if room exists to 1 left, 1 down (And Repton isn't there)
	                If (sTemp = "0" Or sTemp = "m") And Not (rrRepton.GetXPos = intCurX + 1 And rrRepton.GetYPos = intCurY + 1) Then
	                
	                    iTemp = rrPieces(intCurX + 1, intCurY + 1).intMonsterID
	                    If iTemp <> -1 Then
	                        If rrMonster(iTemp).Die = False Then Exit Function
	                    End If
	                    
	                    ' This rock should fall to the left
	                    blnFalling = True
	                    Me.Move Right
	                    Me.Move Down
	                End If
	            End If
	        End If
	        
	    End If
	    
	  
	    
	    ' If rock is in free falling (ie, it has been falling before it was detected that it should fall
	    '  again (directly afterward), then add count (so that it can be detected if it hit repton, or if this is
	    '  an egg, if it should crack).
	    If blnFalling = True And bWasFalling = True Then
	        blnFreeFall = True
	    Else
	        blnFreeFall = False
	    End If
	
	    ' Should falling sound stop?
	    If blnFalling = False And bWasFalling = True Then
	        If bPlayingSnd Then rrGame.PlayRockRumbleSound False
	        bPlayingSnd = False
	        
	        If intPieceType = Rock Then ExSnds(5).PlaySound (False) Else ExSnds(8).PlaySound (False)
	    End If
	    
	End Function


*/
	}
}