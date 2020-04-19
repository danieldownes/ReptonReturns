using UnityEngine;
using System.Collections.Generic;

public class rr2player : rr2moveable2
{
	public enum enmPlayerState
	{
	    Stoped = 0,
	    Walk = 1,
	    Push = 2,
	    PushNoWalk = 3,
	    DigAndWalk = 4,
	    Board = 5
	};
	
    public Vector3 vStartPos;
	
	public enmPlayerState iPlayerState;

    public bool bCanMove = true;

    private bool updatedMove = true;

    private int iDontReplace = 0;  // If set, wont replace old map piece with a space (eg monster, fungus, etc..)
	
	public int iLives;
	
    public string sName;

    public List<string> lInventory = new List<string>();

    public string[] playerVars;
	
	// Use this for initialization
	void Start () 
	{
		iLives = 3;
		iPlayerState = 0; //enmPlayerState.Stopped;
		fTime = 0.0f;
		fTimeToMove = 0.3f;
		vLastDirection = Vector3.back;
		vDirection = Vector3.forward;
	}
	
	void Update()
	{
		
		if( fTime > 0.01f)
		{
			fTime -= Time.deltaTime;

			// Update movmement of Player on map
            if( !updatedMove && fTime <= fTimeToMove * 0.3 )
            {
				CheckPickup();
                if( iDontReplace != 2)
                    rr2gameObject.loadedLevel.SetMapP(vPosition, (char)rr2level.enmPiece.Repton);
                if( iDontReplace != 1 )
                    rr2gameObject.loadedLevel.SetMapP(vLastPosition, (char)rr2level.enmPiece.Space);
                else
                    iDontReplace = 0;
                iDontReplace--;

                updatedMove = true;
            }
		}else
		{
			fTime = 0.0f;

            iPlayerState = enmPlayerState.Stoped;
			
			// Check for new movement, if allowed
            if( bCanMove)
            {
                if (Input.GetAxis("Horizontal") < 0)
                    Move(Vector3.left);

                else if (Input.GetAxis("Horizontal") > 0)
                    Move(Vector3.right);

                else if (Input.GetAxis("Vertical") > 0)
                    Move(Vector3.forward);

                else if (Input.GetAxis("Vertical") < 0)
                    Move(Vector3.back);
            }
		}
		
        Move3D();
	}
	
	public void MoveToPos(Vector3 vNewPos)
	{
		if( iDontReplace != 1 )
        	rr2gameObject.loadedLevel.SetMapP(vLastPosition, (char)rr2level.enmPiece.Space);
		rr2gameObject.loadedLevel.SetMapP(vNewPos, (char)rr2level.enmPiece.Repton);
		
		vLastPosition = vPosition = vNewPos;
		
		//rr2gameObject.guiObject.OnGUI ();
	}

