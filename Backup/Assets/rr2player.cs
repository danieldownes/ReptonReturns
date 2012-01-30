using UnityEngine;


public class rr2player : MonoBehaviour 
{
	
	public rr2game rr2gameObject;
	
	
	public enum enmPlayerState
	{
	    Stoped = 0,
	    Walk = 1,
	    Push = 2,
	    PushNoWalk = 3,
	    DigAndWalk = 4,
	    Board = 5
	};
	
	
	public enmPlayerState iPlayerState;
	
	private Vector3 vDirection;         	// The direction that the visual mesh is facing
	private Vector3 vLastDirection;
	
	private float fTime;
	private float fTimeToMove = 0.3f;
	
	public Vector3 vPosition;
	public Vector3 vLastPosition;
	
	
	// Use this for initialization
	void Start () 
	{
		iPlayerState = 0; //enmPlayerState.Stopped;
		fTime = 0.0f;
		vLastDirection = Vector3.back;
		vDirection = Vector3.forward;
	}
	
	void Update()
	{
		
		if( fTime > 0.01f)
		{
			fTime -= Time.deltaTime;
			// Update movmement of Repton
			
		}else
		{
			fTime = 0.0f;
			
			// Check for new movement			
			if( Input.GetAxis("Horizontal") < 0 )
				Move( Vector3.left);
			
			else if( Input.GetAxis("Horizontal") > 0 )
				Move( Vector3.right);
			
			else if( Input.GetAxis("Vertical") > 0 )
				Move( Vector3.forward);
			
			else if( Input.GetAxis("Vertical") < 0 )
				Move( Vector3.back);			
		}
		
		Move3D();
	}
	
	public void MoveToPos(Vector3 vNewPos)
	{
		vLastPosition = vPosition = vNewPos;
		
		
		//rr2gameObject.guiObject.OnGUI ();
	}
	
	private void Move3D()
	{
			
		// This is needed to force player to turn towards camera when going left>right & right>left
		Vector3 vLeft = new Vector3(-0.99f, 0f, -0.01f);
		Vector3 vRight = new Vector3(0.99f, 0f, -0.01f);
		
		Quaternion vRotTo = Quaternion.LookRotation(Vector3.forward);
		Quaternion vRotFrom = Quaternion.LookRotation(Vector3.back);
		
		// Interpolate
		transform.position = Vector3.Lerp(vLastPosition, vPosition, (fTimeToMove - fTime) / fTimeToMove);
		
		if( vLastDirection != vDirection )
		{
			
			vRotFrom = Quaternion.LookRotation( vLastDirection );
			vRotTo = Quaternion.LookRotation( vDirection );
			
			// Spectial case to ensure repton moves in the right direction
			if( vLastDirection == Vector3.left)
				vRotFrom =Quaternion.LookRotation( vLeft );
			
			if( vLastDirection == Vector3.right)
				vRotFrom = Quaternion.LookRotation( vRight );
			
			// Apply the rotation
			GameObject reptonObject = GameObject.Find("ReptonMesh");
			reptonObject.transform.rotation = Quaternion.identity;
			reptonObject.transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (fTimeToMove - fTime) / fTimeToMove);
			
			
		}
		
