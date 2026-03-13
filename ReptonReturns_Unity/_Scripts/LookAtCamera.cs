using UnityEngine;
using System.Collections;
 
public class LookAtCamera : MonoBehaviour
{
	public Camera cameraToLookAt;
 
	void Update() 
	{ 
		transform.LookAt(cameraToLookAt.transform); 
	}
}