    public void Move(Vector3 vDirectionToMove)
    {
        if (iPlayerState == enmPlayerState.Stoped || iPlayerState == enmPlayerState.PushNoWalk)
        {
            if (MoveableTo(vPosition + vDirectionToMove, vDirectionToMove))
            {
                fTime = fTimeToMove;
                vLastPosition = vPosition;
                //iPlayerState = enmPlayerState.Walk;

                //Debug.Log("Move" + vPosition.x.ToString() + "," + vPosition.z.ToString());

                vLastDirection = vDirection;
                vDirection = vDirectionToMove;

                // Add the movement
                vPosition += vDirectionToMove;

                updatedMove = false;


                //rr2gameObject.guiObject.sInventory = vDirectionToMove.x.ToString();
                //Debug.Log("sInventory=" + vDirectionToMove.x.ToString());


                iPlayerState = enmPlayerState.Walk;
            }
            else
            {
                //iPlayerState = enmPlayerState.PushNoWalk;
            }
        }
    }

    	
	public void Move3D()
	{
			
		// This is needed to force player to turn towards camera when going left>right & right>left
		Vector3 vLeft = new Vector3(-0.99f, 0f, -0.01f);
		Vector3 vRight = new Vector3(0.99f, 0f, -0.01f);
		
		Quaternion vRotTo = Quaternion.LookRotation(Vector3.forward);
		Quaternion vRotFrom = Quaternion.LookRotation(Vector3.back);
		
		// Interpolate //
		transform.position = Vector3.Lerp(AddSlant(vLastPosition), AddSlant(vPosition), (fTimeToMove - fTime) / fTimeToMove);
		
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
	}
	

	
	public bool MoveableTo( Vector3 vPos, Vector3 vDir)
	{
		bool bMoveableTo = true;
        bool bUpdateMap = true;
		rr2level.MapPiece2d cPiece = rr2gameObject.loadedLevel.RrMapDetail[(int) vPos.x, (int) -vPos.z];
		
		// Static pieces...
		switch( (rr2level.enmPiece)cPiece.TypeID )
		{
            
            case rr2level.enmPiece.Door:
                // Has the key to this door?
                if( lInventory.Contains("Coloured Key:" + rr2gameObject.loadedLevel.colourKey[cPiece.iRef].ToString()) )
                {
                    //lInventory.Add("DOOR:" + cPiece.iRef.ToString());
                }else
                    bMoveableTo = false;

                break;

            case rr2level.enmPiece.Bomb:
				
				// Only if objectives are completed
				//if( If rrRepton.intDimondsCollected <> rrMap.intTotDimonds _
               //Or rrMap.intTotCrowns <> 0 Or rrMap.intTotEggs <> 0 Or rrMap.intTotMonstersAlive <> 0 Then
				bMoveableTo = false;
				break;

            case rr2level.enmPiece.Monster:
            case rr2level.enmPiece.Skull:
            case rr2level.enmPiece.Fungus:
                iDontReplace = 2;
                break;

            
            case rr2level.enmPiece.Wall:
            case rr2level.enmPiece.Wall1:
            case rr2level.enmPiece.Wall2:
            case rr2level.enmPiece.Wall3:
            case rr2level.enmPiece.Wall4:
            case rr2level.enmPiece.Wall6:
			case rr2level.enmPiece.Wall7:
			case rr2level.enmPiece.Wall8:
			case rr2level.enmPiece.Wall9:
			case rr2level.enmPiece.FilledWall:
			case rr2level.enmPiece.FilledWall1:
			case rr2level.enmPiece.FilledWall3:
			case rr2level.enmPiece.FilledWall7:
			case rr2level.enmPiece.FilledWall9:	
			case rr2level.enmPiece.Barrier:
            case rr2level.enmPiece.Cage:
			case rr2level.enmPiece.Safe:
				bMoveableTo = false;
				break;
			
		}
		
		
		
		// Movable pieces...
		if( cPiece.TypeID == (char)rr2level.enmPiece.Rock || cPiece.TypeID == (char)rr2level.enmPiece.Egg )
		{
			
			// If egg is cracking,
			//if( (char)cPiece.TypeID == (char)rr2level.enmPiece.Egg && )
			//If rrPieces(intX, intY).intRockOrEggID = -1 Then
			//bMoveableTo = false;
			
			bMoveableTo = false;
			
			if( vDir == Vector3.left || vDir == Vector3.right )
			{
                rr2level.MapPiece2d cPieceTo = rr2gameObject.loadedLevel.RrMapDetail[(int)(vPos.x + vDir.x), (int)-vPos.z];
								
				bMoveableTo = false;

                if (cPieceTo.TypeID == (char)rr2level.enmPiece.Space || cPieceTo.TypeID == (char)rr2level.enmPiece.Monster)
				{
					rr2moveable oScript = rr2gameObject.loadedLevel.lObjects3[cPiece.id].GetComponent("rr2moveable") as rr2moveable;
                    if (oScript)
                    {
                        bMoveableTo = oScript.Move(vDir);
                    }
				}
			}
		}
        else if (bUpdateMap && bMoveableTo)
        {
            // Remove the graphic
            //try
            //{
			//	int pId = rr2gameObject.loadedLevel.RrMapDetail[(int)vPos.x, (int)-vPos.z].id;
		//		if( pId != -1)
          //      	Destroy(rr2gameObject.loadedLevel.lObjects3[pId]);
            //} catch {}
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
	public void CheckPickup()
	{
        bool bUpdateMap = true;
				
		rr2level.MapPiece2d cPiece = rr2gameObject.loadedLevel.RrMapDetail[(int) vPosition.x, (int) -vPosition.z];
		
		Debug.Log("moving to:" + (rr2level.enmPiece)cPiece.TypeID);
		
		// Static pieces...
		switch( (rr2level.enmPiece)cPiece.TypeID )
		{
            case rr2level.enmPiece.Dimond:
                this.GetComponent<AudioSource>().Play();
                break;

			case rr2level.enmPiece.Key:
				rr2gameObject.loadedLevel.OpenSafes();
			 	break;

            case rr2level.enmPiece.ColourKey:
                lInventory.Add("Coloured Key:" + cPiece.iRef.ToString());
                break;

            case rr2level.enmPiece.Bomb:
				
				// Already cheked if objectives are completed in MoveableTo
				
				break;

            case rr2level.enmPiece.Monster:
				//If rrMonster(rrPieces(intX, intY).intMonsterID).blnEarth Then MoveableTo = False
                bUpdateMap = false;
                iDontReplace = 2;
				break;

            case rr2level.enmPiece.Skull:
			case rr2level.enmPiece.Fungus:
                bUpdateMap = false;
                Die();

                break;
			
			case rr2level.enmPiece.Transporter:
            	rr2gameObject.loadedLevel.RrMapDetail[(int)vLastPosition.x, (int)-vLastPosition.z].TypeID = (char)rr2level.enmPiece.Space;
				vLastPosition = vPosition;
                vPosition = vStartPos = rr2gameObject.loadedLevel.tTransporter[cPiece.iRef];
				vDirection = Vector3.back;
			
				cPiece.iRef = 0;
					
                // Set to update position of player
				fTime = 0.2f;
					   
                
                // Start pause
                //rrGame.Pause 2.5
                
                // Start FX

				break; 
		}
		
		if (bUpdateMap)
        {
            // Remove the graphic
            rr2gameObject.loadedLevel.RemovePiece(vPosition);
        }

		return;
	}
	
	
	public int Die()
	{
		iLives--;
		
		// Reset to starting position]
        rr2gameObject.loadedLevel.SetMapP(vPosition, '0');
		MoveToPos(vStartPos);
        vDirection = Vector3.back;

        
		
		// Reset bomb?
		
		return iLives;
	}
	/*
	
Function Die(Optional bPlaySound As Boolean = True) As Integer
'Returns number of remening lifes

    Dim sTemp As String
    
    
    If bPlaySound Then ExSnds(19).PlaySound False
        
        
      
    Die = intPlayerLives
        
    ' Write to file
    Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat" For Input As #1
        Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp" For Output As #2
            ' Number of times player selected
            Input #1, sTemp
            Print #2, sTemp
            ' Number of lives remaining
            Input #1, sTemp
            sTemp = Trim(Str(Val(sTemp) - 1))
            Print #2, sTemp
        Close #2
    Close #1
    MoveFile App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp", App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat"

    If intPlayerLives < 0 Then
        rrGame.iLevelCompeted = -2
        Exit Function
    End If
      
    If rrMap.GetData(intCurX, intCurY) <> "u" Then
        rrMap.SetData intCurX, intCurY, Space
        rrPieces(intCurX, intCurY).TypeID = "0"
    End If
    
    If rrMap.GetData(intOldX, intOldY) = "i" Then
        rrMap.SetData intOldX, intOldY, Space
        rrPieces(intOldX, intOldY).TypeID = "0"
    End If
       
    ' Reset to starting position
    intCurX = intOrgX
    intCurY = intOrgY
    int3DDirection = Down
    Move3D
    Me.SetPosition intCurX, intCurY
    
    ' Reset TimeBomb
    rrMap.TimeBombControl 3
    
    ' Start pause
    rrGame.Pause 2.5
    
    ' Start FX
    
    
End Function
	*/
	
}
