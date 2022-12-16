using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float Speed = 1.0f;

    void Update()
    {
        transform.RotateAround(Vector3.up, Time.deltaTime * Speed);
    }
}