		//transform.Find("Repton").Rotate = (0, 1, 0);
	}
	
	public void Move(Vector3 vDirectionToMove)
	{
		if( iPlayerState == enmPlayerState.Stoped || iPlayerState == enmPlayerState.PushNoWalk )
		{
			if( MoveableTo(vPosition + vDirectionToMove, vDirectionToMove) )
			{
				fTime = fTimeToMove;
				vLastPosition = vPosition;
				//iPlayerState = enmPlayerState.Walk;
				
				//Debug.Log("Move" + vPosition.x.ToString() + "," + vPosition.z.ToString());
				
				vLastDirection = vDirection;
				vDirection = vDirectionToMove;
				
				// Add the movement
				vPosition += vDirectionToMove;
				
				
				rr2gameObject.guiObject.sInventory = vDirectionToMove.x.ToString();
				Debug.Log("sInventory=" + vDirectionToMove.x.ToString());
								
			}else
			{
				//iPlayerState = enmPlayerState.PushNoWalk;
			}
		}
	}
	
	
	
	/*
	Function Move(intDirection As enmDirection)

    If enmPlayerState = Stoped Or enmPlayerState = PushNoWalk Or enmPlayerState = Board Then
                
        If MoveableTo(intCurX, intCurY, intDirection) = True Then
        
            
            If rrMap.GetData(intCurX, intCurY) = "e" Then
                If enmPlayerState <> DigAndWalk Then
                    enmPlayerState = DigAndWalk
                    intAniMin = 110
                    intAniMax = 155
                    intAniSpeed = 5.2
                End If
            Else
                If enmPlayerState <> Walk Then
                    enmPlayerState = Walk
                    intAniMin = 56
                    intAniMax = 97
                    intAniSpeed = 4
                End If
            End If
            
        Else
        
            intCurX = intOldX
            intCurY = intOldY
            
            enmPlayerState = PushNoWalk
        
        End If
        
        Move3D          ' Direction and/or position may have changed
        
    End If
        
End Function
*/
	
	public bool MoveableTo( Vector3 vPos, Vector3 vDir)
	{
		bool bMoveableTo = true;
		
		//Vector3 vMPos = vPos * Vector3.(1,1,-1);
		
		rr2game.MapPiece2d cPiece = rr2gameObject.RrMapDetail[(int) vPos.x, (int) -vPos.z];
		
		// Static pieces...
		switch( (rr2game.enmPiece)cPiece.TypeID )
		{
			case rr2game.enmPiece.Bomb:
				
				// Only if objectives are completed
				//if( If rrRepton.intDimondsCollected <> rrMap.intTotDimonds _
               //Or rrMap.intTotCrowns <> 0 Or rrMap.intTotEggs <> 0 Or rrMap.intTotMonstersAlive <> 0 Then
				   bMoveableTo = false;
				break;
			
			case rr2game.enmPiece.Monster:
				//If rrMonster(rrPieces(intX, intY).intMonsterID).blnEarth Then MoveableTo = False
				break;
			
			case rr2game.enmPiece.Cage:
				break;
			
			case rr2game.enmPiece.Wall:
			case rr2game.enmPiece.Wall1:
			case rr2game.enmPiece.Wall2:
			case rr2game.enmPiece.Wall3:
			case rr2game.enmPiece.Wall4:
			case rr2game.enmPiece.Wall6:
			case rr2game.enmPiece.Wall7:
			case rr2game.enmPiece.Wall8:
			case rr2game.enmPiece.Wall9:
			case rr2game.enmPiece.FilledWall:
			case rr2game.enmPiece.FilledWall1:
			case rr2game.enmPiece.FilledWall3:
			case rr2game.enmPiece.FilledWall7:
			case rr2game.enmPiece.FilledWall9:	
			case rr2game.enmPiece.Barrier:
				bMoveableTo = false;
				break;
			
			
			case rr2game.enmPiece.Earth:
				//ExSnds(16).PlaySound False
            	//StartParticleFountian intX, intY, "dig" & Trim(Str(intDirection))
				break;
		}
		
    	//If intTemp >= 3 And intTemp <= 10 Then MoveableTo = False       ' Sides of normal type wall
    	//If intTemp >= 27 And intTemp <= 31 Then MoveableTo = False       ' Stagnights
		
		
		// Movable pieces...
		if( (char)cPiece.TypeID == (char)rr2game.enmPiece.Rock || (char)cPiece.TypeID == (char)rr2game.enmPiece.Egg )
		{
			
			// If egg is cracking,
			//if( (char)cPiece.TypeID == (char)rr2game.enmPiece.Egg && )
			//If rrPieces(intX, intY).intRockOrEggID = -1 Then
			//bMoveableTo = false;
			
			if( vDir == Vector3.forward || vDir == Vector3.back )
			{
				bMoveableTo = false;
			}else
			{				
				rr2game.MapPiece2d cPieceTo = rr2gameObject.RrMapDetail[(int) (vPos.x + vDir.x), (int) -vPos.z];
				
				Debug.Log("rock: " + cPieceTo.TypeID);
				
				if( (rr2game.enmPiece)cPieceTo.TypeID == rr2game.enmPiece.Space )
				{
					rr2moveable oScript = rr2gameObject.lObjects3[cPiece.id].GetComponent("rr2moveable") as rr2moveable;
					if( oScript)
					{
						Debug.Log("dir:" + (int) vDir.x);
        				oScript.Move(vDir);
					}
					//cPiece.go.transform.Translate( vDir);
					//cPiece.go.Move( vDir );
				}					
			}
		}
			
		return bMoveableTo;
	}
		
/*
Private Function MoveableTo(intX As Integer, intY As Integer, intDirection As enmDirection) As Boolean
    
    If intTemp = enmPieceType.Rock Or (intTemp = enmPieceType.Egg) Then        ' Rocks or eggs
        If intDirection = Up Or intDirection = Down Then
            MoveableTo = False
        Else
            If intDirection = Left Then
                If rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Space) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                ElseIf rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                Else
                    MoveableTo = False
                End If
            Else
                If rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Space) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                ElseIf rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                    rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                Else
                    MoveableTo = False
                End If
            End If
        End If
    End If

*/
	
	
}