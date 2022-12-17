using UnityEngine;

public class Monster : Movable
{
    public Game rr2gameObject;

    public enum State
    {
        InEgg = 0,
        EggCracking,
        Waking,
        Seeking,
        Dead
    };

    public State iState;

    public char cOnPiece; // Monsters can go through Earth + Space, this tracks what the monster may be on
    public char cLastOnPiece;
    public int iOnId;
    public int iLastOnId;

    bool bEarth = false;


    public void Init(Vector3 vPos)
    {
        PieceType = Level.Piece.Monster;

        timeToMove = 0.45f;

        cOnPiece = '0';
        iOnId = -1;

        //intMyID = rrMap.intTotMonsters

        iState = State.Waking;
        LastTime = 1.0f;


        Position = LastPosition = vPos;
        Direction = LastDirection = Vector3.back;
        //rr2gameObject.loadedLevel.ReplacePiece(vPos, (char)pPieceType);
    }

    private new void  Update()
    {
        if (LastTime > 0.0f)
            LastTime -= UnityEngine.Time.deltaTime;


        if (iState == State.Waking)
        {
            if (LastTime <= 0.0f)
                iState = State.Seeking;
        }
        else
        {
            ControlSeek();
        }

        Move3D();
    }


    public override bool Move(Vector3 directin)
    {
        base.Move(directin);

        //cOnPiece = rr2gameObject.loadedLevel.GetMapP(vPosition);
        iOnId = rr2gameObject.loadedLevel.GetMapPId(Position);

        // Does Repton die in result of this move?
        if (rr2gameObject.loadedLevel.GetMapP(Position) == 'i'
         || rr2gameObject.loadedLevel.GetMapP(LastPosition) == 'i')
        {
            rr2gameObject.playerObject.Die();
            //cOnPiece = '0';
        }

        return true;
    }

    public void Move3D()
    {

        // This is needed to force player to turn towards camera when going left>right & right>left
        Vector3 left = new Vector3(-0.99f, 0f, -0.01f);
        Vector3 right = new Vector3(0.99f, 0f, -0.01f);

        Quaternion to = Quaternion.LookRotation(Vector3.forward);
        Quaternion from = Quaternion.LookRotation(Vector3.back);

        // Interpolate
        transform.position = Vector3.Lerp(rr2gameObject.loadedLevel.AddSlant(LastPosition), rr2gameObject.loadedLevel.AddSlant(Position), (timeToMove - LastTime) / timeToMove);

        /*
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
			//transform.rotation = Quaternion.identity;
			//transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (fTimeToMove - fTime) / fTimeToMove);
			
		}
         */
    }

    void ControlSeek()
    {
        char cT;
        //bool bMove;

        // Control spawn timing sequences ...
        if (iState == State.EggCracking)
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
        else if (iState == State.Waking)
        {
            // Has Monster has fully awakened
            //if( fTime < 0f) 

            //timMonsterSpawnCont.LocalTime > 3 / rrGame.sngGameSpeed Then

            iState = Monster.State.Seeking;
        }
        else if (iState == State.Seeking)
        {
            // Ready to move (again)?
            if (LastTime <= 0.0f)
            {
                LastDirection = Direction;

                // Simply move towards Repton ...
                Vector3 vToReptonV = (rr2gameObject.playerObject.Position - Position); //.Normalize;
                Vector3 vToRepton = Vector3.zero;

                // Check possible movement for all axis directions .. randomly so that no axis has a preference
                if (Random.Range(0, 2) == 0)
                {
                    if (vToReptonV.x != 0f)
                    {
                        if (vToReptonV.x > 0)
                            vToRepton = Vector3.right;
                        else
                            vToRepton = Vector3.left;
                    }
                }
                else
                {
                    if (vToReptonV.z != 0f)
                    {
                        if (vToReptonV.z > 0)
                            vToRepton = Vector3.forward;
                        else
                            vToRepton = Vector3.back;
                    }
                }

                // Check if it is okay to move in this direction ...
                cT = rr2gameObject.loadedLevel.GetMapP(Position + vToRepton);
                if (cT == '0' || cT == 'i' || cT == 'e')
                    Move(vToRepton);
            }
        }
    }

    public bool Die()
    {
        Debug.Log("Die");
        if (!bEarth)
        {
            DieForced();
            return true;
        }
        else
            return false;
    }

    void DieForced()
    {
        //Debug.Log("DieForced:" + iId);
        //Destroy(rr2gameObject.loadedLevel.lMonsters[iId]);
        //lMonsters.Remove(i);
        //Destroy(rr2gameObject.loadedLevel.lMonsters[iId]);
        //rr2gameObject.loadedLevel.lMonsters.Remove(iId);
        rr2gameObject.loadedLevel.iMonstersAlive--;
        rr2gameObject.loadedLevel.SetMapP(Position, '0');
    }
}