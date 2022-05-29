VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "Repton Returns v1 BETA 2  :  Ex-D Software Development(TM)"
   ClientHeight    =   10305
   ClientLeft      =   105
   ClientTop       =   135
   ClientWidth     =   13890
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   687
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   926
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
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
      Left            =   4800
      TabIndex        =   2
      Top             =   6480
      Visible         =   0   'False
      Width           =   4215
   End
   Begin VB.Label lblInitExP 
      BackStyle       =   0  'Transparent
      Caption         =   "Starting..."
      BeginProperty Font 
         Name            =   "System"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080FF80&
      Height          =   855
      Left            =   1320
      TabIndex        =   3
      Top             =   2040
      Visible         =   0   'False
      Width           =   3375
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

Private Type Mode_T
    X As Integer
    Y As Integer
    Col  As Integer
End Type

Public iXsize As Integer
Public iYsize As Integer

Private dmOld As DEVMODE   ' origonal display settings

Private iResID As Integer
    

Private Sub Form_Click()
    MsgBox "Please use the arrow keys and enter key to navigate though the menu and to play the game.", , "Repton Returns"
End Sub

Private Sub Form_Load()

    Dim rrGameMenu As New cGameMenu
    
    Dim iSel As Integer
    
    Dim n As Integer
    Dim sFileToRead As String
    Dim sTemp As String
    
    Dim bFirstGo As Boolean
    
    ' First ever load?
    If GetSettingString(HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID") = "" Then
        If MsgBox("This is the first time you've run Repton Returns on this computer;" & vbCrLf & _
                  "Would you like to configure full screen mode?" & vbCrLf & _
                  "(Clicking 'No' will run Repton Returns in windowed mode)", vbYesNo, "Repton Returns") = vbYes Then
                  
            ShellExecute Me.hwnd, "open", "RR1_ResSelector.exe", vbNullString, vbNullString, SW_NORMAL
        
        
            End
            
        End If
    End If
    
    
    ' Game one time inits...
    
    ' Setup the display window
    SetScreenParams
    
    ' Load Secured Files
    pckGenFiles.Init App.Path & "\data\rr_general_data.pck"
    pckOrigThemeFiles.Init App.Path & "\data\themes\origonal.pck"
    pckLevelsFiles.Init App.Path & "\data\episode\repton3.pck"
    
    ' Initalize Ex-Perspective™
    InitExperspectiveObjects
    
    
    
    'InitFMOD
    
    
    
    ' GUI inits
    ExTxtGUI.InitText "", lblGUIRef.Font
    
    ExTxtGUI.Colour &HFF00A000

    ExTxtMsg.InitText "", lblMsgRef.Font
    
    'OpenFMOD pckGenFiles("The Thunderous Intro for Repton Returns.mp3")
    rrGameMenu.Init
    
    
    'Me.picExP.Visible = False
    'Me.picExP.Picture = Me.Picture
    'Me.lblInitExP.Visible = False
    'DoEvents
    rrGameMenu.ExDlogoLoop
    
    rrGameMenu.ReptonReturnsIntroLoop
    
    Do
    
        iSel = rrGameMenu.ReptonReturnsMenu
        
        Select Case iSel
        
            Case 1              ' Player selection menu.
            
                Do
RetrySelectPlayer:
                    iSel = rrGameMenu.SelectPlayerMenu
                    
                    Select Case iSel
                    
                        Case 0              ' Create new player
                            rrGameMenu.NewPlayer
                        
                        Case -1             ' Back to the Main Menu (do nothing)
                        
                        Case Else           ' Start game with selected player
                        
                            'rrGameMenu.Deinit
                            
                            
                            ' Read names from file
                            If FileExists(App.Path & "\data\players\names.dat") Then
                                Open App.Path & "\data\players\names.dat" For Input As #1
                                    n = 0
                                    Do While Not EOF(1) And iSel <> n
                                        n = n + 1
                                        Input #1, sTemp
                                        sPrimPlayerName = sTemp
                                    Loop
                                Close #1
                            Else
                                rrGameMenu.NewPlayer
                            End If
    
                            ' Read settings from file for selected player
                            sFileToRead = App.Path & "\data\players\" & sPrimPlayerName & "\options.dat"
                            If Not (FileExists(sFileToRead)) Then
                                sFileToRead = App.Path & "\data\players\new\options.dat"
                            End If
                            ' Read file
                            Open sFileToRead For Input As #1
                                ' game speed(0.25 - 5#)
                                Input #1, sTemp
                                rrGame.sngGameSpeed = Val(sTemp)
                                ' Sound volume / off
                                Input #1, sTemp
                                rrGame.sngSfxVol = Val(sTemp)
                                ' music volume / off
                                Input #1, sTemp
                                rrGame.sngMusicVol = Val(sTemp)
                            Close #1
                            
                            ' Update stats
                            If FileExists(App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat") = False Then
                                MsgBox "Error selecting this player, choose another or create new", , "Repton Returns"
                                GoTo RetrySelectPlayer
                            End If
                            Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat" For Input As #1
                                Open App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp" For Output As #2
                                    ' Number of times player selected
                                    Input #1, sTemp
                                    bFirstGo = Not (CBool(sTemp))
                                    sTemp = Trim(Str(Val(sTemp) + 1))
                                    Print #2, sTemp
                                    ' Number of lives remaining
                                    Input #1, sTemp
                                    If Int(sTemp) < 0 Then
                                        Print #2, "3"
                                    Else
                                        Print #2, sTemp
                                    End If
                                Close #2
                            Close #1
                            MoveFile App.Path & "\data\players\" & sPrimPlayerName & "\stats.tmp", App.Path & "\data\players\" & sPrimPlayerName & "\stats.dat"
                            
                            intPlayerLives = Int(sTemp)
                            
                            ' No more lives? must restart.
                            If Int(sTemp) < 0 Then
                                CopyFile App.Path & "\data\players\new\Home\" & "Home.rre", App.Path & "\data\players\" & sPrimPlayerName & "\Home\Home.rre"
                                CopyFile App.Path & "\data\players\new\Home\" & "Home.rre", App.Path & "\data\players\" & sPrimPlayerName & "\Home\old\Home.rre"
                                
                                CopyFile App.Path & "\data\players\new\Home\" & "start.rrl", App.Path & "\data\players\" & sPrimPlayerName & "\Home\start.rrl"
                                CopyFile App.Path & "\data\players\new\Home\" & "start.rrl", App.Path & "\data\players\" & sPrimPlayerName & "\Home\old\start.rrl"

                                intPlayerLives = 3
                                MsgBox "You have no remaining lives left, your game progress has been reset", , "Repton Returns"
                            End If
                                                        
                            
                            ' Start Game
                            rrGame.sEpisodeDir = App.Path & "\data\players\" & sPrimPlayerName & "\Home\"
                            If bFirstGo Then
                                If MsgBox("Do you wish to play a quick tutorial that will introduce the game of Repton Returns?", vbYesNo, "Repton Returns") = vbYes Then
                                    rrGame.sEpisodeDir = App.Path & "\data\episode\Tutorial\"
                                    intPlayerLives = 5000
                                End If
                            End If
                            
                            
                            rrGame.Init
                            
                        
                            Do
                            Loop While rrGame.MainLoop
                                                        
                            
                            rrGame.DeInit
                            
                            ' UnLoad sounds...
                            For n = 0 To UBound(ExSnds)
                                Set ExSnds(0) = Nothing
                            Next n

                        
                            iSel = -1           ' After playing, go beck to main menu
                    
                    End Select
                
                Loop Until iSel = -1
                
                iSel = 1
            
            Case 2              ' Options menu
                rrGameMenu.OptionMenu
            
            Case 3              ' Help
                ShellExecute Me.hwnd, "open", App.Path & "\help\help.chm", vbNullString, vbNullString, 3 'SW_NORMAL
                
            Case 4              ' About
                rrGameMenu.AboutTitles
                
            Case 0              ' Exit
        
        End Select
        
'        OpenFMOD pckGenFiles("The Thunderous Intro for Repton Returns.mp3")
        rrGame.sngMusicVol = 100
        PlayFMOD
        
    Loop Until iSel = 0
    
    rrGameMenu.DeInit
    
      
    
    
    Unload frmMain
    
End Sub

Sub Form_Unload(Cancel As Integer)

    rrGame.DeInit
    
    pckOrigThemeFiles.DeInit
    pckGenFiles.DeInit
    
    Set rrGame = Nothing
    
    Set ExInp = Nothing
    Set ExCam = Nothing
    Set ExPrj = Nothing
        
    'DeInitFMOD
    
    SetScreenParams True
        
    End
    
End Sub

Sub SetScreenParams(Optional bRevert As Boolean = False)

   
    Dim iModes(10) As Mode_T

    
    Dim dm As DEVMODE   ' display settings
    Dim retval As Long  ' return value
    
    
    Dim n As Integer
    Dim b As Integer
    Dim i As Integer
    Dim strT As String
    
    
    ' Reverting back ?
    If bRevert Then
        If iResID <> -1 Then    ' Only if we were in fullscreen in the first place
            ' Reset the res
            dm = dmOld
            
            ' Test to make sure the changes are possible.
            retval = ChangeDisplaySettings(dm, CDS_TEST)
            If retval <> DISP_CHANGE_SUCCESSFUL Then
                Debug.Print "Cannot change to selected resolution; please re-run the resolution selector program", , "Repton Returns"
            Else
                ' Change and save to the new settings.
                retval = ChangeDisplaySettings(dm, &H4)
            End If
        End If
        
        'Do
            retval = ShowCursor(1)
        'Loop While retval < 0
        
        Exit Sub
    End If
    
    
    ' Get saved preference
    If GetSettingString(HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID") <> "" Then
        
        iResID = Int(GetSettingString(HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID"))
    Else
        iResID = -1     ' Default to windowed if no setting exists
    End If
    
    
    If iResID <> -1 Then            ' fullscreen?
        
        ' Create ResID lookup data
        i = 1
        For n = 1 To UBound(iModes) / 2
            For b = 1 To 2
    
                ' Calculate res'es and show results
                iModes(i).X = 320 * n
                iModes(i).Y = 240 * n
                If iModes(i).X = 960 Then   ' 800x600 is a unique res
                    iModes(i).X = 800
                    iModes(i).Y = 600
                End If
                iModes(i).Col = 16 * b
                i = i + 1
            Next b
        Next n
        
        ' Initialize the structure that will hold the settings.
        dm.dmSize = Len(dm)
        ' Get the current display settings.
        retval = EnumDisplaySettings(vbNullString, ENUM_CURRENT_SETTINGS, dm)
         
        ' Change the resolution settings, saving origonal settings first ...
        
        dmOld = dm
        
        dm.dmPelsWidth = iModes(iResID).X  ' 160 '1600   '640
        dm.dmPelsHeight = iModes(iResID).Y   '120 '1200  '480
        ' Test to make sure the changes are possible.
        retval = ChangeDisplaySettings(dm, CDS_TEST)
        If retval <> DISP_CHANGE_SUCCESSFUL Then
            MsgBox "Cannot change to that resolution!"
        Else
            ' Change and save to the new settings.
            retval = ChangeDisplaySettings(dm, &H4)
        End If
        
        Me.BorderStyle = 0
        Me.WindowState = vbMaximized
        
        
        
        SetWindowPos Me.hwnd, HWND_TOPMOST, 0, 0, 0, 0, TOPMOST_FLAGS
        
        DoEvents
        
        'Do
            retval = ShowCursor(0)
        'Loop While retval > 0
    
    Else
        ' windowed
        Me.BorderStyle = 1
        
    End If
    
    Me.Show
    
    iXsize = Me.ScaleWidth
    iYsize = Me.ScaleHeight

End Sub

