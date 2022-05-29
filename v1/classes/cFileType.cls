VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFileType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const SHGFI_DISPLAYNAME = &H200
Const SHGFI_TYPENAME = &H400
Const MAX_PATH = 260
Const DEFAULT_NAME = "~x"

Private Type SHFILEINFO
    hIcon           As Long
    iIcon           As Long
    dwAttributes    As Long
    szDisplayName   As String * MAX_PATH
    szTypeName      As String * 80
End Type

Private Declare Function SHGetFileInfo Lib "Shell32.dll" Alias "SHGetFileInfoA" (ByVal pszPath As String, ByVal dwFileAttributes As Long, psfi As SHFILEINFO, ByVal cbFileInfo As Long, ByVal uFlags As Long) As Long
Private Declare Function GetTmpPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Public Property Get FileTypeFromExtension(ByVal Extension As String) As String
Dim Fp  As String

Fp = GetTempFile(Extension)
Open Fp For Binary As #1
Put #1, , "  "
Close
FileTypeFromExtension = FileTypeFromPath(Fp)
Kill Fp
End Property

Public Function GetTempFile(ByVal Extension As String, Optional ByVal Name As String = DEFAULT_NAME) As String
If Mid(Extension, 1, 1) <> "." Then Extension = "." & Extension
GetTempFile = GetTempPath & Name & Extension
End Function

Public Property Get FileTypeFromPath(ByVal Path As String) As String
Dim FI  As SHFILEINFO

'Get file info
SHGetFileInfo Path, 0, FI, Len(FI), SHGFI_DISPLAYNAME Or SHGFI_TYPENAME
FileTypeFromPath = NullStrip(FI.szTypeName)
End Property
Public Function GetTempPath()
Dim Folder As String

Folder = String(MAX_PATH, 0)
If GetTmpPath(MAX_PATH, Folder) <> 0 Then GetTempPath = NullStrip(Folder)

End Function
Private Function NullStrip(s As String) As String
Dim ix As Long

ix = InStr(1, s, vbNullChar)
If ix > 0 Then
    NullStrip = Mid(s, 1, ix - 1)
Else
    NullStrip = s
End If
End Function

