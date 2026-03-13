using UnityEngine;
using System.Collections;
using Sfs2X;
using Sfs2X.Core;
using Sfs2X.Entities;
using Sfs2X.Entities.Data;
using Sfs2X.Requests;
using Sfs2X.Logging;

public class GameGUI : MonoBehaviour {
	private SmartFox smartFox;
	private bool shuttingDown = false;

	public enum GameState {
		WAITING_FOR_PLAYERS = 0,
		RUNNING,
		GAME_WON,
		GAME_LOST,
		GAME_TIE,
		GAME_DISRUPTED
	};
	private TrisGame trisGameInstance;
	private ChatWindow chatWindow;
	private GameState currentGameState;

	public GUISkin gSkin;
	
	private bool started = false;

	/************
	 * Unity callback methods
	 ************/

	void OnApplicationQuit() {
		shuttingDown = true;
	}

	void FixedUpdate() {
		if (!started) return;
		smartFox.ProcessEvents();
	}

	void Awake() {
		Application.runInBackground = true;

		if ( SmartFoxConnection.IsInitialized ) {
			smartFox = SmartFoxConnection.Connection;
		} else {
			Application.LoadLevel("login");
			return;
		}

		// Register callbacks
		smartFox.AddEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
		smartFox.AddEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
		smartFox.AddEventListener(SFSEvent.USER_ENTER_ROOM, OnUserEnterRoom);
		smartFox.AddEventListener(SFSEvent.USER_EXIT_ROOM, OnUserLeaveRoom);
		smartFox.AddEventListener(SFSEvent.USER_COUNT_CHANGE, OnUserCountChange);
		smartFox.AddEventListener(SFSEvent.OBJECT_MESSAGE, OnObjectReceived);
		smartFox.AddEventListener(SFSEvent.ROOM_JOIN, OnJoinRoom);

		chatWindow = new ChatWindow(Screen.width-180, 95, 150, 350);

		currentGameState = GameState.WAITING_FOR_PLAYERS;
		
		trisGameInstance = new TrisGame();
		trisGameInstance.InitGame(smartFox);
		
		started = true;
	}

	void StartGame() {
		chatWindow.AddSystemMessage("Game started! May the best man win");
		currentGameState = GameState.RUNNING;
	}

	void OnGUI() {
		if (!started) return;
		GUI.skin = gSkin;
		
		int screenW = Screen.width;
		int screenH = Screen.height;
	
		GUI.Label(new Rect(2, -2, 680, 70), "", "SFSLogo");

		// Standard view
		if ( GUI.Button(new Rect(screenW-190, 495, 90, 24), "Exit game") ) {
			smartFox.Send(new JoinRoomRequest("The Lobby", null, smartFox.LastJoinedRoom.Id));
			trisGameInstance.DestroyGame();
			return;
		}

		GUI.Box(new Rect(screenW-190, 80, 180, 370), "Chat");
		chatWindow.Draw();

		// Game view
		GUI.Label(new Rect(10, 80, 470, 30), "Tic Tac Toe - " + smartFox.LastJoinedRoom.Name);

		// Print the current game state
		if ( currentGameState == GameState.WAITING_FOR_PLAYERS ) {
			ShowSimplePopup("Waiting", "Waiting for player to join");
		}

		if ( currentGameState == GameState.GAME_DISRUPTED ) {
			ShowSimplePopup("Game Over", "Enemy player disconnected");

		} else if ( currentGameState == GameState.GAME_LOST ) {
			ShowGameOverPopup("Game Over", "You lost");

		} else if ( currentGameState == GameState.GAME_WON ) {
			ShowGameOverPopup("Game Over", "You win!!");

		} else if ( currentGameState == GameState.GAME_TIE ) {
			ShowGameOverPopup("Game Over", "It is a tie!!");

		} else if ( currentGameState == GameState.RUNNING ) {

			GUI.Label(new Rect(10, 100, 300, 30), trisGameInstance.GetGameStatus());
		}
	}

	public void SetGameOver(string result) {
		chatWindow.AddSystemMessage("Game over");
		if ( result == "win" ) {
			currentGameState = GameState.GAME_WON;
			chatWindow.AddSystemMessage("Result: Win");
		} else if ( result == "loss" ) {
			currentGameState = GameState.GAME_LOST;
			chatWindow.AddSystemMessage("Result: Loss");
		} else {
			currentGameState = GameState.GAME_TIE;
			chatWindow.AddSystemMessage("Result: Tie");
		}
	}

