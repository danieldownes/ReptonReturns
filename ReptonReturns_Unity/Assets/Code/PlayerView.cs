using System;
using UnityEngine;

public class PlayerView : MonoBehaviour
{
    public event Action OnMoveComplete;

    public GameObject ReptonMesh;

    float timeToMove = 0.3f;
    float LastTime = 0.0f;
    Vector3 LastDirection = Vector3.forward;
    Vector3 Direction = Vector3.back;
    private bool InterMove;

    private void Start()
    {
        LastTime = 0.0f;
        LastDirection = Vector3.forward;
        Direction = Vector3.back;
        //Position = transform.position;
    }

    private void Update()
    {
        LastTime -= Time.deltaTime;

        // Inter-mediate move (half way)
        if (LastTime < (timeToMove * 0.4f) && InterMove)
        {
            // Almost finished move (interval-move)? 
            InterMove = false;

            // Probably not continuously moving?
            //if (WantMoveMe < 2)
            //{
            //playStepSound();
            //}

            // Update movement of Player on map
            //updatedMove = true;
        }

        // Still going, or ready for next move?
        if (LastTime < 0.001f)
        {
            LastTime = 0.0f;

            OnMoveComplete?.Invoke();

            // Just finished doing? Then stop undo sound
            /*
            if (wasUndoing)
            {
                camObject.GetComponent<AudioSource>().Stop();
                camObject.GetComponent<AudioSource>().clip = SndPush;
                camObject.GetComponent<AudioSource>().loop = false;
                wasUndoing = false;
            }
            */
        }
    }

    public void StartMove(Vector3 lastDirection, Vector3 newDirection)
    {
        Direction = newDirection;
        LastDirection = lastDirection;
        LastTime = timeToMove;
    }

    public void Move3D(Vector3 position, Vector3 lastPosition)
    {
        // This is needed to force player to turn towards camera when going left>right & right>left
        Vector3 vLeft = new Vector3(-0.99f, 0f, -0.01f);
        Vector3 vRight = new Vector3(0.99f, 0f, -0.01f);

        Quaternion vRotTo = Quaternion.LookRotation(Vector3.forward);
        Quaternion vRotFrom = Quaternion.LookRotation(Vector3.back);

        // Interpolate
        transform.position = Vector3.Lerp(lastPosition, position, (timeToMove - LastTime) / timeToMove);

        if (LastDirection != Direction)
        {
            vRotFrom = Quaternion.LookRotation(LastDirection);
            vRotTo = Quaternion.LookRotation(Direction);

            // Special case to ensure Repton moves in the right direction
            if (LastDirection == Vector3.left)
                vRotFrom = Quaternion.LookRotation(vLeft);

            if (LastDirection == Vector3.right)
                vRotFrom = Quaternion.LookRotation(vRight);


            // Apply the rotation
            ReptonMesh.transform.rotation = Quaternion.identity;
            ReptonMesh.transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (timeToMove - LastTime) / timeToMove);

        }
    }

}
