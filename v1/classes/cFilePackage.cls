VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFilePackage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Repton Returns
' Ex-D Software Development(TM)
' All rights reserved.

Option Explicit

Private aMediaFiles As New cPackedFile
Private Ft          As cFileType
Private Fd          As cFileData
Private sUnpackedFiles() As String

Function Init(strPackageFile As String)
    
    ReDim sUnpackedFiles(0)
    
    aMediaFiles.ReadFile strPackageFile
    
End Function

'Public Function AddFile(ByVal FileSpec As String) As AddError
'Dim Fd As cFileData
'
''On Error GoTo AddErr
''if already in the packed file exit
''use the filespec as the key
'If Not Exists(FileSpec) Then
'    'say busy
'    'RaiseEvent Working(False)
'    'add a new filedata object to the collection
'    'using the path as unique key
'    Set Fd = Add(FileSpec)
'    'attempt to load it
'    If Fd.Load(FileSpec, m_Compressed) Then
'        'success
'        AddFile = AddOK
'    Else
'        'failure, remove the filedata object
'        m_Col.Remove Fd.Key
'        AddFile = AddFailure
'    End If
'Else
'    'this is already in the collection
'    AddFile = File_Exists
'End If
'
'AddErr:
''RaiseEvent Working(True)
'End Function


Function GetPackedFile(sFile As String) As String
    Dim n As Integer
    
    ' Find file
    sFile = UCase(sFile)
    For n = 1 To aMediaFiles.Count
        If sFile = UCase(aMediaFiles.Item(n).FileName) Then GoTo FoundFile
    Next n
    GetPackedFile = ""
  Exit Function
    
FoundFile:
    
    Set Fd = aMediaFiles(n)

    'create a temproary file to extract to
    Set Ft = New cFileType
    GetPackedFile = Ft.GetTempFile(Fd.Extension, GetBaseName(Fd.FileName))
    Set Ft = Nothing
    
    'extract to the tempfile
    If Not Fd.ExtractToFile(GetPackedFile, True) Then
        GetPackedFile = ""
    Else
        ReDim Preserve sUnpackedFiles(UBound(sUnpackedFiles) + 1)
        sUnpackedFiles(UBound(sUnpackedFiles)) = GetPackedFile
    End If
    
End Function
Function DeInit()
    Dim n As Integer
    
    Set Fd = Nothing
    
    For n = 1 To UBound(sUnpackedFiles)
        If FileExists(sUnpackedFiles(n)) Then Kill sUnpackedFiles(n)
    Next n
    ReDim sUnpackedFiles(0)
End Function


Private Function GetBaseName(ByVal FileName As String) As String
    Dim ix  As Long
    
    ix = InStrRev(FileName, ".")
    If ix > 0 Then FileName = Mid(FileName, 1, ix - 1)
    GetBaseName = FileName
End Function
