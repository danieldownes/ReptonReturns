VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPackedFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"cFileData"
Attribute VB_Ext_KEY = "Member0" ,"cFileData"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
Private Const FOLDER_DELIMITER = "\"
Private Const MAX_PATH = 260
Private Const THIS_VERSION = 1

Enum AddError
    AddOK = 0
    File_Exists = 1
    AddFailure = 2
End Enum

Enum ReadError
    ReadOK = 0
    ReadPartial = 1
    ReadFailure = 2
    ReadBadPath = 3
End Enum

Private Type ContentInfo
    Length          As Long
    Files           As Long
    Version         As Long
    Compressed      As Boolean
End Type

Private m_Col           As Collection
Private m_Version       As Long
Private m_FileSpec      As String
Private m_Compressed    As Boolean
Private m_Changed       As Boolean

Public Event Working(ByVal Finished As Boolean)
Public Event VersionError()
Public Event ReadError(ByVal R As ReadError)
Public Event WriteError()

Public Function Add(Key As String) As cFileData
Dim FileData As cFileData

Set FileData = New cFileData

FileData.Key = Key
m_Col.Add FileData, Key
m_Changed = True
Set Add = FileData
Set FileData = Nothing
End Function

Public Function AddFile(ByVal FileSpec As String) As AddError
Dim Fd As cFileData

On Error GoTo AddErr
'if already in the packed file exit
'use the filespec as the key
If Not Exists(FileSpec) Then
    'say busy
    RaiseEvent Working(False)
    'add a new filedata object to the collection
    'using the path as unique key
    Set Fd = Add(FileSpec)
    'attempt to load it
    If Fd.Load(FileSpec, m_Compressed) Then
        'success
        AddFile = AddOK
    Else
        'failure, remove the filedata object
        m_Col.Remove Fd.Key
        AddFile = AddFailure
    End If
Else
    'this is already in the collection
    AddFile = File_Exists
End If

AddErr:
RaiseEvent Working(True)
End Function


Public Property Get Changed() As Boolean
Changed = m_Changed
End Property

Public Sub Clear()
With m_Col
    While .Count > 0
        Remove .Count
    Wend
End With
m_Changed = True
End Sub

Private Function Exists(ByVal Key As String) As Boolean
Dim Fd As cFileData

On Error Resume Next

Set Fd = m_Col(Key)
Exists = (Err.Number = 0)

Set Fd = Nothing
End Function




Public Property Get Item(Key As Variant) As cFileData
Attribute Item.VB_UserMemId = 0
Set Item = m_Col(Key)
End Property



Public Property Get Count() As Long
    'used when retrieving the number of elements in the
    'collection. Syntax: Debug.Print x.Count
    Count = m_Col.Count
End Property




Public Function ReadFile(Optional ByVal FileSpec As String = vbNullString) As ReadError
Dim Fd          As cFileData
Dim FileInfo    As ContentInfo
Dim ix          As Long
Dim Buffer      As Long
Dim Result      As ReadError

On Error GoTo NoRead

'if no filespec passed use m_filespec
If FileSpec = vbNullString Then FileSpec = m_FileSpec

'if no filespec of bad filepath
If (FileSpec = vbNullString) Or (Not FileExists(FileSpec)) Then
    ReadFile = False
    'say error
    RaiseEvent ReadError(ReadBadPath)
End If

'save the filespec for writing
m_FileSpec = FileSpec

'say busy
RaiseEvent Working(False)

'get a file buffer
Buffer = FreeFile

'open the file for reading
Open FileSpec For Binary As #Buffer

'read the fileinfo header
Get #Buffer, , FileInfo

'check the version
If FileInfo.Version <> m_Version Then
    Close
    ReadFile = False
    'say done
    RaiseEvent Working(True)
    'say error
    RaiseEvent VersionError
    Exit Function
End If

'get compression state
m_Compressed = FileInfo.Compressed

'clear the collection
Clear

'add each file in turn
For ix = 1 To FileInfo.Files
    Set Fd = New cFileData
    If Fd.ReadFromPackedFile(Buffer) Then m_Col.Add Fd, Fd.FileSpec
Next

Close
'file is just read in so no changes
m_Changed = False

If m_Col.Count = FileInfo.Files Then
    Result = ReadOK
ElseIf m_Col.Count < FileInfo.Files Then
    Result = ReadOK
Else
NoRead:
    Result = ReadFailure
    Close
End If

ReadFile = Result
'say done
RaiseEvent Working(True)
'say error
If Result > ReadOK Then RaiseEvent ReadError(Result)
End Function


Private Function NullStrip(S As String) As String
Dim ix As Long

ix = InStr(1, S, vbNullChar)
If ix > 0 Then
    NullStrip = Left$(S, ix - 1)
Else
    NullStrip = S
End If
End Function

Public Function WriteFile(Optional ByVal FileSpec As String = vbNullString) As Boolean
Dim FileInfo    As ContentInfo
Dim Fd          As cFileData
Dim Failure     As Boolean
Dim Buffer      As Integer

'if nothing to save quit
If (m_Col.Count = 0) Then Exit Function

'if no filespec passed use m_filespec
If FileSpec = vbNullString Then FileSpec = m_FileSpec

'if no filespec exit
If FileSpec = vbNullString Then Exit Function

On Error GoTo NoWrite

'say busy
RaiseEvent Working(False)

'build the file header
With FileInfo
    .Files = m_Col.Count
    .Version = m_Version
    .Compressed = m_Compressed
End With

'get a file buffer
Buffer = FreeFile

'open the file for writing
Open FileSpec For Binary As #Buffer

'write the fileinfo
Put #Buffer, , FileInfo

For Each Fd In m_Col
    Failure = Not Fd.WriteToPackedFile(Buffer)
    If Failure Then Exit For
Next
If Failure Then GoTo NoWrite

'cleanup
Close
'file is just written in so no changes
m_Changed = False
WriteFile = True
'say done
RaiseEvent Working(True)
Exit Function

NoWrite:
Close

WriteFile = False

'say done
RaiseEvent Working(True)
'say error
RaiseEvent WriteError
End Function

Public Property Get FileName() As String
If m_FileSpec = vbNullString Then Exit Property
FileName = Mid$(m_FileSpec, InStrRev(m_FileSpec, FOLDER_DELIMITER) + 1)
End Property
Private Function FileExists(ByVal FileSpec As String) As Boolean
If FileSpec = vbNullString Then Exit Function

On Error Resume Next
FileExists = Not (Dir(FileSpec, (vbArchive Or vbHidden Or vbReadOnly Or vbSystem)) = vbNullString)
If Err.Number Then FileExists = False
On Error GoTo 0
End Function
Public Sub Remove(Key As Variant)
m_Col.Remove Key
m_Changed = True
End Sub






Private Sub Class_Initialize()
Set m_Col = New Collection
m_Version = THIS_VERSION
m_Changed = False
End Sub


Private Sub Class_Terminate()
Clear
Set m_Col = Nothing
End Sub


Public Property Get FileSpec() As String
FileSpec = m_FileSpec
End Property

Public Property Let FileSpec(ByVal S As String)
m_FileSpec = S
End Property

Public Property Get Compressed() As Boolean
Compressed = m_Compressed
End Property

Public Property Let Compressed(ByVal b As Boolean)
'if no change exit
If (m_Compressed = b) Then Exit Property

Dim Fd As cFileData

'say busy
RaiseEvent Working(False)

For Each Fd In m_Col
    Fd.Compressed = b
Next

'save change
m_Compressed = b

'say changed
m_Changed = True

'say done
RaiseEvent Working(True)
End Property
