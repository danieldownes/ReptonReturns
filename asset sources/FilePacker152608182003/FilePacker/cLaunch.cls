VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLaunch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Const SYNCHRONIZE = &H100000
Private Const INFINITE = -1&
Private Const SEE_MASK_INVOKEIDLIST = &HC
Private Const SEE_MASK_NOCLOSEPROCESS = &H40
Private Const SEE_MASK_FLAG_NO_UI = &H400
Private Const SW_NORMAL = 1


Private Type SHELLEXECUTEINFO
    cbSize          As Long
    fMask           As Long
    hwnd            As Long
    lpVerb          As String
    lpFile          As String
    lpParameters    As String
    lpDirectory     As String
    nShow           As Long
    hInstApp        As Long
    lpIDList        As Long
    lpClass         As String
    hkeyClass       As Long
    dwHotKey        As Long
    hIcon           As Long
    hProcess        As Long
End Type

Private Declare Function ShellExecuteEx Lib "shell32.dll" (SEI As SHELLEXECUTEINFO) As Long
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long





Public Function LaunchAndWait(FileName As String, OwnerhWnd As Long) As Boolean
Dim SEI     As SHELLEXECUTEINFO
Dim r       As Long
Dim hProc   As Long

On Error GoTo NoLaunch

If Dir(FileName) = vbNullString Then Exit Function

With SEI
    .cbSize = Len(SEI)
    .fMask = SEE_MASK_NOCLOSEPROCESS
    .hwnd = OwnerhWnd
    .lpVerb = "open"
    .lpFile = FileName & vbNullChar
    .lpParameters = vbNullChar
    .lpDirectory = vbNullChar
    .nShow = SW_NORMAL
    .hInstApp = 0
    .lpIDList = 0
End With
r = ShellExecuteEx(SEI)
If r Then
    hProc = SEI.hProcess
    If hProc <> 0 Then
        WaitForSingleObject hProc, INFINITE
        CloseHandle hProc
    End If
End If

LaunchAndWait = r
Exit Function

NoLaunch:
   LaunchAndWait = False
End Function


