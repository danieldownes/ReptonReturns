VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Display Settings for Repton Returns"
   ClientHeight    =   2505
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   4305
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2505
   ScaleWidth      =   4305
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdWizTog 
      Caption         =   "A&dvanced User"
      Height          =   255
      Left            =   2760
      TabIndex        =   8
      Top             =   0
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.Frame fraWizard 
      Caption         =   "Wizard"
      Height          =   3135
      Left            =   360
      TabIndex        =   7
      Top             =   2880
      Width           =   6615
   End
   Begin VB.Frame fraAdvanced 
      BackColor       =   &H00000000&
      Height          =   2415
      Left            =   120
      TabIndex        =   5
      Top             =   0
      Width           =   4095
      Begin VB.Frame frmTestingMsg 
         BackColor       =   &H00000000&
         Height          =   2175
         Left            =   120
         TabIndex        =   9
         Top             =   120
         Visible         =   0   'False
         Width           =   3855
         Begin VB.Label Label1 
            Alignment       =   2  'Center
            BackColor       =   &H00000000&
            Caption         =   "Testing all playable screen modes. Please Wait..."
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   14.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            ForeColor       =   &H0000C000&
            Height          =   1335
            Left            =   600
            TabIndex        =   10
            Top             =   600
            Width           =   2775
         End
      End
      Begin VB.CommandButton cmdStandard 
         BackColor       =   &H00FFFFFF&
         Caption         =   "&Use standard and play!"
         Height          =   735
         Left            =   2640
         MaskColor       =   &H00C00000&
         Style           =   1  'Graphical
         TabIndex        =   0
         Top             =   240
         Width           =   1335
      End
      Begin VB.ListBox lstRes 
         BackColor       =   &H00000000&
         ForeColor       =   &H0000FF00&
         Height          =   2010
         Left            =   120
         TabIndex        =   6
         Top             =   240
         Width           =   2415
      End
      Begin VB.CommandButton cmdCancel 
         BackColor       =   &H00FFFFFF&
         Cancel          =   -1  'True
         Caption         =   "&Cancel"
         Height          =   255
         Left            =   2640
         MaskColor       =   &H00C00000&
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   2040
         Width           =   1335
      End
      Begin VB.CommandButton cmdSet 
         BackColor       =   &H00FFFFFF&
         Caption         =   "&Set Selected"
         Height          =   255
         Left            =   2640
         MaskColor       =   &H00C00000&
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   1800
         Width           =   1335
      End
      Begin VB.CommandButton cmdSetPlay 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Set and &Play"
         Height          =   375
         Left            =   2640
         MaskColor       =   &H00C00000&
         Style           =   1  'Graphical
         TabIndex        =   1
         Top             =   1080
         Width           =   1335
      End
      Begin VB.CommandButton cmdReTest 
         BackColor       =   &H00FFFFFF&
         Caption         =   "&Re-test"
         Height          =   255
         Left            =   2640
         MaskColor       =   &H00C00000&
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   1560
         Width           =   1335
      End
   End
   Begin VB.Timer timTestModes 
      Enabled         =   0   'False
      Interval        =   1750
      Left            =   5760
      Top             =   1920
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Type Mode_T
    X As Integer
    Y As Integer
    Col  As Integer
    Works As Integer     ' -1=FAILED   1=WORKS   0=UNTESTED
End Type

Dim iModes(10) As Mode_T
Dim iCurSelMode As Integer          ' Current selected mode
Dim iSetMode As Integer          ' Current mode set



Private Sub cmdCancel_Click()
    End
End Sub

Private Sub cmdReTest_Click()
    StartResTest
End Sub

Private Sub cmdSet_Click()

    If ValidateSelection Then
        
        ' Set
        SaveSettingString HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID", iCurSelMode
    End If
    
End Sub

Private Sub cmdSetPlay_Click()

    If ValidateSelection Then
        
        ' Set
        SaveSettingString HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID", iCurSelMode
        
        ' Run RR
        ShellExecute Me.hwnd, "open", "ReptonReturns_V1.exe", vbNullString, vbNullString, 0
        
        ' Exit
        End
    End If
    
