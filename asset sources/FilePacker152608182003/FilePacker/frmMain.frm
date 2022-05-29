VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MsComCtl.ocx"
Begin VB.Form frmMain 
   Caption         =   "File Binder - New Document"
   ClientHeight    =   6945
   ClientLeft      =   165
   ClientTop       =   165
   ClientWidth     =   8415
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   463
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   561
   StartUpPosition =   1  'CenterOwner
   Begin VB.PictureBox CtrlPanel 
      Height          =   720
      Left            =   45
      ScaleHeight     =   44
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   551
      TabIndex        =   2
      Top             =   3480
      Width           =   8325
      Begin VB.CommandButton Btn 
         Caption         =   "&Launch"
         Height          =   570
         Index           =   6
         Left            =   6156
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":08CA
         Style           =   1  'Graphical
         TabIndex        =   10
         ToolTipText     =   "Extract a file from the packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CheckBox chkCompress 
         DownPicture     =   "frmMain.frx":0DBC
         Height          =   570
         Left            =   7147
         Picture         =   "frmMain.frx":1686
         Style           =   1  'Graphical
         TabIndex        =   9
         ToolTipText     =   "Compression is off"
         Top             =   60
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&Extract"
         Height          =   570
         Index           =   5
         Left            =   5165
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":1F50
         Style           =   1  'Graphical
         TabIndex        =   8
         ToolTipText     =   "Extract a file from the packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&Remove"
         Height          =   570
         Index           =   4
         Left            =   4174
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":2442
         Style           =   1  'Graphical
         TabIndex        =   7
         ToolTipText     =   "Remove a file from the packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&Add"
         Height          =   570
         Index           =   3
         Left            =   3183
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":2A14
         Style           =   1  'Graphical
         TabIndex        =   6
         ToolTipText     =   "Insert a file into the packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&New"
         Height          =   570
         Index           =   2
         Left            =   2192
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":2FE6
         Style           =   1  'Graphical
         TabIndex        =   5
         ToolTipText     =   "Create a new packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&Save"
         Enabled         =   0   'False
         Height          =   570
         Index           =   1
         Left            =   1201
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":35B8
         Style           =   1  'Graphical
         TabIndex        =   4
         ToolTipText     =   "Save the packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
      Begin VB.CommandButton Btn 
         Caption         =   "&Open"
         Height          =   570
         Index           =   0
         Left            =   210
         MaskColor       =   &H00FF00FF&
         Picture         =   "frmMain.frx":3B8A
         Style           =   1  'Graphical
         TabIndex        =   3
         ToolTipText     =   "Open a packed file"
         Top             =   60
         UseMaskColor    =   -1  'True
         Width           =   900
      End
   End
   Begin MSComctlLib.ListView lvFiles 
      Height          =   3375
      Left            =   120
      TabIndex        =   1
      Top             =   0
      Width           =   7935
      _ExtentX        =   13996
      _ExtentY        =   5953
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   5
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Name"
         Object.Width           =   3201
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Path"
         Object.Width           =   5609
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   2
         Text            =   "Normal"
         Object.Width           =   1984
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   3
         Text            =   "Compressed"
         Object.Width           =   1984
      EndProperty
      BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   4
         Text            =   "Ratio"
         Object.Width           =   1323
      EndProperty
   End
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   4305
      Width           =   8205
      _ExtentX        =   14473
      _ExtentY        =   4471
      _Version        =   393217
      BorderStyle     =   0
      ReadOnly        =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"frmMain.frx":415C
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Terminal"
         Size            =   9
         Charset         =   255
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   105
      Top             =   105
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Const ALLFILES = "All Files (*.*)|*.*"
Private Const PACKFILES = "Packed File (*.pck)|*.pck"
Private Const CSTATE = "Compression is "
Private Const FOLDER_DELIMITER = "\"
Private Const ERROR_FILE_SUCCESS As Long = 32
Private Const MAX_PATH = 260
Private Const SW_SHOW = 5

'button defs
Private Const OPENFILE = 0
Private Const SAVE = 1
Private Const NEWFILE = 2
Private Const ADD_ITEM = 3
Private Const REMOVE_ITEM = 4
Private Const EXTRACT_ITEM = 5
Private Const LAUNCH_ITEM = 6

Private Type RECT
   Left     As Long
   top      As Long
   Right    As Long
   bottom   As Long
End Type

Private Const DT_SINGLELINE = &H20&
Private Const DT_PATH_ELLIPSIS = &H4000&
Private Const DT_MODIFYSTRING = &H10000


Private Loading             As Boolean 'indicates we are laoding a file
Private WithEvents PFile    As cPackedFile
Attribute PFile.VB_VarHelpID = -1