	public void SetStartGame() {
		currentGameState = GameState.RUNNING;
	}

	/************
	 * Helper methods
	 ************/

	private void UnregisterSFSSceneCallbacks() {
		// This should be called when switching scenes, so callbacks from the backend do not trigger code in this scene
		smartFox.RemoveEventListener(SFSEvent.CONNECTION_LOST, OnConnectionLost);
		smartFox.RemoveEventListener(SFSEvent.PUBLIC_MESSAGE, OnPublicMessage);
		smartFox.RemoveEventListener(SFSEvent.USER_ENTER_ROOM, OnUserEnterRoom);
		smartFox.RemoveEventListener(SFSEvent.USER_EXIT_ROOM, OnUserLeaveRoom);
		smartFox.RemoveEventListener(SFSEvent.USER_COUNT_CHANGE, OnUserCountChange);
		smartFox.RemoveEventListener(SFSEvent.OBJECT_MESSAGE, OnObjectReceived);
		smartFox.RemoveEventListener(SFSEvent.ROOM_JOIN, OnJoinRoom);
	}

	private void ShowSimplePopup(string header, string text) {
		int x = Screen.width/2 - 100;
		int y = Screen.height/2 - 50;
		int width = 200;
		int height = 100;
		GUI.Box(new Rect(x, y, width, height), header);
		GUIStyle style = new GUIStyle(); 
		style.alignment = TextAnchor.MiddleCenter;
		GUI.Label( new Rect(x + 20, y + 20, width - 40, height - 20), text, style);
	}

	private void ShowGameOverPopup(string header, string text) {
		int x = Screen.width / 2 - 100;
		int y = Screen.height / 2 - 50;
		int width = 200;
		int height = 100;
		GUI.Box(new Rect(x, y, width, height), header);
		GUIStyle style = new GUIStyle();
		style.alignment = TextAnchor.MiddleCenter;
		GUI.Label(new Rect(x + 20, y + 10, width - 40, height - 20), text, style);
		if (GUI.Button(new Rect(x+50, y+70, 100, 24), "Restart")) {
			trisGameInstance.RestartGame();
			currentGameState = GameState.RUNNING;
			// Send "Lets restart" message to other player
			SFSObject restartObject = new SFSObject();
			restartObject.PutUtfString("cmd", "restart");
			smartFox.Send(new ObjectMessageRequest(restartObject));
			trisGameInstance.ResetGameBoard();			
		}
	}

	/************
	 * Callbacks from the SFS API
	 ************/

	private void OnConnectionLost(BaseEvent evt) {
		UnregisterSFSSceneCallbacks();
		if ( shuttingDown == true ) return;
		Application.LoadLevel("login");
	}

	private void OnPublicMessage(BaseEvent evt) {
		string message = (string)evt.Params["message"];
		User sender = (User)evt.Params["sender"];
		chatWindow.AddChatMessage(sender.Name + " said: " + message);
	}

	private void OnJoinRoom(BaseEvent evt) {
		Room room = (Room)evt.Params["room"];
		Debug.Log("Joining lobby room " + room.Name);
		started = false;
		UnregisterSFSSceneCallbacks();
		Application.LoadLevel("lobby");
	}

	private void OnUserEnterRoom(BaseEvent evt) {
		User user = (User)evt.Params["user"];
		chatWindow.AddPlayerJoinMessage(user.Name + " joined room");
	}

	private void OnUserLeaveRoom(BaseEvent evt) {
		User user = (User)evt.Params["user"];
		chatWindow.AddPlayerLeftMessage(user.Name + " left room");
		currentGameState = GameState.GAME_DISRUPTED;
	}

	private void OnObjectReceived(BaseEvent evt) {
		SFSObject obj = (SFSObject)evt.Params["message"];
		User sender = (User)evt.Params["sender"];
		
		switch ( obj.GetUtfString("cmd") ) {
			case "restart":
				currentGameState = GameState.RUNNING;
				break;
		}
	}

	private void OnUserCountChange(BaseEvent evt) {
		Room room = (Room)evt.Params["room"];
		if ( room.UserCount == 2 ) {
			StartGame();
		}
	}
}
