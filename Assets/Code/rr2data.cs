using UnityEngine;
using System.IO;
using System.Collections;
using System.Collections.Generic;

using System;
using System.Xml;
//using System.Data;


public class rr2data : MonoBehaviour
{
    public rr2game rr2gameObject;


    public class tsSection
    {
        public int id;
        public int moduleId;
        public string title;
        public string section;
        public int sortorder;
    }

    public class tsQuestion
    {
        public int id;
        public int sectionId;
        public string title;
        public string type;
        public string hint;
        public int sortorder;
    }

    public class tsChoice
    {
        public int id;
        public int questionId;
        public string title;
        public string type;
        public string answer;
        public int sortorder;
    }

    public List<tsSection> lSections = new List<tsSection>();
    public List<tsQuestion> lQuestions = new List<tsQuestion>();
    public List<tsChoice> lChoices = new List<tsChoice>();

    /*
    var list1 = new List<int>();       // <- var keyword used
    List<int> list2 = new List<int>(); // <- Is equivalent to
    */


    void Start() //IEnumerator
    {
        Debug.Log("readPlayerData");
        StartCoroutine( readPlayerData("http://symbiosoft/kyle/sqlconnector/load-account.php") );
        StartCoroutine( readXml("http://symbiosoft/kyle/sqlconnector/questions-xml.php") ) ;
    }

    private IEnumerator readPlayerData(string dataUrl)
    {

        // Create a form object for sending data to the server
        var form = new WWWForm();
        // Assuming the script manages for different games
        form.AddField("game", "MyGameName");
        // The name of the player submitting the scores
        form.AddField("id", 2);

        // Create a download object
        WWW downloadW = new WWW(dataUrl, form);

        // Wait until the download is done
        yield return downloadW;


        if (downloadW.error != null)
        {
            Debug.Log("Error downloading: " + downloadW.error);
        }
        else
        {
            // show the highscores
            //Debug.Log("XML DATA: " + downloadW.text);

            rr2gameObject.playerObject.playerVars = downloadW.text.Split('&');
        }
    }

    private void readQuestions(int section_id)
    {

    }


    public IEnumerator readXml(string dataUrl)
    {
        var form = new WWWForm();
        form.AddField("section_id", 1);

        // Create a download object
        WWW downloadW = new WWW(dataUrl, form);

        // Wait until the download is done
        yield return downloadW;

        if (downloadW.error != null)
        {
            Debug.Log("Error downloading: " + downloadW.error);
        }
        else
        {
            // show the highscores
            Debug.Log("XML DATA: " + downloadW.text);

            StringReader myReader = new StringReader(downloadW.text);

            int sectionId = 0;
            int questionId = 0;
            //lSections.Add(new tsSection());
            string sTemp;


            tsQuestion newQuestion = new tsQuestion();

            // Create an XML reader for this file.
			XmlReader reader;
            using( reader = XmlReader.Create(myReader))
            {
                while (reader.Read())
                {
                    // Only detect start elements.
                    if (reader.IsStartElement())
                    {
                        // Get element name and switch on it.
                        switch (reader.Name)
                        {
                            case "section":

                                tsSection newSection = new tsSection();
                                sTemp = reader["section_id"];
                                
                                if (sTemp != null)
                                {
                                    newSection.id = sectionId = Convert.ToInt32(sTemp);

                                    lSections.Add(newSection);
                                }
                                

                                // Detect this element.
                                //Debug.Log("<section> element." + sTemp);

                                break;

                            case "question":
                                
                                newQuestion = null;
                                newQuestion = new tsQuestion();

                                sTemp = reader["question_id"];


                                if (sTemp != null)
                                {
                                    newQuestion.id = questionId = Convert.ToInt32(sTemp);
                                    newQuestion.sectionId = sectionId;
                                    newQuestion.type = reader["type"];
                                    
                                }

                                Debug.Log("<question>." + questionId);
                                
                                break;


                            case "title":

                                // Detect this element.
                                Debug.Log("Start <title> element.");
                                reader.Read();
                                newQuestion.title = reader.Value.Trim();

                                break;
                                

                            case "choice":

                                // Detect this article element.
                                Debug.Log("Start <choice> element.");

                                tsChoice newChoice = new tsChoice();


                                // Search for the attribute  on this current node.
                                sTemp = reader["choice_id"];
                                if (sTemp != null)
                                {
                                    Debug.Log("  Has attribute choice_id: " + sTemp);

                                    newChoice.id = Convert.ToInt32(sTemp);
                                    newChoice.questionId = questionId;
                                    newChoice.type = reader["type"];
                                    newChoice.answer = reader["answer"];
                                }

                                // Next read will contain text.
                                if( reader.Read())
                                {
                                    newChoice.title = reader.Value.Trim();
                                    Debug.Log("  Text node: " + newChoice.title);
                                    lChoices.Add(newChoice);


                                }

                                break;


                            case "hint":

                                // Detect this element.
                                Debug.Log("Start <hint> element.");
                                reader.Read();
                                newQuestion.hint = reader.Value.Trim();

                                lQuestions.Add(newQuestion);

                                //Debug.Log("lQuestions Index: " + lQuestions.FindIndex(item => item.id == questionId));

                                break;
                        }
                    }
                }
            }
        }
    }

    /*
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
     * */


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
