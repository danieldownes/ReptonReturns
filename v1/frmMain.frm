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
   Begin VB.TextBox txtName 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080FF80&
      Height          =   615
      Left            =   3720
      TabIndex        =   2
      Top             =   3960
      Visible         =   0   'False
      Width           =   5415
   End
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

Public iXsize As Integer
Public iYsize As Integer


Private Sub Form_Load()

    Dim rrGameMenu As New cGameMenu
    
    Dim iSel As Integer
    
    
    iXsize = Me.ScaleWidth
    iYsize = Me.ScaleHeight

    
    ' Initalize Ex-Perspective™
    InitExperspectiveObjects
    
    
    InitFMOD
    OpenFMOD "C:\Documents and Settings\Dan.DAN-NEWCOMP\My Documents\Ex-D\Software Development\Projects\Games\Repton Returns\_no use\Music\thunderus intro - v good\older\Repton Returns - Thunderus Intro (pre-release).mp3"
    
    
    
    ' Game one time inits...
    
    ' Data Structure Initalization (LookUp tables, etc)
    SetupWallAroundInfo_LookUpTable
    
    ' GUI inits
    ExTxtGUI.InitText "", lblGUIRef.Font
    
    ExTxtGUI.Colour &HFF00A000

    ExTxtMsg.InitText "", lblMsgRef.Font
    
    Me.Show
    
    
    rrGameMenu.Init
    
    rrGameMenu.ExDlogoLoop
    PlayFMOD
    rrGameMenu.ReptonReturnsIntroLoop
    
    Do
    
        iSel = rrGameMenu.ReptonReturnsMenu
        
        Select Case iSel
        
            Case 1              ' Player selection menu.
            
                Do
                
                    iSel = rrGameMenu.SelectPlayerMenu
                    
                    Select Case iSel
                    
                        Case 0              ' Create new player
                            rrGameMenu.NewPlayer
                        
                        Case -1             ' Back to the Main Menu (do nothing)
                        
                        Case Else           ' Start game with selected player
                        
                            'rrGameMenu.Deinit
                            
                            ' Show loading screen
                            
                        
                            ' Start Game
                            rrGame.Init
                            
                        
                            
                            ' The main loop. Each cycle represents one frame.
                            Do While Not (UserInteraction)                     ' {  Input
                                
                                ' Allow events in this game to accour          ' /
                                GameEvents                                     ' |
                                                                               '-   Process
                                ' Allow other events to process.               ' |
                                DoEvents                                       ' \
                                
                                
                                DrawFrame                                      ' {  Output
                                        
                            Loop
                        
                            iSel = -1           ' After playing, go beck to main menu
                    
                    End Select
                
                Loop Until iSel = -1
                
                iSel = 1
            
            Case 2              ' Options menu
                rrGameMenu.OptionMenu
            
            Case 3              ' Help
                ShellExecute Me.hwnd, "open", App.Path & "\help.chm", vbNullString, vbNullString, 3 'SW_NORMAL
                
            Case 4              ' About
                rrGameMenu.AboutTitles
                
            Case 0              ' Exit
        
        End Select
        
    Loop Until iSel = 0
    
    rrGameMenu.DeInit
    
    DeInitFMOD
    
    End
    
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
    
    DeInitFMOD
    
    Unload frmMain
    
    End
    
End Sub

Private Sub lblRef_Click()

End Sub

Private Sub Label1_Click()

End Sub
