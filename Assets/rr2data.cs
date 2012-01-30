using UnityEngine;
using System.IO;
using System.Collections;
using System.Collections.Generic;


using System.Xml;
using System.Data;


public class rr2data : MonoBehaviour
{
    public rr2game rr2gameObject;

    IEnumerator Start() //IEnumerator
    {
        

        //StartCoroutine( getDataTest);

        string dataUrl = "http://symbiosoft/kyle/sqlconnector/load-account.php";
        string playName = "Player 1";
        int score = -1;

        // Create a form object for sending high score data to the server
        var form = new WWWForm();
        // Assuming the perl script manages high scores for different games
        form.AddField("game", "MyGameName");
        // The name of the player submitting the scores
        form.AddField("id", 2);
        // The score
        form.AddField("score", score);

        // Create a download object
        WWW downloadW = new WWW(dataUrl, form);

        // Wait until the download is done
        yield return downloadW;


        if (downloadW.error != null)
        {
            print("Error downloading: " + downloadW.error);
            //            return false;
        }
        else
        {
            // show the highscores
            Debug.Log(downloadW.text);

            rr2gameObject.playerObject.playerVars = downloadW.text.Split('&');

            //DataSet xmlDs = new DataSet();
            //xmlDs = GetDatasetFromXMLString(downloadW.text);

        }


    }

    public static DataSet GetDatasetFromXMLString(string inString)
    {
        StringReader StringReader;
        XmlReader XmlReader = null;

        try
        {
            //Console.WriteLine("Initializing StringReader ...");

            //if (inString.IndexOf("<?xml version='1.0'?>") == -1)
            //{
            //    inString = "<?xml version='1.0'?>" + inString;
            //}

            StringReader = new StringReader(inString);

            //Create XmlReader and load reader from StringReader
            XmlReader = XmlReader.Create(StringReader);

            ////Output reader to console
            //using (XmlWriter XmlWriter = XmlWriter.Create(Console.Out))
            //{
            //    XmlWriter.WriteNode(XmlReader, true);
            //}



            DataSet ds = new DataSet();
            ds.ReadXml(XmlReader);

            Debug.Log("Count:" + ds.Tables.Count);

            return ds;
        }
        finally
        {
            //Console.WriteLine("Processing of StringReader complete.");
        }
    }


	// Update is called once per frame
	void Update () {
	
	}



    /*
    IEnumerator getDataTest()
    {
		
        string dataUrl = "http://symbiosoft/game/test.php";
        string playName = "Player 1";
        int score = -1;

        // Create a form object for sending high score data to the server
        var form = new WWWForm();
        // Assuming the perl script manages high scores for different games
        form.AddField( "game", "MyGameName" );
         // The name of the player submitting the scores
        form.AddField( "playerName", playName );
         // The score
        form.AddField( "score", score );

        // Create a download object
        WWW downloadW = new WWW( dataUrl, form );

        // Wait until the download is done
        //yield return true; //downloadW
		
		
        if(downloadW.error == null) {
            print( "Error downloading: " + downloadW.error );
            return false;
        } else {
            // show the highscores
            Debug.Log(downloadW.text);
        }
		
        return true;
    }
    */
	

}
