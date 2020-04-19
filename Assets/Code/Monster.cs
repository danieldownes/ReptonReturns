using UnityEngine;

public class Monster : Moveable2
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
        pPieceType = Level.Piece.Monster;

        fTimeToMove = 0.45f;

        cOnPiece = '0';
        iOnId = -1;

        //intMyID = rrMap.intTotMonsters

        iState = State.Waking;
        fTime = 1.0f;


        vPosition = vLastPosition = vPos;
        vDirection = vLastDirection = Vector3.back;
        //rr2gameObject.loadedLevel.ReplacePiece(vPos, (char)pPieceType);
    }

    // Update is called once per frame
    void Update()
    {
        if (fTime > 0.0f)
            fTime -= Time.deltaTime;


        if (iState == State.Waking)
        {
            if (fTime <= 0.0f)
                iState = State.Seeking;
        }
        else
        {
            ControlSeek();
        }

        Move3D();
    }


    void Move(Vector3 vDir)
    {
        // Update local info

        vLastPosition = vPosition;
        vLastDirection = vDirection;

        vPosition += vDir;
        vDirection = vDir;

        cLastOnPiece = cOnPiece;
        iLastOnId = iOnId;

        fTime = fTimeToMove;


        //cOnPiece = rr2gameObject.loadedLevel.GetMapP(vPosition);
        iOnId = rr2gameObject.loadedLevel.GetMapPId(vPosition);

        // Does Repton die in result of this move?
        if (rr2gameObject.loadedLevel.GetMapP(vPosition) == 'i'
         || rr2gameObject.loadedLevel.GetMapP(vLastPosition) == 'i')
        {
            rr2gameObject.playerObject.Die();
            //cOnPiece = '0';
        }

        rr2gameObject.loadedLevel.SetMapP(vLastPosition, cOnPiece, iOnId);
        rr2gameObject.loadedLevel.SetMapP(vPosition, (char)pPieceType, iId);
    }

    public void Move3D()
    {

        // This is needed to force player to turn towards camera when going left>right & right>left
        Vector3 left = new Vector3(-0.99f, 0f, -0.01f);
        Vector3 right = new Vector3(0.99f, 0f, -0.01f);

        Quaternion to = Quaternion.LookRotation(Vector3.forward);
        Quaternion from = Quaternion.LookRotation(Vector3.back);

        // Interpolate
        transform.position = Vector3.Lerp(rr2gameObject.loadedLevel.AddSlant(vLastPosition), rr2gameObject.loadedLevel.AddSlant(vPosition), (fTimeToMove - fTime) / fTimeToMove);

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
            if (fTime <= 0.0f)
            {
                vLastDirection = vDirection;

                // Simply move towards Repton ...
                Vector3 vToReptonV = (rr2gameObject.playerObject.vPosition - vPosition); //.Normalize;
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
                cT = rr2gameObject.loadedLevel.GetMapP(vPosition + vToRepton);
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
        Debug.Log("DieForced:" + iId);
        Destroy(rr2gameObject.loadedLevel.lMonsters[iId]);
        //lMonsters.Remove(i);
        //Destroy(rr2gameObject.loadedLevel.lMonsters[iId]);
        //rr2gameObject.loadedLevel.lMonsters.Remove(iId);
        rr2gameObject.loadedLevel.iMonstersAlive--;
        rr2gameObject.loadedLevel.SetMapP(vPosition, '0');
    }
}