using UnityEngine;
using System.Collections;

public class rr2gui : MonoBehaviour 
{
	
	public string sInventory;
	
	/* Declare a GUI Style */
	public GUIStyle customGuiStyle;

	// Use this for initialization
	void Start () 
	{
		
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
	
	
	public void OnGUI () 
	{
		// Make a button. We pass in the GUIStyle defined above as the style to use
		GUI.Button (new Rect (70,30,150,20), "I am a Custom Button", customGuiStyle);
		
		// Make a background box
		GUI.Box(new Rect (10,10,100,90), "Loader Menu");
		
		
		// Make the first button. If it is pressed, Application.Loadlevel (1) will be executed
		if (GUI.Button (new Rect (20,40,80,20), "Level 1"))
		{
			Debug.Log("button1");
			//Application.LoadLevel (1);
			sInventory = "b1";
		}

		// Make the second button.
		if (GUI.Button (new Rect (20,70,80,20), "Level 2")) 
		{
			Debug.Log("button2");
			//Application.LoadLevel (2);
			sInventory = "b2";
		}
		
		GUI.Label (new Rect (250, 25, 100, 30), "Intentory" + sInventory);
	}
}
