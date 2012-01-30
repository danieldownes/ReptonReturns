using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class rr2gui : MonoBehaviour 
{
    public rr2game rr2gameObject;

	
	/* Declare a GUI Style */
	public GUIStyle customGuiStyle;

    private int iShowQuestion = 0;
    private string sQuestionText = "Sample Question ... ?";

    private List<rr2data.tsChoice> lChoices = new List<rr2data.tsChoice>();

    private float fMsgTime = 0.0f;

    string sAnswer;


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
			
		}

		// Make the second button.
		if (GUI.Button (new Rect (20,70,80,20), "Level 2")) 
		{
			Debug.Log("button2");
			//Application.LoadLevel (2);
			
		}


        // Player Vars/Info
        GUI.Box(new Rect(110, 200, 100, 300), "Player:");
        string sVars = "";
        foreach( string sVar in rr2gameObject.playerObject.playerVars)
            sVars += System.Environment.NewLine + sVar;
        GUI.Label(new Rect(110, 200, 100, 300), sVars);


        // Intentory
        GUI.Box(new Rect(10, 200, 100, 300), "Intentory");
        string sInventory = "";
        foreach(string sItem in rr2gameObject.playerObject.lInventory)
            sInventory += System.Environment.NewLine + sItem;
        GUI.Label(new Rect(10, 200, 100, 300), sInventory);



        /*
         * 
         * GUI.Box (Rect (Screen.width - 100,0,100,50), "Top-right");
	        GUI.Box (Rect (0,Screen.height - 50,100,50), "Bottom-left");
	        GUI.Box (Rect (Screen.width - 100,Screen.height - 50,100,50), "Bottom-right");
         */
	}

}
