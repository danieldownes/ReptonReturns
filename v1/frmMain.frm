VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Repton Returns v1.00   :  Ex-D Software Development(TM)"
   ClientHeight    =   10080
   ClientLeft      =   165
   ClientTop       =   480
   ClientWidth     =   11400
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   10080
   ScaleWidth      =   11400
   StartUpPosition =   3  'Windows Default
   Begin VB.Label lblRef 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
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
    

    'Load the Repton Level
    rrMap.ThemeDir = "Repton 3"
    rrMap.CurGameLevel = 1
    rrMap.GameLevelsDir = "Repton 3"

    rrMap.LoadLevelData App.Path & "\data\episode\" & "Repton 3\1.rr"    '"tests\test_level.rr"

    
    ' GUI inits
    txt2D.InitText "REPTON RETURNS", lblRef.Font
    txt2D.Position 200, 50
    txt2D.Colour &HFF00A000
    
    txtScore2D.InitText "Dimonds left: " & rrMap.intTotDimonds - rrRepton.intDimondsCollected, lblRef.Font
    txtScore2D.Position 300, 10
    txtScore2D.Colour &HFF00A000
    
    
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