End Sub


Private Sub cmdStandard_Click()
        ' Set
        SaveSettingString HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID", 5
        
        ' Run RR
        ShellExecute Me.hwnd, "open", "ReptonReturns_V1.exe", vbNullString, vbNullString, 0
        
        ' Exit
        End
End Sub

Private Sub Form_Load()
    UpdateResList
    
    ' Start a test?
    If GetSettingString(HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns", "CurResID") = "" Then
        StartResTest
    End If
End Sub

Function StartResTest()
    frmTestingMsg.Visible = True
    timTestModes.Enabled = True
    iCurSelMode = 1
End Function

Private Sub timTestModes_Timer()
    Dim dm As DEVMODE   ' display settings
    Dim retval As Long  ' return value
    
    ' Initialize the structure that will hold the settings.
    dm.dmSize = Len(dm)
    ' Get the current display settings.
    retval = EnumDisplaySettings(vbNullString, ENUM_CURRENT_SETTINGS, dm)
    ' Change the resolution settings to 800x600.
    dm.dmPelsWidth = iModes(iCurSelMode).X
    dm.dmPelsHeight = iModes(iCurSelMode).Y
    dm.dmColor = iModes(iCurSelMode).Col
    ' Test to make sure the changes are possible.
    retval = ChangeDisplaySettings(dm, CDS_TEST)
    If retval <> DISP_CHANGE_SUCCESSFUL Then
        iModes(iCurSelMode).Works = -1
    Else
        ' Change and save to the new settings.
        retval = ChangeDisplaySettings(dm, CDS_TEST)
        Select Case retval
        Case DISP_CHANGE_SUCCESSFUL
            iModes(iCurSelMode).Works = 1
        Case DISP_CHANGE_RESTART
            iModes(iCurSelMode).Works = -1
        Case Else
            iModes(iCurSelMode).Works = -1
        End Select
    End If
    
    ' Save result
    SaveSettingString HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns\ResTests", "Res" & Trim(Val(iCurSelMode)), Str(iModes(iCurSelMode).Works)

    
    If iCurSelMode = UBound(iModes) Then
        frmTestingMsg.Visible = False
        timTestModes.Enabled = False
        iCurSelMode = 4
    Else
        iCurSelMode = iCurSelMode + 1
    End If
    
    UpdateResList
    
    cmdStandard.Default = True
    
End Sub

Function ValidateSelection() As Boolean
    Select Case Int(iModes(iCurSelMode).Works)
        Case -1
            MsgBox "Testing failed on the selected setting, please choose a different setting", , "Repton Returns Resolution Selector"
            ValidateSelection = False
            
        Case 0
            MsgBox "No testing has been made on the selected setting; please allow testing to finnish", , "Repton Returns Resolution Selector"
            ValidateSelection = False
            
        Case 1
            ValidateSelection = True
    End Select
End Function


Function UpdateResList()
' ...on-screen and in the registry

    Dim n As Integer
    Dim b As Integer
    Dim i As Integer
    Dim strT As String
    
    lstRes.Clear
        
    i = 1
    For n = 1 To UBound(iModes) / 2
        For b = 1 To 2
            
            ' Read from registry
            iModes(i).Works = Val(GetSettingString(HKEY_LOCAL_MACHINE, "Software\Ex-D Software DevelopmentTM\Repton Returns\ResTests", "Res" & Trim(Val(i))))
        
            Select Case iModes(i).Works
                Case 0
                    strT = "UNTESTED"
                Case 1
                    strT = "PASSED"
                Case -1
                    strT = "!!FAILED!!"
            End Select
            

            ' Calculate res'es and show results
            iModes(i).X = 320 * n
            iModes(i).Y = 240 * n
            If iModes(i).X = 960 Then   ' 800x600 is a unique res
                iModes(i).X = 800
                iModes(i).Y = 600
            End If
            iModes(i).Col = 16 * b
            lstRes.AddItem Trim(Str(iModes(i).X)) & " x " & Trim(Str(iModes(i).Y)) & " @ " & Trim(Str(16 * b)) & "  : " & strT
            i = i + 1
        Next b
    Next n
End Function