Private Declare Function DrawText Lib "User32" Alias "DrawTextA" (ByVal hDc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Private Declare Function FindExecutable Lib "shell32.dll" Alias "FindExecutableA" (ByVal lpFile As String, ByVal lpDirectory As String, ByVal sResult As String) As Long
Private Declare Function ShellExecuteA Lib "shell32.dll" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Function IsLaunchable() As Boolean
Dim s           As String
Dim FileSpec    As String

If ValidFile Then
    If ValidSelection Then
        FileSpec = PFile(lvFiles.SelectedItem.Key).FileSpec
        s = LCase$(Right$(FileSpec, 3))

        'avoid executable files
        If (s = "exe") Or (s = "bat") Or (s = "com") Or (s = "dll") Then Exit Function

        s = Space$(MAX_PATH)

        IsLaunchable = FindExecutable(GetFileName(FileSpec), ParentFolder(FileSpec), s) >= ERROR_FILE_SUCCESS
    End If
End If
End Function
Private Function GetFileName(FileSpec As String) As String
If FileSpec = vbNullString Then Exit Function
GetFileName = Mid$(FileSpec, InStrRev(FileSpec, FOLDER_DELIMITER) + 1)
End Function
Public Sub LaunchItem()
Dim FileSpec    As String
Dim Ft          As cFileType
Dim Fd          As cFileData
Dim Launcher    As cLaunch
Dim r           As Boolean


On Error GoTo LaunchError

'get the selected dataitem
Set Fd = PFile(lvFiles.SelectedItem.Key)

'create a temproary file to extract to
Set Ft = New cFileType
FileSpec = Ft.GetTempFile(Fd.Extension, GetBaseName(Fd.FileName))
Set Ft = Nothing

'extract to the tempfile
If Fd.ExtractToFile(FileSpec, True) Then
    'create a launcher
    Set Launcher = New cLaunch
    Me.Visible = False
    DoEvents
    'launch the file
    r = Launcher.LaunchAndWait(FileSpec, Me.hwnd)
    Me.Visible = True
    DoEvents
    If Not r Then GoTo LaunchError
End If

LaunchDone:
    'cleanup
    If FileExists(FileSpec) Then Kill FileSpec
    Set Launcher = Nothing
    Set Fd = Nothing
    Exit Sub

LaunchError:
    DoEvents
    MsgBox "Unable to open file!", vbOKOnly + vbDefaultButton1 + vbExclamation + vbMsgBoxSetForeground, "Error!"
    Resume LaunchDone
End Sub
Private Function FileExists(ByVal FileSpec As String) As Boolean
If FileSpec = vbNullString Then Exit Function

On Error Resume Next
FileExists = Not (Dir(FileSpec, (vbArchive Or vbHidden Or vbReadOnly Or vbSystem)) = vbNullString)
If Err.Number Then FileExists = False
On Error GoTo 0
End Function
Private Sub LoadFile(FileSpec As String)
Set PFile = New cPackedFile
PFile.ReadFile FileSpec
Me.Caption = "File Binder - " & PFile.FileName
UpdateList
Loading = True
chkCompress.Value = IIf(PFile.Compressed, vbChecked, vbUnchecked)
Loading = False
End Sub

Private Function ParentFolder(ByVal FileSpec As String) As String
Dim ix As Long

If FileSpec = vbNullString Then Exit Function

ix = InStrRev(FileSpec, FOLDER_DELIMITER)
If ix > 0 Then
    ParentFolder = Left$(FileSpec, ix)
Else
    ix = InStrRev(FileSpec, ":")
    If ix > 0 Then ParentFolder = Left$(FileSpec, ix) & FOLDER_DELIMITER
End If
End Function
Private Function PackPath(ByVal Path As String, ByVal Width As Long) As String
Dim r   As RECT

r.Right = Width
DrawText hDc, Path, -1, r, DT_PATH_ELLIPSIS Or DT_SINGLELINE Or DT_MODIFYSTRING
PackPath = Path
End Function

Private Function ChangeCheck() As Boolean
'function returns false if user cancelled
'true on any other selection
ChangeCheck = True
If ValidFile Then
    If PFile.Changed Then
        Select Case MsgBox("The file contents have changed." & vbCrLf & "Do you wish to save the changes?", vbYesNoCancel + vbDefaultButton2 + vbQuestion + vbMsgBoxSetForeground, "File Contents Changed")
            Case vbYes
                SavePackedFile
            Case vbCancel
                ChangeCheck = False
        End Select
    End If
End If
End Function


Private Sub UpdateButtons()
Dim b As Boolean

If ValidFile Then Btn(SAVE).Enabled = PFile.Changed


b = ValidSelection
Btn(EXTRACT_ITEM).Enabled = b
Btn(REMOVE_ITEM).Enabled = b
Btn(LAUNCH_ITEM).Enabled = b And IsLaunchable
End Sub



Private Function ValidFile() As Boolean
ValidFile = Not (PFile Is Nothing)
End Function


Private Function ValidSelection() As Boolean
ValidSelection = Not (lvFiles.SelectedItem Is Nothing)
End Function

Private Sub Btn_Click(Index As Integer)
Select Case Index
    Case OPENFILE
        OpenPackedFile
    Case SAVE
        SavePackedFile
    Case NEWFILE
        NewPackedFile
    Case ADD_ITEM
        AddItem
    Case REMOVE_ITEM
        RemoveItem
    Case EXTRACT_ITEM
        ExtractItem
    Case LAUNCH_ITEM
        LaunchItem
End Select
End Sub

Private Sub chkCompress_Click()
Dim b As Boolean

b = (chkCompress = vbChecked)
chkCompress.ToolTipText = CSTATE & IIf(b, "on", "off")

If Not Loading Then
    If ValidFile Then PFile.Compressed = b
End If

UpdateButtons
End Sub


Private Sub CtrlPanel_Paint()
Dim p   As StdPicture
Dim ix  As Long
Dim iy  As Long

Set p = LoadResPicture(101, vbResBitmap)
With CtrlPanel
    For ix = 0 To .ScaleWidth - 1 Step 22
        For iy = 0 To .ScaleHeight - 1 Step 22
            .PaintPicture p, ix, iy
        Next
    Next
End With
End Sub




Private Sub Form_Activate()
'handle any files dropped on the app
If Command$ <> vbNullString Then
    Dim s As String
    
    s = Mid$(Command$, 2, Len(Command$) - 2)
    If LCase$(Right$(s, 4)) = ".pck" Then
        If FileExists(s) Then LoadFile s
    End If
End If
            
UpdateButtons
Btn(OPENFILE).SetFocus
End Sub


Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
If (UnloadMode = vbAppWindows) Or (UnloadMode = vbAppTaskManager) Then Exit Sub
Cancel = CInt(Not ChangeCheck)
End Sub

Private Sub Form_Resize()
Const PANELHGT = 48
On Error Resume Next
With lvFiles
    .Left = 3
    .Width = ScaleWidth - 6
    .Height = ScaleHeight / 2
    RichTextBox1.Move 3, .top + .Height + 6 + PANELHGT, .Width, ScaleHeight - (.top + .Height + 9 + PANELHGT)
    CtrlPanel.Move 3, .top + .Height + 3, .Width, PANELHGT
End With

End Sub



Private Sub Form_Unload(Cancel As Integer)
Set PFile = Nothing
End Sub


Private Sub lvFiles_Click()
If ValidFile Then
    RichTextBox1.Text = PFile(lvFiles.SelectedItem.Key).ToString
    UpdateButtons
End If
End Sub



Private Sub AddItem()
On Error GoTo AddCancelled

'make sure there is something to add to
If Not ValidFile Then Set PFile = New cPackedFile

With cd
    .Flags = cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNExplorer
    .Filter = ALLFILES
    .DialogTitle = "Add File"
    .ShowOpen
End With

If cd.FileName <> vbNullString Then
    Select Case PFile.AddFile(cd.FileName)
        Case 0 'no error
            'MsgBox "File addition nominal!", vbOKOnly + vbDefaultButton1 + vbInformation + vbMsgBoxSetForeground, "Information"
            UpdateList
        Case 1 'file exists
            MsgBox "This file is already a member of the packed file!", vbOKOnly + vbDefaultButton1 + vbExclamation + vbMsgBoxSetForeground, "File Exists!"
        Case 2 'undefined error while loading
            MsgBox "An undefined error has occurred while loading the file data!", vbOKOnly + vbDefaultButton1 + vbCritical + vbMsgBoxSetForeground, "Error!"
    End Select
End If

AddCancelled:
End Sub



Private Sub ExtractItem()
Dim Fd      As cFileData
Dim Ft      As cFileType
Dim Fts     As String
Dim Ftx     As String

On Error GoTo ExtractCancelled

'get the selected dataitem
Set Fd = PFile(lvFiles.SelectedItem.Key)
'get the extension of the file therein
Ftx = Fd.Extension

'get the filetype that matches the extension
Set Ft = New cFileType
Fts = Ft.FileTypeFromExtension(Ftx)
Set Ft = Nothing

'create the dialog
With cd
    .FileName = Fd.FileSpec
    'if we have an associated filetype
    'add it to the filter
    'otherwise use the default filter
    If Fts <> vbNullString Then
        Ftx = "*" & Ftx
        .Filter = Fts & " (" & Ftx & ")|" & Ftx & "|" & ALLFILES
    Else
        .Filter = ALLFILES
    End If
    
    .DialogTitle = "Extract As..."
    .ShowSave
End With

'extract the file
If Fd.ExtractToFile(cd.FileName) Then
    MsgBox "File save nominal!", vbOKOnly + vbDefaultButton1 + vbInformation + vbMsgBoxSetForeground, "Information"
Else
    MsgBox "Error while writing file!", vbOKOnly + vbDefaultButton1 + vbExclamation + vbMsgBoxSetForeground, "Error!"
End If

ExtractCancelled:
Set Fd = Nothing
End Sub

Public Function GetBaseName(ByVal FileName As String) As String
Dim ix  As Long

ix = InStrRev(FileName, ".")
If ix > 0 Then FileName = Left$(FileName, ix - 1)
GetBaseName = FileName
End Function
Private Sub NewPackedFile()
'check for changes
If Not ChangeCheck Then Exit Sub
    
Set PFile = New cPackedFile
Me.Caption = "File Binder - New Document"
PFile.Compressed = (chkCompress = vbChecked)
UpdateList
End Sub

Private Sub OpenPackedFile()

On Error GoTo OpenCancelled

With cd
    .Flags = cdlOFNFileMustExist Or cdlOFNHideReadOnly Or cdlOFNExplorer
    .Filter = PACKFILES
    .DialogTitle = "Open"
    .ShowOpen
End With

If cd.FileName <> vbNullString Then LoadFile cd.FileName

OpenCancelled:
End Sub
Private Sub RemoveItem()
If MsgBox("Are you sure you want to remove " + lvFiles.SelectedItem.Text + "?", vbYesNo + vbQuestion, "Remove") = vbYes Then
    PFile.Remove lvFiles.SelectedItem.Key
    UpdateList
End If
End Sub

Private Function UpdateList()
Dim ix As Long
Dim li As ListItem

lvFiles.ListItems.Clear

If ValidFile Then
    For ix = 1 To PFile.Count
        With PFile(ix)
            Set li = lvFiles.ListItems.Add(, .Key, .FileName)
            'li.SubItems(1) = PackPath(.ParentFolder, lvFiles.ColumnHeaders(2).Width - 12)
            li.SubItems(1) = .ParentFolder
            li.SubItems(2) = .SizeString
            li.SubItems(3) = .CompressedSizeString
            If .Compressed Then
                li.SubItems(4) = Format(.CompressedSize / .Size, "##.#%")
            Else
                li.SubItems(4) = "n/a"
            End If
        End With
    Next
End If

Set lvFiles.SelectedItem = Nothing
UpdateButtons
End Function

Private Sub SavePackedFile()

On Error GoTo SaveCancelled

With cd
    .Flags = cdlOFNCreatePrompt Or cdlOFNOverwritePrompt Or cdlOFNExplorer
    .Filter = PACKFILES
    .DialogTitle = "Save as..."
    .FileName = PFile.FileSpec
    .ShowSave
End With
    
If cd.FileName <> vbNullString Then PFile.WriteFile cd.FileName

SaveCancelled:
UpdateButtons
End Sub









Private Sub PFile_ReadError(ByVal r As ReadError)
If r = ReadBadPath Then
    MsgBox "Specified file does not exist!", vbOKOnly + vbDefaultButton1 + vbCritical + vbMsgBoxSetForeground, "File Read Error!"
ElseIf r = ReadPartial Then
    MsgBox "An error occurred during the read." & vbCrLf & "Not all the data could be read.", vbOKOnly + vbDefaultButton1 + vbExclamation + vbMsgBoxSetForeground, "Error During Read!"
ElseIf r = ReadFailure Then
    MsgBox "Corrupt file could not be read!", vbOKOnly + vbDefaultButton1 + vbCritical + vbMsgBoxSetForeground, "Read Failure"
End If

End Sub

Private Sub PFile_VersionError()
MsgBox "The packed file is the wrong version!", vbOKOnly + vbDefaultButton1 + vbCritical + vbMsgBoxSetForeground, "Error!"
End Sub

Private Sub PFile_Working(ByVal Finished As Boolean)
Screen.MousePointer = IIf(Finished, vbDefault, vbHourglass)
Me.Enabled = Finished
End Sub


Private Sub PFile_WriteError()
MsgBox "Unable to write the packed file!", vbOKOnly + vbDefaultButton1 + vbCritical + vbMsgBoxSetForeground, "Error!"
End Sub


