VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Repton Returns v1.00   :  Ex-D Software Development(TM)"
   ClientHeight    =   10200
   ClientLeft      =   165
   ClientTop       =   480
   ClientWidth     =   13785
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   680
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   919
   StartUpPosition =   3  'Windows Default
   Begin VB.Label lblMsgRef 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   360
      Width           =   615
   End
   Begin VB.Label lblGUIRef 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Ex-D Software Development"
         Size            =   26.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   615
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit



Private Sub Form_Load()

   ' Dim ExTool As New ExTools
    
    ' Initalize Ex-Perspective™...
    ExPrj.Init Me.hWnd       ' Main
    ExPrj.BackColour &H0

    ExInp.InitKeyboardInput  ' Input

    ' Data Structure Initalization (LookUp tables, etc)
    SetupWallAroundInfo_LookUpTable
    
    ' Start Game
    rrGame.Init
    
    ' GUI inits
    ExTxtGUI.InitText "", lblGUIRef.Font
    
    ExTxtGUI.Colour &HFF00A000

    ExTxtMsg.InitText "", lblMsgRef.Font
    ExTxtMsg.Colour &HFFFFFF00
    
    Me.Show

    
    ' The main loop. Each cycle repersents one frame.
    Do
        
        UserInteraction                                ' {  Input
        
        
        ' Allow events in this game to accour          ' /
        GameEvents                                     ' |
                                                       '-   Process
        ' Allow other events to process.               ' |
        DoEvents                                       ' \
        
        
        DrawFrame                                      ' {  Output
                
    Loop
    
End Sub

Sub Form_Unload(Cancel As Integer)
    Set ExInp = Nothing
    Set ExCam = Nothing
    Set ExPrj = Nothing
    'Set ExSnds() = Nothing
    
    'Set rrPieces() = Nothing
    Set rrRepton = Nothing
    Set rrMap = Nothing
    Set rrGame = Nothing
    
    Unload frmMain
    
    End
    
End Sub

Private Sub lblRef_Click()

End Sub

Private Sub Label1_Click()

End Sub
