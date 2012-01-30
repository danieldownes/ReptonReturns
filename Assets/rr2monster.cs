using UnityEngine;
using System.Collections;

public class rr2monster : MonoBehaviour
{
	public rr2game rr2gameObject;
	
	public int iId; // lObjects ref
	
	
	public rr2level.enmPiece pPieceType;
	
	public enum enmState
	{
		InEgg = 0,
		EggCracking,
		Waking,
		Seeking,
		Dead
	};

	public enmState iState;
	
	public Vector3 vPosition;
	public Vector3 vLastPosition;
	public Vector3 vLastPositionAbs;
	
	private Vector3 vDirection;         	// The direction that the visual mesh is facing
	private Vector3 vLastDirection;
	
	private float fTime;
	private float fTimeToMove = 0.45f;
	
	
	//public bool bEarth;
	public char cOnPiece; // Monsters can go through Earth + Space, this tracks what the monster may be on
	public char cLastOnPiece;
	public int iOnId;
	public int iLastOnId;
	
	
	// Use this for initialization
	void Start ()
	{
		pPieceType = rr2level.enmPiece.Monster;
		
    	cOnPiece = '0';
		iOnId = -1;

    	//intMyID = rrMap.intTotMonsters
    
    	iState = enmState.InEgg;
	
	}
	
	// Update is called once per frame
	void Update ()
	{
		//If enmMonsterState = EggIsCracking Or enmMonsterState = MonsterWaking Or enmMonsterState = SeekingRepton Then
		
		Move3D();
	}


	void Move( Vector3 vDir)
	{
		// Update local info
		
		vLastPosition = vPosition;
		vLastDirection = vDirection;
			
		vPosition += vDir;
		vDirection = vDir;
		
		cLastOnPiece = cOnPiece;
		iLastOnId = iOnId;
		
		cOnPiece = rr2gameObject.loadedLevel.GetMapP(vPosition);
		iOnId = rr2gameObject.loadedLevel.GetMapPId(vPosition);
		
		// Does Repton die in result of this move?
		if( rr2gameObject.loadedLevel.GetMapP(vPosition) == 'i' 
		 || rr2gameObject.loadedLevel.GetMapP(vLastPosition) == 'i' )
			rr2gameObject.playerObject.Die();
			
		
		rr2gameObject.loadedLevel.SetMapP(vLastPosition, cOnPiece, iOnId);
		rr2gameObject.loadedLevel.SetMapP(vPosition, (char)pPieceType, iId);
		
	}
	
	public void Move3D()
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
			//GameObject reptonObject = GameObject.Find("ReptonMesh");
			transform.rotation = Quaternion.identity;
			transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (fTimeToMove - fTime) / fTimeToMove);
			
		}
	}
	
	void ControlMove()
	{
		char cT;
		bool bMove;
		
		// Control spawn timing sequences ...
		if( iState == enmState.EggCracking)
		{
			/*
			 ' Egg has fully cracked
            intPieceType = Monster
            rrPieces(intCurX, intCurY).intMonsterID = intMyID
            
            rrMap.SetData intCurX, intCurY, Monster
            enmMonsterState = MonsterWaking
            timMonsterSpawnCont.ReSet
            */
		}
		else if( iState == enmState.Waking)
		{
			// Has Monster has fully awakened
			//if( fTime < 0f) 
			
			//timMonsterSpawnCont.LocalTime > 3 / rrGame.sngGameSpeed Then
            
            iState = rr2monster.enmState.Seeking;
		}
		else if( iState == enmState.Seeking)
		{
			// Ready to move (again)?
			if( fTime < 0f) 
			{
				 vLastDirection = vDirection;
				
				// Simply move towards Repton ...
				Vector3 vToRepton = (vPosition - rr2gameObject.playerObject.vPosition); //.Normalize;
				
				// Check possible movement for all axis directions .. randomly so that no axis has a preference
				if( Random.Range(0, 2) == 0)
				{
					if( vToRepton.x != 0f )
					{
						if( vToRepton.x > 0)
							vToRepton = Vector3.right;
						else
							vToRepton = Vector3.left;
					}
				}else
				{
					if( vToRepton.z != 0f )
					{
						if( vToRepton.z > 0)
							vToRepton = Vector3.forward;
						else
							vToRepton = Vector3.back;
					}
				}
				
				// Check if it is okay to move in this direction ...
				cT = rr2gameObject.loadedLevel.GetMapP(vPosition + vToRepton);
				if( cT == '0' || cT == 'i' || cT == 'e')
					Move(vToRepton);
			}
		}
	}
	
	void Spawn(Vector3 vPos)
	{
		vPosition = vLastPosition = vPos;
		vDirection = vLastDirection = Vector3.back;
		rr2gameObject.loadedLevel.ReplacePiece(vPos, pPieceType);
	}
}



/*
Function Spawn(intX As Integer, intY As Integer)
    
    'intPieceType = Egg
    
    rrMap.SetData intX, intY, intPieceType
    rrPieces(intX, intY).intMonsterID = intMyID
    
    rrMap.intTotMonstersAlive = rrMap.intTotMonstersAlive + 1
    
    enmMonsterState = EggIsCracking
    
       
    timMonsterSpawnCont.ReSet
    
End Function

Function Die() As Boolean
    If (enmMonsterState = SeekingRepton Or enmMonsterState = MonsterWaking) And blnEarth = False Then
        DieForced
        Die = True
        
        ExSnds(18).PlaySound False
    Else
        Die = False
    End If
End Function

Function DieForced()
    enmMonsterState = Dead
    rrMap.intTotMonstersAlive = rrMap.intTotMonstersAlive - 1
End Function


*/